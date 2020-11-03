extends Node2D


signal animation_finished(name)

onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	anim.connect("animation_finished", self, "on_AnimationPlayer_animation_finished")


func on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)


func play(anim_name: String, data: Dictionary = {}) -> void:
	assert(anim_name in anim.get_animation_list())
	if "from" in data:
		position = data.from
	anim.play(anim_name)
