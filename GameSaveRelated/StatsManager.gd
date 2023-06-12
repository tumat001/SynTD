extends Node

signal enemy_id_killed_by_dmg_count_changed(arg_enemy_id, arg_count)
signal enemy_id_escaped_count_changed(arg_enemy_id, arg_count)
signal tidbit_id_val_changed(arg_tidbit_id, arg_val)


signal stats_loaded()

#################

# killed by dmg with no revives
const stat_name__enemy_id__killed_by_dmg_count := "stat_name__enemy_id__killed_by_dmg_count"
const stat_name__enemy_id__escape_count := "stat_name__enemy_id__escape_count"

const stat_name__tower_id__play_per_round_count := "stat_name__tower_id__play_per_round_count"
const stat_name__synergy_id_and_tier__play_per_round_count := "stat_name__synergy_id_and_tier__play_per_round_count"

const stat_name__text_tidbit_id__value := "stat_name__text_tidbit_id__value"


# can be used if its the first time a player has played.
const stat_name__completed_tutorial_world__value := "stat_name__completed_tutorial_world__value"


################

var enemy_id_to_killed_by_dmg_count_map : Dictionary
var enemy_id_to_escape_count_map : Dictionary

var tower_id_to_play_per_round_count_map : Dictionary
var synergy_compo_id_tier_to_play_per_round_count : Dictionary

var text_tidbit_id_to_int_val_map : Dictionary


var first_tutorial_world = StoreOfMaps.MapsId_TutorialV02_01

enum TutorialWorldCompletionState {
	
	TUTORIAL_X__NONE = 1 << 0,
	TUTORIAL_X__AVAILABLE = 1 << 1,
	
	#
	
	TUTORIAL_01__FULL_COMPLETE = 1 << 2,
	
	#
	
	TUTORIAL_02__FULL_COMPLETE = 1 << 2,
	
}
var completed_tutorial_id_to_state_val_map : Dictionary


#

var is_stats_loaded : bool

#

var game_elements
var stage_round_manager
var tower_manager
var synergy_manager

#

var _current_stageround_id

var _current_tower_ids_at_round_start : Array
var _current_syn_compo_id_tier_at_round_start : Array

#

func _ready():
	GameSaveManager.load_stats__of_stats_manager()
	
	is_stats_loaded = true
	emit_signal("stats_loaded")

#

func _get_save_dict_for_stats():
	var save_dict = {
		stat_name__enemy_id__killed_by_dmg_count : enemy_id_to_killed_by_dmg_count_map,
		stat_name__enemy_id__escape_count : enemy_id_to_escape_count_map,
		
		stat_name__tower_id__play_per_round_count : tower_id_to_play_per_round_count_map,
		
		stat_name__synergy_id_and_tier__play_per_round_count : synergy_compo_id_tier_to_play_per_round_count,
		
		stat_name__text_tidbit_id__value : text_tidbit_id_to_int_val_map,
		
		
		stat_name__completed_tutorial_world__value : completed_tutorial_id_to_state_val_map,
		
	}
	
	return save_dict

func _load_stats(arg_file : File):
	var save_dict = parse_json(arg_file.get_line())
	
	if !save_dict is Dictionary:
		save_dict = {}
	
	_initialize_stats_with_save_dict(save_dict)

func _initialize_stats_with_save_dict(arg_save_dict : Dictionary):
	_initialize_enemy_id_to_killed_by_dmg_count_map(arg_save_dict)
	_initialize_enemy_id_to_escape_count_map(arg_save_dict)
	
	_initialize_tower_id_to_play_per_round_count_map(arg_save_dict)
	_initialize_synergy_id_and_tier_to_play_per_round_count_map(arg_save_dict)
	_initialize_tidbit_id_to_int_value_map(arg_save_dict)
	

# called by GameSaveManager
func _initialize_stats_from_scratch():
	_initialize_stats_with_save_dict({})

###

func _initialize_enemy_id_to_killed_by_dmg_count_map(arg_save_dict : Dictionary):
	if arg_save_dict.has(stat_name__enemy_id__killed_by_dmg_count):
		#enemy_id_to_killed_by_dmg_count_map = arg_save_dict[stat_name__enemy_id__killed_by_dmg_count]
		enemy_id_to_killed_by_dmg_count_map = _convert_dict_to_types__to_int_key_and_int_val(arg_save_dict[stat_name__enemy_id__killed_by_dmg_count])
		
	else:
		enemy_id_to_killed_by_dmg_count_map = {}
	
	_fill_in_missing_enemy_id_in_map_with_default_val(enemy_id_to_killed_by_dmg_count_map, 0)


