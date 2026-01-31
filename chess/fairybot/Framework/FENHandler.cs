using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChessAP.chess.fairybot.Framework
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


    public interface FENHandler
    {
        /// <summary>
        /// Takes a string describing a position in the FEN standard https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation
        /// and generates bitmaps of what piece is in what position including color maps, Dictionaries with positions of each type
        /// of piece and what is on each square. Also updates posible castling information, en passant and player in turn.
        /// </summary>
        /// <param name="fenString">FEN encoded string of the position</param>
        void setCurrentFEN(string fenString);

        /// <summary>
        /// Generates all posible moves for the current position
        /// </summary>
        /// <returns>List of all posible moves using (from, to) notation</returns>
        List<(int, int)> generateMoves();

        

        string generateMoveFEN(int from, int to);

    }
}