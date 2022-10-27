extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButtonWithTooltip.gd"

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
#const Hero = preload("res://TowerRelated/Color_White/Hero/Hero.gd")

var hero setget set_hero

var func_name_of_if_can_level : String
var func_name_of_attempt_level : String
var signal_name_of_can_spend_x_for_level : String
var func_name_of_desc_of_leveling : String

var _can_attempt_level : bool

func set_hero(arg_hero):
	if is_instance_valid(hero):
		hero.disconnect(signal_name_of_can_spend_x_for_level, self, "update_if_can_upgrade")
	
	hero = arg_hero
	
	if is_instance_valid(hero):
		hero.connect(signal_name_of_can_spend_x_for_level, self, "update_if_can_upgrade")
		
		update_if_can_upgrade(hero.call(func_name_of_if_can_level))


func update_if_can_upgrade(can_upgrade):
	_can_attempt_level = can_upgrade
	
	if can_upgrade:
		modulate = Color(1, 1, 1, 1)
	else:
		modulate = Color(0.3, 0.3, 0.3, 1)



func _on_Base_HeroLevelUpButton_pressed_mouse_event(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT and _can_attempt_level:
			attempt_level()

func attempt_level():
	hero.call(func_name_of_attempt_level)



#

func _construct_about_tooltip() -> BaseTooltip:
	var descs : Array = hero.call(func_name_of_desc_of_leveling)
	
	
	var tooltip : BaseTowerSpecificTooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = "Level Up"
	tooltip.descriptions = descs
	
	return tooltip
	

