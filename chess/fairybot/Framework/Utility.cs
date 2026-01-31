using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChessAP.chess.fairybot.Framework
{
    public class Utility
    {
        int mapIndex(ColoredPiece coloredPiece)
        {
            return (int) coloredPiece;
        }

        int mapIndex(Color color)
        {
            return ((int) color) << 4;
        }

        Color colorOfPiece(ColoredPiece coloredPiece)
        {
            return (Color) ((int) coloredPiece >> 4);
        }
    }
}