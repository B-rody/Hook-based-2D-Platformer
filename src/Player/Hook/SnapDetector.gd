tool
extends Area2D


onready var hooking_hint: Position2D = $HookingHint
onready var ray_cast: RayCast2D = $RayCast2D

var target: HookTarget = null setget set_target


func _ready() -> void:
	ray_cast.set_as_toplevel(true)


func _physics_process(delta: float) -> void:
	self.target = find_best_target()


func find_best_target() -> HookTarget:
	force_update_transform()
	var targets = get_overlapping_areas()
	
	if not targets:
		return null
	
	var closest_target: HookTarget = null
	var distance_to_closest: = 10000.0
	for t in targets:
		if not t.is_active:
			continue
			
		var distance: = global_position.distance_to(t.global_position)
		if distance > distance_to_closest:
			continue
			
		ray_cast.global_position = global_position
		ray_cast.cast_to = t.global_position - ray_cast.global_position
		ray_cast.force_update_transform()
		if ray_cast.is_colliding():
			continue
		distance_to_closest = distance
		closest_target = t

	return closest_target


func has_target() -> bool:
	return target != null


func calculate_length() -> float:
	var length: = -1.0
	for collider in [$CapsuleH, $CapsuleV]:
		if not collider:
			continue
		var capsule: CapsuleShape2D = collider.shape
		var capsule_length: float = collider.position.length() + capsule.height / 2 * sin(collider.rotation) + capsule.radius
		length = max(length, capsule_length)
	return length


func set_target(value: HookTarget) -> void:
	if hooking_hint:
		target = value
		hooking_hint.visible = has_target()
		hooking_hint.global_position = target.global_position if target else hooking_hint.global_position
