class_name StateBase

extends Reference

var e
var states_path = "res://Scripts/Entities/States"

func _init(e: EntityBase):
	self.e = e

func _enter():
	assert(false)

func _exit():
	assert(false)
	
func _process(delta: float):
	pass#	assert(false)

func _handle_input() -> StateBase:
	assert(false)
	return null
