class_name Util

extends Reference

static func randi_range_step(a: int, b: int, step_size: int, rng: RandomNumberGenerator) -> int:
	var nums = range(a,b,step_size)
	return nums[rng.randi() % nums.size()]

static func rand_axis_aligned_direction(rng: RandomNumberGenerator):
	match rng.randi_range(0,3):
		0:
			return Int2D.new(0,1)
		1: 
			return Int2D.new(0,-1)
		2: 
			return Int2D.new(1,0)
		3: 
			return Int2D.new(-1,0)
