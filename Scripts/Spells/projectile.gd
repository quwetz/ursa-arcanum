class_name Projectile
extends KinematicBody2D

var proj_scene = load("res://Scenes/projectile.tscn")

var fork_angle: float = PI/4
var motion = Vector2.ZERO setget set_motion
#TODO: link motion and rotation via setter to clean up rotation_setting

var n_pierce: int
var n_chain: int
var n_fork: int
var n_bounce: int

var speed: float
var explosion_radius: float
var dmg: float

var exploding: bool = false

var target_area: Area2D
var target_area_radius: int = 256


func _physics_process(delta):
	var coll = move_and_collide(motion * delta)
	if coll != null:
		# collision with wall
		if n_bounce > 0:
			set_motion(motion.bounce(coll.normal))
			rotation = motion.angle()
			n_bounce -= 1
			dmg *= 1.1
		else:
			queue_free()


func initialize(s: Spell):
	n_pierce = s.n_pierce
	n_chain = s.n_chain
	n_fork = s.n_fork
	n_bounce = s.n_bounce
	speed = s.proj_speed * 200.0
	explosion_radius = s.aoe_radius
	set_motion(Vector2.RIGHT.rotated(rotation).normalized() * speed)
	
	# add $TargetArea if needed
	if n_chain > 0:
		add_target_area()



#an entity is hit
func _on_Hitbox_body_entered(body):
	body.hit()
	if n_chain > 0:
		chain(body)
	elif n_pierce > 0:
		n_pierce -= 1
	elif n_fork > 0:
		fork()
	else:
		queue_free()


func copy() -> Projectile:
	var p = proj_scene.instance()
	p.position = position
	p.n_pierce = n_pierce
	p.n_chain = n_chain
	p.n_fork = n_fork
	p.n_bounce = n_bounce
	p.speed = speed
	p.explosion_radius = explosion_radius
	p.exploding = exploding
	p.set_motion(motion)
	return p


# change the direction to another targetable Object in the TargetArea
# @hit_object: The object the projectile initially hit (has to be excluded from raycast)
func chain(hit_object: PhysicsBody2D):
	#TODO: different collidion masks for TargetArea
	var possible_targets = target_area.get_overlapping_bodies()
	#loop through all enemies in TargetArea and choose any one of them, that has line of sight
	for t in possible_targets:
		if t != hit_object:
			var result = get_world_2d().direct_space_state.intersect_ray(
					global_position, t.global_position, [], collision_mask)
			if not result:
				set_motion((t.global_position - global_position).normalized() * speed)
				break
	n_chain -= 1
	if n_chain == 0:
		remove_child(target_area)
		target_area.queue_free()


func fork():
	var p = copy()
	set_motion(motion.rotated(fork_angle))
	p.set_motion(p.motion.rotated(-fork_angle))
	get_parent().add_child(p)
	n_fork -= 1
	p.n_fork -= 1

# adds a $TargetArea Node to the projectile (needed for example for chaining
func add_target_area():
	target_area = Area2D.new()
	target_area.name = "TargetArea"
	var col = CollisionShape2D.new()
	col.shape = CircleShape2D.new()
	col.shape.radius = target_area_radius
	target_area.add_child(col)
	target_area.collision_layer = Globals.PROJECTILE_LAYER
	target_area.collision_mask = $HitBox.collision_mask
	add_child(target_area)


func set_motion(v: Vector2):
	motion = v
	rotation = v.angle()
