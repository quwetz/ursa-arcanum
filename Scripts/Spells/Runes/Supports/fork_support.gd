class_name ForkSupport
extends SupportRune

func _init(s: Spell):
	spell = s
	n_fork = 1
	Globals.cheat_controller.fork = self
