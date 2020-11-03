extends RayCast2D
class_name FloorDetector

func is_close_to_floor() -> bool:
	return is_colliding()
	

func get_floor_position() -> Vector2:
	force_raycast_update()
	return get_collision_point()
