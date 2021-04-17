extends Sprite

func _ready():
	frame = randi() % (vframes * hframes)
