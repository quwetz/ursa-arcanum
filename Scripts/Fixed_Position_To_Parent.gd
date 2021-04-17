extends Node2D

onready var offset: Vector2 = Vector2(0, -6)

func _process(delta):
	position = offset
	print(position)
