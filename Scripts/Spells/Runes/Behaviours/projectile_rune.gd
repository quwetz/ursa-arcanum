class_name ProjectileRune
extends BehaviourRune

const MIN_SPREAD = PI/10
const MAX_SPREAD = PI/3

var projectile_scene = preload("res://Scenes/projectile.tscn")


func _init():
	name = "projectile"


func _execute(s: Spell, target_pos: Vector2, caster: Node):
	# handle secondary behaviours
	var exploding: bool = false
	for b in s.secondary_behaviours:
		if b.name == "explosion":
			exploding = true
	
	# calc spread for multiple projectiles
	var max_spread: float = max_spread(caster.projSpawnPos.global_position.distance_squared_to(target_pos))
	for j in s.n_projectiles:
		var p = projectile_scene.instance()
		var spread = max_spread * ((ceil(j*0.5) * (1 - ((j % 2) * 2))) / s.n_projectiles)
		p.rotation = caster.projSpawnCenter.rotation + spread
#		p.position = caster.projSpawnPos.global_position
		p.position = caster.projSpawnPos.position.rotated(p.rotation + spread) + caster.projSpawnCenter.global_position
		p.exploding = exploding
		p.initialize(s)
		caster.get_tree().get_root().add_child(p)


func max_spread(dist: float):
	return clamp(distance_to_spread(dist), MIN_SPREAD, MAX_SPREAD)
	
func distance_to_spread(dist: float):
	# at distance 16,348 = (8 Tiles * 16 Pixels)^2 is the maximum spread
	return ((MIN_SPREAD - MAX_SPREAD) / 16_384) * dist + MAX_SPREAD
