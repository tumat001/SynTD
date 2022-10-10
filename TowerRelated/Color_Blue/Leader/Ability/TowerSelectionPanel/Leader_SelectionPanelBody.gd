extends MarginContainer

const Leader = preload("res://TowerRelated/Color_Blue/Leader/Leader.gd")

const ShowingMembers_Pic = preload("res://TowerRelated/Color_Blue/Leader/Ability/TowerSelectionPanel/MemberConnectionShow_Icon.png")
const HidingMembers_Pic = preload("res://TowerRelated/Color_Blue/Leader/Ability/TowerSelectionPanel/MemberConnectionHide_Icon.png")

onready var add_tower_ability_button = $InnerMarginer/HBoxContainer/TowerAddButton
onready var remove_tower_ability_button = $InnerMarginer/HBoxContainer/TowerRemoveButton
onready var member_show_hide_button = $InnerMarginer/HBoxContainer/MemberShowHideButton

var tower_leader : Leader setget set_tower_leader


#

func _ready():
	add_tower_ability_button.hotkey = InputMap.get_action_list("game_tower_panel_ability_01")[0].as_text()
	remove_tower_ability_button.hotkey = InputMap.get_action_list("game_tower_panel_ability_02")[0].as_text()

#

func set_tower_leader(arg_leader : Leader):
	if is_instance_valid(tower_leader):
		add_tower_ability_button.ability = null
		remove_tower_ability_button.ability = null
		tower_leader.disconnect("show_member_connection_mode_changed", self, "_showing_member_state_changed")
	
	tower_leader = arg_leader
	
	if is_instance_valid(tower_leader):
		add_tower_ability_button.ability = tower_leader.add_tower_as_member_ability
		remove_tower_ability_button.ability = tower_leader.remove_tower_as_member_ability
		tower_leader.connect("show_member_connection_mode_changed", self, "_showing_member_state_changed")
		
		if tower_leader.is_showing_member_connections:
			member_show_hide_button.texture_normal = ShowingMembers_Pic
		else:
			member_show_hide_button.texture_normal = HidingMembers_Pic



func _on_MemberShowHideButton_pressed_mouse_event(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if !tower_leader.is_showing_member_connections:
				tower_leader.show_member_connections()
			else:
				tower_leader.hide_member_connections()


func _showing_member_state_changed(showing : bool):
	if showing:
		member_show_hide_button.texture_normal = ShowingMembers_Pic
	else:
		member_show_hide_button.texture_normal = HidingMembers_Pic

