extends State
"""
Parent state that abstracts and handles basic movement
Move-related children states can delegate movement to it, or us its utility functions
"""

const PASS_THROUGH_LAYER := 3
export var max_speed_default: = Vector2(500.0, 900.0)
export var acceleration_default: = Vector2(100000, 3000.0)
export var decceleration_default: = Vector2(2000.0, 3000.0)
export var max_speed_fall: = 1500.0

var acceleration: = acceleration_default
var decceleration: = decceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO
var dash_count: int = 0

func on_Hook_hooked_onto_target(target_global_position: Vector2, velocity_multiplier: float) -> void:
	var to_target: Vector2 = target_global_position - owner.global_position
	if owner.is_on_floor() and to_target.y > 0.0:
		return
	_state_machine.transition_to("Hook", {target_global_position = target_global_position, velocity = velocity, velocity_multiplier = velocity_multiplier })
	

func _on_PassThrough_body_exited(body) -> void:
	owner.set_collision_mask_bit(PASS_THROUGH_LAYER, true)


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = true })
	if event.is_action_pressed("toggle_debug_mode"):
		_state_machine.transition_to("Debug")

	if event.is_action_pressed("move_down") and owner.is_on_floor():
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, false)
		_state_machine.transition_to("Move/Air")
	elif event.is_action_released("move_down") and not owner.get_collision_mask_bit(PASS_THROUGH_LAYER):
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, true)


func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, decceleration, delta,
	get_move_direction())
	velocity = owner.move_and_slide_with_snap(velocity, Vector2.DOWN * 20.0, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)
	
	
func enter(msg: Dictionary = {}) -> void:
	$Air.connect("jumped", $Idle.jump_delay, "start")
	owner.pass_through.connect("body_exited", self, "on_PassThrough_body_exited")
	owner.hook.connect("hooked_onto_target", self, "on_Hook_hooked_onto_target")


func exit() -> void:
	$Air.disconnect("jumped", $Idle.jump_delay, "start")
	owner.hook.disconnect("hooked_onto_target", self, "on_Hook_hooked_onto_target")
	owner.pass_through.disconnect("body_exited", self, "on_PassThrough_body_exited")

static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		decceleration: Vector2,
		delta: float,
		move_direction: Vector2,
		max_speed_fall = 1500.0
	) -> Vector2:
	var new_velocity: = old_velocity
	new_velocity.y += move_direction.y * acceleration.y * delta
	
	if move_direction.x:
			new_velocity.x += move_direction.x * acceleration.x * delta
	elif abs(new_velocity.x) > 0.1:
		new_velocity.x -= decceleration.x * delta * sign(new_velocity.x)
		new_velocity.x = new_velocity.x if sign(new_velocity.x) == sign(old_velocity.x) else 0
	
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed_fall)
	return new_velocity


static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 1.0
	)
