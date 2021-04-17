class_name RoomLayoutRandom

extends RoomLayout


const PIT_CHANCE: float = 0.25


func _init(size: Int2D, rng: RandomNumberGenerator).(size, rng):
	pass


func _build_room():
	_connect_exits()
	update_free_positions()
	add_pit()
	add_pillars()
	add_clutter()


func _connect_exits():
	var connections_graph: Graph = exit_connections_graph(0.5)
	for e in connections_graph._E:
		draw_path(e.v1, e.v2)
		

func draw_path(pos1: Int2D, pos2: Int2D):
	var start: Int2D = Int2D.new(
		clamp(pos1.x, 1, tiles.cols - 2),
		clamp(pos1.y, 1, tiles.rows - 2)
	)
	var end: Int2D = Int2D.new(
		clamp(pos2.x, 1, tiles.cols - 2),
		clamp(pos2.y, 1, tiles.rows - 2)
	)
	var walker: ManhattenWalker = ManhattenWalker.new(start, end, rng)
	set_path(walker.pos)
	while not walker.pos.equals(end):
		walker.step_random_towards(end, 0.5)
		set_path(walker.pos)


func add_pillars():
	for i in range(rng.randi_range(1,5)):
		if free_positions.size() > 0:
			tiles.set_value_Int2D(get_free_pos(), "Wall")

func add_pit():
	if rng.randf() < PIT_CHANCE:
		var pit_pos = get_free_pos()
		var walker: DrunkWalker = DrunkWalker.new(pit_pos, tiles, 50, rng)
		walker.walk("Pit")


func add_clutter():
	for i in rng.randi_range(0, 3):
		if free_positions.size() > 0:
			var walker_pos = get_free_pos()
			var steps = rng.randi_range(3, 10)
			var walker: DrunkWalker = DrunkWalker.new(walker_pos, tiles, steps, rng)
			walker.walk("Clutter")
			


func get_free_pos() -> Int2D:
	return free_positions.pop_front()
