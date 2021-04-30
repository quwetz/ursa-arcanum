extends Stats

export var wander_speed_multi: float = 0.2
export var damage_multi: float = 1.0
export var acceleration: float = 300
export var friction: float = 300
export var attack_range = 8 setget set_attack_range

export var base_damage = {
	"physical": 1
}
onready var damage = base_damage.duplicate()

onready var attack_range_squared = pow(attack_range, 2)



func set_attack_range(value):
	attack_range = value
	attack_range_squared = pow(value, 2)
