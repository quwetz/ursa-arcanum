class_name Int2D
extends Reference

var x: int
var y: int

func _init(x: int, y: int):
	self.x = x
	self.y = y


func equals(other: Int2D):
	return x == other.x and y == other.y
