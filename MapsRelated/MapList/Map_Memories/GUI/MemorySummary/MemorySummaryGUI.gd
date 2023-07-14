extends Control


const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")

const MemorySummaryStageRoundColumn = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySummary/Subs/MemorySummaryStageRoundColumn/MemorySummaryStageRoundColumn.gd")
const MemorySummaryStageRoundColumn_Scene = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySummary/Subs/MemorySummaryStageRoundColumn/MemorySummaryStageRoundColumn.tscn")

const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")


const ESCAPABLE_BY_ESC : bool = true

const X_POS_OFFSET_FOR_LABEL : float = 40.0


onready var label__curent = $MainContainer/VBoxContainer/ContentContainer/HBoxContainer/PastFutureContainer/LabelContainer/CurrentLabel
onready var label__future = $MainContainer/VBoxContainer/ContentContainer/HBoxContainer/PastFutureContainer/LabelContainer/FutureLabel

onready var mem_summary_stage_round_column_container = $MainContainer/VBoxContainer/ContentContainer/HBoxContainer/VBoxContainer/MemSummaryStageRoundColumnContainer



class ConstructorParams:
	
	var all_stageround_ids_with_action : Array
	
	var past__stageround_id_to_recall_memories_map
	var future__stageround_id_to_recall_memories_map
	
	# expects a func that accepts 1 param: is_past (bool)
	var func_source_for__empty_recall_type_panel_constr_param
	var func_name_for__empty_recall_type_panel_constr_param
	
	# expects a func that accepts 1 param: RecallMemory
	var func_source_for__convert_recall_memory_into_type_panel_constr_param
	var func_name_for__convert_recall_memory_into_type_panel_constr_param
	
	


var all_stageround_ids_with_action : Array

var past__stageround_id_to_recall_memories_map : Dictionary
var future__stageround_id_to_recall_memories_map : Dictionary

var func_source_for__empty_recall_type_panel_constr_param
var func_name_for__empty_recall_type_panel_constr_param

var func_source_for__convert_recall_memory_into_type_panel_constr_param
var func_name_for__convert_recall_memory_into_type_panel_constr_param


######

var reservation_for_whole_screen_gui

var game_elements
var stage_round_manager


#

var _converted_past__stageround_id_to_recall_type_panel_constr_param_map : Dictionary
var _converted_future__stageround_id_to_recall_type_panel_constr_param_map : Dictionary


var _stageround_id_to_mem_summ_stageround_column_map : Dictionary
var _leftmost_mem_summ_stageround_column : MemorySummaryStageRoundColumn

#####

func initialize_gui(arg_game_elements):
	game_elements = arg_game_elements
	stage_round_manager = game_elements.stage_round_manager
	
	
	_initialize_connection_with_stage_round_manager()
	_initialize_queue_reservation()

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	

##

func set_prop_based_on_constructor(arg_constr : ConstructorParams):
	all_stageround_ids_with_action = arg_constr.all_stageround_ids_with_action
	
	past__stageround_id_to_recall_memories_map = arg_constr.past__stageround_id_to_recall_memories_map
	future__stageround_id_to_recall_memories_map = arg_constr.future__stageround_id_to_recall_memories_map
	
	func_source_for__empty_recall_type_panel_constr_param = arg_constr.func_source_for__empty_recall_type_panel_constr_param
	func_name_for__empty_recall_type_panel_constr_param = arg_constr.func_name_for__empty_recall_type_panel_constr_param
	
	func_source_for__convert_recall_memory_into_type_panel_constr_param = arg_constr.func_source_for__convert_recall_memory_into_type_panel_constr_param
	func_name_for__convert_recall_memory_into_type_panel_constr_param = arg_constr.func_name_for__convert_recall_memory_into_type_panel_constr_param
	
	
	_initialize_converted_past_and_future_recall_mem_maps()


func _initialize_converted_past_and_future_recall_mem_maps():
	_convert_and_correct_recall_mem_map(past__stageround_id_to_recall_memories_map, _converted_past__stageround_id_to_recall_type_panel_constr_param_map, true)
	_convert_and_correct_recall_mem_map(future__stageround_id_to_recall_memories_map, _converted_future__stageround_id_to_recall_type_panel_constr_param_map, false)
	
	_build_mem_summary_stageround_columns()


