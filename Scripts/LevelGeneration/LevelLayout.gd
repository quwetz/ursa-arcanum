extends Reference

class_name LevelLayout

var min_room_size: int #hast to be > 10
var max_room_size: int
var room_count: int
var additional_conn_chance: float

var rng: RandomNumberGenerator

var rooms: Array
var room_graph: Graph

func _init(min_room_size: int, max_room_size: int, room_count: int, chance: float, rng: RandomNumberGenerator):
	self.min_room_size = min_room_size
	self.max_room_size = max_room_size
	self.room_count = room_count
	self.additional_conn_chance = chance
	self.rng = rng
	rooms = []
	generate_layout()


func generate_layout():
	rooms.clear()
	for i in room_count:
		add_room()
	#rooms.append(Room.new(Vector2(0,0), Vector2(21,21)))
	#rooms.append(Room.new(Vector2(-21,19), Vector2(21,21)))
	slide_rooms_to_center()
	slide_rooms_to_center()
	set_all_neighbors()
	generate_graph()
	add_corridors()
	for r in rooms:
		r.initialize_tiles()
	add_doors()

# adds gaps in the walls between the rooms
# precondition: all rooms in the graph must be adjacent and have space for doors
#   -> call add_corridors() for that
func add_doors():
	for e in room_graph._E:
		var v1_points = e.v1.get_adjacent_points(e.v2)
		var v2_points = e.v2.get_adjacent_points(e.v1)
		#first and last elements should not be chosen because they are obstructed by walls
		var door_pos: int = rng.randi_range(1, v1_points.size() - 2)
		var v1_pos = Int2D.new(v1_points[door_pos].x - e.v1._left_x, v1_points[door_pos].y - e.v1._top_y)
		var v2_pos = Int2D.new(v2_points[door_pos].x - e.v2._left_x, v2_points[door_pos].y - e.v2._top_y)
		e.v1.add_door(v1_pos)
		e.v2.set_tile(v2_pos, "F")


