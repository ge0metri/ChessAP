using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;

using ChessAP.chess.fairybot.Framework;



namespace ChessAP.chess.fairybot.Standard
{
    public class StandardBoard : Board
    {
        private ColoredPiece[,] currentBoard;
        
        public StandardBoard(string piecePositionFEN)
        {
            currentBoard = new ColoredPiece[8,8];
        }

        public ColoredPiece getPieceOnSquare(int colomn, int row)
        {
            return currentBoard[colomn,row];
        }

        public ColoredPiece movePiece(int colomn_from, int row_from, int colomn_to, int row_to)
        {
            ColoredPiece pieceToMove = getPieceOnSquare(colomn_from, row_from);
            setPieceOnSquare(colomn_from, row_from, ColoredPiece.NONE);
            setPieceOnSquare(colomn_to, row_to, pieceToMove);
            return pieceToMove;
        }

        public void print()
        {
            throw new NotImplementedException();
        }

        public ColoredPiece removePieceFromSquare(int colomn, int row)
        {
            ColoredPiece pieceToRemove = getPieceOnSquare(colomn, row);
            setPieceOnSquare(colomn, row, ColoredPiece.NONE);
            return pieceToRemove;
        }

        public void setPieceOnSquare(int colomn, int row, ColoredPiece piece)
        {
            currentBoard[colomn, row] = piece;
        }
    }
}