func _initialize_enemy_id_to_escape_count_map(arg_save_dict : Dictionary):
	if arg_save_dict.has(stat_name__enemy_id__escape_count):
		#enemy_id_to_escape_count_map = arg_save_dict[stat_name__enemy_id__escape_count]
		enemy_id_to_escape_count_map = _convert_dict_to_types__to_int_key_and_int_val(arg_save_dict[stat_name__enemy_id__escape_count])
		
	else:
		enemy_id_to_escape_count_map = {}
	
	_fill_in_missing_enemy_id_in_map_with_default_val(enemy_id_to_escape_count_map, 0)

func _initialize_tower_id_to_play_per_round_count_map(arg_save_dict : Dictionary):
	if arg_save_dict.has(stat_name__tower_id__play_per_round_count):
		#tower_id_to_play_per_round_count_map = arg_save_dict[stat_name__tower_id__play_per_round_count]
		tower_id_to_play_per_round_count_map = _convert_dict_to_types__to_int_key_and_int_val(arg_save_dict[stat_name__tower_id__play_per_round_count])
		
	else:
		tower_id_to_play_per_round_count_map = {}
	
	_fill_in_missing_tower_id_in_map_with_default_val(tower_id_to_play_per_round_count_map, 0)


func _initialize_synergy_id_and_tier_to_play_per_round_count_map(arg_save_dict : Dictionary):
	if arg_save_dict.has(stat_name__synergy_id_and_tier__play_per_round_count):
		#synergy_compo_id_tier_to_play_per_round_count = arg_save_dict[stat_name__synergy_id_and_tier__play_per_round_count]
		synergy_compo_id_tier_to_play_per_round_count = _convert_dict_to_types__to_string_key_and_int_val(arg_save_dict[stat_name__synergy_id_and_tier__play_per_round_count])
		
	else:
		synergy_compo_id_tier_to_play_per_round_count = {}
	
	_fill_in_missing_syn_compo_id_in_map_with_default_val(synergy_compo_id_tier_to_play_per_round_count, 0)

func _initialize_tidbit_id_to_int_value_map(arg_save_dict : Dictionary):
	if arg_save_dict.has(stat_name__text_tidbit_id__value):
		text_tidbit_id_to_int_val_map = _convert_dict_to_types__to_int_key_and_int_val(arg_save_dict[stat_name__text_tidbit_id__value])
		
	else:
		text_tidbit_id_to_int_val_map = {}
	
	_fill_in_missing_tidbit_id_in_map_with_default_val(text_tidbit_id_to_int_val_map, 0)

func _initialize_completed_tutorial_world_value_map(arg_save_dict : Dictionary):
	if arg_save_dict.has(stat_name__completed_tutorial_world__value):
		completed_tutorial_id_to_state_val_map = _convert_dict_to_types__to_int_key_and_int_val(arg_save_dict[stat_name__completed_tutorial_world__value])
		
	else:
		completed_tutorial_id_to_state_val_map = {}
	
	_fill_in_missing_completed_tutorial_world_map_with_default_val(completed_tutorial_id_to_state_val_map, TutorialWorldCompletionState.TUTORIAL_X__NONE)




# initialize save dict helpers

func _convert_dict_to_types__to_int_key_and_int_val(dict : Dictionary):
	var new_dict : Dictionary = {}
	
	for string_key in dict.keys():
		new_dict[int(string_key)] = int(dict[string_key])
	
	return new_dict

func _convert_dict_to_types__to_string_key_and_int_val(dict : Dictionary):
	var new_dict : Dictionary = {}
	
	for string_key in dict.keys():
		new_dict[string_key] = int(dict[string_key])
	
	return new_dict



func _fill_in_missing_enemy_id_in_map_with_default_val(arg_specific_save_dict : Dictionary, arg_default_val):
	for id in EnemyConstants.Enemies.values():
		if !arg_specific_save_dict.has(id):
			arg_specific_save_dict[id] = arg_default_val

func _fill_in_missing_tower_id_in_map_with_default_val(arg_specific_save_dict : Dictionary, arg_default_val):
	for id in Towers.TowerTiersMap.keys():
		if !arg_specific_save_dict.has(id):
			arg_specific_save_dict[id] = arg_default_val

#func _fill_in_missing_syn_id_in_map_with_default_val(arg_specific_save_dict : Dictionary, arg_default_val):
#	for id in TowerDominantColors.SynergyId.values():
#		if !arg_specific_save_dict.has(id):
#			arg_specific_save_dict[id] = arg_default_val
#
#	for id in TowerCompositionColors.SynergyId.values():
#		if !arg_specific_save_dict.has(id):
#			arg_specific_save_dict[id] = arg_default_val

func _fill_in_missing_syn_compo_id_in_map_with_default_val(arg_specific_save_dict : Dictionary, arg_default_val):
	for id_tier_compo in TowerDominantColors.all_syn_id_tier_compos:
		if !arg_specific_save_dict.has(id_tier_compo):
			arg_specific_save_dict[id_tier_compo] = arg_default_val
	
	for id_tier_compo in TowerCompositionColors.all_syn_id_tier_compos:
		if !arg_specific_save_dict.has(id_tier_compo):
			arg_specific_save_dict[id_tier_compo] = arg_default_val

