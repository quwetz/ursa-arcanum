class_name FasterSupport
extends SupportRune

func _apply_support_effect(s: Spell):
	s.cast_speed *= 1.3
	s.proj_speed *= 1.3
	s.dmg *= 0.7
