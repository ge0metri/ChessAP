class_name ChessPiece
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func setup(piece:Piece) -> void:
	if not is_node_ready():
		await ready
	sprite_2d.texture = piece.texture
