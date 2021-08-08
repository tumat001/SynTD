extends "res://MiscRelated/AttackSpriteRelated/SizeAdaptingAttackSprite.gd"

var tower setget set_tower


#

func set_tower(arg_tower):
	tower = arg_tower
	set_size_adapting_to(tower)
	
	tower.connect("tree_exiting", self, "_on_tower_queue_free")
	tower.connect("global_position_changed", self, "_on_tower_pos_changed")
	position = tower.global_position


func _on_tower_queue_free():
	queue_free()

func _on_tower_pos_changed(old_pos, new_pos):
	global_position = new_pos

