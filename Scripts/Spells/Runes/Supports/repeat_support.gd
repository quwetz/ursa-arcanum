class_name RepeatSupport
extends SupportRune

func _apply_support_effect(s: Spell):
	s.cast_speed *= 2.0
	s.n_repitions += 1
	s.dmg *= 0.5
