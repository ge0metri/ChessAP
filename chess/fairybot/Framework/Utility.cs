using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChessAP.chess.fairybot.Framework
{
    public static class Utility
    {
        public static int mapIndex(ColoredPiece coloredPiece)
        {
            return (int) coloredPiece;
        }

        public static int mapIndex(Color color)
        {
            return ((int) color) << 4;
        }

        public static Color colorOfPiece(ColoredPiece coloredPiece)
        {
            return (Color) ((int) coloredPiece >> 4);
        }
    }
}