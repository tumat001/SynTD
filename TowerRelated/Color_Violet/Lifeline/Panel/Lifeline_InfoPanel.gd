extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")



var lifeline setget set_lifeline

onready var base_dmg_buff_effect_panel = $VBoxContainer/BodyMarginer/MarginContainer/BaseDamageBuff

#

func _ready():
	base_dmg_buff_effect_panel.use_dynamic_description = true

#

func set_lifeline(arg_tower):
	if is_instance_valid(lifeline):
		lifeline.disconnect("base_dmg_lifeline_effect_changed", self, "_update_base_dmg_lifeline_effect_panel")
	
	lifeline = arg_tower
	
	if is_instance_valid(lifeline):
		lifeline.connect("base_dmg_lifeline_effect_changed", self, "_update_base_dmg_lifeline_effect_panel", [], CONNECT_PERSIST)
		
		base_dmg_buff_effect_panel.tower_base_effect = lifeline.sample_base_dmg_effect_for_info_panel
		
		_update_base_dmg_lifeline_effect_panel()



func _update_base_dmg_lifeline_effect_panel():
	base_dmg_buff_effect_panel.update_display()
	

#

# Override this to return a tooltip
func _construct_about_tooltip() -> BaseTooltip:
	var plain_fragment__base_damage = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BASE_DAMAGE, "bonus base damage")
	
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = "Lifeline Effects"
	tooltip.descriptions = [
		["Lifeline gives |0|, increasing based on its missing health.", [plain_fragment__base_damage]]
	]
	
	return tooltip


#

static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.LIFELINE

