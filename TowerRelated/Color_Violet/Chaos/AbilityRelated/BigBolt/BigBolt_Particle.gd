extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


signal on_struck_ground()

const _target_frame_index = 4

func _ready():
	connect("frame_changed", self, "_on_frame_changed")

func _on_frame_changed():
	if frame == _target_frame_index:
		emit_signal("on_struck_ground")


