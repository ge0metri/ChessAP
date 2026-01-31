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
        private ulong[] positionMaps;
        private ulong[] moveMaps;
        private Dictionary<int, ColoredPiece> spaceToPieceMap;
        private Dictionary<ColoredPiece, int[]> pieceToSpacesMap;
        private int enPassantSquare; // is -1 if no enPessent is possible
                public StandardFENHandler()
        {
            
        }

        public void setCurrentFEN(string fenString)
        {
            currentFENString = fenString;
            string[] chunks = fenString.Split(" ");
                // Splits the string into 6 bits:
                //   0) The position of the pieces
                //   1) The player in turn
                //   2) Castleing rights  (- if no castlerights)
                //   3) En passant square (- if no double pawn move has been made)
                //   4) Halfturns since last capture or pawnmove (for 50 move rule)
                //   5) Turns of the game (for fun :D)

            string position = chunks[0];
            int currentSquare = 0;
            foreach (char c in position)
            {
                // update everything
                // https://www.w3schools.com/cs/cs_switch.php
                switch (c)
                {
                    case 'P':
                        // TODO
                        break;
                }
            }

            //https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/strings/how-to-determine-whether-a-string-represents-a-numeric-value
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