extends Reference

class_name GraphEdge

# Class that represents an Edge in a Graph of Room-Objects

var v1
var v2

# weight is the "axis-alignedness" of the edge
# -> minimum abs distance of the x and y coordinates
# bigger numbers mean that the rooms are not only farther away, but also more diagonally aligned
# 
var distance: float = NAN

func _init(v1, v2):
	self.v1 = v1
	self.v2 = v2
	assert(distance != NAN)


func contains_v(v) -> bool:
	return v1 == v or v2 == v


func equals(e: GraphEdge) -> bool:
	return e.contains_v(v1) and e.contains_v(v2)

func smaller_distance(e1: GraphEdge, e2: GraphEdge):
	return e1.distance < e2.distance
