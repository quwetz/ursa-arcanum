class_name Util
extends Reference


static func randi_range_step(a: int, b: int, step_size: int, rng: RandomNumberGenerator) -> int:
	var nums = range(a,b,step_size)
	return nums[rng.randi() % nums.size()]
