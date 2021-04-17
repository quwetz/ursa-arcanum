class_name RoomLayout
extends Reference

###############################
#        Abstract class       #
###############################


var tiles: Grid
# Array of Int2Ds
var exits: Array = []
var free_positions = []

var rng: RandomNumberGenerator

func _init(size: Int2D, rng: RandomNumberGenerator):
	self.rng = rng
	tiles = Grid.new(size.x, size.y)
	initialize_tiles()

# override in child classes!
func _build_room():
	assert(false)

# override in child classes!
func _connect_exits():
	assert(false)


func exit_connections_graph(additional_connection_chance: float) -> Graph:
	var complete_graph: Graph = Graph.new(exits, [])
	complete_graph(complete_graph)
	var connections: Graph = complete_graph.min_span_tree()
	for e in complete_graph._E:
		if rng.randf() < additional_connection_chance: connections.add_edge(e)
	return connections


func set_path(pos: Int2D):
	tiles.set_value_Int2D(pos, "Path")


func set_door(pos: Int2D):
	tiles.set_value_Int2D(pos, "Door")
	exits.append(pos)

func set_entrance(pos: Int2D):
	tiles.set_value_Int2D(pos, "Entrance")
	exits.append(pos)
	

# clears the tilegrid of the room, fills with floor and adds wall to the edges
func initialize_tiles():
	tiles.fill("Free")
	tiles.set_col(0, "Wall")
	tiles.set_col(tiles.cols - 1, "Wall")
	tiles.set_row(0, "Wall")
	tiles.set_row(tiles.rows - 1, "Wall")


func update_free_positions():
	free_positions.clear()
	for x in range(tiles.cols):
		for y in range(tiles.rows):
			if tiles.get_value(x,y) == "Free":
				free_positions.append(Int2D.new(x,y))
	free_positions.shuffle()


func complete_graph(g: Graph):
	var v_left = g._V.duplicate()
	while v_left.size() > 0:
		var v1: Int2D = v_left.pop_front()
		for v2 in v_left:
			g.add_edge(Int2DGraphEdge.new(v1, v2))
