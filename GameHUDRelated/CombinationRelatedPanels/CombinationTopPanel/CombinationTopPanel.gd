extends MarginContainer

const TowerIconPanel = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.gd")
const TowerIconPanel_Scene = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.tscn")
const TowerTooltip = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.gd")
const TowerTooltipScene = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.tscn")

const CombinationWholeScreenPanel = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationWholeScreenPanel.gd")
const CombinationWholeScreenPanel_Scene = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationWholeScreenPanel.tscn")

const CombinationEffect = preload("res://GameInfoRelated/CombinationRelated/CombinationEffect.gd")

const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")


onready var combination_more_details_button = $HBoxContainer/MiddleFill/MainContainer/HBoxContainer/CombinationMoreDetailsButton
onready var combination_icons_hbox = $HBoxContainer/MiddleFill/MainContainer/HBoxContainer/ComboTowerIconsPanel

var current_tooltip : TowerTooltip
var combination_whole_screen_panel : CombinationWholeScreenPanel

var combination_manager
var whole_screen_gui
var game_settings_manager

var per_tier_index_position : Dictionary = {
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0,
	5 : 0,
	6 : 0,
}


# queue related

var reservation_for_whole_screen_gui

#

func _ready():
	_initialize_queue_reservation()

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	#reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	#reservation_for_whole_screen_gui.on_removed_method


#

func add_combination_effect(arg_combi_effect : CombinationEffect):
	var tower_icon_scene = TowerIconPanel_Scene.instance()
	tower_icon_scene.set_tower_type_info(arg_combi_effect.tower_type_info)
	
	var tower_tier : int = arg_combi_effect.tower_type_info.tower_tier
	
	combination_icons_hbox.add_child(tower_icon_scene)
	combination_icons_hbox.move_child(tower_icon_scene, per_tier_index_position[tower_tier])
	
	tower_icon_scene.set_button_interactable(true)
	
	tower_icon_scene.connect("on_mouse_hovered", self, "on_tower_icon_mouse_entered", [arg_combi_effect.tower_type_info, tower_icon_scene], CONNECT_PERSIST)
	tower_icon_scene.connect("on_mouse_hover_exited", self, "on_tower_icon_mouse_exited", [tower_icon_scene], CONNECT_PERSIST)
	tower_icon_scene.size_flags_vertical = SIZE_EXPAND | SIZE_SHRINK_CENTER
	#combination_icons_hbox.connect("mouse_exited", self, "on_tower_icon_mouse_exited", [], CONNECT_PERSIST)
	
	shift_index_based_on_inserted_combi_effect(tower_tier)
	

func shift_index_based_on_inserted_combi_effect(arg_tower_tier : int):
	for tier in per_tier_index_position.keys():
		if arg_tower_tier > tier:
			continue
		
		per_tier_index_position[tier] += 1


#

func on_tower_icon_mouse_entered(tower_type_info, combi_icon):
	_free_old_and_create_tooltip_for_tower(tower_type_info, combi_icon)

func _free_old_and_create_tooltip_for_tower(tower_type_info, combi_icon):
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
	
	current_tooltip = TowerTooltipScene.instance()
	current_tooltip.tower_info = tower_type_info
	current_tooltip.tooltip_owner = combi_icon
	current_tooltip.game_settings_manager = game_settings_manager
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(current_tooltip)

func on_tower_icon_mouse_exited(combi_icon):
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
		current_tooltip = null

###




func _on_CombinationMoreDetailsButton_pressed_mouse_event(event : InputEventMouseButton):
	if event.button_index == BUTTON_LEFT:
		_bring_up_combination_whole_screen_gui()
		

func _bring_up_combination_whole_screen_gui():
	if combination_whole_screen_panel == null:
		combination_whole_screen_panel = CombinationWholeScreenPanel_Scene.instance()
		combination_whole_screen_panel.combination_manager = combination_manager
	
	#whole_screen_gui.show_control(combination_whole_screen_panel)
	whole_screen_gui.queue_control(combination_whole_screen_panel, reservation_for_whole_screen_gui)

##

func get_tower_icon_with_tower_id(arg_tower_id):
	for icon in combination_icons_hbox.get_children():
		if icon.tower_type_info != null and icon.tower_type_info.tower_type_id == arg_tower_id:
			return icon
	
	return null

