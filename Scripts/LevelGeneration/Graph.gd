extends Reference

class_name Graph

# A Graph of Room Objects
# vertices
var _V: Array

# edges
var _E: Array


func _init(vertices: Array = [], edges: Array = []):
	_V = vertices
	_E = edges


# returns the minimum spanning tree of the graph
# using Prim's Algorithm
# the weighting used is the axis-alignedness of the edge.
# Meaning we prefer to have connections between rooms that are more 
# vertically or horizonally aligned, than diagonally.
# precondition: The graph has to be connected
func min_span_tree() -> Graph:
	# copy the array of vertices
	var nodes: Array = _V.duplicate()
	# initialize an empty Graph
	# somehow can't instantiate a new Graph with Graph.new() -> use get_script() instead ¯\_(ツ)_/¯ 
	var msp: Graph = get_script().new([], [])
	# add the first node to the Graph
	msp.add_vertex(nodes.pop_front())
	
	# sort the edges
	_E.sort_custom(GraphEdge, "is_more_axis_aligned")
	
	while nodes.size() > 0:
		var node_removed = false
		
		# go over all edges and take the one with the smallest weight,
		# that is connecting a vertex, that is not yet part of msp
		# remove that node from nodes
		# note that _E is sorted by weight
		for e in _E:
			var v1_in_msp: bool = e.v1 in msp._V
			var v2_in_msp: bool = e.v2 in msp._V
			if v1_in_msp != v2_in_msp:
				msp.add_edge(e)
				var v: Room = e.v1 if v2_in_msp else e.v2
				msp.add_vertex(v)
				nodes.remove(nodes.find(v))
				node_removed = true
				break
		# assertion will fail, if the graph is not connected. 
		# prevents the loop from running infinitely on disconnected graphs
		assert(node_removed) 
	return msp


func contains(v: Room) -> bool:
	return v in _V


# Adds a Vertex v to the Graph, if v is not already in the graph. 
# Returns false if the vertex is already in the Graph
# QND: LINEAR RUNTIME! FIX: use a better datastructure
func add_vertex(v: Room) -> bool:
	if v in _V:
		return false
	else:
		_V.append(v)
		return true


# Adds an edge e to the Graph, if e is not already in the graph. 
# Returns false if the edge is already in the Graph
# QND: LINEAR RUNTIME! FIX: use a better datastructure
func add_edge(e1: GraphEdge) -> bool:
	for e2 in _E:
		if e1.equals(e2):
			return false
	_E.append(e1)
	return true


func remove_edge(e: GraphEdge):
	_E.remove(_E.find(e))

## returns a dictionary containing:
## keys: vertices of the graph
## values: an array of weight sorted edges to that vertex
#func vertex_edges() -> Dictionary:
#	var v_e = {}
#	for v in _V:
#		var edges_to_v = []
#		for e in _E:
#			if e.v1 == v or e.v2 == v:
#				edges_to_v.append(e)
#		edges_to_v.sort_custom(GraphEdge, "is_more_axis_aligned")
#		v_e[v] = edges_to_v
#	return v_e
