class_name FireballFadeout
extends ParticleOneshot

onready var velocity: Vector2 = Vector2.ZERO 


func _process(delta):
	global_position +=  velocity * delta
	velocity *= 0.85


func initialize(pos, speed, rotation):
	global_position = pos
	velocity = Vector2.RIGHT.rotated(rotation) * speed

