class_name ChainSupport
extends SupportRune

func _init(s: Spell):
	spell = s
	n_chain = 1
	dmg = 0.75
	Globals.cheat_controller.chain = self
