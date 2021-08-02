extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const Leader_SelectionPanelBody = preload("res://TowerRelated/Color_Blue/Leader/Ability/TowerSelectionPanel/Leader_SelectionPanelBody.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

const ShowingConnection_Pic = preload("res://MiscRelated/CommonTextures/CT_ConnectionShow_Pic.png")
const HidingConnection_Pic = preload("res://MiscRelated/CommonTextures/CT_ConnectionHide_Pic.png")

var blossom setget set_blossom

onready var assign_partner_button = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/AssignPartnerButton
onready var unassign_partner_button = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/UnassignPartnerButton
onready var show_partner_connection_button = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/ShowConnectionButton


func set_blossom(arg_blossom):
	if blossom != null:
		blossom.disconnect("showing_partner_connection_status_changed", self, "_blossom_showing_partner_changed")
		assign_partner_button.ability = null
		unassign_partner_button.ability = null
	
	blossom = arg_blossom
	
	if blossom != null:
		if !blossom.is_connected("showing_partner_connection_status_changed", self, "_blossom_showing_partner_changed"):
			blossom.connect("showing_partner_connection_status_changed", self, "_blossom_showing_partner_changed", [], CONNECT_PERSIST)
			assign_partner_button.ability = blossom.partner_assign_ability
			unassign_partner_button.ability = blossom.partner_unassign_ability
		
		_blossom_showing_partner_changed(blossom.is_showing_partner_connection)



# Showing partner related

func _blossom_showing_partner_changed(is_showing : bool):
	if is_showing:
		show_partner_connection_button.texture_normal = ShowingConnection_Pic
	else:
		show_partner_connection_button.texture_normal = HidingConnection_Pic


func _on_ShowConnectionButton_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		if blossom.is_showing_partner_connection:
			blossom.hide_partner_connection()
		else:
			blossom.show_partner_connection()


#

func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Blossom is all about its Partner. This panel contains actions to (re)assign a partner and unassign a partner."
	]
	a_tooltip.header_left_text = "Partner Configuration"
	
	return a_tooltip


static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.BLOSSOM
