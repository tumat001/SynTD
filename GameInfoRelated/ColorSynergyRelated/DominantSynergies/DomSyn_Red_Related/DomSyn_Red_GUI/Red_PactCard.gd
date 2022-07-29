extends MarginContainer

const Red_BasePact = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd")


signal pact_card_pressed(pact)

const requirements_unmet_modulate : Color = Color(0.3, 0.3, 0.3, 1)
const requirements_met_modulate : Color = Color(1, 1, 1, 1)


var base_pact : Red_BasePact setget set_base_pact

onready var name_label = $VBoxContainer/HeaderMarginer/NameLabel
onready var good_descriptions = $VBoxContainer/MarginContainer/HBoxContainer/GoodMarginer/ScrollContainer/GoodDescriptions
onready var bad_descriptions = $VBoxContainer/MarginContainer/HBoxContainer/BadMarginer/ScrollContainer/BadDescriptions
onready var pact_icon = $VBoxContainer/MarginContainer/HBoxContainer/PicMarginer/PactIcon
onready var tier_label = $VBoxContainer/MarginContainer/HBoxContainer/TierMarginer/TierLabel

func set_base_pact(arg_pact : Red_BasePact):
	
	if base_pact != null:
		if base_pact.is_connected("on_activation_requirements_met", self, "_on_base_pact_activation_requirements_met"):
			base_pact.disconnect("on_activation_requirements_met", self, "_on_base_pact_activation_requirements_met")
			base_pact.disconnect("on_activation_requirements_unmet", self, "_on_base_pact_activation_requirements_unmet")
			base_pact.disconnect("on_description_changed", self, "_on_base_pact_description_changed")
	
	base_pact = arg_pact
	
	if base_pact != null:
		if !base_pact.is_connected("on_activation_requirements_met", self, "_on_base_pact_activation_requirements_met"):
			base_pact.connect("on_activation_requirements_met", self, "_on_base_pact_activation_requirements_met", [], CONNECT_PERSIST)
			base_pact.connect("on_activation_requirements_unmet", self, "_on_base_pact_activation_requirements_unmet", [], CONNECT_PERSIST)
			base_pact.connect("on_description_changed", self, "_on_base_pact_description_changed", [], CONNECT_PERSIST)
	
	if name_label != null:
		update_display()


#

func _on_base_pact_activation_requirements_met(red_dom_syn_curr_tier : int):
	update_display()

func _on_base_pact_activation_requirements_unmet(red_dom_syn_curr_tier : int):
	update_display()

func _on_base_pact_description_changed():
	update_display()

#

func _ready():
	update_display()

func update_display():
	if base_pact != null and !is_queued_for_deletion() and name_label != null:
		name_label.text = base_pact.pact_name
		pact_icon.texture = base_pact.pact_icon
		
		good_descriptions.descriptions = base_pact.good_descriptions
		good_descriptions.update_display()
		
		bad_descriptions.descriptions = base_pact.bad_descriptions
		bad_descriptions.update_display()
		
		tier_label.text = _convert_number_to_roman_numeral(base_pact.tier)
		
		
		if base_pact.is_activation_requirements_met:
			modulate = requirements_met_modulate
		else:
			modulate = requirements_unmet_modulate


func _convert_number_to_roman_numeral(number : int) -> String:
	var return_val : String = ""
	if number == 0:
		return_val = "0"
	elif number == 1:
		return_val = "I"
	elif number == 2:
		return_val = "II"
	elif number == 3:
		return_val = "III"
	elif number == 4:
		return_val = "IV"
	elif number == 5:
		return_val = "V"
	elif number == 6:
		return_val = "VI"
	elif number == 7:
		return_val = "VII"
	
	return return_val


#

func _on_AdvancedButton_pressed_mouse_event(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			emit_signal("pact_card_pressed", base_pact)

