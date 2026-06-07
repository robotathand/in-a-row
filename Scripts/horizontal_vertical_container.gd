extends BoxContainer

func _ready() -> void:
	resize()


func resize():
	var screen_size = get_viewport_rect().size
	if screen_size.x > screen_size.y:
		vertical = false
	elif screen_size.x < screen_size.y:
		vertical = true
	else:
		vertical = false


func _on_resized() -> void:
	resize()
