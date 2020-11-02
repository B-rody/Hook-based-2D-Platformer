extends State

const STARTING_POWER: = 1.0

export var max_power: = 2.0

var _power: = STARTING_POWER


func enter(msg: = {}) -> void:
	_power = STARTING_POWER
	
	
func exit() -> void:
	owner.arrow.head.modulate = Color.white
	
	
func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("hook") and owner.can_hook():
		_state_machine.transition_to("Aim/Fire", { velocity_multiplier = _power })
	elif event.is_action_released("hook"):
		_state_machine.transition_to("Aim")
	
	
func physics_process(delta: float) -> void:
	_power = clamp(_power + delta, STARTING_POWER, max_power)
	var power_percent: = ((_power - STARTING_POWER) / (max_power - STARTING_POWER))
	var color_target = Color.blue
	color_target.a = power_percent
	owner.arrow.head.modulate = Color.white.blend(color_target)
	var move: = get_parent()
	move.physics_process(delta)
