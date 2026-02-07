class_name PlayerStatus
extends Resource

var unlockced_moves : Dictionary[Rules.UNLOCKABLE_MOVES, bool] = {
	Rules.UNLOCKABLE_MOVES.PAWN_DOUBLE_MOVE : true,
	Rules.UNLOCKABLE_MOVES.EN_PASSANT : true,
}
var unlocked_pieces : Dictionary[Rules.PieceType, int]
