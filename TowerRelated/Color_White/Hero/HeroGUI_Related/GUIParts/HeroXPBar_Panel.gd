extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
#const Hero = preload("res://TowerRelated/Color_White/Hero/Hero.gd")
const ControlProgressBar = preload("res://MiscRelated/ControlProgressBarRelated/ControlProgressBar.gd")

var hero setget set_hero

onready var hero_xp_bar : ControlProgressBar = $VBoxContainer/BodyMarginer/HeroXPBar

func set_hero(arg_hero):
	if is_instance_valid(hero):
		if hero.is_connected("current_xp_changed", self, "_hero_xp_changed"):
			hero.disconnect("current_xp_changed", self, "_hero_xp_changed")
			hero.disconnect("xp_needed_for_next_level_changed", self, "_hero_xp_cap_changed")
			hero.disconnect("max_level_reached", self, "_hero_max_level_reached")
	
	hero = arg_hero
	
	if is_instance_valid(hero):
		if hero.max_hero_level > hero.current_hero_natural_level:
			if !hero.is_connected("current_xp_changed", self, "_hero_xp_changed"):
				hero.connect("current_xp_changed", self, "_hero_xp_changed", [], CONNECT_PERSIST)
				hero.connect("xp_needed_for_next_level_changed", self, "_hero_xp_cap_changed", [], CONNECT_PERSIST)
				hero.connect("max_level_reached", self, "_hero_max_level_reached", [], CONNECT_PERSIST)
			
			_hero_xp_changed(null, hero.current_hero_xp)
			_hero_xp_cap_changed(hero.get_xp_for_next_level())
			
		else:
			# 10 is just an arbitrary number
			_hero_xp_changed(null, 10)
			_hero_xp_cap_changed(10)


func _hero_xp_changed(gained_amount, curr_xp):
	hero_xp_bar.current_value = curr_xp

func _hero_xp_cap_changed(new_cap):
	hero_xp_bar.max_value = new_cap

func _hero_max_level_reached():
	hero_xp_bar.current_value = hero_xp_bar.max_value
	
	if hero.is_connected("current_xp_changed", self, "_hero_xp_changed"):
		hero.disconnect("current_xp_changed", self, "_hero_xp_changed")
		hero.disconnect("xp_needed_for_next_level_changed", self, "_hero_xp_cap_changed")
		hero.disconnect("max_level_reached", self, "_hero_max_level_reached")


#

func _construct_about_tooltip() -> BaseTooltip:
	var tooltip : BaseTowerSpecificTooltip = BaseTowerSpecificTooltip_Scene.instance()
	
	tooltip.header_left_text = "About EXP"
	tooltip.descriptions = hero.xp_about_descriptions
	
	return tooltip

