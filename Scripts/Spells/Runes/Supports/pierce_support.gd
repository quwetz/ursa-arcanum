class_name PierceSupport
extends SupportRune

func _init(s: Spell):
	spell=s
	n_pierce = 2
	dmg = 1.0
	Globals.cheat_controller.pierce = self
