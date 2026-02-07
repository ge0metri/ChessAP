class_name GameController
extends Node2D

@export var board : Board
@export var game_state : GameState
@export var player_color : Rules.COLOR
@export var unlocked_moves : Dictionary
@export var player_status: PlayerStatus

func _ready() -> void:
	player_status = preload("uid://co4hwhncg0bxt")
	game_state = GameState.new()
	game_state.board = board
	var move := MoveRecord.new()
	move.piece = Piece.new(Rules.PieceType.PAWN, Rules.COLOR.BLACK)
	move.from = Vector2i(6, 6)
	move.to = Vector2i(6, 4)
	game_state.move_history.append(move)
	var piece_layot : Dictionary[Vector2i, Piece] = {}
	for i in range(8):
		piece_layot[Vector2i(i, 1)] = Piece.new(Rules.PieceType.PAWN, Rules.COLOR.WHITE)
		piece_layot[Vector2i(i, 6)] = Piece.new(Rules.PieceType.PAWN, Rules.COLOR.BLACK)
	piece_layot[Vector2i(5, 4)] = Piece.new(Rules.PieceType.PAWN, Rules.COLOR.WHITE)
	piece_layot[Vector2i(6, 4)] = Piece.new(Rules.PieceType.PAWN, Rules.COLOR.BLACK)
	var camel := Piece.new(Rules.PieceType.CAMEL, Rules.COLOR.BLACK)
	piece_layot[Vector2i(0, 1)] = camel
	board.initiate_board()
	board.setup_board(piece_layot)
	board.update_piece_positions()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug1"):
		pass
	if not game_state.current_player == player_color:
		return
	if event is InputEventMouseButton and event.is_action_released("mouse_left") and board.get_selected_square():
		var square = board.calculate_mouse_pos_to_square()
		print_debug("Square released ", square)
		game_state.execute_move(board.get_selected_square(), square)
		board.stop_drag()
	if event is InputEventMouse:
		var square = board.calculate_mouse_pos_to_square()
		if event.is_action_pressed("mouse_left") and board.selected_piece.is_empty():
			if board.select_piece_at(square, player_color):
				board.highlight_squares(Rules.get_legal_moves(board, square, game_state.move_history, player_status.unlockced_moves))
			else:
				board.highlight_squares([])
		print_debug("Square clicked ", square)
		board.drag_selected_piece()
