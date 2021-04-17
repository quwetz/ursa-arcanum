class_name Grid
extends Reference

var columns: Array
var cols: int
var rows: int

func _init(cols: int, rows: int):
	self.cols = cols
	self.rows = rows
	for x in cols:
		columns.append([])
		columns[x].resize(rows)


func get_value(x: int, y: int):
	return(columns[x][y])
	

func get_value_Int2D(pos: Int2D):
	return(columns[pos.x][pos.y])


func set_value(x: int, y: int, value):
	columns[x][y] = value


func set_value_Int2D(pos: Int2D, value):
	columns[pos.x][pos.y] = value


func set_col(x: int, value):
	for y in rows:
		columns[x][y] = value


func set_row(y: int, value):
	for x in cols:
		columns[x][y] = value


func fill(v):
	for x in cols:
		for y in rows:
			columns[x][y] = v

func to_string() -> String:
	var s: String = ""
	for x in cols:
		for y in rows:
			s += str(columns[x][y])
		s += "\n"
	return s


func flood_fill(x: int, y: int, value: String, depth: int, chance: float = 1.0):
	var this_value = get_value(x, y)
	if depth > 0 and randf() <= chance:
		if(x > 0) and (get_value(x - 1, y) == this_value):
			flood_fill(x - 1, y, value, depth - 1, chance)
		if(x < cols - 1) and (get_value(x + 1, y) == this_value):
			flood_fill(x + 1, y, value, depth - 1, chance)
		if(y > 0) and (get_value(x, y - 1) == this_value):
			flood_fill(x, y - 1, value, depth - 1, chance)
		if(y < rows - 1) and (get_value(x, y + 1) == this_value):
			flood_fill(x, y + 1, value, depth - 1, chance)
	set_value(x, y, value)


func fill_rect(x: int, y: int, extent_x: int, extent_y, value: String):
	var this_value = get_value(x, y)
	if extent_x > 0:
		if x > 0 and get_value(x - 1, y) == this_value:
			fill_rect(x - 1,y,extent_x - 1,extent_y, value)
		if x < rows - 1 and get_value(x + 1, y) == this_value:
			fill_rect(x + 1,y,extent_x - 1,extent_y, value)
	if extent_y > 0:
		if y > 0 and get_value(x, y - 1) == this_value:
			fill_rect(x, y - 1,extent_x,extent_y - 1, value)
		if y < cols - 1 and get_value(x, y - 1) == this_value:
			fill_rect(x, y + 1,extent_x,extent_y - 1, value)
	set_value(x, y, value)
