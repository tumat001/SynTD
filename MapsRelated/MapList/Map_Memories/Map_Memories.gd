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

const GSSB_Memory_Recall_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Recall_Normal.png")
const GSSB_Memory_Recall_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Recall_Highlighted.png")
const GSSB_Memory_Sacrifice_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Sacrifice_Normal.png")
const GSSB_Memory_Sacrifice_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Sacrifice_Highlighted.png")
const GSSB_Memory_Summary_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Summary_Normal.png")
const GSSB_Memory_Summary_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Summary_Highlighted.png")

#

const GenStats_SmallButton = preload("res://GameHUDRelated/StatsPanel/SmallButtonRelated/GenStats_SmallButton.gd")
#const GenStats_SmallButton_Scene = preload("res://GameHUDRelated/StatsPanel/SmallButtonRelated/GenStats_SmallButton.tscn")

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

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const CenterBasedAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd")
const CenterBasedAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.tscn")

const Memories_CircleConcealParticle_Pic = preload("res://MapsRelated/MapList/Map_Memories/Particles/Memories_CircleConcealParticle.png")



signal conditions_changed__towers()
signal conditions_changed__towers_with_ings()
signal conditions_changed__relic_and_gold()
signal conditions_changed__gold()
signal conditions_changed__health()

#######

const CAN_WRITE_SAVE_FILE : bool = false  # todo change this when testing/exiting from testing

#

enum MemoryTypeId {
	NONE = 0,
	
	TOWERS = 1,
	TOWERS_WITH_INGS = 2,   # NOT yet supported as saving ings is troublesome
	#COMBINATION = 3,     
	RELIC_AND_GOLD = 4,
	GOLD = 5,
	HEALTH = 6,
	
}

const memory_type_id_to_conditions_changed_signal_name : Dictionary = {
	MemoryTypeId.NONE : "",
	MemoryTypeId.TOWERS: "conditions_changed__towers",
	MemoryTypeId.TOWERS_WITH_INGS: "conditions_changed__towers_with_ings",
	MemoryTypeId.RELIC_AND_GOLD: "conditions_changed__towers",
	MemoryTypeId.GOLD: "conditions_changed__gold",
	MemoryTypeId.HEALTH: "conditions_changed__health",
	
}

const TOWERS_WITH_INGS_MAX_ING_COUNT : int = 2

#####

class RoundMemorySacrificeInfo:
	
	var sacrifice_type_ids_available_to_param_map : Dictionary
	var stage_round_id : String
	

const stage_round_trigger_to_round_memory_info_map : Dictionary = {}


###


enum MemoryActionStates {
	NONE__WITH_NO_SACRIFICES = 0,
	NONE__WITH_SACRIFICES = 1,    # SUMMARY is viewable at this state
	
	SACRIFICING = 2,
	RECALLING = 3,
}
var _current_mem_action_state : int


#### gen stats small buttons

var GSSB__show_memory_sacrifice : GenStats_SmallButton
var GSSB__show_memory_recall : GenStats_SmallButton
var GSSB__show_memory_overview : GenStats_SmallButton

var _all_GSSB : Array

var _at_least_one_GSSB_is_visible : bool

#

var _current_stageround_id
var _current_sacrifice_id_and_param

#

var _current_round_memory_sacrifice_info : RoundMemorySacrificeInfo
var _mem_type_sac_construction_param__none

var _memory_sacrifice_gui : MemorySacrificeGUI

#

const _modulate_transition_duration_for_GSSB : float = 0.75
const _min_modulate_rgb_for_GSSB : float = 0.8
const _max_modulate_rgb_for_GSSB : float = 1.5
var _current_modulate_rgb_for_GSSB : float setget set_current_modulate_rgb_for_GSSB

var _modulate_rgb_tweener_for_GSSB : SceneTreeTween


########### Memories related

const RECALL_MEMORY__NAME__STAGE_ROUND_ID = "stage_round_id"
const RECALL_MEMORY__NAME__MEMORY_TYPE_ID = "memory_type_id"
const RECALL_MEMORY__NAME__VERSION_NUM = "version_num"
const RECALL_MEMORY__NAME__PARAM = "param"

const _current_recall_memory_version__gold : int = 1 
const _current_recall_memory_version__health : int = 1 
const _current_recall_memory_version__relic_and_gold : int = 1 
const _current_recall_memory_version__towers : int = 1 


