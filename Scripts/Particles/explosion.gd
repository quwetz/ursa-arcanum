extends ParticleOneShot

export var light_energy: float = 1.0
onready var light = $Light2D

func _ready():
	light.energy = light_energy
	
func _process(delta):
	light.energy -= (light_energy / lifetime) * delta
