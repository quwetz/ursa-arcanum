class_name AmplifySupport
extends SupportRune

func _init(s: Spell):
	spell = s
	aoe_radius = 1.3
	n_projectiles = 2
	dmg = 0.75
	Globals.cheat_controller.amplify = self


