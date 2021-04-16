extends TileMap



export(int) var min_room_size = 15
export(int) var max_room_size = 27
export(int) var max_room_count = 30
export(float) var additional_conn_chance = 0.75

enum Tiles {WALL, FLOOR}

var layout: LevelLayout

onready var rng = RandomNumberGenerator.new()

var room_labels: Array = []

func _ready():
	clear()
	layout = LevelLayout.new(min_room_size, max_room_size, max_room_count, additional_conn_chance, rng)
	draw_rooms()

	
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		clear()
		layout.generate_layout()
		draw_rooms()


#func _draw():
#	for r1 in layout.rooms:
#		for r2 in r1.neighbors:
#			draw_line(r1.center * cell_size, r2.center * cell_size, Color.green, 3.0)
#
#	if layout.room_graph != null:
#		for e in layout.room_graph._E:
#			draw_line(e.v1.center * cell_size, e.v2.center * cell_size, Color.black, 10.0)

func draw_rooms():
	clear()
	for r in layout.rooms:
		draw_room(r)


func set_room_labels():
	for l in room_labels:
		l.queue_free()
	room_labels.clear()
	for r in layout.rooms:
		var label = Label.new()
		label.text = r.to_string()
		label.rect_position = Vector2(r._left_x, r._top_y) * cell_size
		add_child(label)
		room_labels.append(label)


func draw_room(r: Room):
	for x in int(r.size.x):
		for y in int(r.size.y):
			var t: String = r.tiles.get_value(x,y)
			match t:
				"W":
					set_cell(x + r._left_x, y + r._top_y, Tiles.WALL)
				"F":
					set_cell(x + r._left_x, y + r._top_y, Tiles.FLOOR)
	
