namespace ChessAP.chess.fairybot.Framework
{
    public enum Piece
    {
    NONE,
	// Standard pieces
	PAWN, 
    ROOK, 
    KNIGHT,
    BISHOP, 
    QUEEN, 
    KING,
	// Historical pieces
	MINISTER,    // Moves like a weak queen (1 square diagonally or orthogonally)
	ELEPHANT,    // Jumps exactly 2 squares diagonally
	CAMEL,       // Knight-like: jumps in 3-1 L-shape
	MAN,         // King-like but can be captured
	PRINCESS,    // Bishop + Knight
	EMPRESS,     // Rook + Knight
    }
}