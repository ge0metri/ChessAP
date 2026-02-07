class_name Board
extends Node2D

signal square_clicked(pos : Vector2i)
signal piece_selected(pos : Vector2i)
signal move_animation_finished()
signal piece_dragged(from: Vector2i, to: Vector2i)

var grid : Array[Array]
var selected_piece: Dictionary[Vector2i, Piece]
var ui_pieces : Dictionary[Vector2i, ChessPiece]
var highlighted_sqaures : Array[Node2D]
@onready var chess_board: Sprite2D = $ChessBoard

func initiate_board() -> void:
	var new_board : Array[Array] = []
	for row in range(Rules.BOARD_SIZE):
		var row_array := []
		for column in range(Rules.BOARD_SIZE):
			row_array.append(null)
		new_board.append(row_array)
	grid = new_board

func setup_board(piece_layout: Dictionary[Vector2i, Piece]) -> void:
	for square in piece_layout:
		set_piece(square, piece_layout[square])
		

func get_piece(position_vector:Vector2i) -> Piece:
	if position_vector > Vector2i.ONE*7 or position_vector < Vector2i.ZERO:
		return
	return grid[position_vector.y][position_vector.x] as Piece

func set_piece(square:Vector2i, piece:Piece) -> void:
	grid[square.y][square.x] = piece
	if piece == null:
		if ui_pieces.has(square):
			ui_pieces[square].queue_free()
			ui_pieces.erase(square)
		return
	var new_piece_scene := preload("res://chess/scenes/chess_piece.tscn")
	var new_piece : ChessPiece = new_piece_scene.instantiate()
	new_piece.setup(piece)
	ui_pieces[square] = new_piece
	add_child(new_piece)

func move_piece(from:Vector2i, to:Vector2i) -> void:
	set_piece(to, null)
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
	out.initiate_board()
	out.setup_board(get_pieces())
	return out

func calculate_mouse_pos_to_square() -> Vector2i:
	var mouse_pos := get_local_mouse_position()
	var board_rect := chess_board.get_rect()
	var square_size := board_rect.size/Rules.BOARD_SIZE
	return Vector2i(
		int((mouse_pos.x - board_rect.position.x)/square_size.x), 
		int((board_rect.position.y - mouse_pos.y)/square_size.y) + Rules.BOARD_SIZE - 1
	)

func _square_to_2d_pos(square:Vector2i) -> Vector2:
	var board_rect := chess_board.get_rect()
	var square_size := board_rect.size/Rules.BOARD_SIZE
	return (Vector2(square)*square_size)*Vector2(1,-1)  - board_rect.size*0.5*Vector2(1,-1) + square_size*0.5*Vector2(1,-1)

func update_piece_positions() -> void:
	for pos in ui_pieces:
		ui_pieces[pos].position = _square_to_2d_pos(pos)

func select_piece_at(pos:Vector2i, player_color:Rules.COLOR) -> bool:
	var possible_piece := get_piece(pos)
	if possible_piece and possible_piece.color == player_color:
		selected_piece.clear()
		selected_piece[pos] = possible_piece
		return true
	return false

func drag_selected_piece() -> void:
	if selected_piece.is_empty():
		return
	ui_pieces[get_selected_square()].global_position = get_global_mouse_position()
	
func stop_drag() -> void:
	update_piece_positions()
	selected_piece.clear()
	highlight_squares([])

func valid_square(square:Vector2i) -> bool:
	if square == get_selected_square():
		return false
	if not (0 <= square.x and square.x <= 7 and 0 <= square.y and square.y <= 7):
		return false
	return true

func get_selected_square():
	if selected_piece.is_empty():
		return null
	return selected_piece.keys().front()

func highlight_squares(squares: Array[Vector2i]) -> void:
	print(squares)
	for node in highlighted_sqaures:
		node.queue_free()
	highlighted_sqaures.clear()
	for square in squares:
		var square_sprite := Sprite2D.new()
		square_sprite.texture = preload("uid://d1ftk3bomoxn4")
		square_sprite.modulate = Color(0.769, 0.812, 0.376, 0.58)
		square_sprite.scale = Vector2.ONE*0.125
		square_sprite.position = _square_to_2d_pos(square)
		square_sprite.z_index = -2
		highlighted_sqaures.append(square_sprite)
		add_child(square_sprite)
