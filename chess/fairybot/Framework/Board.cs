using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;


namespace ChessAP.chess.fairybot.Framework
{
    public interface Board
    {
        (Piece, Color) getPieceOnSquare(int colomn, int row);
        void setPieceOnSquare(int colomn, int row, Piece piece, Color color);
        Piece removePieceFromSquare(int colomn, int row);
        Piece movePiece(int colomn_from, int row_from, int colomn_to, int row_to);
        void print();
    }
}