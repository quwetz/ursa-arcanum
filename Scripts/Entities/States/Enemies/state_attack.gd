class_name StateAttack

extends StateBase

var player: CollisionObject2D
var StateChase


func _init(e: Node2D).(e):
	StateChase = load(states_path + "/Enemies/state_chase.gd")
	player = e.playerDetector.player
	assert(player != null)
	

func _process(delta: float):
	var direction: Vector2 = (player.global_position - e.global_position).normalized()
	e.velocity = e.velocity.move_toward(direction * e.stats.move_speed, delta * e.stats.acceleration)
	e.set_pivot_orientation(player.global_position - e.hitBoxPivot.global_position)
	if e.sprite.frame == 2:
		e.set_hitbox_active(true)
	elif e.sprite.frame == 3:
		e.set_hitbox_active(false)


func _handle_input() -> StateBase:
	if not e.playerDetector.can_see_player():
		return StateWander.new(e)
	else:
		return null


func _enter():
	e.sprite.animation = "Attack"
	e.sprite.frame = 0

func _exit():
	e.sprite.animation = "Idle"


func animation_finished():
	e.change_state(StateChase.new(e))
