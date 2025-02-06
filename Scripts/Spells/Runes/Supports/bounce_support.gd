class_name BounceSupport
extends SupportRune

func _init(s: Spell):
	spell = s
	n_bounce = 2
	Globals.cheat_controller.bounce = self
