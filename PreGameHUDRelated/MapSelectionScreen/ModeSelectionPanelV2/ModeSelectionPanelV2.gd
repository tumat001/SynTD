extends MarginContainer


const ModeSelectionPanel_Background_NormalPic = preload("res://PreGameHUDRelated/MapSelectionScreen/ModeSelectionPanelV2/Assets/ModeSelectionPanelV2_Background_Normal.png")
const ModeSelectionPanel_Background_HighlightedPic = preload("res://PreGameHUDRelated/MapSelectionScreen/ModeSelectionPanelV2/Assets/ModeSelectionPanelV2_Background_Highlighted.png")

const SelectionListStandard = preload("res://MiscRelated/PlayerGUI_Category_Related/SelectionListStandard/SelectionListStandard.gd")
const SelectionListStandard_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/SelectionListStandard/SelectionListStandard.tscn")
const GameModeTypeInformation = preload("res://GameplayRelated/GameModeRelated/GameModeTypeInformation.gd")
const GameModeButton = preload("res://PreGameHUDRelated/MapSelectionScreen/ModeSelectionPanelV2/Subs/ModeButton/GameModeButton.gd")
const GameModeButton_Scene = preload("res://PreGameHUDRelated/MapSelectionScreen/ModeSelectionPanelV2/Subs/ModeButton/GameModeButton.tscn")
const MapTypeInformation = preload("res://MapsRelated/MapTypeInformation.gd")

signal current_selected_game_mode_changed(arg_mode_id)


onready var border_header_left = $VBoxContainer/Header/Left
onready var border_header_right = $VBoxContainer/Header/Right
onready var border_header_top = $VBoxContainer/Header/Top
onready var border_header_bottom = $VBoxContainer/Header/Bottom
onready var border_content_left = $VBoxContainer/Content/Left
onready var border_content_right = $VBoxContainer/Content/Right
onready var border_content_bottom = $VBoxContainer/Content/Bottom

onready var background_header = $VBoxContainer/Header/Background
onready var background_content = $VBoxContainer/Content/Background

onready var game_mode_button = $VBoxContainer/Content/ModePanel/GameModeButton

onready var mode_selection_button = $ModeSelectionButton

#

var mode_id_to_button_map : Dictionary
var current_selected_mode : int = -1
var current_map_id = -1

var game_mode_selection_list : SelectionListStandard
var node_to_add_selection_list_to : Node setget set_node_to_add_selection_list_to

#

func _ready():
	mode_selection_button.connect("mouse_entered", self, "_on_mouse_entered_selection_button")
	mode_selection_button.connect("mouse_exited", self, "_on_mouse_exited_selection_button")
	connect("visibility_changed", self, "_on_visibility_changed")
	mode_selection_button.connect("pressed", self, "_on_mode_selection_button_up")
	
	game_mode_button.about_button_index_trigger = game_mode_button._button_indexes.NONE

func set_node_to_add_selection_list_to(arg_node):
	node_to_add_selection_list_to = arg_node
	
	_initialize_game_mode_selection_list()

#

func _on_mouse_entered_selection_button():
	background_header.texture = ModeSelectionPanel_Background_HighlightedPic
	background_content.texture = ModeSelectionPanel_Background_HighlightedPic

func _on_mouse_exited_selection_button():
	background_header.texture = ModeSelectionPanel_Background_NormalPic
	background_content.texture = ModeSelectionPanel_Background_NormalPic

func _on_visibility_changed():
	_on_mouse_exited_selection_button()

##

func _on_mode_selection_button_up():
	game_mode_selection_list.start_display_anim()
	

func _initialize_game_mode_selection_list():
	game_mode_selection_list = SelectionListStandard_Scene.instance()
	
	node_to_add_selection_list_to.add_child(game_mode_selection_list)
	
	game_mode_selection_list.set_tooltip_owner(node_to_add_selection_list_to)
	game_mode_selection_list.set_pos_to_anchor_to(Vector2(game_mode_button.rect_global_position.x, 50))
	game_mode_selection_list.header_label.text = "Select Game Mode"
	game_mode_selection_list.stop_and_hide_display()
	
	#game_mode_selection_list.rect_min_size.x = 200
	game_mode_selection_list.rect_min_size.y = 400
	#game_mode_selection_list.rect_size.x = 200
	game_mode_selection_list.rect_size.y = 400
	
	_initialize_all_mode_buttons()


