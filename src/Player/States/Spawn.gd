extends State


var _start_position: = Vector2.ZERO


func _ready() -> void:
	yield(owner, "ready")
	_start_position = owner.position


func _on_Skin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Move/Idle")


func enter(msg: Dictionary = {}) -> void:
	owner.is_active = false
	owner.position = _start_position
	owner.skin.play("spawn")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
	

func exit() -> void:
	owner.is_active = true
	owner.hook.visible = true
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
