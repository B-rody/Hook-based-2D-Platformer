extends Node
class_name State, "res://assets/icons/state.svg"



onready var _state_machine: StateMachine = _get_state_machine(self)


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


# Enter the state. Passes data when switching from one state to another
func enter(msg: Dictionary = {}) -> void:
	return


func exit() -> void:
	return


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node