using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ChessAP.chess.fairybot.Framework;

namespace ChessAP.chess.fairybot.Standard
{

    /*
    Board indexing:
           A    B    C    D    E    F    G    H
        +----+----+----+----+----+----+----+----+
      8 |  0 |  1 |  2 |  3 |  4 |  5 |  6 |  7 | 8
        +----+----+----+----+----+----+----+----+
      7 |  8 |  9 | 10 | 11 | 12 | 13 | 14 | 15 | 7
        +----+----+----+----+----+----+----+----+
      6 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 6
        +----+----+----+----+----+----+----+----+
      5 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 | 5
        +----+----+----+----+----+----+----+----+
      4 | 32 | 33 | 34 | 35 | 36 | 37 | 38 | 39 | 4
        +----+----+----+----+----+----+----+----+
      3 | 40 | 41 | 42 | 43 | 44 | 45 | 46 | 47 | 3
        +----+----+----+----+----+----+----+----+
      2 | 48 | 49 | 50 | 51 | 52 | 53 | 54 | 55 | 2
        +----+----+----+----+----+----+----+----+
      1 | 56 | 57 | 58 | 59 | 60 | 61 | 62 | 63 | 1
        +----+----+----+----+----+----+----+----+
           A    B    C    D    E    F    G    H
    Matching with FEN position incoding.
*/
    public class StandardFENHandler : FENHandler
    {
        private string currentFENString;
        private Color playerInTurn;

        /// <summary>
        /// Contains bit maps of pieces. 1 means piece is present while 0 means not.
        /// For colored piece, one can find the bit_map as positionMap[mapIndex(piece)]
        /// For all pieces of a color one can find the bit map as positionMap[mapIndex(color)]
        /// For all pieces one can find the bit map as positionMap[0]
        /// </summary>
        private ulong[] positionMaps;
        private ulong[] moveMaps; // Are these usefull??
        private ColoredPiece[] spaceToPieceMap;
        private Dictionary<ColoredPiece, List<int>> pieceToSpacesMap;
        private int enPassantSquare; // is -1 if no enPessent is possible
        private bool[] canCastle;
        private const ulong ONE = 1;   
        
        private static readonly int[] castleSquareConverter = new int[64]{0,0,1,2,3,0,5,6,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,9,10,0,12,13,0,0,0,8,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; 
                                                                        //- A B C D E F G H I J K L M N O P Q R S T U V W X Y Z - - - - - - a b c  d e  f  g h i j k l m n o p  q r s t u v w x y z - - - - -
        public StandardFENHandler()
        {
            playerInTurn = Color.WHITE;
            positionMaps = new ulong[64];
            moveMaps = new ulong[64];
            spaceToPieceMap = new ColoredPiece[64];
            pieceToSpacesMap = new Dictionary<ColoredPiece, List<int>>();
            canCastle = new bool[16];
            enPassantSquare = -1;
        }

        private void resetFields()
        {
          for (int i = 0; i < 64; i++)
          {
            positionMaps[i] = 0;
            moveMaps[i] = 0;
            spaceToPieceMap[i] = ColoredPiece.NONE;
          }

          foreach (ColoredPiece piece in (ColoredPiece[]) Enum.GetValues(typeof(ColoredPiece))){
            pieceToSpacesMap[piece] = new List<int>();
          }

          for (int i = 0; i < 16; i++)
          {
            canCastle[i] = false;
          }
        }

        private void updateSinglePiece(int currentSquare, ColoredPiece piece)
        {
          positionMaps[Utility.mapIndex(piece)] |= ONE << currentSquare;
          spaceToPieceMap[currentSquare] = piece;
          pieceToSpacesMap[piece].Add(currentSquare);
        }

        public void setCurrentFEN(string fenString)
        {

          currentFENString = fenString;
          string[] chunks = fenString.Split(" ");

              // Splits the string into 6 bits:
              //   0) The position of the pieces
              //   1) The player in turn
              //   2) Castleing rights  (- if no castlerights. Otherwise: QBCDFGKqbcdfgk)
              //   3) En passant square (- if no double pawn move has been made)
              //   4) Halfturns since last capture or pawnmove (for 50 move rule)
              //   5) Turns of the game (for fun :D)

          // Initialize field containers
          resetFields();

          string position = chunks[0];
          int currentSquare = 0;
          foreach (char c in position)
          {
              // update everything
              switch (c) // Refactor for speed later TODO
              {
                  case '/': // just a divider of the lines. Does not change anything.
                      break;
                  case 'P':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_PAWN);
                      currentSquare++;
                      break;
                  case 'R':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_ROOK);
                      currentSquare++;
                      break;
                  case 'N':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_KNIGHT);
                      currentSquare++;
                      break;
                  case 'B':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_BISHOP);
                      currentSquare++;
                      break;
                  case 'Q':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_QUEEN);
                      currentSquare++;
                      break;
                  case 'K':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_KING);
                      currentSquare++;
                      break;
                  case 'I':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_MINISTER);
                      currentSquare++;
                      break;
                  case 'L':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_ELEPHANT);
                      currentSquare++;
                      break;
                  case 'C':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_CAMEL);
                      currentSquare++;
                      break;
                  case 'M':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_MAN);
                      currentSquare++;
                      break;
                  case 'S':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_PRINCESS);
                      currentSquare++;
                      break;
                  case 'E':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_EMPRESS);
                      currentSquare++;
                      break;
                  case 'p':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_PAWN);
                      currentSquare++;
                      break;
                  case 'r':
                      updateSinglePiece(currentSquare, ColoredPiece.WHITE_ROOK);
                      currentSquare++;
                      break;
                  case 'n':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_KNIGHT);
                      currentSquare++;
                      break;
                  case 'b':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_BISHOP);
                      currentSquare++;
                      break;
                  case 'q':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_QUEEN);
                      currentSquare++;
                      break;
                  case 'k':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_KING);
                      currentSquare++;
                      break;
                  case 'i':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_MINISTER);
                      currentSquare++;
                      break;
                  case 'l':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_ELEPHANT);
                      currentSquare++;
                      break;
                  case 'c':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_CAMEL);
                      currentSquare++;
                      break;
                  case 'm':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_MAN);
                      currentSquare++;
                      break;
                  case 's':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_PRINCESS);
                      currentSquare++;
                      break;
                  case 'e':
                      updateSinglePiece(currentSquare, ColoredPiece.BLACK_EMPRESS);
                      currentSquare++;
                      break;
                  default: // symbol is a number and we simply increment currentsquar
                      currentSquare += c - 48; // in ascii '0' is 48.
                      break;
              }
          }
        
          // Set player in turn:
          playerInTurn = chunks[1].Equals("w") ? Color.WHITE : Color.BLACK;

          // Set castling rights:
          string castleString = chunks[2];
          if (!castleString.Equals("-"))
          {
            foreach (char c in castleString)
            {
              canCastle[castleSquareConverter[c - 64]] = true;
            }
          }

          string enPassantInformation = chunks[3];
          if (enPassantInformation.Equals("-"))
          {
            enPassantSquare = -1;
          }
          else
          {
            enPassantSquare = enPassantInformation[0] - 8 * enPassantInformation[1] + 351; // ascii magic
          }


        }
        public string generateMoveFEN(int from, int to)
        {
            throw new NotImplementedException();
        }

        public List<(int, int)> generateMoves()
        {
            throw new NotImplementedException();
        }

        
    }
}