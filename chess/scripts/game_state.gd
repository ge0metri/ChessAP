class_name GameState
extends Node

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
	if Rules.is_move_legal(board, from, to, move_history, {}): #TODO: REMEMBER THE UNLOCKED MOVES!!
		# MAKE MOVE
		return true
	return false
