extends State

onready var jump_delay: Timer = $JumpDelay
onready var move: = get_parent()


func unhandled_input(event: InputEvent) -> void:
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	if owner.is_on_floor() and move.get_move_direction().x != 0.0:
		_state_machine.transition_to("Move/Run")
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air")
	else:
		move.physics_process(delta)
	


# Enter the state. Passes data when switching from one state to another
func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	move.max_speed = move.max_speed_default
	move.velocity = Vector2.ZERO
	
	if not jump_delay.is_stopped():
		_state_machine.transition_to("Move/Air", { impulse = true })
		jump_delay.stop()
		return
		

func exit() -> void:
	move.exit()