# Right now, the purpose of this is to:
# 1) Convert RecallMemory into -> RecallTypePanelConstrParam
# 2) Convert null into -> RecallMemory with type: Empty (which means not decided yet) -> RecallTypePanelConstrParam. Primarily used for future map.
func _convert_and_correct_recall_mem_map(arg_map : Dictionary, arg_map_to_assign_to : Dictionary, arg_is_past : bool):
	for stageround_id in all_stageround_ids_with_action:
		var recall_mem = null
		var recall_type_panel_constr_param
		
		if arg_map.has(stageround_id):
			recall_mem = arg_map[stageround_id]
			recall_type_panel_constr_param = _convert_recall_mem_to_recall_type_panel_constr_param(recall_mem)
		
		if recall_mem == null:
			recall_type_panel_constr_param = _get_recall_mem_for_empty(arg_is_past)
		
		 
		arg_map_to_assign_to[stageround_id] = recall_type_panel_constr_param
	

func _convert_recall_mem_to_recall_type_panel_constr_param(arg_recall_mem):
	return func_source_for__convert_recall_memory_into_type_panel_constr_param.call(func_name_for__convert_recall_memory_into_type_panel_constr_param, arg_recall_mem)

func _get_recall_mem_for_empty(arg_is_past):
	return func_source_for__empty_recall_type_panel_constr_param.call(func_name_for__empty_recall_type_panel_constr_param, arg_is_past)




func _build_mem_summary_stageround_columns():
	var i = 0
	for stageround_id in _converted_past__stageround_id_to_recall_type_panel_constr_param_map.keys():
		i += 1
		var is_last_stageround_id = (i == _converted_past__stageround_id_to_recall_type_panel_constr_param_map.size())
		
		
		#
		var past_recall_type_constr_param = _converted_past__stageround_id_to_recall_type_panel_constr_param_map[stageround_id]
		var future_recall_type_constr_param = _converted_future__stageround_id_to_recall_type_panel_constr_param_map[stageround_id]
		
		
		var mem_summ_stageround_column = MemorySummaryStageRoundColumn_Scene.instance()
		mem_summary_stage_round_column_container.add_child(mem_summ_stageround_column)
		
		_stageround_id_to_mem_summ_stageround_column_map[stageround_id] = mem_summ_stageround_column
		
		var constr_param = MemorySummaryStageRoundColumn.ConstructorParams.new()
		constr_param.past_memory_type_recall_panel_constr_params = past_recall_type_constr_param
		constr_param.future_memory_type_recall_panel_constr_params = future_recall_type_constr_param
		
		constr_param.show_left_border = true
		constr_param.show_right_border = is_last_stageround_id
		constr_param.tooltip_owner = self
		
		constr_param.stageround_id_to_represent = stageround_id
		constr_param.stage_round_manager = stage_round_manager
		
		#mem_summ_stageround_column.set_prop_based_on_constructor(constr_param)
		call_deferred("_deferred_set_mem_summ_stageround_column_props", mem_summ_stageround_column, constr_param)
		
		
		
		if _leftmost_mem_summ_stageround_column == null:
			_leftmost_mem_summ_stageround_column = mem_summ_stageround_column
		
	
	call_deferred("_deferred_set_current_future_label_poses_based_on_leftmost_column")
	call_deferred("_deferred_update_stageround_col")

func _deferred_set_mem_summ_stageround_column_props(arg_column : MemorySummaryStageRoundColumn, arg_param : MemorySummaryStageRoundColumn.ConstructorParams):
	arg_column.set_prop_based_on_constructor(arg_param)


func _deferred_set_current_future_label_poses_based_on_leftmost_column():
	var icon_size = _leftmost_mem_summ_stageround_column.get_size_of_x_icon()
	
	var past_icon_pos = _leftmost_mem_summ_stageround_column.get_glob_position_of_past_icon()
	var future_icon_pos = _leftmost_mem_summ_stageround_column.get_glob_position_of_future_icon()
	
	var adjusted_past_pos__y = _get_y_pos__adjusted_to_center_label(past_icon_pos.y, label__curent, icon_size)
	var adjusted_future_pos__y = _get_y_pos__adjusted_to_center_label(future_icon_pos.y, label__future, icon_size)
	
	
	#label__curent.rect_global_position = Vector2(X_POS_OFFSET_FOR_LABEL, adjusted_past_pos__y)
	#label__future.rect_global_position = Vector2(X_POS_OFFSET_FOR_LABEL, adjusted_future_pos__y)
	
	label__curent.rect_position.x = X_POS_OFFSET_FOR_LABEL
	label__future.rect_position.x = X_POS_OFFSET_FOR_LABEL
	
	label__curent.rect_global_position.y = adjusted_past_pos__y
	label__future.rect_global_position.y = adjusted_future_pos__y
	