func _fill_in_missing_tidbit_id_in_map_with_default_val(arg_specific_save_dict : Dictionary, arg_default_val):
	for id in StoreOfTextTidbit.TidbitId.values():
		if !arg_specific_save_dict.has(id):
			arg_specific_save_dict[id] = arg_default_val


func _fill_in_missing_completed_tutorial_world_map_with_default_val(arg_specific_save_dict : Dictionary, arg_default_val):
	for id in StoreOfMaps.all_tutorial_map_ids:
		if !arg_specific_save_dict.has(id):
			arg_specific_save_dict[id] = arg_default_val
	
	arg_specific_save_dict[first_tutorial_world] = TutorialWorldCompletionState.TUTORIAL_X__AVAILABLE


##############

func connect_signals_with_game_elements(arg_game_elements):
	game_elements = arg_game_elements
	
	game_elements.connect("before_game_quit", self, "_on_before_game_quit", [], CONNECT_PERSIST)

func disconnect_signals_with_game_elements():
	game_elements.disconnect("before_game_quit", self, "_on_before_game_quit")
	
	game_elements = null

func _on_before_game_quit():
	disconnect_signals_with_game_elements()
	
	GameSaveManager.save_stats__of_stats_manager()


## ENEMY RELATED

func connect_signals_with_enemy_manager(arg_enemy_manager):
	arg_enemy_manager.connect("enemy_killed_by_damage_and_no_more_revives", self, "_on_enemy_killed_by_damage_and_no_more_revives", [], CONNECT_PERSIST)
	arg_enemy_manager.connect("enemy_escaped", self, "_on_enemy_escaped", [], CONNECT_PERSIST)

func _on_enemy_killed_by_damage_and_no_more_revives(arg_dmg_instance_report, arg_enemy):
	enemy_id_to_killed_by_dmg_count_map[arg_enemy.enemy_id] += 1
	
	#print(enemy_id_to_killed_by_dmg_count_map[arg_enemy.enemy_id])
	
	emit_signal("enemy_id_killed_by_dmg_count_changed", arg_enemy.enemy_id, enemy_id_to_killed_by_dmg_count_map[arg_enemy.enemy_id])

func _on_enemy_escaped(arg_enemy):
	enemy_id_to_escape_count_map[arg_enemy.enemy_id] += 1
	
	emit_signal("enemy_id_escaped_count_changed", arg_enemy.enemy_id, enemy_id_to_escape_count_map[arg_enemy.enemy_id])


## STAGE ROUND RELATED

func connect_signals_with_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	arg_manager.connect("round_started", self, "_on_round_started", [], CONNECT_PERSIST)
	arg_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)

func _on_round_started(arg_stageround):
	#_current_stageround_id = arg_stageround.id
	
	_on_round_started__for_tower_purposes(arg_stageround)
	_on_round_started__for_syn_purposes(arg_stageround)

func _on_round_ended(arg_stageround):
	_current_stageround_id = arg_stageround.id
	
	_on_round_ended__for_tower_purposes(arg_stageround)
	_on_round_ended__for_syn_purposes(arg_stageround)

# TOWER RELATED

func connect_signals_with_tower_manager(arg_tower_manager):
	tower_manager = arg_tower_manager
	
	arg_tower_manager.connect("tower_transfered_in_map_from_bench", self, "_on_tower_transfered_in_map_from_bench", [], CONNECT_PERSIST)
	arg_tower_manager.connect("tower_added", self, "_on_tower_added", [], CONNECT_PERSIST)

func _on_round_started__for_tower_purposes(arg_stageround):
	for tower in tower_manager.get_all_towers_except_in_queue_free():
		_add_tower_id_to_current_tower_ids_if_none(tower)

func _on_round_ended__for_tower_purposes(arg_stageround):
	for id in _current_tower_ids_at_round_start:
		tower_id_to_play_per_round_count_map[id] += 1
	
	_current_tower_ids_at_round_start.clear()

func _on_tower_transfered_in_map_from_bench(arg_tower, arg_map_placable, arg_bench_placable):
	if stage_round_manager.round_started:
		_add_tower_id_to_current_tower_ids_if_none(arg_tower)

func _on_tower_added(arg_tower):
	if arg_tower.is_a_summoned_tower:
		_add_tower_id_to_current_tower_ids_if_none(arg_tower)

func _add_tower_id_to_current_tower_ids_if_none(arg_tower):
	if !_current_tower_ids_at_round_start.has(arg_tower.tower_id):
		_current_tower_ids_at_round_start.append(arg_tower.tower_id)



########


