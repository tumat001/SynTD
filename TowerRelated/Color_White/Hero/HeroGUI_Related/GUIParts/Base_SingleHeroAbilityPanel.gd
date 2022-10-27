extends MarginContainer

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
#const Hero = preload("res://TowerRelated/Color_White/Hero/Hero.gd")


var hero setget set_hero

var func_name_of_ability_desc : String
var func_name_of_ability_level_up_desc : String
var func_name_of_ability_name : String

var func_name_of_can_level_up_ability : String
var func_name_of_attempt_level_up_ability : String
var signal_name_of_ability_level_changed : String

var property_name_of_ability_level : String

export(Texture) var ability_image : Texture

onready var ability_level_up_button = $VBoxContainer/AbilityLevelUpButton
onready var ability_display_button = $VBoxContainer/MarginContainer/AbilityDisplayButton
onready var ability_level_label = $VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/MarginContainer/AbilityLevelLabel
onready var ability_texture_rect = $VBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/AbilityImage

const non_level_0_ability_modulate : Color = Color(1, 1, 1, 1)
const level_0_ability_modulate : Color = Color(0.3, 0.3, 0.3, 1)

func _ready():
	ability_display_button.define_tooltip_construction_in_button = false
	ability_level_up_button.define_tooltip_construction_in_button = false
	
	if ability_image != null:
		ability_texture_rect.texture = ability_image

func set_hero(arg_hero):
	if is_instance_valid(hero):
		hero.disconnect("current_spendables_changed", self, "_hero_curr_spendables_changed")
		hero.disconnect(signal_name_of_ability_level_changed, self, "_hero_ability_level_changed")
	
	hero = arg_hero
	
	if is_instance_valid(hero):
		hero.connect("current_spendables_changed", self, "_hero_curr_spendables_changed")
		hero.connect(signal_name_of_ability_level_changed, self, "_hero_ability_level_changed")
		
		_hero_ability_level_changed(hero.get(property_name_of_ability_level))


# ability level up button related

func _hero_curr_spendables_changed(new_amount):
	_update_based_on_if_hero_can_level_up_ability()

func _hero_ability_level_changed(new_level):
	ability_level_label.text = str(new_level)
	
	if new_level == 0:
		ability_display_button.modulate = level_0_ability_modulate
		ability_texture_rect.modulate = level_0_ability_modulate
	else:
		ability_display_button.modulate = non_level_0_ability_modulate
		ability_texture_rect.modulate = non_level_0_ability_modulate
	
	_update_based_on_if_hero_can_level_up_ability()

func _update_based_on_if_hero_can_level_up_ability():
	if hero.call(func_name_of_can_level_up_ability):
		ability_level_up_button.visible = true
	else:
		ability_level_up_button.visible = false


func _on_AbilityLevelUpButton_pressed_mouse_event(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			hero.call(func_name_of_attempt_level_up_ability)


func _on_AbilityLevelUpButton_about_tooltip_construction_requested():
	var tooltip : BaseTowerSpecificTooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = hero.call(func_name_of_ability_name)
	tooltip.descriptions = hero.call(func_name_of_ability_level_up_desc)
	
	ability_level_up_button.display_requested_about_tooltip(tooltip)

#

func _on_AbilityDisplayButton_about_tooltip_construction_requested():
	var tooltip : BaseTowerSpecificTooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = hero.call(func_name_of_ability_name)
	tooltip.descriptions = hero.call(func_name_of_ability_desc)
	
	ability_display_button.display_requested_about_tooltip(tooltip)


func _on_AbilityDisplayButton_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		_on_AbilityDisplayButton_about_tooltip_construction_requested()
