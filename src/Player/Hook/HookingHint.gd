tool
extends DrawingUtils


export var color: Color = Color.lightblue
export var radius: = 12.0


func _ready() -> void:
	set_as_toplevel(true)
	update()


func _draw() -> void:
	draw_circle_outline(self, Vector2.ZERO, 20.0, color, 2.0)
	draw_circle(Vector2.ZERO, radius, color)
