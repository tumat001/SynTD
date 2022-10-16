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

onready var tower_name_label = $RowsMainContainer/HeaderContainer/Marginer/HeaderColumns/TowerName
onready var tower_color_01_texturerect = $RowsMainContainer/HeaderContainer/Marginer/HeaderColumns/Marginer/HBoxContainer/TowerColor01
onready var tower_color_02_texturerect = $RowsMainContainer/HeaderContainer/Marginer/HeaderColumns/Marginer/HBoxContainer/TowerColor02

onready var base_damage_label = $RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/BaseDamagePanel/BaseDamageLabel
onready var attack_speed_label = $RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/AttkSpeedPanel/AttkSpeedLabel
onready var damage_type_label = $RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/DamageTypePanel/DamageTypeLabel
onready var range_label = $RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/RangePanel/RangeLabel
onready var on_hit_multiplier_label = $RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/OnHitMultiplierPanel/OnHitMultiplierLabel

onready var ing_info_body = $RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/IngInfoBody

# Called when the node enters the scene tree for the first time.
func _ready():
	tower_descriptions_tooltip.use_color_for_dark_background = true
	update_display()


func update_display():
	if tower_info != null:
		tower_name_label.text = tower_info.tower_name
		
		var tower_colors : Array = tower_info.colors
		if tower_colors.size() >= 1:
			tower_color_01_texturerect.texture = TowerColors.get_color_symbol_on_card(tower_colors[0])
		if tower_colors.size() >= 2:
			tower_color_02_texturerect.texture = TowerColors.get_color_symbol_on_card(tower_colors[1])
		
		base_damage_label.text = str(tower_info.base_damage)
		damage_type_label.text = DamageType.get_name_of_damage_type(tower_info.base_damage_type)
		attack_speed_label.text = str(tower_info.base_attk_speed)
		range_label.text = str(tower_info.base_range)
		
		_update_ingredients()
		
		
		# descriptions
		tower_descriptions_tooltip.clear_descriptions_in_array()
		var descriptions_to_use : Array = GameSettingsManager.get_descriptions_to_use_based_on_tower_type_info(tower_info, game_settings_manager)
		
		for desc in descriptions_to_use:
			tower_descriptions_tooltip.descriptions.append(desc)
		
		tower_descriptions_tooltip.update_display()
		
		
		_update_on_hit_multiplier()

func _update_ingredients():
	ing_info_body.clear_descriptions_in_array()
	if tower_info.ingredient_effect == null:
		ing_info_body.descriptions = ["Cannot be used as an ingredient."]
	else:
		var ing_desc = tower_info.ingredient_effect.description
		
		var desc_instance = TooltipWithImageIndicatorDescription_Scene.instance()
		
		if ing_desc is Array:
			desc_instance.description = ing_desc[0]
			desc_instance._text_fragment_interpreters = ing_desc[1]
		elif ing_desc is String:
			desc_instance.description = tower_info.ingredient_effect.description
		
		desc_instance.img_indicator = tower_info.ingredient_effect.tower_base_effect.effect_icon
		desc_instance._use_color_for_dark_background = true
		
		ing_info_body.descriptions.append(desc_instance)
	ing_info_body.update_display()
	

func _update_on_hit_multiplier():
	on_hit_multiplier_label.text = "x" + str(tower_info.on_hit_multiplier)