class RecallMemory:
	var stage_round_id : String
	
	var memory_type_id : int
	var param
	
	var version_num : int
	
	func convert_to_JSON():
		return to_json({
			RECALL_MEMORY__NAME__STAGE_ROUND_ID : stage_round_id,
			RECALL_MEMORY__NAME__MEMORY_TYPE_ID : memory_type_id,
			RECALL_MEMORY__NAME__VERSION_NUM : version_num,
			RECALL_MEMORY__NAME__PARAM : param,
			
		})
	
	#######
	
	
	
	


var _past__stageround_id_to_recall_memories_map : Dictionary
var _future__stageround_id_to_recall_memories_map : Dictionary



### PARTICLES

enum CircleParticleType {
	TOWER = 1,
	HUD = 2
}

var circle_conceal_particle_pool_compo : AttackSpritePoolComponent

const circle_conceal_min_count : int = 7
const circle_conceal_max_count : int = 11

const circle_conceal_mod_a_starting_min : float = 0.25
const circle_conceal_mod_a_starting_max : float = 0.5

const circle_conceal_mod_a_finishing_min : float = 0.85
const circle_conceal_mod_a_finishing_max : float = 1.0

const circle_conceal_initial_speed_to_center_min : float = 30.0
const circle_conceal_initial_speed_to_center_max : float = 50.0

const circle_conceal_speed_accel_to_center_min : float = 200.0
const circle_conceal_speed_accel_to_center_max : float = 250.0

const circle_conceal_phase_duration : float = 0.75


const circle_conceal_center_modification_mag__tower := Vector2(10, 10)


var _circle_conceal_data_active_queue_list : Array

#######



###### SAVE FILE RELATED

const SAVE_FILE__DICT__VERSION = "1"

const SAVE_FILE__DICT_KEY__VERSION = "SaveKey_Version"
const SAVE_FILE__DICT_KEY__SACRIFICE = "SaveKey_Sacrifice"

######################

var game_elements setget set_game_elements
var stage_round_manager
var input_prompt_manager


######################


func set_game_elements(arg_ele):
	game_elements = arg_ele
	
	game_elements.connect("before_game_quit", self, "_on_before_game_quit", [], CONNECT_PERSIST)
	
	input_prompt_manager = game_elements.input_prompt_manager

#####

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	set_game_elements(arg_game_elements)
	stage_round_manager = game_elements.stage_round_manager
	
	#
	
	_initialize_memory_infos()
	_initialize_custom_stagerounds()
	_initialize_memory_sacrifice_gui()
	
	stage_round_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)
	
	_initialize_all_GSSB()
	_connect_to_relateds__for_conditions_changed__all()
	
	#
	
	_load_memories_from_save_file()
	
	#
	
	call_deferred("_deferred_init")

func _deferred_init():
	_initialize_all_particle_pools()


func _initialize_custom_stagerounds():
	var stage_rounds = ModeNormal_Memories_StageRounds.new()
	
	game_elements.stage_round_manager.set_stagerounds(stage_rounds)


