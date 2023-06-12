extends "res://MapsRelated/BaseMap.gd"

const MemoryType_Gold_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Gold.png")
const MemoryType_Gold_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Gold_Highlighted.png")
const MemoryType_Health_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Health.png")
const MemoryType_Health_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Health_Highlighted.png")
const MemoryType_Relic_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Relic.png")
const MemoryType_Relic_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Relic_Highlighted.png")
const MemoryType_Towers_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Towers.png")
const MemoryType_Towers_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Towers_Highlighted.png")
const MemoryType_TowersWithIngs_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_TowersWithIngs.png")
const MemoryType_TowersWithIngs_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_TowersWithIngs_Highlighted.png")
const MemoryType_None_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_None.png")
const MemoryType_None_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_None_Highlighted.png")


#

const ModeNormal_Memories_StageRounds = preload("res://GameplayRelated/StagesAndRoundsRelated/CustomStagerounds/ModeNormal_Memories_StageRounds.gd")

const MemoryTypeSacrificeButton = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/Subs/MemoryTypeSacrificeButton/MemoryTypeSacrificeButton.gd")

const MemorySacrificeGUI_Scene = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/MemorySacrificeGUI.tscn")
const MemorySacrificeGUI = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/MemorySacrificeGUI.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


#######

enum MemoryTypeId {
	NONE = 0,
	
	TOWERS = 1,
	TOWERS_WITH_INGS = 2,
	#COMBINATION = 3,     # would be too op so dont bother hahahhaa
	RELIC_AND_GOLD = 4,
	GOLD = 5,
	HEALTH = 6,
	
}

const TOWERS_WITH_INGS_MAX_ING_COUNT : int = 2

#####

class RoundMemorySacrificeInfo:
	
	var sacrifice_type_ids_available_to_param_map : Dictionary
	var stage_round_id : String
	

const stage_round_trigger_to_round_memory_info_map : Dictionary = {}


###

var _current_round_memory_sacrifice_info : RoundMemorySacrificeInfo
var _mem_type_sac_construction_param__none

var _memory_sacrifice_gui : MemorySacrificeGUI


var game_elements
var stage_round_manager

##################

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	game_elements = arg_game_elements
	stage_round_manager = game_elements.stage_round_manager
	
	#
	
	_initialize_memory_infos()
	_initialize_custom_stagerounds()
	_initialize_memory_sacrifice_gui()
	
	stage_round_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)


func _initialize_custom_stagerounds():
	var stage_rounds = ModeNormal_Memories_StageRounds.new()
	
	game_elements.stage_round_manager.set_stagerounds(stage_rounds)


func _initialize_memory_infos():
	var mem_sac_info__3 = RoundMemorySacrificeInfo.new()
	mem_sac_info__3.stage_round_id = "33"
	mem_sac_info__3.sacrifice_type_ids_available_to_param_map = {
		MemoryTypeId.TOWERS : [1],
		MemoryTypeId.GOLD : [4],
		MemoryTypeId.HEALTH : [8],
	}
	_add_memory_info(mem_sac_info__3)
	
	var mem_sac_info__5 = RoundMemorySacrificeInfo.new()
	mem_sac_info__5.stage_round_id = "53"
	mem_sac_info__5.sacrifice_type_ids_available_to_param_map = {
		MemoryTypeId.TOWERS_WITH_INGS : [1, TOWERS_WITH_INGS_MAX_ING_COUNT],
		MemoryTypeId.TOWERS : [2],
		MemoryTypeId.GOLD : [8],
		MemoryTypeId.HEALTH : [14],
	}
	_add_memory_info(mem_sac_info__5)
	
	var mem_sac_info__7 = RoundMemorySacrificeInfo.new()
	mem_sac_info__7.stage_round_id = "73"
	mem_sac_info__7.sacrifice_type_ids_available_to_param_map = {
		MemoryTypeId.TOWERS_WITH_INGS : [2, TOWERS_WITH_INGS_MAX_ING_COUNT],
		MemoryTypeId.TOWERS : [4],
		MemoryTypeId.GOLD : [18],
		MemoryTypeId.HEALTH : [28],
		MemoryTypeId.RELIC_AND_GOLD : [1, 2],
	}
	_add_memory_info(mem_sac_info__7)
	
	var mem_sac_info__9 = RoundMemorySacrificeInfo.new()
	mem_sac_info__9.stage_round_id = "93"
	mem_sac_info__9.sacrifice_type_ids_available_to_param_map = {
		MemoryTypeId.TOWERS_WITH_INGS : [3, TOWERS_WITH_INGS_MAX_ING_COUNT],
		MemoryTypeId.TOWERS : [5],
		MemoryTypeId.GOLD : [40],
		MemoryTypeId.HEALTH : [40],
		MemoryTypeId.RELIC_AND_GOLD : [1, 5],
	}
	_add_memory_info(mem_sac_info__9)
	


func _add_memory_info(arg_info : RoundMemorySacrificeInfo):
	stage_round_trigger_to_round_memory_info_map[arg_info.stage_round_id] = arg_info
	


func _initialize_memory_sacrifice_gui():
	_mem_type_sac_construction_param__none = _generate_mem_type_sacrifice_button_constructor_param(MemoryTypeId.NONE, null)
	
	_memory_sacrifice_gui = MemorySacrificeGUI_Scene.instance()
	game_elements.whole_screen_manager.add_control_but_dont_show(_memory_sacrifice_gui)

#######

