extends State

signal jumped
export var acceleration_x: = 5000.0
onready var jump_delay: Timer = $JumpDelay
onready var move: = get_parent()
export var jump_impulse: = 900.0
export var max_jumps: = 2
var _jump_count: = 0

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and _jump_count < max_jumps:
		if move.velocity.y >= 0.0 and jump_delay.time_left > 0.0:
			move.velocity = calculate_jump_velocity(jump_impulse)
		else:
			jump()
		emit_signal("jumped")
		return
	if move.dash_count == 0 and event.is_action_pressed("dash"):
		move.dash_count += 1
		_state_machine.transition_to("Move/Dash", {direction = owner.hook.ray_cast.cast_to.normalized()})
		return
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	move.physics_process(delta)
	
	if owner.is_on_floor():
		move.dash_count = 0
		var target_state: = "Move/Idle" if move.get_move_direction().x == 0.0 else "Move/Run"
		_state_machine.transition_to(target_state)
	elif owner.ledge_wall_detector.is_against_ledge():
		_state_machine.transition_to("Ledge", {move_state=move})


# Enter the state. Passes data when switching from one state to another
func enter(msg: Dictionary = {}) -> void:
	jump_delay.start()
	move.enter(msg)
	move.acceleration.x = acceleration_x
	
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed_default.x)
	if not "impulse" in msg:
		_jump_count += 1
	if "impulse" in msg:
		jump()


func exit() -> void:
	move.exit()
	_jump_count = 0
	move.acceleration = move.acceleration_default


func jump() -> void:
	move.velocity += calculate_jump_velocity(jump_impulse)
	_jump_count += 1


func calculate_jump_velocity(impulse: = 0.0) -> Vector2:
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		Vector2.ZERO,
		1.0,
		Vector2.UP
	)
