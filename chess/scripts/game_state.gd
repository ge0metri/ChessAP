class_name GameState
extends Resource

enum GameStatus {
	WHITE_WINS,
	BLACK_WINS,
	STALEMATE,
	FIFTY_MOVES,
	THREE_FOLD_REPITITION,
}

var board:Board
var current_player: Rules.COLOR
var move_history: Array[MoveRecord]
var captured_prices : Dictionary[Rules.COLOR, Array]
var game_status: GameStatus
var starting_position : Dictionary[Vector2i, Piece] # Should this be moved up?
var material_count: Dictionary[Rules.COLOR, float]

func execute_move(from:Vector2i, to:Vector2i) -> bool:
	var player_status: PlayerStatus = preload("uid://co4hwhncg0bxt")
	if Rules.is_move_legal(board, from, to, move_history, player_status.unlockced_moves):
		if Rules.is_valid_en_passant(board, from, to, board.get_piece(from), move_history):
			board.set_piece(Rules.get_en_passant_capture_square(from, to), null)
		board.move_piece(from, to)
		return true
	return false