func _initialize_memory_infos():
	#todo TESTING
	var mem_sac_info__test = RoundMemorySacrificeInfo.new()
	mem_sac_info__test.stage_round_id = "02"
	mem_sac_info__test.sacrifice_type_ids_available_to_param_map = {
		MemoryTypeId.TOWERS : [2],
		MemoryTypeId.GOLD : [4],
		MemoryTypeId.HEALTH : [8],
	}
	_add_memory_info(mem_sac_info__test)
	
	var mem_sac_info__test1 = RoundMemorySacrificeInfo.new()
	mem_sac_info__test1.stage_round_id = "11"
	mem_sac_info__test1.sacrifice_type_ids_available_to_param_map = {
		MemoryTypeId.TOWERS : [3],
		MemoryTypeId.GOLD : [6],
		MemoryTypeId.HEALTH : [10],
	}
	_add_memory_info(mem_sac_info__test1)
	#todo END OF TEST
	
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
		#MemoryTypeId.TOWERS_WITH_INGS : [1, TOWERS_WITH_INGS_MAX_ING_COUNT],
		MemoryTypeId.TOWERS : [2],
		MemoryTypeId.GOLD : [8],
		MemoryTypeId.HEALTH : [14],
	}
	_add_memory_info(mem_sac_info__5)
	
	var mem_sac_info__7 = RoundMemorySacrificeInfo.new()
	mem_sac_info__7.stage_round_id = "73"
	mem_sac_info__7.sacrifice_type_ids_available_to_param_map = {
		#MemoryTypeId.TOWERS_WITH_INGS : [2, TOWERS_WITH_INGS_MAX_ING_COUNT],
		MemoryTypeId.TOWERS : [4],
		MemoryTypeId.GOLD : [18],
		MemoryTypeId.HEALTH : [28],
		MemoryTypeId.RELIC_AND_GOLD : [1, 2],
	}
	_add_memory_info(mem_sac_info__7)
	
	var mem_sac_info__9 = RoundMemorySacrificeInfo.new()
	mem_sac_info__9.stage_round_id = "93"
	mem_sac_info__9.sacrifice_type_ids_available_to_param_map = {
		#MemoryTypeId.TOWERS_WITH_INGS : [3, TOWERS_WITH_INGS_MAX_ING_COUNT],
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
	game_elements.whole_screen_gui.add_control_but_dont_show(_memory_sacrifice_gui)
	
	_memory_sacrifice_gui.initialize_gui(game_elements)
	
	_memory_sacrifice_gui.connect("select_later_clicked", self, "_sacrifice__on_select_later_clicked", [], CONNECT_PERSIST)

#########

func _initialize_all_GSSB():
	_initialize_GSSB__sacrifice()
	
	

func _initialize_GSSB__sacrifice():
	var constr_params = GenStats_SmallButton.ConstructorParams.new()
	
	constr_params.show_descs = false
	
	constr_params.image_normal = GSSB_Memory_Sacrifice_Normal
	constr_params.image_hovered = GSSB_Memory_Sacrifice_Highlighted
	
	constr_params.condition_visible__func_source = self
	constr_params.condition_visible__func_name = "_update_GSSB_visibility__mem_sacrifice"
	#constr_params.condition_visible__func_param
	
	constr_params.on_click__func_source = self
	constr_params.on_click__func_name = "_on_click__show_memory_sacrifice_gui"
	
	GSSB__show_memory_sacrifice = game_elements.general_stats_panel.construct_small_button_using_cons_params(constr_params)
	_all_GSSB.append(GSSB__show_memory_sacrifice)

func _on_click__show_memory_sacrifice_gui():
	_memory_sacrifice_gui.show_gui()
	



#func _initialize_GSSB_modulate_rgb_tweener():
#	pass
#

func _start_GSSB_modulate_rgb_tweener():
	set_current_modulate_rgb_for_GSSB(_min_modulate_rgb_for_GSSB)
	
	_modulate_rgb_tweener_for_GSSB = create_tween()
	
	#todo make tweener modify a property in there, then call func that updates the button's modulates
	_modulate_rgb_tweener_for_GSSB.set_loops()
	_modulate_rgb_tweener_for_GSSB.tween_property(self, "_current_modulate_rgb_for_GSSB", _max_modulate_rgb_for_GSSB, _modulate_transition_duration_for_GSSB)
	_modulate_rgb_tweener_for_GSSB.tween_property(self, "_current_modulate_rgb_for_GSSB", _min_modulate_rgb_for_GSSB, _modulate_transition_duration_for_GSSB)
	

func _end_GSSB_modulate_rgb_tweener():
	_modulate_rgb_tweener_for_GSSB.stop()
	_modulate_rgb_tweener_for_GSSB.kill()


func set_current_modulate_rgb_for_GSSB(arg_val):
	_current_modulate_rgb_for_GSSB = arg_val
	
	for button in _all_GSSB:
		if button.visible:
			button.modulate.r = _current_modulate_rgb_for_GSSB
			button.modulate.g = _current_modulate_rgb_for_GSSB
			button.modulate.b = _current_modulate_rgb_for_GSSB
	
	

#

func set_current_mem_action_state(arg_state):
	_current_mem_action_state = arg_state
	
	var old_val = _at_least_one_GSSB_is_visible
	_at_least_one_GSSB_is_visible = _update_all_GSSB_visibility()
	_update_round_is_startable()
	_update_GSSB_modulate_rgb_tweener_state(old_val)

func _update_all_GSSB_visibility():
	var at_least_one_is_vis : bool = false
	for button in _all_GSSB:
		var res = button.update_is_visible_based_on_conditions()
		if res:
			at_least_one_is_vis = true
	
	return at_least_one_is_vis

func _update_GSSB_visibility__mem_sacrifice(arg_params):
	return _current_mem_action_state == MemoryActionStates.SACRIFICING


func _update_round_is_startable():
	var clause = game_elements.stage_round_manager.BlockStartRoundClauseIds.MAP_MEMORIES__IS_IN_SAC_OR_RECALL
	
	if _current_mem_action_state == MemoryActionStates.NONE__WITH_NO_SACRIFICES or _current_mem_action_state == MemoryActionStates.NONE__WITH_SACRIFICES:
		game_elements.stage_round_manager.block_start_round_conditional_clauses.remove_clause(clause)
	else:
		game_elements.stage_round_manager.block_start_round_conditional_clauses.attempt_insert_clause(clause)
	

func _update_GSSB_modulate_rgb_tweener_state(arg_old_at_least_one_GSSB_is_visible):
	if _at_least_one_GSSB_is_visible != arg_old_at_least_one_GSSB_is_visible:
		if _at_least_one_GSSB_is_visible:
			_start_GSSB_modulate_rgb_tweener()
		else:
			_end_GSSB_modulate_rgb_tweener()
	




#######

func _on_round_ended(arg_stageround):
	var id = arg_stageround.id
	if stage_round_trigger_to_round_memory_info_map.has(id):
		_current_stageround_id = id
		_current_round_memory_sacrifice_info = stage_round_trigger_to_round_memory_info_map[id]
		set_current_mem_action_state(MemoryActionStates.SACRIFICING)
		
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
	var condition_func_name
	var condition_func_param
	
	if arg_type == MemoryTypeId.GOLD:
		descs = _generate_description_for_mem_type_with_params__gold(arg_params)
		image_normal = MemoryType_Gold_Normal
		image_hovered = MemoryType_Gold_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__gold" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__gold"
		
	elif arg_type == MemoryTypeId.HEALTH:
		descs = _generate_description_for_mem_type_with_params__health(arg_params)
		image_normal = MemoryType_Health_Normal
		image_hovered = MemoryType_Health_Highlighted 
		on_click_func_name = "_on_execute_memory_sacrifice_type__health" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__health"
		
	elif arg_type == MemoryTypeId.RELIC_AND_GOLD:
		descs = _generate_description_for_mem_type_with_params__relic_and_gold(arg_params)
		image_normal = MemoryType_Relic_Normal
		image_hovered = MemoryType_Relic_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__relic_and_gold" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__relic_and_gold"
		
	elif arg_type == MemoryTypeId.TOWERS:
		descs = _generate_description_for_mem_type_with_params__towers(arg_params)
		image_normal = MemoryType_Towers_Normal
		image_hovered = MemoryType_Towers_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__towers" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__towers"
		
	elif arg_type == MemoryTypeId.TOWERS_WITH_INGS:
		descs = _generate_description_for_mem_type_with_params__towers_with_ings(arg_params)
		image_normal = MemoryType_TowersWithIngs_Normal
		image_hovered = MemoryType_TowersWithIngs_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__towers_with_ings" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__towers_with_ings"
		
	elif arg_type == MemoryTypeId.NONE:
		
		descs = _generate_description_for_mem_type_with_params__none(arg_params)
		image_normal = MemoryType_None_Normal
		image_hovered = MemoryType_None_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__none" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__none"
		
		constructor_param.row_index = constructor_param.ROW_BELOW
	
	
	constructor_param.descriptions = descs
	constructor_param.header_left_text = "Sacrifice Info"
	constructor_param.image_normal = image_normal
	constructor_param.image_hovered = image_hovered
	constructor_param.on_click_func_source = self
	constructor_param.on_click_func_name = on_click_func_name
	constructor_param.on_click_func_params = arg_params
	constructor_param.condition_func_source = self
	constructor_param.condition_func_param = arg_params
	constructor_param.condition_func_name = condition_func_name
	constructor_param.condition_changed_signal_source = self
	constructor_param.condition_changed_signal_name = memory_type_id_to_conditions_changed_signal_name[arg_type]
	
	
	return constructor_param


func _generate_description_for_mem_type_with_params__gold(arg_params):
	var plain_fragment__x_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % [arg_params[0]])
	
	return [
		["Sacrifice |0|.", [plain_fragment__x_gold]]
	]

