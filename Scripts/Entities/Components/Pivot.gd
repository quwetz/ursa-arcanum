class_name Pivot

extends Position2D


func point_to(target_pos: Vector2):
	rotation = (target_pos - global_position).angle()

func set_direction(direction: Vector2):
	rotation = direction.angle()
