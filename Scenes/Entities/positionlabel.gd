extends RichTextLabel


func _process(delta):
	text = String(get_parent().global_position)
