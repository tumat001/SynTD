extends "res://GameHUDRelated/Tooltips/BaseTooltip.gd"

const TowerBuffs = preload("res://GameInfoRelated/TowerBuffs.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

var tower_info : TowerTypeInformation

# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()

func update_display():
	if tower_info != null:
		$RowsMainContainer/HeaderContainer/Marginer/HeaderColumns/TowerName.text = tower_info.tower_name
		
		var tower_colors : Array = tower_info.colors
		if tower_colors.size() >= 1:
			$RowsMainContainer/HeaderContainer/Marginer/HeaderColumns/Marginer/TowerColor01.texture = TowerColors.get_color_symbol_on_card(tower_colors[0])
		if tower_colors.size() >= 2:
			$RowsMainContainer/HeaderContainer/Marginer/HeaderColumns/Marginer/TowerColor02.texture = TowerColors.get_color_symbol_on_card(tower_colors[1])
		
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/BaseDamagePanel/BaseDamageLabel.text = str(tower_info.base_damage)
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/DamageTypePanel/DamageTypeLabel.text = DamageType.get_name_of_damage_type(tower_info.base_damage_type)
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/AttkSpeedPanel/AttkSpeedLabel.text = str(tower_info.base_attk_speed)
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/TowerStatsPanel/StatsRow/RangePanel/RangeLabel.text = str(tower_info.base_range)
		
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/CmbInfoBody.descriptions.clear()
		if tower_info.ingredient_buffs.size() == 0:
			$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/CmbInfoBody.descriptions = ["(Cannot be used as an ingredient."]
		else:
			for ing_buff in tower_info.ingredient_buffs:
				$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/CmbInfoBody.descriptions.append(ing_buff.get_description())
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/CmbInfoBody.update_display()
		
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.descriptions.clear()
		if tower_info.energy_consumption_levels.size() == 0:
			$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.descriptions = ["(Cannot use energy)"]
		else:
			for energy_buff in tower_info.energy_consumption_level_buffs:
				if energy_buff != null:
					$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.descriptions.append(energy_buff.get_description())
				else:
					$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.descriptions = ["No effect"]
		$RowsMainContainer/StatsContainer/StatsAndInfoDivider/CombineAndPowerInfoPanel/InfoRow/EnergyInfoBody.update_display()
		
		$RowsMainContainer/DescriptionContainer/Marginer/DescriptionsBody.descriptions.clear()
		for desc in tower_info.tower_descriptions:
			$RowsMainContainer/DescriptionContainer/Marginer/DescriptionsBody.descriptions.append(desc)
		$RowsMainContainer/DescriptionContainer/Marginer/DescriptionsBody.update_display()
