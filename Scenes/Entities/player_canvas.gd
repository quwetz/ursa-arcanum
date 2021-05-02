extends CanvasModulate

var flash_color = Color.black

func _process(delta):
	color = color - flash_color * 2 * delta
	color.a = 1.0

func flash_red():
	color = Color.darkred
	flash_color = color
