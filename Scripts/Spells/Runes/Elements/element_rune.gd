class_name ElementRune
extends Rune


func _init():
	assert(self.has_method("_apply_status_effect"))
	type = "element"

# @override _apply_status_effect(object):