func _generate_description_for_mem_type_with_params__health(arg_params):
	var plain_fragment__x_health = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "%s health" % [arg_params[0]])
	
	return [
		["Sacrifice |0|.", [plain_fragment__x_health]]
	]

func _generate_description_for_mem_type_with_params__relic_and_gold(arg_params):
	var gold_amount = arg_params[1]
	
	var plain_fragment__x_relic = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.RELIC, "%s relic(s)" % [arg_params[0]])
	
	if gold_amount != 0:
		var plain_fragment__x_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % [gold_amount])
		
		return [
			["Sacrifice |0| and |1|.", [plain_fragment__x_relic, plain_fragment__x_gold]]
		]
		
	else:
		return [
			["Sacrifice |0|.", [plain_fragment__x_relic]]
		]


func _generate_description_for_mem_type_with_params__towers(arg_params):
	var plain_fragment__x_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s tower(s)" % [arg_params[0]])
	var plain_fragment__ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredients")
	
	return [
		["Sacrifice |0|. Does not include their |1|.", [plain_fragment__x_towers, plain_fragment__ingredients]]
	]

func _generate_description_for_mem_type_with_params__towers_with_ings(arg_params):
	var plain_fragment__x_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s tower(s)" % [arg_params[0]])
	var plain_fragment__x_ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "%s ingredient(s)" % [arg_params[1]])
	
	return [
		["Sacrifice |0|. Includes up to |1|.", [plain_fragment__x_towers, plain_fragment__x_ingredients]]
	]

