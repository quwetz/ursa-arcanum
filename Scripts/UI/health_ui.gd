extends Control

var hp = 100 setget set_hp
var max_hp = 100 setget set_max_hp
var _n_hearts: float = 5
var _max_hearts: int = 5
var hearts: Array = []


var UIHeart = preload("res://Scenes/UI/UIHeart.tscn")


func _ready():
	Events.connect("player1_hp_changed", self, "on_hp_changed")
	for i in _max_hearts:
		add_heart()
	update_hearts(hp)


func on_hp_changed(value: float):
	set_hp(value)


func set_hp(value):
	hp = clamp(value, 0, max_hp)
	_n_hearts = float(hp) / 20.0
	update_hearts(hp)
	

func set_max_hp(value):
	max_hp = value
	hp = min(hp, max_hp)
	_max_hearts = int(ceil(float(value) / 20))
	resize_hearts_array()
	update_hearts(hp)

func update_hearts(new_hp: float):
	for h in hearts:
		h.update_heart(new_hp)


func add_heart():
	var new_heart = UIHeart.instance()
	var index: int = hearts.size()
	new_heart.position = Vector2(32 * index + 16, 0)
	new_heart.set_thresholds(index * 20, (index * 20) + 10)
	hearts.append(new_heart)
	add_child(new_heart)

func resize_hearts_array():
	if hearts.size() < _max_hearts:
		for i in _max_hearts - hearts.size():
			add_heart()
	elif hearts.size() > _max_hearts:
		for i in hearts.size() - _max_hearts:
			var h = hearts.pop_back()
			h.queue_free()
