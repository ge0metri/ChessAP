class_name Board
extends Node2D

var grid : Array[Array]
var selected_piece: Vector2i
var has_selected_piece : bool
var highlighted_moves : Array[Vector2i]

func setup_board(piece_layout: Dictionary[Vector2i, Piece]) -> void:
	for row in range(Rules.BOARD_SIZE):
		for column in range(Rules.BOARD_SIZE):
			var current_position := Vector2i(row,column)
			if piece_layout.has(current_position):
				grid[column][row] = piece_layout[current_position]
			else:
				grid[column][row] = null

func get_piece(position_vector:Vector2i) -> Piece:
	return grid[position_vector.y][position_vector.x] as Piece

func set_piece(position_vector:Vector2i, piece:Piece) -> void:
	grid[position_vector.y][position_vector.x] = piece

func move_piece(from:Vector2i, to:Vector2i) -> void:
	set_piece(to, get_piece(from))
	set_piece(from, null)

func get_pieces() -> Dictionary[Vector2i, Piece]:
	var out: Dictionary[Vector2i, Piece] = {}
	for row in range(Rules.BOARD_SIZE):
		for column in range(Rules.BOARD_SIZE):
			var current_position := Vector2i(row,column)
			var current_piece: Piece = get_piece(current_position)
			if current_piece:
				out[current_position] = current_piece
	return out

func clone() -> Board:
	var out:= Board.new()
	out.setup_board(get_pieces())
	return out
