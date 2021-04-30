class_name StateWander

extends StateBase

var direction: Vector2
var StateChase

func _init(e: Node2D).(e):
	direction = Vector2.RIGHT.rotated(rand_range(-PI, PI))
	StateChase = load(states_path + "/Enemies/state_chase.gd")


func _process(delta: float):
	direction = direction.rotated(rand_range(-PI/10, PI/10))
	e.velocity = e.velocity.move_toward(direction * e.stats.move_speed * e.stats.wander_speed_multi, e.stats.friction * delta)


func _handle_input() -> StateBase:
	if e.playerDetector.can_see_player():
		return StateChase.new(e)
	else:
		return null


func _enter():
	pass


func _exit():
	pass


func animation_finished():
	pass
