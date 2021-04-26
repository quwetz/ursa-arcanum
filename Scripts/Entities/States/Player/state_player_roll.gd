class_name StatePlayerRoll

extends StateBase

var StateMove
var StateCast

var velocity: Vector2 = Vector2.ZERO
var is_cast_pressed: bool = false

func _init(e: Node2D).(e):
	StateMove = load(states_path + "/Player/state_player_move.gd")
	StateCast = load(states_path + "/Player/state_player_cast.gd")

func _enter():
	e.animationState.travel("Roll")
	velocity = e.facing_direction * e.stats.move_speed * e.stats.roll_speed_multi

func _exit():
	pass
	
	
func _process(delta: float):
	e.move_and_slide(velocity)


func _handle_input() -> StateBase:
	if Input.is_action_just_pressed("cast"):
		is_cast_pressed = true
	return null
	

func animation_finished():
	var next_state: StateBase
	if is_cast_pressed or Input.is_action_pressed("cast"):
		next_state = StatePlayerCast.new(e)
	else:
		next_state = StateMove.new(e)
	e.change_state(next_state)
