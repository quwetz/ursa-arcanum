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


func set_value(x: int, y: int, value):
	columns[x][y] = value


func fill_col(x: int, value):
	for y in rows:
		columns[x][y] = value


func fill_row(y: int, value):
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
