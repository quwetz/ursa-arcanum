extends Camera2D

func _process(delta):
	if(Input.is_action_just_released("scroll_down")):
		zoom += Vector2(0.1, 0.1)
	if(Input.is_action_just_released("scroll_up")):
		zoom -= Vector2(0.1, 0.1)
