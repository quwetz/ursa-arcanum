class_name Door
extends StaticBody2D

onready var Anim: AnimatedSprite = $AnimatedSprite

func _ready():
	Anim.frame = 0
	Anim.stop()
	Anim.get_sprite_frames().set_animation_loop("default", false)


func _on_Triggerbox_body_entered(body):
	open()



func _on_Triggerbox_body_exited(body):
	close()


func open():
	Anim.play("default", false)
	yield(get_tree().create_timer(0.1), "timeout")
	$CollisionShape2D.set_deferred("disabled", true)


func close():
	Anim.play("default", true)
	$CollisionShape2D.set_deferred("disabled", false)