func _generate_description_for_mem_type_with_params__none(arg_params):
	return [
		["Sacrifice nothing.", []]  # needed for alignment
	]


###############

func _is_condition_met_for__memory_sacrifice_type__none(arg_params):
	return true

func _is_condition_met_for__memory_sacrifice_type__gold(arg_params):
	return game_elements.gold_manager.current_gold >= arg_params[0]
	

func _is_condition_met_for__memory_sacrifice_type__health(arg_params):
	return game_elements.health_manager.current_health > arg_params[0]
	

func _is_condition_met_for__memory_sacrifice_type__relic_and_gold(arg_params):
	return game_elements.relic_manager.current_relic_count >= arg_params[0] and game_elements.gold_manager.current_gold >= arg_params[1]
	

func _is_condition_met_for__memory_sacrifice_type__towers(arg_params):
	var towers = _get_all_towers_viable_for_sacrifice()
	
	return towers.size() >= arg_params[0]

func _is_condition_met_for__memory_sacrifice_type__towers_with_ings(arg_params):
	var towers = _get_all_towers_viable_for_sacrifice()
	
	return towers.size() >= arg_params[0]


func _get_all_towers_viable_for_sacrifice() -> Array:
	var towers = game_elements.tower_manager.get_all_towers()
	var final_candidates = []
	for tower in towers:
		if _is_tower_valid_for_sacrifice(tower):
			final_candidates.append(tower)
			
	
	return final_candidates

##

func _connect_to_relateds__for_conditions_changed__all():
	_connect_to_relateds__for_conditions_changed__gold()
	_connect_to_relateds__for_conditions_changed__health()
	_connect_to_relateds__for_conditions_changed__relic_and_gold()
	_connect_to_relateds__for_conditions_changed__towers_and_towers_with_ings()

func _connect_to_relateds__for_conditions_changed__gold():
	game_elements.gold_manager.connect("current_gold_changed", self, "_on_current_gold_changed", [], CONNECT_PERSIST)

func _on_current_gold_changed(arg_amount):
	emit_signal("conditions_changed__gold")


func _connect_to_relateds__for_conditions_changed__health():
	game_elements.health_manager.connect("current_health_changed", self, "_on_current_health_changed", [], CONNECT_PERSIST)

func _on_current_health_changed(arg_amount):
	emit_signal("conditions_changed__health")


