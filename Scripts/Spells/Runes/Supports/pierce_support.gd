class_name PierceSupport
extends SupportRune

func _apply_support_effect(s: Spell):
	s.n_pierce += 2
	s.dmg *= 1.0
