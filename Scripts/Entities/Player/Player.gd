class_name Player

extends EntityBase


const SPEED = 100.0

var roll_speed_multi: float = 1.60
var facing_direction: Vector2 = Vector2.RIGHT
var state: StateBase
var active_spell: Spell


func _ready():
	speed = SPEED
	state = StatePlayerMove.new(self)
	state._enter()
	
	active_spell = Spell.new(self)
	active_spell.add_rune(FireRune.new())
	active_spell.add_rune(ProjectileRune.new())
	active_spell.add_rune(BounceSupport.new())
#	active_spell.add_rune(ChainSupport.new())
	active_spell.add_rune(ForkSupport.new())
	active_spell.add_rune(AmplifySupport.new())
	active_spell.add_rune(FasterSupport.new())


func _process(delta):
	var next_state: StateBase = state._handle_input()
	if(next_state != null):
		change_state(next_state)


func _physics_process(delta):
	state._process(delta)


func get_playermovement_input():
	var input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		)
	return input.normalized()


func set_direction(v: Vector2):
	facing_direction = v
	set_anim_direction(v)


func set_target_pos():
	target_pos = get_global_mouse_position()
	set_proj_spawn_pos()
	set_direction((get_global_mouse_position() - global_position).normalized())


func set_anim_direction(v: Vector2):
	animationTree.set("parameters/Cast/BlendSpace2D/blend_position", v)
	animationTree.set("parameters/Run/blend_position", v)
	animationTree.set("parameters/Idle/blend_position", v)
	animationTree.set("parameters/Roll/blend_position", v)


func change_state(to: StateBase):
	state._exit()
	state = to
	state._enter()


func _hit():
	get_tree().reload_current_scene()


func state_anim_finished():
	state.animation_finished()


func move_key_pressed():
	return Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")


func move_key_released():
	return Input.is_action_just_released("move_down") or Input.is_action_just_released("move_up") or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right")
