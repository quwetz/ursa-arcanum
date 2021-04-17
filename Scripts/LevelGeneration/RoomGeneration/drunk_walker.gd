class_name DrunkWalker

extends Walker

var steps_left: int
var grid: Grid

func _init(start: Int2D, grid: Grid, n_steps: int, rng: RandomNumberGenerator).(start, rng):
	steps_left = n_steps
	self.grid = grid


func walk(tile: String):
	while steps_left > 0:
		if (grid.get_value_Int2D(pos) == "Free"):
			grid.set_value_Int2D(pos, tile)
		step()


func step():
	if(steps_left > 0):
		var direction: Int2D = Util.rand_axis_aligned_direction(rng)
		pos.x = clamp(pos.x + direction.x, 0, grid.cols - 1)
		pos.y = clamp(pos.y + direction.y, 0, grid.rows - 1)
		steps_left -= 1
