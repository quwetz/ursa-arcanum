extends KinematicBody2D

var facing_direction: Vector2 = Vector2.RIGHT
var state: StateBase
var active_spell: Spell
var target_pos: Vector2

onready var projSpawnPivot = $ProjSpawnPivot
onready var projSpawnPos = $ProjSpawnPivot/ProjSpawn
onready var stats = $Stats
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var canvas = $CanvasModulate
onready var light = $ViewLight
onready var canvasModulate = $CanvasModulate

func _ready():
	animationTree.set_active(true)
	state = StatePlayerMove.new(self)
	state._enter()
	
	active_spell = Spell.new(self)
	active_spell.add_rune(FireRune.new())
	active_spell.add_rune(ProjectileRune.new())
	active_spell.add_rune(AmplifySupport.new(active_spell))
	active_spell.add_rune(PierceSupport.new(active_spell))
	active_spell.add_rune(BounceSupport.new(active_spell))
	active_spell.add_rune(ChainSupport.new(active_spell))
	active_spell.add_rune(ForkSupport.new(active_spell))
	active_spell.add_rune(FasterSupport.new(active_spell))

	


func _process(delta):
	var next_state: StateBase = state._handle_input()
	if(next_state != null):
		change_state(next_state)
	if Input.is_action_just_pressed("Debug4"):
		light.visible = !light.visible
		canvasModulate.visible = !canvasModulate.visible


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
	projSpawnPivot.point_to(target_pos)
	set_direction((target_pos - global_position).normalized())


func set_anim_direction(v: Vector2):
	animationTree.set("parameters/Cast/BlendSpace2D/blend_position", v)
	animationTree.set("parameters/Run/blend_position", v)
	animationTree.set("parameters/Idle/blend_position", v)
	animationTree.set("parameters/Roll/blend_position", v)


func change_state(to: StateBase):
	state._exit()
	state = to
	state._enter()


func state_anim_finished():
	state.animation_finished()

func state_cast():
	state.cast()

func move_key_pressed():
	return Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")


func move_key_released():
	return Input.is_action_just_released("move_down") or Input.is_action_just_released("move_up") or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right")


func _on_HurtBox_take_hit(damage: Dictionary, hit_direction: Vector2):
	stats.do_damage(damage)
	canvas.flash_red()


func _on_Stats_no_hp():
	queue_free()