# adds corridor rooms to the graph if needed for room_connections
# postcondition: all edges connect rooms that are directly adjacent and have enough space to fit a door (1 Tile)
func add_corridors():
	# array to store the new edges / edges to remove connecting the corridors
	# (adding/removing afterwards is needed to prevent unexpected behaviour by altering the arrray during the loop
	var edges_to_add: Array = [] 
	var edges_to_remove: Array = []
	for e in room_graph._E:
		if e.v1.is_adjacent(e.v2):
			if e.v1.get_adjacent_points(e.v2).size() < 3:
				# if adjacent and the number of adjacent points is smaller than 3
				# we need to create a 3x3 corridor room that creates an 90° connection between the rooms
				# there are alway two possible locatiions for that, calculate both, and use the one,
				# thats not colliding with any other room (one of them should always be possible)
				var corridor1_pos: Vector2 = Vector2()
				var corridor2_pos: Vector2 = Vector2()
				if e.v1.center.x < e.v2.center.x:
					# v1 is left of v2
					corridor1_pos.x = e.v1._right_x + 2
					corridor2_pos.x = e.v2._left_x - 2
				else:
					# v1 is right of v2
					corridor1_pos.x = e.v1._left_x - 2
					corridor2_pos.x = e.v2._right_x + 2
				if e.v1.center.y < e.v2.center.y:
					# v1 is on top of v2
					corridor1_pos.y = e.v2._top_y - 2
					corridor2_pos.y = e.v1._bottom_y + 2
				else:
					# v1 is beneath than v2
					corridor1_pos.y = e.v2._bottom_y + 2
					corridor2_pos.y = e.v1._top_y - 2
				var corridor: Room = Room.new(corridor1_pos, Vector2(3,3))
				if corridor.intersections(rooms).size() > 0:
					corridor.set_center(corridor2_pos)
				# add the new corridor if it's not intersecting any other room
				if(corridor.intersections(rooms).size() == 0):
					rooms.append(corridor)
					room_graph.add_vertex(corridor)
					edges_to_add.append(GraphEdge.new(e.v1, corridor))
					edges_to_add.append(GraphEdge.new(e.v2, corridor))
					edges_to_remove.append(e)
				else:
					edges_to_remove.append(e)
		else: # rooms are not directly adjacent -> fill the gap with a corridor
			var corridor_pos: Vector2 = Vector2()
			var corridor_size: Vector2
			if (e.v1._bottom_y < e.v2._top_y) or (e.v1._top_y > e.v2._bottom_y):
				# v1 and v2 are vertically aligned
				corridor_pos.x = rng.randi_range(max(e.v1._left_x, e.v2._left_x) + 1, min(e.v1._right_x, e.v2._right_x) - 2)
				corridor_size = Vector2(4, max(e.v2._top_y - e.v1._bottom_y - 1, e.v1._top_y - e.v2._bottom_y - 1))
				if e.v1._bottom_y < e.v2._top_y:
					# v1 is on top of v2
					corridor_pos.y = e.v1._bottom_y + int((corridor_size.y + 1) / 2)
				elif e.v1._top_y > e.v2._bottom_y:
					# v1 is beneath v2
					corridor_pos.y = e.v2._bottom_y + int((corridor_size.y + 1) / 2)
			else:
				#v1 and v2 are horizontaly aligned
				corridor_pos.y = rng.randi_range(max(e.v1._top_y, e.v2._top_y) + 1, min(e.v1._bottom_y, e.v2._bottom_y) - 2)
				corridor_size = Vector2(max(e.v2._left_x - e.v1._right_x - 1, e.v1._left_x - e.v2._right_x - 1), 4)
				if e.v1._left_x < e.v2._right_x:
					# v1 is to the left of v2
					corridor_pos.x = e.v1._right_x + int((corridor_size.x + 1) / 2)
				elif e.v1._left_x > e.v2._right_x:
					# v1 is to the right of v2
					corridor_pos.x = e.v2._right_x + int((corridor_size.x + 1) / 2)
			var corridor: Room = Room.new(corridor_pos, corridor_size)
			rooms.append(corridor)
			room_graph.add_vertex(corridor)
			edges_to_add.append(GraphEdge.new(e.v1, corridor))
			edges_to_add.append(GraphEdge.new(e.v2, corridor))
			edges_to_remove.append(e)
			assert(corridor.intersections(rooms).size() == 0)
	for e in edges_to_remove:
		room_graph.remove_edge(e)
	for e in edges_to_add:
		room_graph.add_edge(e)

func generate_graph():
	# a graph that contains all rooms and all edges between adjacent rooms
	var adjacent_room_graph = Graph.new(rooms, [])
	for r in rooms:
		for n in r.neighbors:
			adjacent_room_graph.add_edge(GraphEdge.new(r, n))
	# generate a minimum spanning tree
	room_graph = adjacent_room_graph.min_span_tree()
	# QND: go over all edges of adjacent_room_graph 
	# add them with a chance of additional_conn_chance to the room_graph
	# note: adding an edge already contained in the graph will do nothing
	for e in adjacent_room_graph._E:
		if rng.randf() < additional_conn_chance: room_graph.add_edge(e)


func add_room():
	var r = Room.new(Vector2.ZERO, Vector2(
			Util.randi_range_step(min_room_size, max_room_size, 1, rng), 
			Util.randi_range_step(min_room_size, max_room_size, 1, rng)
			))
	
	var dir = Vector2.UP.rotated(rng.randf_range(-PI,PI))
	while r.intersections(rooms).size() > 0:
		r.move(dir)
	r.snap_to_grid()
	rooms.append(r)

func slide_rooms_to_center():
	rooms.sort_custom(Room, "smaller_abs_v_dist_to_center")
	for r in rooms:
		r.slide_to_center_v(rooms)
	
	rooms.sort_custom(Room, "smaller_abs_h_dist_to_center")
	for r in rooms:
		r.slide_to_center_h(rooms)


func set_all_neighbors():
	for r in rooms:
		r.set_neighbors(rooms)