func _connect_to_relateds__for_conditions_changed__relic_and_gold():
	game_elements.gold_manager.connect("current_gold_changed", self, "_on_current_relic_or_gold_changed", [], CONNECT_PERSIST)
	game_elements.relic_manager.connect("current_relic_count_changed", self, "_on_current_relic_or_gold_changed", [], CONNECT_PERSIST)

func _on_current_relic_or_gold_changed(arg_amount):
	emit_signal("conditions_changed__relic_and_gold")


func _connect_to_relateds__for_conditions_changed__towers_and_towers_with_ings():
	game_elements.tower_manager.connect("tower_in_queue_free", self, "_on_tower_queued_free", [], CONNECT_PERSIST)
	game_elements.tower_manager.connect("tower_is_hidden_changed", self, "_on_tower_is_hidden_changed", [], CONNECT_PERSIST)
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added", [], CONNECT_PERSIST)

func _on_tower_queued_free(arg_tower):
	_emit_signals__for_conditions_changed__all_tower_relateds()

func _on_tower_is_hidden_changed(arg_tower, arg_val):
	_emit_signals__for_conditions_changed__all_tower_relateds()

func _on_tower_added(arg_tower):
	call_deferred("_emit_signals__for_conditions_changed__all_tower_relateds")


func _emit_signals__for_conditions_changed__all_tower_relateds():
	emit_signal("conditions_changed__towers")
	emit_signal("conditions_changed__towers_with_ings")
	

##

func _on_execute_memory_sacrifice_type__gold(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.GOLD, arg_params]
	_wrap_up_memory_sacrifice_phase()
	
	#
	game_elements.gold_manager.decrease_gold_by(game_elements.gold_manager.DecreaseGoldSource.MAP_SPECIFIC, arg_params[0])
	_store_to_future_recall_mem_dict__mem_sac__gold(_current_stageround_id, arg_params[0])

func _on_execute_memory_sacrifice_type__health(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.HEALTH, arg_params]
	_wrap_up_memory_sacrifice_phase()
	
	#
	game_elements.health_manager.decrease_health_by(game_elements.health_manager.DecreaseHealthSource.MAP_SPECIFIC, arg_params[0])
	_store_to_future_recall_mem_dict__mem_sac__health(_current_stageround_id, arg_params[0])


func _on_execute_memory_sacrifice_type__relic_and_gold(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.RELIC_AND_GOLD, arg_params]
	_wrap_up_memory_sacrifice_phase()
	
	#
	game_elements.gold_manager.decrease_gold_by(game_elements.gold_manager.DecreaseGoldSource.MAP_SPECIFIC, arg_params[0])
	game_elements.relic_manager.decrease_relic_count_by(game_elements.relic_manager.DecreaseRelicSource.MAP_SPECIFIC, arg_params[1])
	_store_to_future_recall_mem_dict__mem_sac__relic_and_gold(_current_stageround_id, arg_params[0], arg_params[1])


func _on_execute_memory_sacrifice_type__towers(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.TOWERS, arg_params]
	_start_select_multiple_towers_prompt(arg_params[0],
	[
		["To sacrifice for Memories (ingredients NOT included)", []]
	])
	

func _on_execute_memory_sacrifice_type__towers_with_ings(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.TOWERS_WITH_INGS, arg_params]
	_start_select_multiple_towers_prompt(arg_params[0],
	[
		["To sacrifice for Memories (ingredients included)", []]
	])
	

func _on_execute_memory_sacrifice_type__none(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.NONE, arg_params]
	_wrap_up_memory_sacrifice_phase()
	

func _sacrifice__on_select_later_clicked():
	_memory_sacrifice_gui.hide_gui()
	


func _wrap_up_memory_sacrifice_phase():
	set_current_mem_action_state(MemoryActionStates.RECALLING)
	
	#_show_memory_recall_gui()  # call this when done with animations
	

##

func _start_select_multiple_towers_prompt(arg_tower_count, arg_custom_lines : Array):
	_memory_sacrifice_gui.hide_gui()
	
	var adv_param = input_prompt_manager.MultipleTowerSelectionAdvParam.new()
	adv_param.min_select_count = arg_tower_count
	adv_param.max_select_count = arg_tower_count
	
	input_prompt_manager.prompt_select_multiple_towers(adv_param, self, "_finished_tower_selected_from_multiple_select", "_cancelled_multiple_tower_selection", "_is_tower_valid_for_sacrifice",
	arg_custom_lines)
	

