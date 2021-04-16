extends KinematicBody2D

var player
var speed = 1

func _ready():
	player = get_parent().get_node("Player")

func _physics_process(delta):
	var coll = move_and_collide((player.position - position).normalized() * speed)
	if coll != null:
		if Globals.is_on_layer(Globals.PLAYER_LAYER, coll.collider.collision_layer):
			if coll.collider.has_method("hit"):
				coll.collider.hit()

func hit():
	queue_free()
