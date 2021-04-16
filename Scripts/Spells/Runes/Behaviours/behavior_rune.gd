class_name BehaviourRune
extends Rune

func _init():
	assert(self.has_method("_execute"))
	type = "behaviour"

# @override _execute(s: Spell, target_pos: Vector2):
