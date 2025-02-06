extends Label

func _process(delta):
	if(Input.is_action_just_pressed("toggle_cheatcodes")):
		self.visible = !self.visible
