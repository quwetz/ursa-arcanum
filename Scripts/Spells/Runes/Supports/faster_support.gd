class_name FasterSupport
extends SupportRune

func _init(s: Spell):
	spell = s
	cast_speed = 2
	proj_speed = 1.3
	dmg = 0.5
	Globals.cheat_controller.faster = self
