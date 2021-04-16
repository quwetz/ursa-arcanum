class_name AmplifySupport
extends SupportRune

func _apply_support_effect(s: Spell):
	s.aoe_radius *= 1.3
	s.n_projectiles += 2
	s.dmg *= 0.75
