extends "res://MiscRelated/BeamRelated/BeamAesthetic.gd"

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")


var tower_to_convert
var shader_to_use

func _ready():
	connect("animation_finished", self, "_animation_finished_a", [], CONNECT_ONESHOT)


func _animation_finished_a():
	if is_instance_valid(tower_to_convert) and !tower_to_convert.is_queued_for_deletion():
		tower_to_convert.remove_all_colors_from_tower(false)
		tower_to_convert.add_color_to_tower(TowerColors.BLACK)
		
		tower_to_convert.tower_base.material.shader = shader_to_use
		
		var marker_effect = tower_to_convert.get_tower_effect(StoreOfTowerEffectsUUID.AMALGAMATE_TO_CONVERT_MARK_EFFECT)
		if marker_effect != null:
			tower_to_convert.remove_tower_effect(marker_effect)
