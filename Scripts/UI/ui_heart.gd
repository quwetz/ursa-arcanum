extends AnimatedSprite

var threshold_empty: float
var threshold_half: float
var hp: float = 0.0


func set_thresholds(empty: float, half: float):
	threshold_empty = empty
	threshold_half = half


func update_heart(new_hp: float):
	if new_hp > threshold_half:
		# heart should be full
		animation = "destroy_full"
		frame = 0
		playing = false
	elif new_hp <= threshold_empty:
		# heart should be empty, check if and which animation to play
		if hp > threshold_half:
			play_animation("destroy_full")
		elif hp > threshold_empty:
			play_animation("destroy_second_half")
	else:
		# heart should be half-empty, check if and which animation to play
		if hp > threshold_half:
			play_animation("destroy_first_half")
		else:
			animation = "destroy_second_half"
			frame = 0
			playing = false
	hp = new_hp


func play_animation(anim: String):
	animation = anim
	frame = 0
	play()
	
