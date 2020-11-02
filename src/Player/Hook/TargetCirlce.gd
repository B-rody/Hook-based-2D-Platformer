tool
extends DrawingUtils


var offset: = Vector2(100.0, 0) setget set_offset
export var color: = Color(1, 0, 0.28125) setget set_color


func _draw() -> void:
	draw_circle_outline(self, offset, 8.0, color, 3.0)


func set_offset(value: Vector2) -> void:
	offset = value
	update()


func set_color(value: Color) -> void:
	color = value
	update()
