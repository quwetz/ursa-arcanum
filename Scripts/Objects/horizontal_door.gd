class_name HorizontalDoor
extends Door

var y_offset = 24

func set_global_position(v: Vector2):
	global_position = v
	global_position.y -= y_offset
