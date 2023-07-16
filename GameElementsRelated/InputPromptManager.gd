extends Node

const SelectionNotifPanel = preload("res://GameHUDRelated/NotificationPanel/SelectionNotifPanel/SelectionNotifPanel.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
#const SizeAdaptingAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/SizeAdaptingAttackSprite.gd")
#const SizeAdaptingAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/SizeAdaptingAttackSprite.tscn")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const IMSelectionParticle = preload("res://GameElementsRelated/InputManagerRelated/SelectionParticles/IMSelectionParticle.gd")
const IMSelectionParticle_Scene = preload("res://GameElementsRelated/InputManagerRelated/SelectionParticles/IMSelectionParticle.tscn")

const YesNoDialogWholeScreenPanel = preload("res://GameHUDRelated/InputManagerRelated/YesNoDialogWholeScreenPanel/YesNoDialogWholeScreenPanel.gd")
const YesNoDialogWholeScreenPanel_Scene = preload("res://GameHUDRelated/InputManagerRelated/YesNoDialogWholeScreenPanel/YesNoDialogWholeScreenPanel.tscn")
const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")


#

signal prompted_for_tower_selection(prompter, prompt_predicate_method)

signal cancelled_tower_selection()
signal tower_selection_ended()
signal tower_selected(tower)


signal cancelled_multiple_tower_selection(arg_towers)
signal tower_selected__from_multiple_tower_select(tower, current_selected_towers)
signal tower_unselected__from_multiple_tower_select(tower, current_selected_towers)

signal finished_tower_selected_from_multiple_select(towers_selected)


##

#const notif_message_select_single_tower : String = "Select a tower"
var notif_message_select_single_tower
var notif_message_select_multiple_towers__1st_line

const notif_message_select_single_tower__panel_width = 350.0
const notif_message_select_multiple_towers__panel_width = 350.0

############

enum SelectionMode {
	NONE = -10,
	
	TOWER = 1,
	MULTIPLE_TOWERS = 2,
	
	YES_NO = 3
}

var current_selection_mode : int = SelectionMode.NONE
var selection_notif_panel : SelectionNotifPanel

var _current_prompter : Object
var _current_prompt_tower_checker_predicate_name : String

var _prompt_successful_method_handler : String
var _prompt_cancelled_method_handler : String

var _multiple_tower_selection__can_end_selection_via_enter : bool

# additional lines being: [ [string, [ins]], ... (same), ... ]
# can be used to convey reason for selecting
var _selection_panel__additional_lines : Array  # provided by source

var _current_selection_notif_desc_used : Array  # generated at first show (once). this is here for further editing if needed


# multiple towers select specifics
var _current_towers_selected_from_multiple_select : Array
var _min_select_count : int
var _max_select_count : int


var _min_max_selection_notif_panel_desc_index : int   # keeping track of index for changing purposes

var _tower_to_IM_particle_map : Dictionary

class MultipleTowerSelectionAdvParam:
	var min_select_count : int
	var max_select_count : int
	

#

var _IM_selection_particle_component_pool : AttackSpritePoolComponent


#

var reservation_for_whole_screen_gui
var yes_no_dialog_whole_screen_panel : YesNoDialogWholeScreenPanel


#

var game_elements setget set_game_elements

#

func set_game_elements(arg_game_elements):
	game_elements = arg_game_elements
	
	game_elements.connect("before_game_start", self, "_on_before_game_start")


func _on_before_game_start():
	_initialize_yes_no_whole_screen_panel()
	

#

func _init():
	_initialize_notif_panel_messeges()
	

func _initialize_notif_panel_messeges():
	var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Tower")
	notif_message_select_single_tower = [
		["Select a |0|", [plain_fragment__tower]]
	]
	
	var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Towers")
	notif_message_select_multiple_towers__1st_line = [
		["Select |0|", [plain_fragment__towers]]
	]

#

func _ready():
	_initialize_all_particle_compo_pools()
	

func _initialize_all_particle_compo_pools():
	_IM_selection_particle_component_pool = AttackSpritePoolComponent.new()
	_IM_selection_particle_component_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	_IM_selection_particle_component_pool.node_to_listen_for_queue_free = self
	_IM_selection_particle_component_pool.source_for_funcs_for_attk_sprite = self
	_IM_selection_particle_component_pool.func_name_for_creating_attack_sprite = "_create_IM_selection_particle"
	_IM_selection_particle_component_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_up_IM_selection_particle"

func _create_IM_selection_particle():
	var particle = IMSelectionParticle_Scene.instance() #SizeAdaptingAttackSprite_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	particle.stop_process_at_invisible = true
	
	particle.modulate.a = 0.65
	
	particle.has_lifetime = false
	particle.lifetime = 1.0
	
	particle.set_anim_to__circle()
	
	particle.adapt_ratio = 1.2
	
	particle.modulate_x = Color(1, 1, 1)
	particle.modulate_y = Color(233/255.0, 255/255.0, 0/255.0)
	
	return particle

func _set_up_IM_selection_particle(particle):
	pass
	#particle.set_anim_to__circle()


# Prompt select tower related

func prompt_select_tower(prompter, arg_prompt_successful_method_handler : String, arg_prompt_cancelled_method_handler : String, arg_prompt_tower_checker_predicate_name : String = ""):
	if can_prompt():
		current_selection_mode = SelectionMode.TOWER
		_prompt_successful_method_handler = arg_prompt_successful_method_handler
		_prompt_cancelled_method_handler = arg_prompt_cancelled_method_handler
		
		_current_prompter = prompter
		_current_prompt_tower_checker_predicate_name = arg_prompt_tower_checker_predicate_name
		
		_establish_signals_for_discontinue_prompt_if_current_prompter_is_exiting__or_other_conditions()
		
		emit_signal("prompted_for_tower_selection", prompter, arg_prompt_tower_checker_predicate_name)
		_show_selection_notif_panel__for_single_tower_selection()

func _establish_signals_for_discontinue_prompt_if_current_prompter_is_exiting__or_other_conditions():
	if is_instance_valid(_current_prompter) and _current_prompter != null:
		_current_prompter.connect("tree_exiting", self, "cancel_selection")
		
		if _current_prompter is AbstractTower:
			_current_prompter.connect("tower_not_in_active_map", self, "cancel_selection")
	



func tower_selected_from_prompt(tower):
	if current_selection_mode == SelectionMode.TOWER:
		_tower_selected_from_prompt__for_single(tower)
		
	elif current_selection_mode == SelectionMode.MULTIPLE_TOWERS:
		_tower_selected_from_prompt__for_multiple(tower)
		
	


func _tower_selected_from_prompt__for_single(tower):
	emit_signal("tower_selected", tower)
	_current_prompter.call_deferred(_prompt_successful_method_handler, tower)
	
	clean_up_selection()


################################

func prompt_select_multiple_towers(arg_adv_param : MultipleTowerSelectionAdvParam, prompter, arg_prompt_successful_method_handler : String, arg_prompt_cancelled_method_handler : String, arg_prompt_tower_checker_predicate_name : String = "", arg_selection_panel__additional_lines : Array = []):
	if can_prompt():
		current_selection_mode = SelectionMode.MULTIPLE_TOWERS
		_prompt_successful_method_handler = arg_prompt_successful_method_handler
		_prompt_cancelled_method_handler = arg_prompt_cancelled_method_handler
		
		_current_prompter = prompter
		_current_prompt_tower_checker_predicate_name = arg_prompt_tower_checker_predicate_name
		
		_selection_panel__additional_lines = arg_selection_panel__additional_lines
		
		_current_towers_selected_from_multiple_select.clear()
		_max_select_count = arg_adv_param.max_select_count
		_min_select_count = arg_adv_param.min_select_count
		
		_establish_signals_for_discontinue_prompt_if_current_prompter_is_exiting__or_other_conditions()
		
		emit_signal("prompted_for_tower_selection", prompter, arg_prompt_tower_checker_predicate_name)
		#_show_selection_notif_panel__for_single_tower_selection()
		_show_selection_notif_panel__for_multiple_tower_selection()
		
		_update_properties_and_actions_based_on_selected_tower_count()

func _tower_selected_from_prompt__for_multiple(tower):
	if !_current_towers_selected_from_multiple_select.has(tower):
		_add_tower_to_multiple_selection_list(tower)
	else:
		_remove_tower_from_multiple_selection_list(tower)



func _add_tower_to_multiple_selection_list(tower):
	var current_tower_count = _current_towers_selected_from_multiple_select.size()
	
	if current_tower_count < _max_select_count:
		_current_towers_selected_from_multiple_select.append(tower)
		
		emit_signal("tower_selected__from_multiple_tower_select", tower)
		
		if !tower.is_connected("tree_exiting", self, "_on_tower_queued_free"):
			tower.connect("tree_exiting", self, "_on_tower_queued_free", [tower])
		
		
		#put IMparticle on tower
		if !_tower_to_IM_particle_map.has(tower):
			var particle = _IM_selection_particle_component_pool.get_or_create_attack_sprite_from_pool()
			
			_tower_to_IM_particle_map[tower] = particle
			particle.follow_and_config_to_tower(tower)
			particle.start_loop_tween_between_mod_a_and_b()
			particle.visible = true
		
		_update_properties_and_actions_based_on_selected_tower_count()

func _remove_tower_from_multiple_selection_list(tower):
	_current_towers_selected_from_multiple_select.erase(tower)
	emit_signal("tower_unselected__from_multiple_tower_select", tower)
	
	if tower.is_connected("tree_exiting", self, "_on_tower_queued_free"):
		tower.disconnect("tree_exiting", self, "_on_tower_queued_free")
	
	# remove particle
	if _tower_to_IM_particle_map.has(tower):
		var particle = _tower_to_IM_particle_map[tower]
		
		_tower_to_IM_particle_map.erase(tower)
		if is_instance_valid(particle):
			particle.turn_invisible_from_simulated_lifetime_end()
	
	_update_properties_and_actions_based_on_selected_tower_count()

func _on_tower_queued_free(arg_tower):
	_remove_tower_from_multiple_selection_list(arg_tower)


# called when: at first, adding, or removing
func _update_properties_and_actions_based_on_selected_tower_count():
	var current_tower_count = _current_towers_selected_from_multiple_select.size()
	
	_multiple_tower_selection__can_end_selection_via_enter = false
	
	if current_tower_count >= _max_select_count:  # auto end selection since max is reached
		_lock_in_and_end_multiple_tower_selection()
		
	elif current_tower_count >= _min_select_count:   # show option for ENTER 
		_multiple_tower_selection__can_end_selection_via_enter = true
		
	else:
		_multiple_tower_selection__can_end_selection_via_enter = false
		
	
	_update_selection_notif_panel__for_multiple_tower_seleciton()


#

func can_lock_in_and_end_multiple_tower_selection_via_enter():
	return _multiple_tower_selection__can_end_selection_via_enter

func lock_in_and_end_multiple_tower_selection__from_game_elements():
	_lock_in_and_end_multiple_tower_selection()

func _lock_in_and_end_multiple_tower_selection():
	var selected_towers = _current_towers_selected_from_multiple_select.duplicate()
	
	emit_signal("finished_tower_selected_from_multiple_select", selected_towers)
	_current_prompter.call_deferred(_prompt_successful_method_handler, selected_towers)
	
	clean_up_selection()


# General stuffs

func cancel_selection(emit_cancel_selection : bool = true):
	if emit_cancel_selection:
		
		if current_selection_mode == SelectionMode.TOWER:
			emit_signal("cancelled_tower_selection")
		elif current_selection_mode == SelectionMode.MULTIPLE_TOWERS:
			var selected_towers = _current_towers_selected_from_multiple_select.duplicate()
			emit_signal("cancelled_multiple_tower_selection", selected_towers)
		elif current_selection_mode == SelectionMode.YES_NO:
			pass
			
		
	
	if  current_selection_mode == SelectionMode.TOWER:
		pass
	elif current_selection_mode == SelectionMode.MULTIPLE_TOWERS:
		_multiple_tower_selection__can_end_selection_via_enter = false
		_current_towers_selected_from_multiple_select.clear()
	elif current_selection_mode == SelectionMode.YES_NO:
		pass
		
	
	if _current_prompter != null and _current_prompter.has_method(_prompt_cancelled_method_handler):
		_current_prompter.call_deferred(_prompt_cancelled_method_handler)
	
	clean_up_selection()


func clean_up_selection():
	if current_selection_mode == SelectionMode.TOWER or current_selection_mode == SelectionMode.MULTIPLE_TOWERS:
		current_selection_mode = SelectionMode.NONE
		
		_disconnect_established_signals_for_discontinue_prompt_if_current_prompter_is_exiting__or_other_conditions()
		
		_current_prompter = null
		_prompt_cancelled_method_handler = ""
		_prompt_successful_method_handler = ""
		_current_prompt_tower_checker_predicate_name = ""
		
		emit_signal("tower_selection_ended")
		
		_hide_selection_notif_panel()
		
		for particle in _tower_to_IM_particle_map.values():
			particle.turn_invisible_from_simulated_lifetime_end()
		_tower_to_IM_particle_map.clear()
		
	elif current_selection_mode == SelectionMode.YES_NO:
		current_selection_mode = SelectionMode.NONE
		
		_disconnect_established_signals_for_discontinue_prompt_if_current_prompter_is_exiting__or_other_conditions()
		
		_current_prompter = null
		_prompt_cancelled_method_handler = ""
		
		if game_elements.whole_screen_gui.is_currently_showing_control_equal_to(yes_no_dialog_whole_screen_panel):
			game_elements.whole_screen_gui.hide_control(yes_no_dialog_whole_screen_panel)

func _disconnect_established_signals_for_discontinue_prompt_if_current_prompter_is_exiting__or_other_conditions():
	if is_instance_valid(_current_prompter) and _current_prompter != null:
		_current_prompter.disconnect("tree_exiting", self, "cancel_selection")
		
		if _current_prompter is AbstractTower:
			_current_prompter.disconnect("tower_not_in_active_map", self, "cancel_selection")



func is_current_promter_arg(arg) -> bool:
	return _current_prompter == arg


# selection notif panel related

func _hide_selection_notif_panel():
	selection_notif_panel.visible = false


func _show_selection_notif_panel__for_single_tower_selection():
	var message = notif_message_select_single_tower
	
	selection_notif_panel.visible = true
	selection_notif_panel.show_notif_tooltip_body_with_msg(message, _multiple_tower_selection__can_end_selection_via_enter, notif_message_select_single_tower__panel_width)


# additional lines being: [ [string, [ins]], ... (same), ... ]
func _show_selection_notif_panel__for_multiple_tower_selection():
	var message = notif_message_select_multiple_towers__1st_line.duplicate()
	for line in _selection_panel__additional_lines:
		message.append(line)
	
	
	#
	
	message.append("")
	
	_set_count_msg_line__for_multiple_tower_selection(message)
	
	_current_selection_notif_desc_used = message
	
	#
	
	selection_notif_panel.visible = true
	selection_notif_panel.show_notif_tooltip_body_with_msg(message, _multiple_tower_selection__can_end_selection_via_enter, notif_message_select_multiple_towers__panel_width)

func _update_selection_notif_panel__for_multiple_tower_seleciton():
	var message = _current_selection_notif_desc_used.duplicate()
	
	_set_count_msg_line__for_multiple_tower_selection(message, _min_max_selection_notif_panel_desc_index)
	
	selection_notif_panel.show_notif_tooltip_body_with_msg(message, _multiple_tower_selection__can_end_selection_via_enter, notif_message_select_multiple_towers__panel_width)


func _set_count_msg_line__for_multiple_tower_selection(arg_original_msg : Array, arg_index_to_insert : int = -1):
	var index = arg_index_to_insert
	var is_insert : bool = false
	if arg_index_to_insert == -1:
		index = arg_original_msg.size()
		is_insert = true
	
	if _max_select_count > 0:
		var msg_line = ["Selected: %s / %s" % [_current_towers_selected_from_multiple_select.size(), _max_select_count], []]
		if is_insert:
			arg_original_msg.insert(index, msg_line)
		else:
			arg_original_msg[index] = msg_line
		_min_max_selection_notif_panel_desc_index = index
		
	elif _min_select_count > 0:
		var msg_line = ["Selected: %s. Minimum of %s." % [_current_towers_selected_from_multiple_select.size(), _min_select_count], []]
		if is_insert:
			arg_original_msg.insert(index, msg_line)
		else:
			arg_original_msg[index] = msg_line
		_min_max_selection_notif_panel_desc_index = index
		
	

##################

func _initialize_yes_no_whole_screen_panel():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	
	##
	
	yes_no_dialog_whole_screen_panel = YesNoDialogWholeScreenPanel_Scene.instance()
	yes_no_dialog_whole_screen_panel.visible = false
	game_elements.whole_screen_gui.add_control_but_dont_show(yes_no_dialog_whole_screen_panel)
	
	yes_no_dialog_whole_screen_panel.connect("option_chosen", self, "_on_yes_no_dialog__option_chosen", [], CONNECT_PERSIST)
	yes_no_dialog_whole_screen_panel.connect("escaped_via_ESC", self, "_on_yes_no_dialog__escaped_via_esc", [], CONNECT_PERSIST)
#	yes_no_dialog_whole_screen_panel.connect("visibility_set_to_false", self, "_on_yes_no_dialog__visibility_set_to_false", [], CONNECT_PERSIST)

func prompt_yes_no_dialog(arg_prompter, arg_prompt_cancelled_method_handler, 
		desc_to_use : Array, func_source_on_select : Object,
		func_name_for_selection_yes : String, func_name_for_selection_no : String,
		arg_is_escapable):
	
	if can_prompt():
		current_selection_mode = SelectionMode.YES_NO
		_current_prompter = arg_prompter
		_prompt_cancelled_method_handler = arg_prompt_cancelled_method_handler
		
		yes_no_dialog_whole_screen_panel.set_descriptions_to_use(desc_to_use)
		yes_no_dialog_whole_screen_panel.func_source__on_select_option = func_source_on_select
		yes_no_dialog_whole_screen_panel.func_name__on_select_yes = func_name_for_selection_yes
		yes_no_dialog_whole_screen_panel.func_name__on_select_no = func_name_for_selection_no
		
		game_elements.whole_screen_gui.queue_control(yes_no_dialog_whole_screen_panel, reservation_for_whole_screen_gui, true, arg_is_escapable)
		
		_establish_signals_for_discontinue_prompt_if_current_prompter_is_exiting__or_other_conditions()
		


func _on_yes_no_dialog__option_chosen(arg_option : int):
	clean_up_selection()

func _on_yes_no_dialog__escaped_via_esc():
	clean_up_selection()

#func _on_yes_no_dialog__visibility_set_to_false():
#	clean_up_selection()


#######################

func is_in_tower_selection_mode() -> bool:
	return current_selection_mode == SelectionMode.TOWER or current_selection_mode == SelectionMode.MULTIPLE_TOWERS 


func is_in_selection_mode() -> bool:
	return current_selection_mode != SelectionMode.NONE


func can_prompt() -> bool:
	return current_selection_mode == SelectionMode.NONE

#

