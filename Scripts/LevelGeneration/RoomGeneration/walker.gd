class_name Walker

extends Reference

var start: Int2D
var pos: Int2D
var rng: RandomNumberGenerator

func _init(start: Int2D, rng: RandomNumberGenerator):
	self.start = start
	pos = start
	self.rng = rng


# returns the position after taking a step
func step_random_towards(destination: Int2D, v_chance: float = 0.5):
	if pos.equals(destination):
		return
	if pos.x == destination.x:
		step_v_towards(destination)
		return
	if pos.y == destination.y:
		step_h_towards(destination)
		return
	if(rng.randf() < v_chance):
		step_v_towards(destination)
	else:
		step_h_towards(destination)


func step_v_towards(destination: Int2D):
	if pos.equals(destination):
		return
	pos.y += sign(destination.y - pos.y)
	

func step_h_towards(destination: Int2D):
	if pos.equals(destination):
		return
	pos.x += sign(destination.x - pos.x)