func _is_tower_valid_for_sacrifice(arg_tower):
	return !arg_tower.is_a_summoned_tower and !arg_tower.is_queued_for_deletion()
	

func _cancelled_multiple_tower_selection():
	_memory_sacrifice_gui.show_gui()
	


func _finished_tower_selected_from_multiple_select(arg_towers):
	var sac_id = _current_sacrifice_id_and_param[0]
	if sac_id == MemoryTypeId.TOWERS:
		_store_to_future_recall_mem_dict__mem_sac__towers(_current_stageround_id, arg_towers)
		
		
	elif sac_id == MemoryTypeId.TOWERS_WITH_INGS:
		_store_to_future_recall_mem_dict__mem_sac__towers_with_ings(_current_stageround_id, arg_towers)
		
		
	
	for tower in arg_towers:
		tower.queue_free()
	


###

func _construct_recall_memory(arg_stageround_id, arg_mem_type : int, 
	arg_params):
	
	var recall_mem = RecallMemory.new()
	recall_mem.memory_type_id = arg_mem_type
	recall_mem.stage_round_id = arg_stageround_id
	recall_mem.param = arg_params
	
	return recall_mem

func _add_recall_memory_to_future_memories_map(arg_recall_memory : RecallMemory):
	_future__stageround_id_to_recall_memories_map[arg_recall_memory.stage_round_id] = arg_recall_memory
	

#

func _store_to_future_recall_mem_dict__mem_sac__gold(arg_stage_round, arg_amount):
	var recall_mem = _construct_recall_memory(arg_stage_round, MemoryTypeId.GOLD, arg_amount)
	recall_mem.version_num = _current_recall_memory_version__gold
	
	_add_recall_memory_to_future_memories_map(recall_mem)

func _store_to_future_recall_mem_dict__mem_sac__health(arg_stage_round, arg_amount):
	var recall_mem = _construct_recall_memory(arg_stage_round, MemoryTypeId.GOLD, arg_amount)
	recall_mem.version_num = _current_recall_memory_version__gold
	
	_add_recall_memory_to_future_memories_map(recall_mem)
	

func _store_to_future_recall_mem_dict__mem_sac__relic_and_gold(arg_stage_round, arg_relic_amount, arg_gold_amount):
	var recall_mem = _construct_recall_memory(arg_stage_round, MemoryTypeId.RELIC_AND_GOLD, [arg_relic_amount, arg_gold_amount])
	recall_mem.version_num = _current_recall_memory_version__relic_and_gold
	
	_add_recall_memory_to_future_memories_map(recall_mem)

func _store_to_future_recall_mem_dict__mem_sac__towers(arg_stage_round, arg_towers):
	var tower_ids = []
	for tower in arg_towers:
		tower_ids.append(tower.tower_id)
	
	###
	
	var recall_mem = _construct_recall_memory(arg_stage_round, MemoryTypeId.TOWERS, tower_ids)
	recall_mem.version_num = _current_recall_memory_version__towers
	
	_add_recall_memory_to_future_memories_map(recall_mem)


func _store_to_future_recall_mem_dict__mem_sac__towers_with_ings(arg_stage_round, arg_towers):
	var tower_id_to_serialized_ings_map : Dictionary = {}
	for tower in arg_towers:
		pass
		#todo DELEGATED to future when saving ings is possible
	
	print("MEMORIES -> Towers With Ings not supported yet")


########################

func _show_memory_recall_gui():
	_memory_sacrifice_gui.hide_gui()
	
	#todo
	



################################## LOAD

func _load_memories_from_save_file():
	GameSaveManager.load_map_metadata__of_map_memories(self, 
			"_load_memories__using_save_file_from_save_manager")

func _load_memories__using_save_file_from_save_manager(load_file):
	var save_dict = parse_json(load_file.get_line())
	
	_past__stageround_id_to_recall_memories_map = _construct_memories_from_JSON__on_file_next_line(save_dict)


func _construct_memories_from_JSON__on_file_next_line(arg_dict):
	var version = int(arg_dict[SAVE_FILE__DICT_KEY__VERSION])
	
	return _construct_memories_from_save_dict(arg_dict, version)

