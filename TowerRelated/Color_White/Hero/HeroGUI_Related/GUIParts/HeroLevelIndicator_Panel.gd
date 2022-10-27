extends MarginContainer

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
#const Hero = preload("res://TowerRelated/Color_White/Hero/Hero.gd")


var hero  setget set_hero

onready var level_label = $HBoxContainer/MarginContainer/MarginContainer/VBoxContainer/MarginContainer2/LevelLabel
onready var spendables_label = $HBoxContainer/MarginContainer2/MarginContainer/SpendablesLabel


func set_hero(arg_hero):
	if is_instance_valid(hero):
		hero.disconnect("hero_level_changed", self, "_hero_level_changed")
		hero.disconnect("current_spendables_changed", self, "_hero_spendables_changed")
	
	hero = arg_hero
	
	if is_instance_valid(hero):
		hero.connect("hero_level_changed", self, "_hero_level_changed")
		hero.connect("current_spendables_changed", self, "_hero_spendables_changed")
		
		_hero_level_changed(hero.current_hero_effective_level)
		_hero_spendables_changed(hero.current_spendables)


func _hero_level_changed(new_lvl):
	level_label.text = str(new_lvl)

func _hero_spendables_changed(spendables):
	spendables_label.text = str(spendables)
