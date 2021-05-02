class_name StateChase

extends StateBase

var player: CollisionObject2D
var StateWander


func _init(e: Node2D).(e):
	StateWander = load(states_path + "/Enemies/state_wander.gd")
	player = e.playerDetector.player
	

func _process(delta: float):
	if player != null:
		var direction: Vector2 = (player.global_position - e.global_position).normalized()
		e.velocity = e.velocity.move_toward(direction * e.stats.move_speed, delta * e.stats.acceleration)
		e.set_pivot_orientation(player.global_position - e.hitBoxPivot.global_position)


func _handle_input() -> StateBase:
	if not e.playerDetector.can_see_player():
		return StateWander.new(e)
	elif e.global_position.distance_squared_to(player.global_position) < e.stats.attack_range_squared:
		return StateAttack.new(e)
	else:
		return null


func _enter():
	pass


func _exit():
	pass


func animation_finished():
	pass
