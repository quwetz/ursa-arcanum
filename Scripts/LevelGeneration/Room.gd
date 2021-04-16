extends Reference
class_name Room

var center: Vector2 setget set_center
var size: Vector2 setget set_size

var _left_x: int
var _top_y: int
var _right_x: int
var _bottom_y: int

var neighbors: Array
var tiles: Grid


func _init(center_pos: Vector2, room_size: Vector2):
	set_center(center_pos)
	set_size(room_size)


func move(direction: Vector2):
	set_center(center + direction)


# sets the neighbors array
# a neighbor is either an adjacent room,
# or a room, that is within 5 tiles in one direction of the room and has enough overlap to fit a door 
# precondition: self is not currently overlapping with any room in rooms
func set_neighbors(rooms: Array):
	neighbors = []
	for r in rooms:
		var to_add: bool = false
		#add room if directly adjacent
		set_size(Vector2(size.x + 2, size.y))
		to_add = intersects(r) or to_add
		set_size(Vector2(size.x - 2, size.y + 2))
		to_add = intersects(r) or to_add
		set_size(Vector2(size.x, size.y - 2))
		to_add = intersects(r) or to_add
		# add room if within range 5:
		set_size(Vector2(size.x - 8, size.y + 10))
		to_add = intersects(r) or to_add
		set_size(Vector2(size.x + 18, size.y - 18))
		to_add = intersects(r) or to_add
		set_size(Vector2(size.x - 10, size.y + 8))
		
		if to_add: neighbors.append(r)


func slide_to_center_v(rooms: Array):
	var dir: Vector2
	if center.y > 0:
		dir = Vector2.UP
	else:
		dir = Vector2.DOWN

	while (intersections(rooms).size() == 0) && (center.y != 0):
		move(dir)
	#move 1 unit back afterwards
	move(-1 * dir)


func slide_to_center_h(rooms: Array):
	var dir: Vector2
	if center.x > 0:
		dir = Vector2.LEFT
	else:
		dir = Vector2.RIGHT

	while (intersections(rooms).size() == 0) && (center.x != 0):
		move(dir)
	#move 1 unit back afterwards
	move(-1 * dir)


#snaps the current room to the grid by trimming any decimal places from it's coordinates.
func snap_to_grid():
	set_center(Vector2(int(center.x), int(center.y)))


func is_adjacent(r: Room) -> bool:
	if self == r: return false
	var adjacent: bool = false
	set_size(Vector2(size.x + 2, size.y))
	adjacent = intersects(r) or adjacent
	set_size(Vector2(size.x - 2, size.y + 2))
	adjacent = intersects(r) or adjacent
	set_size(Vector2(size.x, size.y - 2))
	return adjacent


func get_adjacent_points(r: Room) -> Array:
	var points: Array = []
	if self.is_adjacent(r):
		if self._left_x - 1 == r._right_x:
			for y in range(max(self._top_y, r._top_y), min(self._bottom_y, r._bottom_y) + 1):
				points.append(Int2D.new(self._left_x, y))
		elif self._right_x + 1 == r._left_x:
			for y in range(max(self._top_y, r._top_y), min(self._bottom_y, r._bottom_y) + 1):
				points.append(Int2D.new(self._right_x, y))
		elif self._top_y - 1 == r._bottom_y:
			for x in range(max(self._left_x, r._left_x), min(self._right_x, r._right_x) + 1):
				points.append(Int2D.new(x, self._top_y))
		elif self._bottom_y + 1 == r._top_y:
			for x in range(max(self._left_x, r._left_x), min(self._right_x, r._right_x) + 1):
				points.append(Int2D.new(x, self._bottom_y))
	return points


func intersects(r: Room) -> bool:
	if self==r:
		return false
	return not(
			(self._right_x < r._left_x) or
			(self._bottom_y < r._top_y) or
			(self._left_x > r._right_x) or
			(self._top_y > r._bottom_y))


func intersections(rooms: Array) -> Array:
	var i= []
	for r in rooms:
		if self.intersects(r):
			i.append(r)
	return i


func set_center(pos: Vector2):
	center = pos
	update_bounds_position()


func set_size(new_size: Vector2):
	size = Vector2(int(new_size.x), int(new_size.y))
	update_bounds_position()
	
	
func update_bounds_position():
	_left_x = int(center.x) - int(size.x/2)
	if int(size.x) % 2 == 0:
		_left_x += 1  
	_right_x = _left_x + int(round(size.x)) - 1
	
	_top_y = int(center.y) - int(size.y/2)
	if int(size.y) % 2 == 0:
		_top_y += 1
	_bottom_y = _top_y + int(round(size.y)) - 1


# clears the tilegrid of the room, fills with floor and adds wall to the edges
func initialize_tiles():
	tiles = Grid.new(size.x, size.y)
	tiles.fill("F")
	tiles.fill_col(0, "W")
	tiles.fill_col(size.x-1, "W")
	tiles.fill_row(0, "W")
	tiles.fill_row(size.y-1, "W")



func add_door(x1: int, y1: int, x2: int, y2: int):
	tiles.set_value(x1, y1, "F")
	tiles.set_value(x2, y2, "F")


func to_string() -> String:
	var s: String = str(self) + "\n"
	s += "Center: " + String(center) + "\n"
	s += "topleft: (%s,%s)\n" %[_left_x, _top_y]
	s += "bottomright: (%s,%s)\n" %[_right_x, _bottom_y]
	s += "size: %s\n" %String(size)
	for n in neighbors:
		var ps = get_adjacent_points(n)
		if ps!=[]:
			s += "touching edge: (%s,%s)-(%s,%s) size: %s\n" %[ps[0].x,
					ps[0].y,ps[ps.size()-1].x,ps[ps.size()-1].y, ps.size()]
	return s


static func smaller_abs_h_dist_to_center(r1: Room, r2: Room) -> bool:
	return abs(r1.center.x) < abs(r2.center.x)


static func smaller_abs_v_dist_to_center(r1: Room, r2: Room) -> bool:
	return abs(r1.center.y) < abs(r2.center.y)
