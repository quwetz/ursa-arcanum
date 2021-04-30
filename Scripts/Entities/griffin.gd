extends KinematicBody2D


var state: StateBase
var velocity: Vector2 = Vector2.ZERO


onready var stats = $Stats
onready var hurtBox = $HurtBox
onready var hitBox = $HitBoxPivot/HitBox
onready var hitBoxPivot = $HitBoxPivot
onready var sprite = $AnimatedSprite
onready var playerDetector = $PlayerDetector

func _ready():
	state = StateWander.new(self)
	hitBox.monitoring = false


func _process(delta):
	set_sprite_orientation()
	var next_state: StateBase = state._handle_input()
	if(next_state != null):
		change_state(next_state)
	state._process(delta)


func _physics_process(delta):
	velocity = move_and_slide(velocity)


func change_state(to: StateBase):
	state._exit()
	state = to
	state._enter()


func set_sprite_orientation():
	sprite.flip_h = velocity.x < 0


func set_pivot_orientation(v: Vector2):
	hitBoxPivot.rotation = v.angle()


func state_anim_finished():
	state.animation_finished()


func _on_Stats_no_hp():
	queue_free()
	
	
func set_hitbox_active(value: bool):
	hitBox.monitoring = value


func _on_HurtBox_take_hit(damage: Dictionary):
	stats.do_damage(damage)


func _on_AnimatedSprite_animation_finished():
	state.animation_finished()


func _on_HitBox_area_entered(area):
	area.hit(stats.damage)
