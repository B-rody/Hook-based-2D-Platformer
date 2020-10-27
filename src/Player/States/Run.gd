extends State


onready var move: = get_parent()
export var max_speed_sprint: = 900.0

func unhandled_input(event: InputEvent) -> void:
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	move.max_speed.x = max_speed_sprint if Input.is_action_pressed("sprint") else move.max_speed_default.x
	
	if owner.is_on_floor():
		if move.velocity.length() < 1.0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
	move.physics_process(delta)


# Enter the state. Passes data when switching from one state to another
func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)


func exit() -> void:
	move.exit()
