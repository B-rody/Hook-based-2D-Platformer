extends State

onready var timer: Timer = $Timer

export var dash_speed: = 1500.0

var direction: = Vector2.ZERO
var _velocity: Vector2 = Vector2.ZERO

func enter(msg: = {}) -> void:
	timer.connect("timeout", self, "_on_Timer_timeout", [], CONNECT_ONESHOT)
	direction = msg.direction
	timer.start()
	

func physics_process(delta: float) -> void:
	_velocity = owner.move_and_slide(direction * dash_speed, owner.FLOOR_NORMAL)


func _on_Timer_timeout() -> void:
	_state_machine.transition_to("Move/Air", {velocity = _velocity/2})
