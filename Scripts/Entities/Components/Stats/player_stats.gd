extends Stats

export var roll_speed_multi: float = 1.6

# override
func do_damage(damage: Dictionary):
	.do_damage(damage)
	Events.emit_signal("player1_hp_changed", hp)
