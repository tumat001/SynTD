extends MarginContainer

const Red_BasePact = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd")


signal pact_card_pressed(pact)

var base_pact : Red_BasePact setget set_base_pact

onready var name_label = $VBoxContainer/HeaderMarginer/NameLabel
onready var good_descriptions = $VBoxContainer/MarginContainer/HBoxContainer/GoodMarginer/ScrollContainer/GoodDescriptions
onready var bad_descriptions = $VBoxContainer/MarginContainer/HBoxContainer/BadMarginer/ScrollContainer/BadDescriptions
onready var pact_icon = $VBoxContainer/MarginContainer/HBoxContainer/PicMarginer/PactIcon
onready var tier_label = $VBoxContainer/MarginContainer/HBoxContainer/TierMarginer/TierLabel

func set_base_pact(arg_pact : Red_BasePact):
	base_pact = arg_pact
	
	if name_label != null:
		update_display()


func _ready():
	update_display()

func update_display():
	if base_pact != null:
		name_label.text = base_pact.pact_name
		pact_icon.texture = base_pact.pact_icon
		
		good_descriptions.descriptions = base_pact.good_descriptions
		good_descriptions.update_display()
		
		bad_descriptions.descriptions = base_pact.bad_descriptions
		bad_descriptions.update_display()
		
		tier_label.text = _convert_number_to_roman_numeral(base_pact.tier)

func _convert_number_to_roman_numeral(number : int) -> String:
	var return_val : String = ""
	if number == 0:
		return_val = ""
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

