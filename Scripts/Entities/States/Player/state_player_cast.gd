class_name StatePlayerCast

extends StateBase

var StateMove
var StateRoll

func _init(e: Node2D).(e):
	StateMove = load(states_path + "/Player/state_player_move.gd")
	StateRoll = load(states_path + "/Player/state_player_roll.gd")
	
func _enter():
	e.animationTree.set("parameters/Cast/TimeScale/scale", e.active_spell.cast_speed)
	e.animationState.start("Cast")
	e.set_target_pos()


func _exit():
	pass
	
	
func _process(delta: float):
	pass


func _handle_input() -> StateBase:
	if e.move_key_pressed():
		return StateMove.new(e)
	if Input.is_action_just_pressed("roll"):
		return StateRoll.new(e)
	return null
	
func cast():
	e.active_spell.cast(e.target_pos)

func animation_finished():
	if Input.is_action_pressed("cast"):
		_enter()
	else:
		e.change_state(StateMove.new(e))
