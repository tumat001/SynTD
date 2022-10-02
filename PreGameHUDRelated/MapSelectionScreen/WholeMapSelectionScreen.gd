extends MarginContainer


onready var map_selection_panel = $VBoxContainer/MapSelectionPanel

#onready var mode_selection_panel = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/ModeSelectionPanel

onready var mode_description_panel = $VBoxContainer/MarginContainer/HBoxContainer2/GameModeDescPanel
onready var mode_selection_panel_v2 = $VBoxContainer/MarginContainer/HBoxContainer2/ModeSelectionPanelV2

#onready var map_summary_panel = $VBoxContainer/MarginContainer/HBoxContainer/MapSummaryPanel
onready var start_button = $VBoxContainer/MarginContainer/HBoxContainer/MapSelection_StartButton

onready var container_for_select_list = $ContainerForSelectLists


var pre_game_screen

var current_map_type_info_selected
var current_mode_type_info_selected

func _ready():
	map_selection_panel.add_map_ids_to_list(StoreOfMaps.MapIdsAvailableFromMenu)
	map_selection_panel.connect("on_current_selected_map_id_changed", self, "_on_current_selected_map_id_changed")
	
	#mode_selection_panel.connect("current_mode_selected_changed", self, "_on_current_selected_mode_changed")
	mode_selection_panel_v2.connect("current_selected_game_mode_changed", self, "_on_current_selected_mode_changed")
	mode_selection_panel_v2.node_to_add_selection_list_to = container_for_select_list
	
	start_button.connect("play_button_released", self, "_on_play_button_pressed")
	
	#
	#map_selection_panel.select_first_visible_map_card()
	#mode_selection_panel_v2.set_first_valid_mode()
	
	GameSaveManager.load_map_selection_defaults__of_settings_manager()
	
	#map_selection_panel.set_current_map_id_selected(GameSettingsManager.last_chosen_map_id)
	map_selection_panel.select_map_card_with_id(GameSettingsManager.last_chosen_map_id)
	mode_selection_panel_v2.set_active_mode_using_game_settings_params()
	
	#
	connect("visibility_changed", self, "_on_visibility_changed")
	_on_visibility_changed()
	
	

func _on_visibility_changed():
	set_process_unhandled_key_input(visible)


func _on_current_selected_map_id_changed(arg_map_id):
	var map_type_info = StoreOfMaps.get_map_type_information_from_id(arg_map_id)
	
	current_map_type_info_selected = map_type_info
	
	if map_type_info != null:
		#map_summary_panel.set_map_name(map_type_info.map_name)
		mode_selection_panel_v2.set_map_id_to_display_modes_for(map_type_info.map_id)
		mode_selection_panel_v2.visible = true
	else:
		#map_summary_panel.set_map_name("")
		mode_selection_panel_v2.visible = true
	
	start_button.set_is_enabled(_if_all_game_starting_requirements_set())


func _if_all_game_starting_requirements_set() -> bool:
	return current_map_type_info_selected != null and current_mode_type_info_selected != null

#

func _on_current_selected_mode_changed(arg_mode_id):
	var mode_type_info = StoreOfGameMode.get_mode_type_info_from_id(arg_mode_id)
	
	if mode_type_info != null:
		#map_summary_panel.set_difficulty_name(mode_type_info.mode_name)
		mode_description_panel.set_descriptions(mode_type_info.mode_descriptions)
	else:
		#map_summary_panel.set_difficulty_name("")
		mode_description_panel.set_descriptions([])
	
	#
	
	current_mode_type_info_selected = mode_type_info
	
	start_button.set_is_enabled(_if_all_game_starting_requirements_set())

#

func _on_play_button_pressed():
	if _if_all_game_starting_requirements_set():
		GameSettingsManager.last_chosen_map_id = current_map_type_info_selected.map_id
		GameSettingsManager.map_id_to_last_chosen_mode_id_map[current_map_type_info_selected.map_id] = current_mode_type_info_selected.mode_id
		GameSaveManager.save_map_selection_defaults__of_settings_manager()
		
		CommsForBetweenScenes.map_id = current_map_type_info_selected.map_id
		CommsForBetweenScenes.game_mode_id = current_mode_type_info_selected.mode_id
		
		CommsForBetweenScenes.goto_game_elements(pre_game_screen)



#

func _unhandled_key_input(event : InputEventKey):
	if !event.echo and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			_exit_to_previous()
	
	accept_event()



func _exit_to_previous():
	pre_game_screen.hide_or_remove_latest_from_node_tree__except_for_starting_screen()

