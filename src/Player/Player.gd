extends KinematicBody2D
class_name player


onready var state_machine: StateMachine = $StateMachine
onready var skin: Node2D = $Skin
onready var collider: CollisionShape2D = $CollisionShape2D
const FLOOR_NORMAL: = Vector2.UP
var is_active = true setget set_is_active
onready var hook: Hook = $Hook
onready var ledge_wall_detector: LedgeWallDetector = $LedgeWallDetector
onready var floor_detector: FloorDetector = $FloorDetector
onready var pass_through: Area2D = $PassThrough

func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.disabled = not value
	hook.is_active = value
	hook.visible = value