###


func _initialize_all_mode_buttons():
	for mode_id in StoreOfGameMode.Mode.values():
		var mode_type_info : GameModeTypeInformation = StoreOfGameMode.get_mode_type_info_from_id(mode_id)
		
		var button = GameModeButton_Scene.instance()
		#button.set_text_for_text_label(mode_type_info.mode_name)
		button.connect("mode_button_up", self, "_on_mode_button_up", [button, mode_type_info])
		button.mouse_filter = MOUSE_FILTER_PASS
		button.size_flags_horizontal = SIZE_EXPAND | SIZE_SHRINK_CENTER
		
		game_mode_selection_list.add_child_to_list(button)
		
		button.change_mode_pic_and_label(mode_type_info) #setting mode
		mode_id_to_button_map[mode_id] = button

func set_map_id_to_display_modes_for(arg_map_id):
	current_map_id = arg_map_id
	var map_type_info : MapTypeInformation = StoreOfMaps.get_map_type_information_from_id(arg_map_id)
	var disabled_current : bool = false
	
	for mode_id in StoreOfGameMode.Mode.values():
		var mode_enabled_in_map : bool = map_type_info.game_mode_ids_accessible_from_menu.has(mode_id)
		
		var button : GameModeButton = mode_id_to_button_map[mode_id]
		button.visible = mode_enabled_in_map
		
		if mode_id == current_selected_mode and !mode_enabled_in_map:
			disabled_current = true
	
	if disabled_current:
		set_first_valid_mode()

func set_first_valid_mode():
	var map_type_info : MapTypeInformation = StoreOfMaps.get_map_type_information_from_id(current_map_id)
	
	if map_type_info != null:
		for mode_id in mode_id_to_button_map.keys():
			if map_type_info.game_mode_ids_accessible_from_menu.has(mode_id):
				var mode_type_info : GameModeTypeInformation = StoreOfGameMode.get_mode_type_info_from_id(mode_id)
				set_active_mode(mode_type_info)
				break
	
	current_selected_mode = -1


func set_active_mode_using_game_settings_params():
	var last_chosen_map_id = GameSettingsManager.last_chosen_map_id
	
	
	if GameSettingsManager.map_id_to_last_chosen_mode_id_map.has(last_chosen_map_id):
		set_active_mode_using_id(GameSettingsManager.map_id_to_last_chosen_mode_id_map[last_chosen_map_id])
	else:
		set_first_valid_mode()
		#print("ERROR: NO DEFAULT last chosen mode")
	

func set_active_mode_using_id(arg_id):
	if arg_id == -1 or arg_id == null:
		arg_id = StoreOfGameMode.default_game_mode
	
	var mode_type_info : GameModeTypeInformation = StoreOfGameMode.get_mode_type_info_from_id(arg_id)
	set_active_mode(mode_type_info)


#

func _on_mode_button_up(arg_button, arg_mode_type_info):
	if game_mode_selection_list.visible:
		game_mode_selection_list.stop_and_hide_display()
		set_active_mode(arg_mode_type_info)

func set_active_mode(arg_mode_type_info : GameModeTypeInformation):
	current_selected_mode = arg_mode_type_info.mode_id
	_change_mode_displayed(arg_mode_type_info)

func _change_mode_displayed(arg_mode_type_info : GameModeTypeInformation):
	_change_border_frame_texture(arg_mode_type_info.game_mode_frame_texture)
	_change_mode_button_and_label(arg_mode_type_info)
	emit_signal("current_selected_game_mode_changed", arg_mode_type_info.mode_id)

func _change_border_frame_texture(arg_new_texture : Texture):
	border_header_left.texture = arg_new_texture
	border_header_right.texture = arg_new_texture
	border_header_top.texture = arg_new_texture
	border_header_bottom.texture = arg_new_texture
	border_content_bottom.texture = arg_new_texture
	border_content_left.texture = arg_new_texture
	border_content_right.texture = arg_new_texture

func _change_mode_button_and_label(arg_mode_type_info : GameModeTypeInformation):
	game_mode_button.change_mode_pic_and_label(arg_mode_type_info, false)

