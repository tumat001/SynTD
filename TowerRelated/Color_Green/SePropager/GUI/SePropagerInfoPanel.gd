extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

var se_propager setget set_se_propager

onready var toggle_auto_sell_golden_button = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/AutoSellAbilityButton
onready var sell_all_golden_button = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/SellAllAbilityButton


#onready var assign_partner_button = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/AssignPartnerButton
#onready var unassign_partner_button = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/UnassignPartnerButton


func set_se_propager(arg_se_propager):
	if is_instance_valid(se_propager):
		toggle_auto_sell_golden_button.ability = null
		sell_all_golden_button.ability = null
	
	se_propager = arg_se_propager
	
	if is_instance_valid(se_propager):
		toggle_auto_sell_golden_button.ability = se_propager.toggle_auto_sell_golden_ability
		sell_all_golden_button.ability = se_propager.sell_all_golden_abiltiy

#

func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Use these advanced controls to determine what to do with this tower's golden Les Semis."
	]
	a_tooltip.header_left_text = "Actions"
	
	return a_tooltip


static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.SE_PROPAGER
