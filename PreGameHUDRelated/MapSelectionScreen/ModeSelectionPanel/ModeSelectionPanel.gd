extends MarginContainer

const PlayerGUI_ButtonToggleStandard = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/PlayerGUI_ButtonToggleStandard.gd")
const PlayerGUI_ButtonToggleStandard_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/PlayerGUI_ButtonToggleStandard.tscn")

const ButtonGroup_Custom = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/ButtonGroup.gd")
const ModeTypeInformation = preload("res://GameplayRelated/GameModeRelated/GameModeTypeInformation.gd")
const MapTypeInformation = preload("res://MapsRelated/MapTypeInformation.gd")


signal current_mode_selected_changed(arg_mode_id)

onready var button_container = $ContentContainer/ButtonContainer

var mode_id_to_button_map : Dictionary = {}
var button_group_for_mode : ButtonGroup_Custom

var current_mode_selected : int = -1 # no mode


func _ready():
	button_group_for_mode = ButtonGroup_Custom.new()
	_initialize_all_mode_buttons()
	

func _initialize_all_mode_buttons():
	for mode_id in StoreOfGameMode.Mode.values():
		var mode_type_info : ModeTypeInformation = StoreOfGameMode.get_mode_type_info_from_id(mode_id)
		
		var button = PlayerGUI_ButtonToggleStandard_Scene.instance()
		button.set_text_for_text_label(mode_type_info.mode_name)
		button.visible = true
		button.configure_self_with_button_group(button_group_for_mode)
		button.connect("toggle_mode_changed", self, "_on_mode_button_toggle_mode_changed", [button, mode_id])
		
		button_container.add_child(button)
		
		mode_id_to_button_map[mode_id] = button

#

func set_map_id_to_display_modes_for(arg_map_id):
	var map_type_info : MapTypeInformation = StoreOfMaps.get_map_type_information_from_id(arg_map_id)
	var disabled_current : bool = false
	
	for mode_id in StoreOfGameMode.Mode.values():
		var mode_enabled_in_map : bool = map_type_info.game_mode_ids_accessible_from_menu.has(mode_id)
		
		var button : PlayerGUI_ButtonToggleStandard = mode_id_to_button_map[mode_id]
		button.visible = mode_enabled_in_map
		
		if !mode_enabled_in_map and button.is_toggle_mode_on:
			button.set_is_toggle_mode_on(false)
			disabled_current = true
	
	if disabled_current:
		set_first_visible_mode_toggle_button_to_on()


func set_first_visible_mode_toggle_button_to_on():
	for button in mode_id_to_button_map.values():
		if button.visible:
			button.set_is_toggle_mode_on(true)
			return
	
	current_mode_selected = -1

#

func _on_mode_button_toggle_mode_changed(arg_val, arg_button : PlayerGUI_ButtonToggleStandard, arg_mode_id : int):
	if arg_button.is_toggle_mode_on:
		current_mode_selected = arg_mode_id
		emit_signal("current_mode_selected_changed", current_mode_selected)
		
	elif !arg_button.is_toggle_mode_on and current_mode_selected == arg_mode_id:
		current_mode_selected = -1
		emit_signal("current_mode_selected_changed", current_mode_selected)


