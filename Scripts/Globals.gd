extends Node

const PLAYER_LAYER = 1
const ENEMY_LAYER = 2
const PROJECTILE_LAYER = 4
const OBSTACLE_LAYER = 8

func is_on_layer(layer_value, collision_layer):
	return (collision_layer & layer_value) != 0
