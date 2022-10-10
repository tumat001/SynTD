extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
const Towers = preload("res://GameInfoRelated/Towers.gd")

const selected_color_mod : Color = Color(1, 1, 1, 1)
const not_selected_color_mod : Color = Color(0.5, 0.5, 0.5, 1)

var brewd_tower setget set_brewd_tower

onready var potion_repel_button = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/PotionRepel_Button
onready var potion_implosion_button = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/PotionImplosion_Button
onready var potion_shuffle_button = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/PotionShuffle_Button

func set_brewd_tower(arg_tower):
	if is_instance_valid(brewd_tower):
		brewd_tower.disconnect("selected_potion_type_changed", self, "_brewd_selected_potion_changed")
	
	brewd_tower = arg_tower
	
	if is_instance_valid(brewd_tower):
		brewd_tower.connect("selected_potion_type_changed", self, "_brewd_selected_potion_changed", [], CONNECT_PERSIST)
		_brewd_selected_potion_changed(brewd_tower.current_potion_type_selected)

#

func _brewd_selected_potion_changed(new_pot_type : int):
	if new_pot_type == brewd_tower.PotionTypes.REPEL:
		potion_repel_button.modulate = selected_color_mod
		potion_implosion_button.modulate = not_selected_color_mod
		potion_shuffle_button.modulate = not_selected_color_mod
		
	if new_pot_type == brewd_tower.PotionTypes.IMPLODE:
		potion_repel_button.modulate = not_selected_color_mod
		potion_implosion_button.modulate = selected_color_mod
		potion_shuffle_button.modulate = not_selected_color_mod
		
	if new_pot_type == brewd_tower.PotionTypes.SHUFFLE:
		potion_repel_button.modulate = not_selected_color_mod
		potion_implosion_button.modulate = not_selected_color_mod
		potion_shuffle_button.modulate = selected_color_mod


#

func _construct_about_tooltip() -> BaseTooltip:
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = "Brewd Potions"
	tooltip.descriptions = [
		"Brewd shoots potions at enemies.",
		"Left click on a potion to select the type of potion to shoot at enemies.",
		"Right click on a potion to view its description.", 
		"",
		"Currently selected potion: %s" % [str(brewd_tower.get_name_of_potion_type())]
	]
	
	return tooltip

#

func _on_PotionRepel_Button_about_tooltip_construction_requested():
	var pot_type = brewd_tower.PotionTypes.REPEL
	
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = brewd_tower.get_name_of_potion_type(pot_type)
	tooltip.descriptions = brewd_tower.get_descriptions_of_potion_type(pot_type)
	
	potion_repel_button.display_requested_about_tooltip(tooltip)


func _on_PotionImplosion_Button_about_tooltip_construction_requested():
	var pot_type = brewd_tower.PotionTypes.IMPLODE
	
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = brewd_tower.get_name_of_potion_type(pot_type)
	tooltip.descriptions = brewd_tower.get_descriptions_of_potion_type(pot_type)
	
	potion_implosion_button.display_requested_about_tooltip(tooltip)


func _on_PotionShuffle_Button_about_tooltip_construction_requested():
	var pot_type = brewd_tower.PotionTypes.SHUFFLE
	
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = brewd_tower.get_name_of_potion_type(pot_type)
	tooltip.descriptions = brewd_tower.get_descriptions_of_potion_type(pot_type)
	
	potion_shuffle_button.display_requested_about_tooltip(tooltip)

#

func _on_PotionRepel_Button_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		brewd_tower.select_potion_type(brewd_tower.PotionTypes.REPEL)


func _on_PotionImplosion_Button_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		brewd_tower.select_potion_type(brewd_tower.PotionTypes.IMPLODE)


func _on_PotionShuffle_Button_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		brewd_tower.select_potion_type(brewd_tower.PotionTypes.SHUFFLE)

#

static func should_display_self_for(tower):
	return tower.tower_id == Towers.BREWD
