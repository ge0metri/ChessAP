class_name Rules
extends RefCounted

# ============================================================================
# ENUMS & CONSTANTS
# ============================================================================

enum PieceType {
	NONE,
	# Standard pieces
	PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING,
	# Historical pieces
	MINISTER,    # Moves like a weak queen (1 square diagonally or orthogonally)
	ELEPHANT,    # Jumps exactly 2 squares diagonally
	CAMEL,       # Knight-like: jumps in 3-1 L-shape
	MAN,         # King-like but can be captured
	PRINCESS,    # Bishop + Knight
	EMPRESS,     # Rook + Knight
	AMAZON,      # Queen + Knight. Will probably not get included
	# Asian pieces. Will probably not get included
	DRAGON_HORSE, # Bishop + adjacent orthogonal (1 square)
	DRAGON_KING,  # Rook + adjacent diagonal (1 square)
	CANNON        # Chinese chess cannon - jumps over exactly one piece to capture
}

enum COLOR {
	WHITE,
	BLACK
}

enum UNLOCKABLE_MOVES {
	PAWN_DOUBLE_MOVE,
	EN_PASSANT,
	CASTLE_KINGSIDE,
	CASTLE_QUEENSIDE,
	PROMOTION
}

const BOARD_SIZE = 8

# Direction vectors for piece movement
const DIR_ORTHOGONAL = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]
const DIR_DIAGONAL = [Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, -1), Vector2i(-1, 1)]
const DIR_ALL = DIR_ORTHOGONAL + DIR_DIAGONAL
const DIR_KNIGHT = [
	Vector2i(2, 1), Vector2i(2, -1), Vector2i(-2, 1), Vector2i(-2, -1),
	Vector2i(1, 2), Vector2i(1, -2), Vector2i(-1, 2), Vector2i(-1, -2)
]
const DIR_CAMEL = [
	Vector2i(3, 1), Vector2i(3, -1), Vector2i(-3, 1), Vector2i(-3, -1),
	Vector2i(1, 3), Vector2i(1, -3), Vector2i(-1, 3), Vector2i(-1, -3)
]
const DIR_ELEPHANT = [
	Vector2i(2, 2), Vector2i(2, -2), Vector2i(-2, 2), Vector2i(-2, -2)
]


# Material values for evaluation
const PIECE_VALUES = {
	PieceType.PAWN: 1,
	PieceType.KNIGHT: 3,
	PieceType.BISHOP: 3,
	PieceType.ROOK: 5,
	PieceType.QUEEN: 9,
	PieceType.KING: 0,  # Invaluable
	PieceType.MINISTER: 4,
	PieceType.ELEPHANT: 2,
	PieceType.CAMEL: 3,
	PieceType.MAN: 2,
	PieceType.PRINCESS: 7,
	PieceType.EMPRESS: 8,
	PieceType.AMAZON: 12,
	PieceType.DRAGON_HORSE: 6,
	PieceType.DRAGON_KING: 7,
	PieceType.CANNON: 4
}

# ============================================================================
# CORE VALIDATION FUNCTIONS
# ============================================================================

