extends Node2D



export(int) var min_room_size = 10
export(int) var max_room_size = 20
export(int) var max_room_count = 20
export(float) var additional_conn_chance = 0.75


var FLOOR: int
var WALL: int
var ROOF: int

var current_floor_index: int = 0
var floor_types = [
		"FloorBig",
		"FloorDirt",
		"FloorReg",
		"FloorTiny"
		]
	
var layout: LevelLayout

onready var rng = RandomNumberGenerator.new()
onready var Floor: TileMap = $Floor
onready var Walls: TileMap = $Walls
onready var Roof: TileMap = $Roof

func _ready():
	FLOOR = Floor.tile_set.find_tile_by_name("FloorReg")
	WALL = Walls.tile_set.find_tile_by_name("Wall")
	ROOF = Walls.tile_set.find_tile_by_name("Roof")
	clear_all()
	layout = LevelLayout.new(min_room_size, max_room_size, max_room_count, additional_conn_chance, rng)
	draw_rooms()


func _process(delta):
	if Input.is_action_just_pressed("Debug1"):
		clear_all()
		layout = LevelLayout.new(min_room_size, max_room_size, max_room_count, additional_conn_chance, rng)
		draw_rooms()
	if Input.is_action_just_pressed("Debug2"):
		FLOOR = Floor.tile_set.find_tile_by_name(floor_types[current_floor_index])
		current_floor_index = (current_floor_index + 1 ) % floor_types.size()
		draw_rooms()


func clear_all():
	Floor.clear()
	Walls.clear()
	Roof.clear()




func draw_rooms():
	clear_all()
	for r in layout.rooms:
		draw_room(r)
	Floor.update_bitmask_region()
	Walls.update_bitmask_region()
	Roof.update_bitmask_region()


func draw_room(r: Room):
	for x in int(r.size.x):
		for y in int(r.size.y):
			var t: String = r.tiles.get_value(x,y)
			match t:
				"W":
					Walls.set_cell(x + r._left_x, y + r._top_y, WALL)
					Roof.set_cell(x + r._left_x, y + r._top_y, ROOF)
				"F":
					Floor.set_cell(x + r._left_x, y + r._top_y, FLOOR)
	

#func _draw():
#	for r1 in layout.rooms:
#		for r2 in r1.neighbors:
#			draw_line(r1.center * cell_size, r2.center * cell_size, Color.green, 3.0)
#
#	if layout.room_graph != null:
#		for e in layout.room_graph._E:
#			draw_line(e.v1.center * cell_size, e.v2.center * cell_size, Color.black, 10.0)
