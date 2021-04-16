extends Reference

class_name GraphEdge

# Class that represents an Edge in a Graph of Room-Objects

var v1: Room
var v2: Room
# weight is the "axis-alignedness" of the edge
# -> minimum abs distance of the x and y coordinates
# bigger numbers mean that the rooms are not only farther away, but also more diagonally aligned
var weight: float

func _init(v1: Room, v2: Room):
	self.v1 = v1
	self.v2 = v2
	weight = min(abs(v1.center.x - v2.center.x), abs(v1.center.y - v2.center.y))


func contains_v(v: Room) -> bool:
	return v1 == v or v2 == v


func equals(e: GraphEdge) -> bool:
	return e.contains_v(v1) and e.contains_v(v2)


# returns true if the minimum distance of the coordinates of the vertices of e1 is smaller than that of e2
# in other words: true if e1 is more vertical or horizontal aligned than e2
# example: 	e1=[(0,0),(3,0)] e2=[(0,0),(1,1)] -> true
static func is_more_axis_aligned(e1: GraphEdge, e2: GraphEdge) -> bool:
	return e1.weight < e2.weight
