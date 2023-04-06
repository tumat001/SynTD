extends Reference

const StoreOfEnemyMorphs = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/StoreOfEnemyMorphs.gd")
const StoreOfEnemyMorphSkillsets = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Skillsets/StoreOfEnemyMorphSkillsets.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")
const EnemyStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/EnemyStatTextFragment.gd")


#

signal description_changed()

#

var id
var enemy_based_icon
var morph_based_icon

var main_enemy_morpher_id

var morph_name

var descriptions : Array
var simple_descriptions : Array

var descriptions_for_wildcard : Array
var simple_descriptions_for_wildcard : Array


var min_round_to_be_offerable_inc : String = "41"


#var morph_skillset_ids : Array
#var morph_skillset_ids__for_wildcard : Array


##

var game_elements
var morph_faction_passive

####

func _init(arg_id):
	id = arg_id


##

func get_descriptions_to_use__based_on_settings():
	if GameSettingsManager.descriptions_mode == GameSettingsManager.DescriptionsMode.SIMPLE:
		if simple_descriptions.size() != 0:
			return simple_descriptions
		else:
			return descriptions
	else:
		return descriptions


func get_wildcard_descriptions_to_use__based_on_settings():
	if GameSettingsManager.descriptions_mode == GameSettingsManager.DescriptionsMode.SIMPLE:
		if simple_descriptions_for_wildcard.size() != 0:
			return simple_descriptions_for_wildcard
		else:
			return descriptions_for_wildcard
	else:
		return descriptions_for_wildcard

func has_wildcard_descriptions():
	return simple_descriptions_for_wildcard.size() != 0 or descriptions.size() != 0

##

func _configure_with_game_elements_and_fac_passive(arg_game_elements, arg_faction_passive):
	game_elements = arg_game_elements
	morph_faction_passive = arg_faction_passive

##

func _apply_morph(arg_game_elements):
	pass
	

func _unapply_morph(arg_game_elements):
	pass
	


#

# expects method with: (enemy, params)
func _listen_for_enemy_before_enemy_spawned(arg_game_elements, arg_func_name, arg_params):
	arg_game_elements.enemy_manager.connect("before_enemy_spawned", self, arg_func_name, [arg_params], CONNECT_PERSIST)

func _unlisten_for_enemy_before_enemy_spawned(arg_game_elements, arg_func_name):
	arg_game_elements.enemy_manager.disconnect("before_enemy_spawned", self, arg_func_name)



