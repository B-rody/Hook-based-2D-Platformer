extends State

export var hook_max_speed: = 1500.0
export var arrive_push: = 500.0

var target_global_position: = Vector2(INF,INF)
var velocity: = Vector2.ZERO


func physics_process(delta: float) -> void:
	velocity = Steering.arrive_to(
		velocity,
		owner.global_position,
		target_global_position, 
		hook_max_speed
	)
	velocity = velocity if velocity.length() > arrive_push else velocity.normalized() * arrive_push
	velocity - owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)
	
	var to_target: Vector2 = target_global_position - owner.global_position
	var distance = to_target.length()
	
	if distance < velocity.length() * delta:
		velocity = velocity.normalized() * arrive_push
		_state_machine.transition_to("Move/Air", {velocity = velocity})
	

func enter(msg: Dictionary = {}) -> void:
	match msg:
		{"target_global_position": var tgp, "velocity": var v}:
			target_global_position = tgp
			velocity = v
			

func exit() -> void:
	target_global_position = Vector2(INF,INF)
	velocity = Vector2.ZERO
