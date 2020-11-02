extends Node


static func get_aim_joystick_direction() -> Vector2:
	return get_aim_joystick_strength().normalized()


static func get_aim_joystick_strength() -> Vector2:
	var deadzone_radius: = 0.5
	var input_strength: = Vector2(
		Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
		Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
		
	)
	return input_strength if input_strength.length() > deadzone_radius else Vector2.ZERO
