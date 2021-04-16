class_name SlowerSupport
extends SupportRune

func _apply_support_effect(s: Spell):
	s.cast_speed *= 0.8
	s.proj_speed *= 0.6
	s.dmg *= 1.2
