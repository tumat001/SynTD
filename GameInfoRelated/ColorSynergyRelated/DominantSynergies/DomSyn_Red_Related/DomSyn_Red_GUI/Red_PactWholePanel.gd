extends MarginContainer

signal unsworn_pact_to_be_sworn(pact)
signal sworn_pact_card_removed(pact, new_replacing_pact)
signal auto_open_shop_checkbox_val_changed(arg_val)

const Red_PactSinglePanel = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactSinglePanel.gd")

onready var unsworn_pact_list : Red_PactSinglePanel = $VBoxContainer/HBoxContainer/UnswornPactList
onready var sworn_pact_list : Red_PactSinglePanel = $VBoxContainer/HBoxContainer/SwornPactList

onready var auto_open_shop_checkbox =  $VBoxContainer/SettingsContainer/AutoOpenCheckbox

const unsworn_descriptions : Array = [
	"This panel contains all unsworn pacts.",
	"Left click a pact to activate its buffs and debuffs."
]

const sworn_descriptions : Array = [
	"This panel contains all sworn pacts.",
	"All buffs and debuffs that are displayed are activated, unless it is grayed out (synergy tier or condition is not met)."
]

#

func _ready():
	auto_open_shop_checkbox.set_label_text("Open shop on round end")
	
	unsworn_pact_list.descriptions_about_panel = unsworn_descriptions
	sworn_pact_list.descriptions_about_panel = sworn_descriptions
	
	sworn_pact_list.disable_card_pact_button = true

#

func _on_UnswornPactList_pact_card_clicked(pact):
	emit_signal("unsworn_pact_to_be_sworn", pact)


func _on_SwornPactList_pact_card_removed(pact, new_replacing_pact):
	emit_signal("sworn_pact_card_removed", pact, new_replacing_pact)

#

func has_pact_in_sworn_list(arg_pact_uuid : int):
	for pact_uuid in sworn_pact_list.get_all_pact_uuids():
		if pact_uuid == arg_pact_uuid:
			return true
	
	for pact_uuid in unsworn_pact_list.get_all_pact_uuids():
		if pact_uuid == arg_pact_uuid:
			return true
	
	return false

func has_at_least_one_of_pact_in_list(arg_pact_uuids : Array):
	for pact_uuid in sworn_pact_list.get_all_pact_uuids():
		for arg_pact_uuid in arg_pact_uuids:
			if pact_uuid == arg_pact_uuid:
				return true
	
	for pact_uuid in unsworn_pact_list.get_all_pact_uuids():
		for arg_pact_uuid in arg_pact_uuids:
			if pact_uuid == arg_pact_uuid:
				return true
	
	return false

#

# USED WHEN FIRST INITIALIZING THIS CONTROL. do not use otherwise.
func set_auto_open_checkbox_val(arg_val):
	auto_open_shop_checkbox.is_checked = arg_val

func _on_AutoOpenCheckbox_on_checkbox_val_changed(arg_new_val):
	emit_signal("auto_open_shop_checkbox_val_changed", arg_new_val)

