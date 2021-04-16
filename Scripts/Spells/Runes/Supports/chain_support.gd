class_name ChainSupport
extends SupportRune

func _apply_support_effect(s: Spell):
	s.n_chain += 1
	s.dmg *= 0.75
