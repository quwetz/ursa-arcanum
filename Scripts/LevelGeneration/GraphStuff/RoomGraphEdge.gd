extends GraphEdge

class_name RoomGraphEdge

# Class that represents an Edge in a Graph of Room-Objects

func _init(v1: Room, v2: Room).(v1, v2):
	# distance is the "axis-alignedness" of the edge
	# -> minimum abs distance of the x and y coordinates
	# bigger numbers mean that the rooms are more diagonally aligned
	distance = min(abs(v1.center.x - v2.center.x), abs(v1.center.y - v2.center.y))
