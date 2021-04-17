extends GraphEdge

class_name Int2DGraphEdge

# Class that represents an Edge in a Graph of Room-Objects

func _init(v1: Int2D, v2: Int2D).(v1, v2):
	var t1 = Vector2(v1.x, v1.y)
	var t2 = Vector2(v2.x, v2.y)
	distance = t1.distance_squared_to(t2)
