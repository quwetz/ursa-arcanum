class_name EntityBase
extends KinematicBody2D

var speed: float
var hp: int
var defense: Dictionary = 	{
								"phys": 0,
								"fire": 0,
								"ice": 0,
								"lightning": 0,
							}

var target_pos: Vector2

onready var projSpawnCenter = $ProjSpawnCenter
onready var projSpawnPos = get_node("ProjSpawnCenter/ProjSpawnPos")

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.set_active(true)


func set_proj_spawn_pos():
	projSpawnCenter.rotation = (target_pos - projSpawnCenter.global_position).angle()


func set_anim_direction(v: Vector2):
	animationTree.set("parameters/Cast/BlendSpace2D/blend_position", v)
	animationTree.set("parameters/Run/blend_position", v)
	animationTree.set("parameters/Idle/blend_position", v)
	animationTree.set("parameters/Roll/blend_position", v)


func _hit():
	assert(false)
