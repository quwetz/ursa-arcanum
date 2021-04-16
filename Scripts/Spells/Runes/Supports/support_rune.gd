class_name SupportRune
extends Rune

func _init():
	assert(self.has_method("_apply_support_effect"))
	type = "support"

# @override _apply_support_effect(s: Spell)