func _get_y_pos__adjusted_to_center_label(arg_y_pos : float, arg_label : Label, arg_icon_size : Vector2) -> float:
	return arg_y_pos - (arg_label.rect_size.y / 2.0) + (arg_icon_size.y / 2.0)


func _deferred_update_stageround_col():
	_update_stageround_column_based_on_curr_stageround(stage_round_manager.current_stageround.id)


#
### FOR outside use. 
### Should be used AFTER the setting of ConstrParams

func set_past_recall_memory__in_stage_round(arg_recall_mem, arg_stageround_id):
	var recall_type_panel_constr_param = _convert_recall_mem_to_recall_type_panel_constr_param(arg_recall_mem)
	_converted_past__stageround_id_to_recall_type_panel_constr_param_map[arg_stageround_id] = recall_type_panel_constr_param
	
	var mem_summ_stageround_column_of_stageround_id : MemorySummaryStageRoundColumn = _stageround_id_to_mem_summ_stageround_column_map[arg_stageround_id]
	mem_summ_stageround_column_of_stageround_id.set_past_memory_type_recall_panel_constr_params__and_update(recall_type_panel_constr_param)
	


func set_future_recall_memory__in_stage_round(arg_recall_mem, arg_stageround_id):
	var recall_type_panel_constr_param = _convert_recall_mem_to_recall_type_panel_constr_param(arg_recall_mem)
	_converted_future__stageround_id_to_recall_type_panel_constr_param_map[arg_stageround_id] = recall_type_panel_constr_param
	
	var mem_summ_stageround_column_of_stageround_id : MemorySummaryStageRoundColumn = _stageround_id_to_mem_summ_stageround_column_map[arg_stageround_id]
	mem_summ_stageround_column_of_stageround_id.set_future_memory_type_recall_panel_constr_params__and_update(recall_type_panel_constr_param)
	



#

func show_gui():
	game_elements.whole_screen_gui.queue_control(self, reservation_for_whole_screen_gui, true, ESCAPABLE_BY_ESC)
	

func hide_gui():
	game_elements.whole_screen_gui.hide_control(self)
	

#

func _initialize_connection_with_stage_round_manager():
	stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	#game_elements.connect("after_all_game_init_finished", self, "_on_after_all_game_init_finished", [], CONNECT_ONESHOT)
	

#func _on_after_all_game_init_finished():
#	_update_stageround_column_based_on_curr_stageround(stage_round_manager.current_stageround.id)


func _on_round_end(arg_stageround):
	var stageround_id = arg_stageround.id
	_update_stageround_column_based_on_curr_stageround(stageround_id)


func _update_stageround_column_based_on_curr_stageround(stageround_id):
	var to_glow_decided : bool = false
	var i : int = 0
	
	for mem_col_stageround_id in _stageround_id_to_mem_summ_stageround_column_map.keys():
		var mem_summ_stageround_col : MemorySummaryStageRoundColumn = _stageround_id_to_mem_summ_stageround_column_map[mem_col_stageround_id]
		i += 1
		var is_last = i == _stageround_id_to_mem_summ_stageround_column_map.size() 
		var is_first = i == 1
		
		var compare_result = StageRound.compare_stage_round__param_to_second_param(mem_col_stageround_id, stageround_id)
		if compare_result == 1:
			
			if !to_glow_decided:
				to_glow_decided = true
				mem_summ_stageround_col.show_left_border__make_others_invis()
			
		elif compare_result == 0:
			
			if !to_glow_decided:
				to_glow_decided = true
				mem_summ_stageround_col.show_background__make_others_invis()
				
			
		elif compare_result == -1:
			
			if is_last and !to_glow_decided:
				to_glow_decided = true
				mem_summ_stageround_col.show_right_border__make_others_invis()
				
			else:
				mem_summ_stageround_col.show_nothing_and_make_all_invis()
			
		


