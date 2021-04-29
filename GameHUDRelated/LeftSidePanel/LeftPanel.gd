extends MarginContainer

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const ColorSynergyChecker = preload("res://GameInfoRelated/ColorSynergyChecker.gd")

var active_synergies_res : Array = []
var non_active_dominant_synergies_res : Array = []
var non_active_composite_synergies_res : Array = []

func _ready():
	update_synergy_displayers()


func update_synergy_displayers():
	$VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer.active_synergies_res = active_synergies_res
	$VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer.non_active_dominant_synergies_res = non_active_dominant_synergies_res
	$VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer.non_active_composite_synergies_res = non_active_composite_synergies_res
	
	$VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer.update_display()
	
	yield(get_tree(), "idle_frame")
	$VBoxContainer/ScrollContainer.scroll_vertical = $VBoxContainer/ScrollContainer.get_v_scrollbar().max_value

