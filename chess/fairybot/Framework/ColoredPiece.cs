namespace ChessAP.chess.fairybot.Framework
{
    public enum ColoredPiece
    {
        NONE = 0,
	    // White pieces
        WHITE_PAWN = 16 + 1, 
        WHITE_ROOK = 16 + 2, 
        WHITE_KNIGHT = 16 + 3,
        WHITE_BISHOP = 16 + 4, 
        WHITE_QUEEN = 16 + 5, 
        WHITE_KING = 16 + 6,
	    // Historical pieces
	    WHITE_MINISTER = 16 + 7,    // Moves like a weak queen (1 square diagonally or orthogonally)
	    WHITE_ELEPHANT = 16 + 8,    // Jumps exactly 2 squares diagonally
	    WHITE_CAMEL = 16 + 9,       // Knight-like: jumps in 3-1 L-shape
	    WHITE_MAN = 16 + 10,         // King-like but can be captured
	    WHITE_PRINCESS = 16 + 11,    // Bishop + Knight
        WHITE_EMPRESS = 16 + 12,  

        // Black pieces:
        BLACK_PAWN = 32 + 1, 
        BLACK_ROOK = 32 + 2, 
        BLACK_KNIGHT = 32 + 3,
        BLACK_BISHOP = 32 + 4, 
        BLACK_QUEEN = 32 + 5, 
        BLACK_KING = 32 + 6,
	    // historical pieces
        BLACK_MINISTER = 32 + 7,    // Moves like a weak queen (1 square diagonally or orthogonally)
	    BLACK_ELEPHANT = 32 + 8,    // Jumps exactly 2 squares diagonally
	    BLACK_CAMEL = 32 + 9,       // Knight-like: jumps in 3-1 L-shape
	    BLACK_MAN = 32 + 10,         // King-like but can be captured
	    BLACK_PRINCESS = 32 + 11,    // Bishop + Knight
	    BLACK_EMPRESS = 32 + 12,    // Rook + Knight
    }
}