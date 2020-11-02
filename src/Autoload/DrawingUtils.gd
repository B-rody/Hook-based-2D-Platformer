tool
extends Node2D
const DEFAULT_POINTS_COUNT: = 32


static func draw_circle_outline(obj: CanvasItem=null, position:=Vector2.ZERO, radius:float=30.0, color:=Color(), thickness:=1.0) -> void:
	var points_array: = PoolVector2Array()
	
	for i in range(DEFAULT_POINTS_COUNT+1):
		var angle:= 2 * PI * i / DEFAULT_POINTS_COUNT
		var point: = position + Vector2(cos(angle) * radius, sin(angle) * radius)
		points_array.append(point)
		obj.draw_polyline(points_array, color, thickness, true)