func _construct_memories_from_save_dict(arg_save_dict, version):
	
	if version == 1:
		var mems = {}
		for stage_round_id in arg_save_dict.keys():
			mems[stage_round_id] = _construct_recall_memory_from_dict(arg_save_dict[stage_round_id])
		
		return mems
		
	



func _construct_recall_memory_from_dict(arg_dict):
	var recall_memory = RecallMemory.new()
	
	var params
	var memory_type_id
	var version_num
	
	for prop_name in arg_dict.keys():
		if prop_name != RECALL_MEMORY__NAME__PARAM:
			recall_memory.set(prop_name, arg_dict[prop_name])
		else:
			params = arg_dict[prop_name]
	
	memory_type_id = recall_memory.memory_type_id
	version_num = recall_memory.version_num
	
	if memory_type_id == MemoryTypeId.GOLD:
		if recall_memory.version_num == 1:
			params = int(params)
			recall_memory.version_num = _current_recall_memory_version__gold
			
	elif memory_type_id == MemoryTypeId.HEALTH:
		if recall_memory.version_num == 1:
			params = int(params)
			recall_memory.version_num = _current_recall_memory_version__health
		
	elif memory_type_id == MemoryTypeId.RELIC_AND_GOLD:
		if recall_memory.version_num == 1:
			var bucket = []
			for x in params:
				bucket.append(int(x))
			params = bucket
			recall_memory.version_num = _current_recall_memory_version__relic_and_gold
		
	elif memory_type_id == MemoryTypeId.TOWERS:
		if recall_memory.version_num == 1:
			var bucket = []
			for x in params:
				bucket.append(int(x))
			params = bucket
			recall_memory.version_num = _current_recall_memory_version__towers
		
	
	
	recall_memory.param = params
	
	return recall_memory


##################

func _on_before_game_quit():
	_write_savables_to_save_file()
	

func _write_savables_to_save_file():
	if CAN_WRITE_SAVE_FILE:
		var save_dict = {}
		
		save_dict[SAVE_FILE__DICT_KEY__VERSION] = SAVE_FILE__DICT__VERSION
		save_dict[SAVE_FILE__DICT_KEY__SACRIFICE] = _future__stageround_id_to_recall_memories_map
		
		GameSaveManager.save_map_data__map_memories(save_dict)



#################
# PARTICLES
#################

func _initialize_all_particle_pools():
	_initialize_particle_attk_sprite_pool()

func _initialize_particle_attk_sprite_pool():
	circle_conceal_particle_pool_compo = AttackSpritePoolComponent.new()
	circle_conceal_particle_pool_compo.node_to_parent_attack_sprites = get_tree().get_root()
	circle_conceal_particle_pool_compo.node_to_listen_for_queue_free = self
	circle_conceal_particle_pool_compo.source_for_funcs_for_attk_sprite = self
	circle_conceal_particle_pool_compo.func_name_for_creating_attack_sprite = "_create_circle_conceal_particle"
	

func _create_circle_conceal_particle():
	var particle = CenterBasedAttackSprite_Scene.instance()
	
	particle.texture_to_use = Memories_CircleConcealParticle_Pic
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	
	return particle


# sequence of:
# 1) Circles appearing at an angle (range) with dist (range) from center pos, increasing in scale
# 2) Beam straight up
# 3) Func call on end

func start_circle_conceal_particle_fx_sequence(arg_type : int):
	if arg_type == CircleParticleType.TOWER:
		pass
		
	elif arg_type == CircleParticleType.HUD:
		pass
		
	
	
	


func _process(delta):
	pass
	
	

func _create_circle_conceal_particle_using_data(arg_data : CircleConcealSequenceData):
	pass
	#todo




class CircleConcealSequenceData:
	var center : Vector2
	var angle_min
	var angle_max
	var dist_min
	var dist_max
	var cirlce_mod_rgb : Color
	
	var delta_per_circle : float
	
	var circle_count : int
	var delta_for_circle_phase
	var delta_for_beam_phase
	
	var _delta_left_for_next_circle : float
	var _current_circle_count : int
	var _delta_left_for_circle_phase : float
	
	var _delta_left_for_beam_phase : float
	
	
	
	var beam_mod_rgb : Color
	
	
	var func_source : Object
	var func_to_call_on_circle_phase_end : String
	var func_to_call_on_beam_phase_end : String
	
	



