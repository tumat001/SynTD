extends "res://GameHUDRelated/Tooltips/BaseTooltip.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const GameSettingsManager = preload("res://GameElementsRelated/GameSettingsManager.gd")

const TooltipWithImageIndicatorDescription = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithImageIndicatorDescription.gd")
const TooltipWithImageIndicatorDescription_Scene = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithImageIndicatorDescription.tscn")

var tower_info : TowerTypeInformation
var game_settings_manager : GameSettingsManager

onready var tower_descriptions_tooltip = $RowsMainContainer/DescriptionContainer/Marginer/DescriptionsBody


# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()

func update_display():
	if tower_info != null:
		$RowsMainContainer/HeaderContainer/Marginer/HeaderColumns/TowerName.text = tower_info.tower_name
		
		var tower_colors : Array = tower_info.colors
		if tower_colors.size() >= 1:
			$RowsMainContainer/HeaderContainer/Marginer/HeaderColumns/Marginer/HBoxContainer/TowerColor01.texture = TowerColors.get_color_symbol_on_card(tower_colors[0])
		if tower_colors.size() >= 2:
			$RowsMainContainer/HeaderContainer/Marginer/HeaderColumns/Marginer/HBoxContainer/TowerColor02.texture = TowerColors.get_color_symbol_on_card(tower_colors[1])
		
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/BaseDamagePanel/BaseDamageLabel.text = str(tower_info.base_damage)
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/DamageTypePanel/DamageTypeLabel.text = DamageType.get_name_of_damage_type(tower_info.base_damage_type)
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/AttkSpeedPanel/AttkSpeedLabel.text = str(tower_info.base_attk_speed)
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/RangePanel/RangeLabel.text = str(tower_info.base_range)
		
		_update_ingredients()
		
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.clear_descriptions_in_array()
		if tower_info.energy_consumption_levels.size() == 0:
			$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.descriptions = ["(Cannot use energy)"]
		else:
			for energy_buff in tower_info.energy_consumption_level_buffs:
				if energy_buff != null:
					$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.descriptions.append(energy_buff.get_description())
				else:
					$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.descriptions = ["No effect"]
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.update_display()
		
		
		# descriptions
		tower_descriptions_tooltip.clear_descriptions_in_array()
		var descriptions_to_use : Array = GameSettingsManager.get_descriptions_to_use_based_on_tower_type_info(tower_info, game_settings_manager)
		
		for desc in descriptions_to_use:
			tower_descriptions_tooltip.descriptions.append(desc)
			tower_descriptions_tooltip.use_color_for_dark_background = false

		tower_descriptions_tooltip.update_display()
		
		
		_update_on_hit_multiplier()

func _update_ingredients():
	
	$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/CmbInfoBody.clear_descriptions_in_array()
	if tower_info.ingredient_effect == null:
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/CmbInfoBody.descriptions = ["(Cannot be used as an ingredient."]
	else:
		var ing_desc = tower_info.ingredient_effect.description
		
		var desc_instance = TooltipWithImageIndicatorDescription_Scene.instance()
		
		if ing_desc is Array:
			desc_instance.description = ing_desc[0]
			desc_instance._text_fragment_interpreters = ing_desc[1]
		elif ing_desc is String:
			desc_instance.description = tower_info.ingredient_effect.description
		
		desc_instance.img_indicator = tower_info.ingredient_effect.tower_base_effect.effect_icon
		desc_instance._use_color_for_dark_background = false
		
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/CmbInfoBody.descriptions.append(desc_instance)
	$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/CmbInfoBody.update_display()
	

func _update_on_hit_multiplier():
	$RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/OnHitMultiplierPanel/OnHitMultiplierLabel.text = "x" + str(tower_info.on_hit_multiplier)
