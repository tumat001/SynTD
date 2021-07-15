extends MarginContainer

signal unsworn_pact_to_be_sworn(pact)
signal sworn_pact_card_removed(pact)

const Red_PactSinglePanel = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactSinglePanel.gd")

onready var unsworn_pact_list : Red_PactSinglePanel = $VBoxContainer/HBoxContainer/UnswornPactList
onready var sworn_pact_list : Red_PactSinglePanel = $VBoxContainer/HBoxContainer/SwornPactList


#

func _on_UnswornPactList_pact_card_clicked(pact):
	emit_signal("unsworn_pact_to_be_sworn", pact)


func _on_SwornPactList_pact_card_removed(pact):
	emit_signal("sworn_pact_card_removed", pact)
