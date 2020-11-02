extends State


export var speed: = Vector2(600.0, 600.0)
var velocity: = Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug_mode"):
		_state_machine.transition_to("Move/Air", {"velocity": Vector2.ZERO})
	if event.is_action_pressed("click"):
		owner.position += owner.get_local_mouse_position()

func physics_process(delta: float) -> void:
	var direction: = get_move_direction()
	var multiplier: = 3.0 if Input.is_action_pressed("debug_sprint") else 1.0
	velocity = direction * speed * multiplier
	owner.position += velocity * delta
	Events.emit_signal("player_moved")


func enter(msg: Dictionary = {}) -> void:
	owner.is_active = false
	

func exit() -> void:
	owner.is_active = true



static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
