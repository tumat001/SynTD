extends MarginContainer

const Red_BasePact = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd")
const TierPic_Bronze = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/DomSyn_Red_TierCardPic_Bronze.png")
const TierPic_Silver = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/DomSyn_Red_TierCardPic_Silver.png")
const TierPic_Gold = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/DomSyn_Red_TierCardPic_Gold.png")
const TierPic_Diamond = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/DomSyn_Red_TierCardPic_Diamond.png")

signal pact_card_pressed(pact)

const requirements_unmet_modulate : Color = Color(0.4, 0.4, 0.4, 1)
const requirements_met_modulate : Color = Color(1, 1, 1, 1)


var base_pact : Red_BasePact setget set_base_pact

onready var name_label = $VBoxContainer/HeaderMarginer/NameLabel
onready var good_descriptions = $VBoxContainer/MarginContainer/HBoxContainer/GoodMarginer/ScrollContainer/GoodDescriptions
onready var bad_descriptions = $VBoxContainer/MarginContainer/HBoxContainer/BadMarginer/ScrollContainer/BadDescriptions
onready var pact_icon = $VBoxContainer/MarginContainer/HBoxContainer/PicMarginer/PactIcon
onready var tier_label = $VBoxContainer/MarginContainer/HBoxContainer/TierMarginer/TierTextMarginer/TierLabel
onready var tier_pic = $VBoxContainer/MarginContainer/HBoxContainer/TierMarginer/TierPic

onready var button = $AdvancedButton

func set_base_pact(arg_pact : Red_BasePact):
	
	if base_pact != null:
		if base_pact.is_connected("on_activation_requirements_met", self, "_on_base_pact_activation_requirements_met"):
			base_pact.disconnect("on_activation_requirements_met", self, "_on_base_pact_activation_requirements_met")
			base_pact.disconnect("on_activation_requirements_unmet", self, "_on_base_pact_activation_requirements_unmet")
			base_pact.disconnect("on_description_changed", self, "_on_base_pact_description_changed")
			base_pact.disconnect("last_calculated_can_be_sworn_changed", self, "_on_last_calculated_can_be_sworn_changed")
	
	base_pact = arg_pact
	
	if base_pact != null:
		if !base_pact.is_connected("on_activation_requirements_met", self, "_on_base_pact_activation_requirements_met"):
			base_pact.connect("on_activation_requirements_met", self, "_on_base_pact_activation_requirements_met", [], CONNECT_PERSIST)
			base_pact.connect("on_activation_requirements_unmet", self, "_on_base_pact_activation_requirements_unmet", [], CONNECT_PERSIST)
			base_pact.connect("on_description_changed", self, "_on_base_pact_description_changed", [], CONNECT_PERSIST)
			base_pact.connect("last_calculated_can_be_sworn_changed", self, "_on_last_calculated_can_be_sworn_changed", [], CONNECT_PERSIST)
	
	if is_instance_valid(name_label):
		update_display()


#

func _on_base_pact_activation_requirements_met(red_dom_syn_curr_tier : int):
	#update_display()
	_update_req_met_or_unmet_modulate()

func _on_base_pact_activation_requirements_unmet(red_dom_syn_curr_tier : int):
	#update_display()
	_update_req_met_or_unmet_modulate()

func _on_base_pact_description_changed():
	#update_display()
	_update_descriptions()

func _on_last_calculated_can_be_sworn_changed(arg_val):
	_update_req_met_or_unmet_modulate()


#

func _ready():
	update_display()

func update_display():
	if base_pact != null and is_instance_valid(self) and !is_queued_for_deletion() and name_label != null:
		name_label.text = base_pact.pact_name
		pact_icon.texture = base_pact.pact_icon
		
		_update_descriptions()
		
		tier_label.text = _convert_number_to_roman_numeral(base_pact.tier)
		_set_tier_pic_to_appropriate_pic(base_pact.tier)
		
		_update_req_met_or_unmet_modulate()

func _update_descriptions():
	if is_inside_tree() and !is_queued_for_deletion():
		good_descriptions.descriptions = base_pact.good_descriptions
		good_descriptions.update_display()
		
		bad_descriptions.descriptions = base_pact.bad_descriptions
		bad_descriptions.update_display()

func _update_req_met_or_unmet_modulate():
	if base_pact.is_activation_requirements_met and (base_pact.last_calculated_can_be_sworn or base_pact.is_sworn):
		modulate = requirements_met_modulate
	else:
		modulate = requirements_unmet_modulate


#

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

func _set_tier_pic_to_appropriate_pic(arg_tier):
	if arg_tier == 3:
		tier_pic.texture = TierPic_Bronze
	elif arg_tier == 2:
		tier_pic.texture = TierPic_Silver
	elif arg_tier == 1:
		tier_pic.texture = TierPic_Gold
	elif arg_tier == 0:
		tier_pic.texture = TierPic_Diamond

#

func _on_AdvancedButton_pressed_mouse_event(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			#if base_pact._if_pact_can_be_sworn():
			if base_pact.last_calculated_can_be_sworn:
				emit_signal("pact_card_pressed", base_pact)


func set_button_disabled(arg_val):
	button.disabled = arg_val

