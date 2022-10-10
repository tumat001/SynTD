extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

var wave_tower setget set_wave_tower

onready var wave_effect_panel = $VBoxContainer/BodyMarginer/MarginContainer/VBoxContainer/WavePassiveEffectPanel

func _construct_about_tooltip():
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Wave passively has an on hit damage buff that is used in its attacks and Tidal Wave ability.",
		"Ability usage reduces this passive temporarily."
	]
	a_tooltip.header_left_text = "Passive"
	
	return a_tooltip

static func should_display_self_for(tower):
	return tower.tower_id == Towers.WAVE


func set_wave_tower(tower):
	if is_instance_valid(wave_tower):
		wave_effect_panel.tower_base_effect = null
		wave_effect_panel.update_display()
		wave_tower.disconnect("effect_modifier_changed", self, "_wave_effect_modifier_changed")
	
	wave_tower = tower
	
	if is_instance_valid(wave_tower):
		wave_effect_panel.tower_base_effect = wave_tower.wave_dmg_effect
		wave_effect_panel.update_display()
		wave_tower.connect("effect_modifier_changed", self, "_wave_effect_modifier_changed")


func _wave_effect_modifier_changed(mod_amount):
	wave_effect_panel.update_display()
