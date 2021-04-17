extends KinematicBody2D

enum {RUNNING, ROLLING, CASTING, CHARGING}

const RUN_SPEED = 100.0
const ROLL_SPEED = 160.0

var state: int = RUNNING
var next_state: int
var active_spell: Spell
var spell_target_pos: Vector2
var roll_direction: Vector2 = Vector2.DOWN
var velocity: Vector2 = Vector2.ZERO

onready var projSpawnCenter = $ProjSpawnCenter
onready var projSpawnPos = get_node("ProjSpawnCenter/ProjSpawnPos")
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.set_active(true)
	
	active_spell = Spell.new(self)
	active_spell.add_rune(FireRune.new())
	active_spell.add_rune(ProjectileRune.new())
	active_spell.add_rune(BounceSupport.new())
	active_spell.add_rune(ChainSupport.new())
	active_spell.add_rune(ForkSupport.new())
	active_spell.add_rune(AmplifySupport.new())
	active_spell.add_rune(FasterSupport.new())


func _physics_process(delta):
	match state:
		CASTING:
			cast_state()
		RUNNING:
			move_state()
		ROLLING:
			roll_state()
		CHARGING:
			pass
	if Input.is_action_just_pressed("roll"):
		state = ROLLING
		next_state = RUNNING


func cast_state():
	if move_key_pressed():
		# cancel casting if receiving movement input
		state = RUNNING

func move_state():
	var movement_input = get_playermovement_input()
	if movement_input != Vector2.ZERO:
		roll_direction = movement_input
		velocity = movement_input * RUN_SPEED
		set_anim_direction(movement_input)
		animationState.travel("Run")
	else:
		velocity = Vector2.ZERO
		animationState.travel("Idle")
		if Input.is_action_pressed("cast"):
			start_casting()
	move()
	if Input.is_action_just_pressed("cast"):
		start_casting()


func roll_state():
	animationState.travel("Roll")
	velocity = roll_direction * ROLL_SPEED
	move()
	if Input.is_action_pressed("cast"):
		next_state = CASTING


func move():
	move_and_slide(velocity)

func get_playermovement_input():
	var input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		)
	return input.normalized()


func move_key_pressed():
	return Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")

func start_casting():
	state = CASTING
	animationTree.set("parameters/Cast/TimeScale/scale", active_spell.cast_speed)
	spell_target_pos = get_global_mouse_position()
	set_proj_spawn_pos()
	var facing_direction = (get_global_mouse_position() - global_position).normalized()
	set_anim_direction(facing_direction)
	roll_direction = facing_direction
	animationState.start("Cast")


func cast_anim_finished():
	active_spell.cast(spell_target_pos)
	if Input.is_action_pressed("cast"):
		start_casting()
	else:
		state = RUNNING


func roll_anim_finished():
	state = next_state
	if(next_state == CASTING):
		start_casting()
	next_state = RUNNING


func set_proj_spawn_pos():
	projSpawnCenter.rotation = (spell_target_pos - projSpawnCenter.global_position).angle()

func set_anim_direction(v: Vector2):
	animationTree.set("parameters/Cast/BlendSpace2D/blend_position", v)
	animationTree.set("parameters/Run/blend_position", v)
	animationTree.set("parameters/Idle/blend_position", v)
	animationTree.set("parameters/Roll/blend_position", v)


func hit():
	get_tree().reload_current_scene()
