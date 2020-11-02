extends Node


signal controls_changed


enum { KBD_MOUSE, GAMEPAD }
var controls: = KBD_MOUSE setget set_controls


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if controls == KBD_MOUSE:
			self.controls = GAMEPAD
	elif event is InputEventMouse and controls == GAMEPAD:
		self.controls = KBD_MOUSE


func set_controls(value: int) -> void:
	controls = value
	emit_signal("controls_changed")
