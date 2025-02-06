class_name SupportRune
extends Rune

var aoe_radius: float = 1.0
var dmg: float = 1.0
var cast_speed: float = 1.0
var proj_speed: float = 1.0

var n_projectiles: int = 0
var n_fork: int = 0
var n_pierce: int = 0
var n_repitions: int = 0
var n_bounce: int = 0
var n_chain: int = 0

var spell: Spell


func _init():
	type = "support"


func toggle_effect():
	if enabled:
		disable()
	else:
		enable()


func enable():
	if enabled:
		return
	enabled = true
	spell.aoe_radius *= aoe_radius
	spell.dmg *= dmg
	spell.cast_speed *= cast_speed
	spell.proj_speed *= proj_speed
	spell.n_projectiles += n_projectiles
	spell.n_fork += n_fork
	spell.n_pierce += n_pierce
#	spell.n_repitions += n_repitions
	spell.n_bounce += n_bounce
	spell.n_chain += n_chain


func disable():
	if enabled:
		enabled = false
		spell.aoe_radius /= aoe_radius
		spell.dmg /= dmg
		spell.cast_speed /= cast_speed
		spell.proj_speed /= proj_speed
		spell.n_projectiles -= n_projectiles
		spell.n_fork -= n_fork
		spell.n_pierce -= n_pierce
#		spell.n_repitions -= n_repitions
		spell.n_bounce -= n_bounce
		spell.n_chain -= n_chain
