extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const Leader_SelectionPanelBody = preload("res://TowerRelated/Color_Blue/Leader/Ability/TowerSelectionPanel/Leader_SelectionPanelBody.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

onready var leader_selection_panel_body : Leader_SelectionPanelBody = $VBoxContainer/BodyMarginer/Leader_SelectionPanelBody


func _construct_about_tooltip():
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Leader shines best with its members. This panel contains actions to assign, remove and view its members."
	]
	a_tooltip.header_left_text = "Member Configuration"
	
	return a_tooltip


func set_leader(leader):
	leader_selection_panel_body.tower_leader = leader


static func should_display_self_for(tower):
	return tower.tower_id == Towers.LEADER
