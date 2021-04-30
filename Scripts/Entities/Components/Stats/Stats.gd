class_name Stats
extends Node

export var max_hp: int = 1
export var move_speed: int = 100

signal no_hp

onready var hp: int = max_hp


func do_damage(damage: Dictionary):
	for k in damage.keys():
		set_hp(hp - damage[k])
	
func set_hp(new_hp: int):
	hp = new_hp
	if new_hp <= 0:
		emit_signal("no_hp")
