class_name Piece
extends RefCounted

var type: Rules.PieceType
var color: Rules.COLOR
var has_moved: bool = false
var texture: Texture

func _init(_type: Rules.PieceType, _color: Rules.COLOR) -> void:
	type = _type
	color = _color
	has_moved = false
	match type:
		Rules.PieceType.PAWN:
			texture = load("uid://cjie1fvvif4ak") if color == Rules.COLOR.WHITE else load("uid://booekwlf1rt1t")
		Rules.PieceType.ROOK:
			texture = load("uid://c7rl6fbyuf0aw") if color == Rules.COLOR.WHITE else load("uid://cte64md7i8ui4")
		Rules.PieceType.KNIGHT:
			texture = load("uid://cnb0ovkanqhww") if color == Rules.COLOR.WHITE else load("uid://bsaqpinf0bt84")
		Rules.PieceType.BISHOP:
			texture = load("uid://c5twnr5qb0dyv") if color == Rules.COLOR.WHITE else load("uid://frp0owrw15u0")
		Rules.PieceType.QUEEN:
			texture = load("uid://dnqvhf4pw5iyd") if color == Rules.COLOR.WHITE else load("uid://dmyun0kj27voo")
		Rules.PieceType.KING:
			texture = load("uid://i710pqm28srs") if color == Rules.COLOR.WHITE else load("uid://d3qi7714b6sm")
		Rules.PieceType.MINISTER:
			texture = load("uid://bwvlfke7fcn1y") if color == Rules.COLOR.WHITE else load("uid://chvxakp4sirrs")
		Rules.PieceType.ELEPHANT:
			texture = load("uid://bvjv54gymqlki") if color == Rules.COLOR.WHITE else load("uid://lbof32u1gxje")
		Rules.PieceType.CAMEL:
			texture = load("uid://3pmpi1x3vkqj") if color == Rules.COLOR.WHITE else load("uid://7oxfs2lupv05")
		Rules.PieceType.MAN:
			texture = load("uid://ctwmc4ljggcsr") if color == Rules.COLOR.WHITE else load("uid://blpddjr04i27y")
		Rules.PieceType.PRINCESS:
			texture = load("uid://bd1t8qwm2yuu1") if color == Rules.COLOR.WHITE else load("uid://glefjbkskjfc")
		Rules.PieceType.EMPRESS:
			texture = load("uid://cqcsdgqqx740k") if color == Rules.COLOR.WHITE else load("uid://dit658gor37yc")
