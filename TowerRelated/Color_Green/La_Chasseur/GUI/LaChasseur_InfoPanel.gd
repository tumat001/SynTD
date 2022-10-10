extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
const LaChasseur = preload("res://TowerRelated/Color_Green/La_Chasseur/LaChasseur.gd")


var tower : LaChasseur setget set_la_chasseur

onready var on_hit_label = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/OnHitLabel

func set_la_chasseur(arg_tower):
	if is_instance_valid(tower):
		tower.disconnect("on_hit_bonus_changed", self, "_on_hit_changed")
	
	tower = arg_tower
	
	if is_instance_valid(tower):
		tower.connect("on_hit_bonus_changed", self, "_on_hit_changed", [], CONNECT_PERSIST)
		
		_on_hit_changed()

#

func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Displays the current bonus on hit damage gained from Hunt Down."
	]
	a_tooltip.header_left_text = "On hit damage stacks"
	
	return a_tooltip


static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.LA_CHASSEUR

#

func _on_hit_changed():
	on_hit_label.text = "+" + str(tower.on_hit_damage_effect.on_hit_damage.damage_as_modifier.flat_modifier)

