extends Control

const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")


const ESCAPABLE_BY_ESC : bool = false


###

class ConstructorParams:
	
	var memory_type_recall_panel_constr_params
	
	var is_sac_made_prev_in_curr_round : bool
	
	var on_accept_func_source
	var on_accept_func_name
	var on_accept_func_params
	
	var on_decline_func_source
	var on_decline_func_name
	var on_decline_func_params
	


var memory_type_recall_panel_constr_params

var is_sac_made_prev_in_curr_round : bool

var on_accept_func_source
var on_accept_func_name
var on_accept_func_params

var on_decline_func_source
var on_decline_func_name
var on_decline_func_params

###

var reservation_for_whole_screen_gui

var game_elements

###

onready var memory_recall_type_panel = $MainContainer/VBoxContainer/MainContainer/HBoxContainer/MemoryRecallPanel
onready var sacrificed_already_label = $MainContainer/VBoxContainer/DecisionContainer/VBoxContainer/SacrificedAlreadyLabel
onready var no_sac_in_round_label = $MainContainer/VBoxContainer/DecisionContainer/VBoxContainer/NoSacInRoundLabel

###

func initialize_gui(arg_game_elements):
	game_elements = arg_game_elements
	
	_initialize_queue_reservation()

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	

#

func show_gui():
	game_elements.whole_screen_gui.queue_control(self, reservation_for_whole_screen_gui, true, ESCAPABLE_BY_ESC)
	

func hide_gui():
	game_elements.whole_screen_gui.hide_control(self)
	

#######

func set_prop_based_on_constructor(arg_const : ConstructorParams):
	memory_type_recall_panel_constr_params = arg_const.memory_type_recall_panel_constr_params
	
	is_sac_made_prev_in_curr_round = arg_const.is_sac_made_prev_in_curr_round
	
	###
	
	on_accept_func_source = arg_const.on_accept_func_source
	on_accept_func_name = arg_const.on_accept_func_name
	on_accept_func_params = arg_const.on_accept_func_params
	
	on_decline_func_source = arg_const.on_decline_func_source
	on_decline_func_name = arg_const.on_decline_func_name
	on_decline_func_params = arg_const.on_decline_func_params
	
	
	if is_inside_tree():
		update_display_and_configs()
	


#

func _ready():
	update_display_and_configs()
	


func update_display_and_configs():
	if memory_type_recall_panel_constr_params != null:
		memory_recall_type_panel.set_prop_based_on_constructor(memory_type_recall_panel_constr_params)
	
	sacrificed_already_label.visible = is_sac_made_prev_in_curr_round
	no_sac_in_round_label.visible = !is_sac_made_prev_in_curr_round

#######

func _on_AcceptButton_on_button_released_with_button_left():
	if on_accept_func_source != null:
		on_accept_func_source.call(on_accept_func_name, on_accept_func_params)


func _on_DeclineButton_on_button_released_with_button_left():
	if on_decline_func_source != null:
		on_decline_func_source.call(on_decline_func_name, on_decline_func_params)


