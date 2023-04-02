extends "res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Skillsets/AbstractMorphSkillset.gd"

signal reached_unit_offset()



var target_unit_offset : float
var _enemy

#

func _init().(StoreOfMorphSkillsets.MorpherSkillsetIds.BARE__PROMOTION):
	pass

#

func _apply_morph_skillset(arg_enemy, arg_game_elements, arg_faction_passive):
	._apply_morph_skillset(arg_enemy, arg_game_elements, arg_faction_passive)
	
	_enemy = arg_enemy
	
	_enemy.connect("moved__from_process", self, "_on_moved__from_process")

func _apply_morph_skillset__to_wildcard(arg_enemy, arg_game_elements, arg_faction_passive):
	._apply_morph_skillset__to_wildcard(arg_enemy, arg_game_elements, arg_faction_passive)
	
	_enemy = arg_enemy
	
	_enemy.connect("moved__from_process", self, "_on_moved__from_process")

####

func _on_moved__from_process(arg_has_moved_from_natural_means, arg_prev_angle_dir, arg_curr_angle_dir):
	var unit_offset = _enemy.unit_offset
	
	if target_unit_offset >= unit_offset:
		_enemy.disconnect("moved__from_process", self, "_on_moved__from_process")
		emit_signal("reached_unit_offset", _enemy)




