class_name Spell
extends Reference

# the node which is casting the spell - must have a ProjSpawnPos to be able to cast projectiles
var caster: Node

var n_projectiles: int = 1
var n_pierce: int = 0
var n_chain: int = 0
var n_fork: int = 0
var n_bounce: int = 0
var proj_speed: float = 1.0
var aoe_radius: float = 1.0

var dmg: float = 1.0
var cast_speed: float = 2.5 #casts per second
#var n_repitions: int = 1

# active Runes
var element: ElementRune
var primary_behaviour: BehaviourRune
var secondary_behaviours: Array = []
var supports: Array = []


func _init(n: Node):
	caster = n


func add_rune(r: Rune):
	match r.type:
		"element":
			element = r
		"support":
			r._apply_support_effect(self)
			supports.append(r)
		"behaviour":
			if primary_behaviour == null:
				primary_behaviour = r
			else:
				secondary_behaviours.append(r)


func cast(target_pos: Vector2):
	primary_behaviour._execute(self, target_pos, caster)