func _on_round_ended(arg_stageround_id):
	if stage_round_trigger_to_round_memory_info_map.has(arg_stageround_id):
		_current_round_memory_sacrifice_info = stage_round_trigger_to_round_memory_info_map[arg_stageround_id]
		
		_show_memory_sacrifice_gui()
		
	else:
		_current_round_memory_sacrifice_info = null
		

func _show_memory_sacrifice_gui():
	var constructor_params : Array
	for mem_type_id in _current_round_memory_sacrifice_info.sacrifice_type_ids_available_to_param_map.keys():
		var params = _current_round_memory_sacrifice_info.sacrifice_type_ids_available_to_param_map[mem_type_id]
		
		constructor_params.append(_generate_mem_type_sacrifice_button_constructor_param(mem_type_id, params))
	
	
	_memory_sacrifice_gui.configure_to_mem_sacrifice_button_construction_params(constructor_params)
	_memory_sacrifice_gui.configure_to_mem_sacrifice_button_construction_params__in_other_slots([_mem_type_sac_construction_param__none])
	
	_memory_sacrifice_gui.show_gui()
	

#######

func _generate_mem_type_sacrifice_button_constructor_param(arg_type, arg_params):
	var constructor_param = MemoryTypeSacrificeButton.ConstructorParams.new()
	
	var descs
	var image_normal
	var image_hovered
	var on_click_func_name
	
	if arg_type == MemoryTypeId.GOLD:
		descs = _generate_description_for_mem_type_with_params__gold(arg_params)
		image_normal = MemoryType_Gold_Normal
		image_hovered = MemoryType_Gold_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__gold" 
		
	elif arg_type == MemoryTypeId.HEALTH:
		descs = _generate_description_for_mem_type_with_params__health(arg_params)
		image_normal = MemoryType_Health_Normal
		image_hovered = MemoryType_Health_Highlighted 
		on_click_func_name = "_on_execute_memory_sacrifice_type__health" 
		
		
	elif arg_type == MemoryTypeId.RELIC_AND_GOLD:
		descs = _generate_description_for_mem_type_with_params__relic_and_gold(arg_params)
		image_normal = MemoryType_Relic_Normal
		image_hovered = MemoryType_Relic_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__relic_and_gold" 
		
		
	elif arg_type == MemoryTypeId.TOWERS:
		descs = _generate_description_for_mem_type_with_params__towers(arg_params)
		image_normal = MemoryType_Towers_Normal
		image_hovered = MemoryType_Towers_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__towers" 
		
		
	elif arg_type == MemoryTypeId.TOWERS_WITH_INGS:
		descs = _generate_description_for_mem_type_with_params__towers_with_ings(arg_params)
		image_normal = MemoryType_TowersWithIngs_Normal
		image_hovered = MemoryType_TowersWithIngs_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__towers_with_ings" 
		
	elif arg_type == MemoryTypeId.NONE:
		
		descs = _generate_description_for_mem_type_with_params__none(arg_params)
		image_normal = MemoryType_None_Normal
		image_hovered = MemoryType_None_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__none" 
		
		constructor_param.row_index = constructor_param.ROW_BELOW
	
	
	constructor_param.descriptions = descs
	constructor_param.header_left_text = "Sacrifice Info"
	constructor_param.image_normal = image_normal
	constructor_param.image_hovered = image_hovered
	constructor_param.on_click_func_source = self
	constructor_param.on_click_func_name = on_click_func_name
	
	
	return constructor_param


func _generate_description_for_mem_type_with_params__gold(arg_params):
	var plain_fragment__x_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % [arg_params[0]])
	
	return ["Sacrifice |0|.", [plain_fragment__x_gold]]

func _generate_description_for_mem_type_with_params__health(arg_params):
	var plain_fragment__x_health = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "%s health" % [arg_params[0]])
	
	return ["Sacrifice |0|.", [plain_fragment__x_health]]

func _generate_description_for_mem_type_with_params__relic_and_gold(arg_params):
	var gold_amount = arg_params[1]
	
	var plain_fragment__x_relic = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.RELIC, "%s relic(s)" % [arg_params[0]])
	
	if gold_amount != 0:
		var plain_fragment__x_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % [gold_amount])
		
		return ["Sacrifice |0| and |1|.", [plain_fragment__x_relic, plain_fragment__x_gold]]
		
	else:
		return ["Sacrifice |0|.", [plain_fragment__x_relic]]


func _generate_description_for_mem_type_with_params__towers(arg_params):
	var plain_fragment__x_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s tower(s)" % [arg_params[0]])
	var plain_fragment__ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredients")
	
	return ["Sacrifice |0|. Does not include their |1|.", [plain_fragment__x_towers, plain_fragment__ingredients]]


func _generate_description_for_mem_type_with_params__towers_with_ings(arg_params):
	var plain_fragment__x_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s tower(s)" % [arg_params[0]])
	var plain_fragment__x_ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "%s ingredient(s)" % [arg_params[1]])
	
	return ["Sacrifice |0|. Includes up to |1|.", [plain_fragment__x_towers, plain_fragment__x_ingredients]]

func _generate_description_for_mem_type_with_params__none(arg_params):
	return "Sacrifice nothing."

###############

func _on_execute_memory_sacrifice_type__gold(arg_params):
	pass
	

func _on_execute_memory_sacrifice_type__health(arg_params):
	pass
	

func _on_execute_memory_sacrifice_type__relic_and_gold(arg_params):
	pass
	

func _on_execute_memory_sacrifice_type__towers(arg_params):
	pass
	

func _on_execute_memory_sacrifice_type__towers_with_ings(arg_params):
	pass
	


func _on_execute_memory_sacrifice_type__none(arg_params):
	pass
	


########################


