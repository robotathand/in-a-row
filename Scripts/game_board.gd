extends Node2D

var spots: Array[Vector2]

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
		screen_pressed(event.position)


func screen_pressed(pos: Vector2):
	spots.append(pos)
	queue_redraw()


func _draw() -> void:
	for s in spots:
		draw_circle(s, 15, Color.BLACK)
