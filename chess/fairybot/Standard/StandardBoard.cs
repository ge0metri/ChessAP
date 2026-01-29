using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using ChessAP.chess.fairybot.Framework;



namespace ChessAP.chess.fairybot.Standard
{
    public class StandardBoard : Board
    {
        private Piece[,] currentBoard;
        
        public StandardBoard()
        {
            currentBoard = new Piece[8,8];
        }

        public (Piece, Color) getPieceOnSquare(int colomn, int row)
        {
            throw new NotImplementedException();
        }

        public Piece movePiece(int colomn_from, int row_from, int colomn_to, int row_to)
        {
            throw new NotImplementedException();
        }

        public void print()
        {
            throw new NotImplementedException();
        }

        public Piece removePieceFromSquare(int colomn, int row)
        {
            throw new NotImplementedException();
        }

        public void setPieceOnSquare(int colomn, int row, Piece piece, Color color)
        {
            throw new NotImplementedException();
        }
    }
}