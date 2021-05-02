extends Node

signal take_hit(damage, hit_direction)

func hit(damage: Dictionary, hit_direction: Vector2):
	emit_signal("take_hit", damage, hit_direction)