func connect_signals_with_synergy_manager(arg_manager):
	synergy_manager = arg_manager
	
	synergy_manager.connect("synergies_updated", self, "_on_synergies_updated", [], CONNECT_PERSIST)

func _on_round_started__for_syn_purposes(arg_stageround):
	for syn_res in synergy_manager.active_synergies_res:
		_add_syn_id_to_current_syn_ids_if_none(syn_res.synergy.current_synergy_tier_id)

func _on_round_ended__for_syn_purposes(arg_stageround):
	for id_tier_compo in _current_syn_compo_id_tier_at_round_start:
		if synergy_compo_id_tier_to_play_per_round_count.has(id_tier_compo):
			synergy_compo_id_tier_to_play_per_round_count[id_tier_compo] += 1
	
	_current_syn_compo_id_tier_at_round_start.clear()

func _add_syn_id_to_current_syn_ids_if_none(arg_syn_compo_id_tier):
	if !_current_syn_compo_id_tier_at_round_start.has(arg_syn_compo_id_tier):
		_current_syn_compo_id_tier_at_round_start.append(arg_syn_compo_id_tier)


func _on_synergies_updated():
	if stage_round_manager.round_started:
		for syn_res in synergy_manager.active_synergies_res:
			_add_syn_id_to_current_syn_ids_if_none(syn_res.synergy.current_synergy_tier_id)
	
	_updated_synergies__for_orange_12_purposes()


#######

func set_val_of_tidbit_val_map(arg_tidbit_id, arg_val):
	text_tidbit_id_to_int_val_map[arg_tidbit_id] = arg_val
	
	emit_signal("tidbit_id_val_changed", arg_tidbit_id, arg_val)



## TIDBIT SPECIFIC CONDITIONS related

func _updated_synergies__for_orange_12_purposes():
	if text_tidbit_id_to_int_val_map[StoreOfTextTidbit.TidbitId.ORANGE_12] == 0:
		if synergy_manager.is_color_synergy_id_active__with_tier_being_equal_to(TowerDominantColors.SynergyID__Orange, 1):
			set_val_of_tidbit_val_map(StoreOfTextTidbit.TidbitId.ORANGE_12, 1)
	


##############


func if_enemy_killed_by_damage_count_is_at_least_x(arg_enemy_id, arg_count):
	return enemy_id_to_killed_by_dmg_count_map[arg_enemy_id] >= arg_count

func if_tower_played_count_per_round_is_at_least_x(arg_id, arg_count):
	return tower_id_to_play_per_round_count_map[arg_id] >= arg_count

func if_synergy_id_has_at_least_x_play_count(arg_syn_id, arg_count):
	var total : int = 0

	for id_tier_compo in synergy_compo_id_tier_to_play_per_round_count.keys():
		var separated = id_tier_compo.split("-")

		if separated[0] == str(arg_syn_id):
			total += synergy_compo_id_tier_to_play_per_round_count[id_tier_compo]

			if total >= arg_count:
				return true

	return false

func if_tidbit_id_has_at_least_x_val(arg_tidbit_id, arg_min_val):
	return text_tidbit_id_to_int_val_map[arg_tidbit_id] >= arg_min_val

func if_tidbit_map_has_at_least_one_tidbit_with_non_zero_val():
	for id in text_tidbit_id_to_int_val_map:
		if text_tidbit_id_to_int_val_map[id] != 0:
			return true
	
	return false


# can be used for determining if its the first time a player is playing
func if_any_tutorial_is_completed():
	for id in completed_tutorial_id_to_state_val_map.keys():
		if !flag_is_enabled(completed_tutorial_id_to_state_val_map[id], TutorialWorldCompletionState.TUTORIAL_X__NONE) and !flag_is_enabled(completed_tutorial_id_to_state_val_map[id], TutorialWorldCompletionState.TUTORIAL_X__AVAILABLE):
			return true
	
	return false

func if_tutorial_world_is_available(arg_tutorial_world_id):
	return flag_is_enabled(completed_tutorial_id_to_state_val_map[arg_tutorial_world_id], TutorialWorldCompletionState.TUTORIAL_X__AVAILABLE)

func set_tutorial_world_to_available(arg_tutorial_world_id):
	set_tutorial_world_flag(arg_tutorial_world_id, TutorialWorldCompletionState.TUTORIAL_X__AVAILABLE)


func set_tutorial_world_flag(arg_tutorial_world_id, arg_flag):
	completed_tutorial_id_to_state_val_map[arg_tutorial_world_id] = set_flag(completed_tutorial_id_to_state_val_map[arg_tutorial_world_id], arg_flag)


##########  FLAG SETTING

static func flag_is_enabled(b : int, flag : int):
	return b & flag != 0

static func set_flag(b : int, flag : int):
	b = b|flag
	return b

static func unset_flag(b : int, flag : int):
	b = b & ~flag
	return b



