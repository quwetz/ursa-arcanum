extends Node2D

const TILE_SIZE: int = 32

export(int) var min_room_size = 10
export(int) var max_room_size = 20
export(int) var max_room_count = 10
export(float) var additional_conn_chance = 0.75


var FLOOR: int
var WALL: int
var ROOF: int
var PIT: int

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

onready var DoorVertical = preload("res://Scenes/DoorVertical.tscn")
onready var DoorHorizontal = preload("res://Scenes/DoorHorizontal.tscn")
onready var Clutter = preload("res://Scenes/Clutter.tscn")

onready var objectContainer = $Objects

func _ready():
	FLOOR = Floor.tile_set.find_tile_by_name("FloorReg")
	WALL = Walls.tile_set.find_tile_by_name("Wall")
	ROOF = Walls.tile_set.find_tile_by_name("Roof")
	PIT = Floor.tile_set.find_tile_by_name("Pit")
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
	objectContainer.queue_free()
	objectContainer= YSort.new()
	objectContainer.name = "Objects"
	add_child(objectContainer)




func draw_rooms():
	clear_all()
	for r in layout.rooms:
		draw_room(r)
	for c in layout.corridors:
		draw_room(c)
	Floor.update_bitmask_region()
	Walls.update_bitmask_region()
	Roof.update_bitmask_region()


func draw_room(r: Room):
	for x in int(r.size.x):
		for y in int(r.size.y):
			var t: String = r.layout.tiles.get_value(x,y)
			Floor.set_cell(x + r._left_x, y + r._top_y, FLOOR)
			match t:
				"Wall":
					Walls.set_cell(x + r._left_x, y + r._top_y, WALL)
					Roof.set_cell(x + r._left_x, y + r._top_y, ROOF)
				"Pit":
					Floor.set_cell(x + r._left_x, y + r._top_y, PIT)
				"Door":
					var is_horizontal: bool = true if (x == 0 or x == r.size.x - 1) else false
					instance_door(Vector2(x + r._left_x, y + r._top_y), is_horizontal)
				"Clutter":
					instance_clutter(Vector2(x + r._left_x, y + r._top_y))


func instance_door(pos: Vector2, is_horizontal: bool):
	var door: Node2D
	if is_horizontal:
		 door = DoorHorizontal.instance()
	else:
		door = DoorVertical.instance()
	objectContainer.add_child(door)
	door.set_global_position(tile_to_world_coordinates(pos))

func instance_clutter(pos: Vector2):
	var clutter: Node2D = Clutter.instance()
	objectContainer.add_child(clutter)
	clutter.set_global_position(tile_to_world_coordinates(pos))


func tile_to_world_coordinates(pos: Vector2) -> Vector2:
	var offset: float = float(TILE_SIZE) / 2
	return (pos * TILE_SIZE) + Vector2(offset, offset)
	


#func _draw():
#	for r1 in layout.rooms:
#		for r2 in r1.neighbors:
#			draw_line(r1.center * cell_size, r2.center * cell_size, Color.green, 3.0)
#
#	if layout.room_graph != null:
#		for e in layout.room_graph._E:
#			draw_line(e.v1.center * cell_size, e.v2.center * cell_size, Color.black, 10.0)