static func is_valid_position(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < BOARD_SIZE and pos.y >= 0 and pos.y < BOARD_SIZE

static func is_move_legal(board: Array, from: Vector2i, to: Vector2i, 
						   move_history: Array, unlocked_moves: Dictionary) -> bool:
	if not is_valid_position(from) or not is_valid_position(to):
		return false
	
	if from == to:
		return false
	
	var piece = board[from.y][from.x]
	if piece == null:
		return false
	
	var target = board[to.y][to.x]
	# Can't capture own pieces
	if target != null and target.color == piece.color:
		return false
	
	# Check if move matches piece's movement pattern
	if not is_valid_piece_move(board, from, to, piece, move_history, unlocked_moves):
		return false
	
	# Check if move leaves own king in check
	if would_be_in_check_after_move(board, from, to, piece.color):
		return false
	
	return true

static func is_valid_piece_move(board: Array, from: Vector2i, to: Vector2i, 
								 piece, move_history: Array, unlocked_moves: Dictionary) -> bool:
	match piece.type:
		PieceType.PAWN:
			return is_valid_pawn_move(board, from, to, piece, move_history, unlocked_moves)
		PieceType.ROOK:
			return is_valid_sliding_move(board, from, to, DIR_ORTHOGONAL)
		PieceType.KNIGHT:
			return is_valid_jump_move(from, to, DIR_KNIGHT)
		PieceType.BISHOP:
			return is_valid_sliding_move(board, from, to, DIR_DIAGONAL)
		PieceType.QUEEN:
			return is_valid_sliding_move(board, from, to, DIR_ALL)
		PieceType.KING:
			return is_valid_king_move(board, from, to, piece, move_history, unlocked_moves)
		PieceType.MINISTER:
			return is_in_direction(from, to, DIR_DIAGONAL, 1)
		PieceType.ELEPHANT:
			return is_valid_jump_move(from, to, DIR_ELEPHANT)
		PieceType.CAMEL:
			return is_valid_jump_move(from, to, DIR_CAMEL)
		PieceType.MAN:
			return is_in_direction(from, to, DIR_ALL, 1)
		PieceType.PRINCESS:  # Bishop + Knight
			return is_valid_sliding_move(board, from, to, DIR_DIAGONAL) or is_valid_jump_move(from, to, DIR_KNIGHT)
		PieceType.EMPRESS:  # Rook + Knight
			return is_valid_sliding_move(board, from, to, DIR_ORTHOGONAL) or is_valid_jump_move(from, to, DIR_KNIGHT)
		PieceType.AMAZON:  # Queen + Knight
			return is_valid_sliding_move(board, from, to, DIR_ALL) or is_valid_jump_move(from, to, DIR_KNIGHT)
		PieceType.DRAGON_HORSE:  # Bishop + 1 square orthogonal
			return is_valid_sliding_move(board, from, to, DIR_DIAGONAL) or is_in_direction(from, to, DIR_ORTHOGONAL, 1)
		PieceType.DRAGON_KING:  # Rook + 1 square diagonal
			return is_valid_sliding_move(board, from, to, DIR_ORTHOGONAL) or is_in_direction(from, to, DIR_DIAGONAL, 1)
		#PieceType.CANNON:
			#return is_valid_cannon_move(board, from, to)
	
	return false

# ============================================================================
# PIECE-SPECIFIC MOVEMENT VALIDATION
# ============================================================================

static func is_valid_pawn_move(board: Array, from: Vector2i, to: Vector2i, 
								piece, move_history: Array, unlocked_moves: Dictionary) -> bool:
	var direction = -1 if piece.color == COLOR.WHITE else 1
	var start_rank = 6 if piece.color == COLOR.WHITE else 1
	var delta = to - from
	
	# Forward move (one square)
	if delta.x == 0 and delta.y == direction:
		return board[to.y][to.x] == null
	
	# Forward move (two squares) - check if unlocked
	if unlocked_moves.get(UNLOCKABLE_MOVES.PAWN_DOUBLE_MOVE, false):
		if delta.x == 0 and delta.y == direction * 2 and from.y == start_rank:
			var middle = Vector2i(from.x, from.y + direction)
			return board[middle.y][middle.x] == null and board[to.y][to.x] == null
	
	# Capture
	if abs(delta.x) == 1 and delta.y == direction:
		var target = board[to.y][to.x]
		if target != null and target.color != piece.color:
			return true
		
		# En passant - check if unlocked
		if unlocked_moves.get(UNLOCKABLE_MOVES.EN_PASSANT, false):
			return is_valid_en_passant(board, from, to, piece, move_history)
	
	return false

static func is_valid_en_passant(_board: Array, from: Vector2i, to: Vector2i, 
								 piece, move_history: Array) -> bool:
	if move_history.is_empty():
		return false
	
	var last_move = move_history[-1]
	var direction = -1 if piece.color == COLOR.WHITE else 1
	
	# Check if last move was a pawn double-move adjacent to current pawn
	if last_move.piece_type != PieceType.PAWN:
		return false
	
	if abs(last_move.from.y - last_move.to.y) != 2:
		return false
	
	if last_move.to.x != to.x or last_move.to.y != from.y:
		return false
	
	# Check if target square is correct
	return to.y == from.y + direction and to.x == last_move.to.x

static func is_valid_king_move(board: Array, from: Vector2i, to: Vector2i, 
								piece, move_history: Array, unlocked_moves: Dictionary) -> bool:
	var delta = to - from
	
	# Normal king move (one square in any direction)
	if abs(delta.x) <= 1 and abs(delta.y) <= 1:
		return true
	
	# Castling - check if unlocked
	if unlocked_moves.get("castling", false):
		if delta.y == 0 and abs(delta.x) == 2:
			return can_castle(board, from, to, piece, move_history)
	
	return false

static func can_castle(board: Array, from: Vector2i, to: Vector2i, 
						piece, _move_history: Array) -> bool:
	# King must not have moved
	if piece.has_moved:
		return false
	
	# Determine rook position
	var is_kingside = to.x > from.x
	var rook_x = 7 if is_kingside else 0
	var rook_pos = Vector2i(rook_x, from.y)
	var rook = board[rook_pos.y][rook_pos.x]
	
	# Rook must exist and not have moved
	if rook == null or rook.type != PieceType.ROOK or rook.has_moved:
		return false
	
	# Path must be clear
	var start_x = min(from.x, rook_x) + 1
	var end_x = max(from.x, rook_x)
	for x in range(start_x, end_x):
		if board[from.y][x] != null:
			return false
	
	# King cannot be in check, pass through check, or end in check
	if is_in_check(board, from, piece.color):
		return false
	
	var direction = 1 if is_kingside else -1
	var intermediate_pos = Vector2i(from.x + direction, from.y)
	if would_be_in_check_at_position(board, intermediate_pos, piece.color):
		return false
	
	if would_be_in_check_at_position(board, to, piece.color):
		return false
	
	return true

static func is_valid_sliding_move(board: Array, from: Vector2i, to: Vector2i, 
								   directions: Array) -> bool:
	var delta = to - from
	
	# Check if move is in one of the allowed directions
	var valid_direction = false
	for dir in directions:
		if delta.x * dir.y == delta.y * dir.x and delta.sign() == dir.sign():
			valid_direction = true
			break
	
	if not valid_direction:
		return false
	
	# Check path is clear
	return is_path_clear(board, from, to)

static func is_valid_jump_move(from: Vector2i, to: Vector2i, jumps: Array) -> bool:
	var delta = to - from
	for jump in jumps:
		if delta == jump:
			return true
	return false

static func is_in_direction(from: Vector2i, to: Vector2i, directions: Array, max_distance: int) -> bool:
	var delta = to - from
	var distance = max(abs(delta.x), abs(delta.y))
	
	if distance > max_distance:
		return false
	
	for dir in directions:
		if delta.x * dir.y == delta.y * dir.x and delta.sign() == dir.sign():
			return true
	
	return false

#static func is_valid_cannon_move(board: Array, from: Vector2i, to: Vector2i) -> bool:
	#var delta = to - from
	#
	## Must move orthogonally
	#if delta.x != 0 and delta.y != 0:
		#return false
	#
	#var direction = delta.sign()
	#var pieces_between = 0
	#var current = from + direction
	#
	#while current != to:
		#if board[current.y][current.x] != null:
			#pieces_between += 1
		#current += direction
	#
	#var target = board[to.y][to.x]
	#
	## Non-capturing: no pieces between
	#if target == null:
		#return pieces_between == 0
	#
	## Capturing: exactly one piece between
	#return pieces_between == 1

# ============================================================================
# CHECK & CHECKMATE
# ============================================================================

static func is_in_check(board: Array, king_pos: Vector2i, player_color: int) -> bool:
	# Find if any enemy piece can attack the king position
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			var piece = board[y][x]
			if piece != null and piece.color != player_color:
				var from = Vector2i(x, y)
				# Check if this piece can attack king position (ignore check validation)
				if can_piece_attack(board, from, king_pos, piece):
					return true
	return false

static func can_piece_attack(board: Array, from: Vector2i, to: Vector2i, piece) -> bool:
	# Similar to is_valid_piece_move but without recursive check validation
	# Used to detect checks without infinite recursion
	match piece.type:
		PieceType.PAWN:
			var direction = -1 if piece.color == COLOR.WHITE else 1
			var delta = to - from
			return abs(delta.x) == 1 and delta.y == direction
		PieceType.ROOK:
			return is_valid_sliding_move(board, from, to, DIR_ORTHOGONAL)
		PieceType.KNIGHT:
			return is_valid_jump_move(from, to, DIR_KNIGHT)
		PieceType.BISHOP:
			return is_valid_sliding_move(board, from, to, DIR_DIAGONAL)
		PieceType.QUEEN:
			return is_valid_sliding_move(board, from, to, DIR_ALL)
		PieceType.KING, PieceType.MAN, PieceType.MINISTER:
			return is_in_direction(from, to, DIR_ALL, 1)
		PieceType.PRINCESS:
			return is_valid_sliding_move(board, from, to, DIR_DIAGONAL) or is_valid_jump_move(from, to, DIR_KNIGHT)
		PieceType.EMPRESS:
			return is_valid_sliding_move(board, from, to, DIR_ORTHOGONAL) or is_valid_jump_move(from, to, DIR_KNIGHT)
		PieceType.AMAZON:
			return is_valid_sliding_move(board, from, to, DIR_ALL) or is_valid_jump_move(from, to, DIR_KNIGHT)
		PieceType.DRAGON_HORSE:
			return is_valid_sliding_move(board, from, to, DIR_DIAGONAL) or is_in_direction(from, to, DIR_ORTHOGONAL, 1)
		PieceType.DRAGON_KING:
			return is_valid_sliding_move(board, from, to, DIR_ORTHOGONAL) or is_in_direction(from, to, DIR_DIAGONAL, 1)
		#PieceType.CANNON:
			#return is_valid_cannon_move(board, from, to)
	return false

static func would_be_in_check_after_move(board: Array, from: Vector2i, to: Vector2i, color: int) -> bool:
	# Simulate the move
	var board_copy = clone_board(board)
	var piece = board_copy[from.y][from.x]
	var captured = board_copy[to.y][to.x]
	
	board_copy[to.y][to.x] = piece
	board_copy[from.y][from.x] = null
	
	# Handle en passant capture
	if piece.type == PieceType.PAWN and to.x != from.x and captured == null:
		var capture_y = from.y
		board_copy[capture_y][to.x] = null
	
	# Find king position
	var king_pos = to if piece.type == PieceType.KING else find_king(board_copy, color)
	
	return is_in_check(board_copy, king_pos, color)

static func would_be_in_check_at_position(board: Array, pos: Vector2i, color: int) -> bool:
	return is_in_check(board, pos, color)

static func is_checkmate(board: Array, player_color: int, move_history: Array, unlocked_moves: Dictionary) -> bool:
	var king_pos = find_king(board, player_color)
	
	if not is_in_check(board, king_pos, player_color):
		return false
	
	# Check if any legal move exists
	return not has_legal_moves(board, player_color, move_history, unlocked_moves)

static func is_stalemate(board: Array, player_color: int, move_history: Array, unlocked_moves: Dictionary) -> bool:
	var king_pos = find_king(board, player_color)
	
	if is_in_check(board, king_pos, player_color):
		return false
	
	# No legal moves but not in check
	return not has_legal_moves(board, player_color, move_history, unlocked_moves)

static func has_legal_moves(board: Array, player_color: int, move_history: Array, unlocked_moves: Dictionary) -> bool:
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			var piece = board[y][x]
			if piece != null and piece.color == player_color:
				var from = Vector2i(x, y)
				var legal_moves = get_legal_moves(board, from, move_history, unlocked_moves)
				if not legal_moves.is_empty():
					return true
	return false

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

static func get_legal_moves(board: Array, position: Vector2i, move_history: Array, unlocked_moves: Dictionary) -> Array[Vector2i]:
	var legal_moves: Array[Vector2i] = []
	
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			var to = Vector2i(x, y)
			if is_move_legal(board, position, to, move_history, unlocked_moves):
				legal_moves.append(to)
	
	return legal_moves

static func find_king(board: Array, color: int) -> Vector2i:
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			var piece = board[y][x]
			if piece != null and piece.type == PieceType.KING and piece.color == color:
				return Vector2i(x, y)
	return Vector2i(-1, -1)  # Should never happen in valid game

static func is_path_clear(board: Array, from: Vector2i, to: Vector2i) -> bool:
	var delta = (to - from).sign()
	var current = from + delta
	
	while current != to:
		if board[current.y][current.x] != null:
			return false
		current += delta
	
	return true

static func clone_board(board: Array) -> Array:
	var new_board = []
	for row in board:
		new_board.append(row.duplicate())
	return new_board

static func is_promotion_square(position: Vector2i, piece) -> bool:
	if piece.type != PieceType.PAWN:
		return false
	
	var promotion_rank = 0 if piece.color == COLOR.WHITE else 7
	return position.y == promotion_rank

static func calculate_material_value(board: Array, color: int) -> int:
	var total = 0
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			var piece = board[y][x]
			if piece != null and piece.color == color:
				total += PIECE_VALUES.get(piece.type, 0)
	return total

static func get_piece_name(piece_type: PieceType) -> String:
	return PieceType.keys()[piece_type]
