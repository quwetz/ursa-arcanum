class_name StatePlayerMove

extends StateBase

var StateRoll
var StateCast

var velocity: Vector2 = Vector2.ZERO

func _init(e: Node2D).(e):
	StateRoll = load(states_path + "/Player/state_player_roll.gd")
	StateCast = load(states_path + "/Player/state_player_cast.gd")

func _enter():
	e.animationState.travel("Idle")

func _exit():
	pass
	
func _process(delta: float):
	if velocity != Vector2.ZERO:
		e.animationState.travel("Run")
		e.move_and_slide(velocity)
	else:
		e.animationState.travel("Idle")
	

func _handle_input() -> StateBase:
	if Input.is_action_just_pressed("roll"):
		return StateRoll.new(e)
	if Input.is_action_just_pressed("cast"):
		return StateCast.new(e)
	if e.move_key_released() and Input.is_action_pressed("cast"):
		return StateCast.new(e)
	set_velocity()
	return null
	

func set_velocity():
	var movement_input: Vector2 = e.get_playermovement_input()
	velocity = movement_input * e.stats.move_speed
	if velocity != Vector2.ZERO:
		e.set_direction(movement_input)


func animation_finished():
	pass
