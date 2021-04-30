extends Node

signal take_hit(damage)

func hit(damage: Dictionary):
	emit_signal("take_hit", damage)
