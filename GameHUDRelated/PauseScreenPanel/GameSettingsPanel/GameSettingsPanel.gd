extends MarginContainer


var game_settings_manager
var main_pause_screen_panel
var hub_pause_panel

onready var desc_mode__description_panel = $VBoxContainer/ContentMargin/ScrollContainer/VBoxContainer/HBoxContainer/DescModeDescriptionPanel
onready var desc_mode__selection_panel = $VBoxContainer/ContentMargin/ScrollContainer/VBoxContainer/HBoxContainer/DescModeSelectionPanel

onready var tower_drag_mode__description_panel = $VBoxContainer/ContentMargin/ScrollContainer/VBoxContainer/HBoxContainer2/TowerDragModeDescriptionPanel
onready var tower_drag_mode__selection_panel = $VBoxContainer/ContentMargin/ScrollContainer/VBoxContainer/HBoxContainer2/TowerDragModeSelectionPanel


func _ready():
	game_settings_manager = GameSettingsManager
	
	# DESC MODE
	_initialize_desc_mode__selection_panel()
	
	# TOWER DRAG MODE
	_initialize_tower_drag_mode__selection_panel()
	
	#
	
	
	# keep at bottom for consistency/visibility
	
	set_process_unhandled_key_input(false)
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST)
	

###### DESC MODE

func _initialize_desc_mode__selection_panel():
	for mode_id in game_settings_manager.descriptions_mode_to_name.keys():
		desc_mode__selection_panel.set_or_add_entry(mode_id, game_settings_manager.descriptions_mode_to_name[mode_id])


func _on_desc_mode_changed(arg_new_val):
	_update_desc_mode_panels()

func _update_desc_mode_panels():
	var curr_desc_mode = game_settings_manager.descriptions_mode
	
	var descs = _get_desc_mode_descriptions(curr_desc_mode)
	desc_mode__description_panel.descriptions = descs
	desc_mode__description_panel.update_display()
	
	desc_mode__selection_panel.set_current_index_based_on_id(curr_desc_mode, false)


func _get_desc_mode_descriptions(arg_curr_desc_mode):
	var expl = game_settings_manager.descriptions_mode_to_explanation[arg_curr_desc_mode]
	
	var base_desc = [
		"%s:" % GameSettingsManager.description_mode_name_identifier,
		"",
	]
	
	for desc in expl:
		base_desc.append(desc)
	
	return base_desc

func _on_DescModeSelectionPanel_on_current_index_changed(arg_index):
	var mode_in_index = desc_mode__selection_panel.get_id_at_current_index()
	game_settings_manager.descriptions_mode = mode_in_index


##### TOWER DRAG MODE


func _initialize_tower_drag_mode__selection_panel():
	for mode_id in game_settings_manager.tower_drag_mode_to_name.keys():
		tower_drag_mode__selection_panel.set_or_add_entry(mode_id, game_settings_manager.tower_drag_mode_to_name[mode_id])


func _on_tower_drag_mode_changed(arg_new_val):
	_update_tower_drag_mode_panels()

func _update_tower_drag_mode_panels():
	var curr_tower_drag_mode = game_settings_manager.tower_drag_mode
	
	var descs = _get_tower_drag_mode_descriptions(curr_tower_drag_mode)
	tower_drag_mode__description_panel.descriptions = descs
	tower_drag_mode__description_panel.update_display()
	
	tower_drag_mode__selection_panel.set_current_index_based_on_id(curr_tower_drag_mode, false)


func _get_tower_drag_mode_descriptions(arg_curr_mode):
	var expl = game_settings_manager.tower_drag_mode_to_explanation[arg_curr_mode]
	
	var base_desc = [
		"%s:" % GameSettingsManager.tower_drag_mode_name_identifier,
		"",
	]
	
	for desc in expl:
		base_desc.append(desc)
	
	return base_desc



func _on_TowerDragModeSelectionPanel_on_current_index_changed(arg_index):
	var mode_in_index = tower_drag_mode__selection_panel.get_id_at_current_index()
	game_settings_manager.tower_drag_mode = mode_in_index




#############



#

func _on_visibility_changed():
	set_process_unhandled_key_input(visible)
	
	if visible:
		# DESC MODE
		if !game_settings_manager.is_connected("on_descriptions_mode_changed", self, "_on_desc_mode_changed"):
			game_settings_manager.connect("on_descriptions_mode_changed", self, "_on_desc_mode_changed", [], CONNECT_PERSIST)
			game_settings_manager.connect("on_tower_drag_mode_changed", self, "_on_tower_drag_mode_changed", [], CONNECT_PERSIST)
		
		_update_desc_mode_panels()
		_update_tower_drag_mode_panels()
		
	else:
		# DESC MODE
		if game_settings_manager.is_connected("on_descriptions_mode_changed", self, "_on_desc_mode_changed"):
			game_settings_manager.disconnect("on_descriptions_mode_changed", self, "_on_desc_mode_changed")
			game_settings_manager.disconnect("on_tower_drag_mode_changed", self, "_on_tower_drag_mode_changed")
		

func _unhandled_key_input(event : InputEventKey):
	if !event.echo and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			
			_on_exit_panel()
	
	
	accept_event()

#

func _on_exit_panel():
	GameSaveManager.save_game_settings__of_settings_manager()
	main_pause_screen_panel.show_control_at_content_panel(hub_pause_panel)

