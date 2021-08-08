extends MarginContainer

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const ColorSynergyChecker = preload("res://GameInfoRelated/ColorSynergyChecker.gd")

signal on_single_syn_tooltip_shown(synergy)
signal on_single_syn_tooltip_hidden(synergy)

var active_synergies_res : Array = []
var non_active_dominant_synergies_res : Array = []
var non_active_composite_synergies_res : Array = []

onready var active_and_nonactive_syn_displayer = $VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer
onready var scroll_container = $VBoxContainer/ScrollContainer

func _ready():
	active_and_nonactive_syn_displayer.connect("on_single_syn_tooltip_shown", self, "_on_single_syn_displayer_tooltip_shown", [], CONNECT_PERSIST)
	active_and_nonactive_syn_displayer.connect("on_single_syn_tooltip_hidden", self, "_on_single_syn_displayer_tooltip_hidden", [], CONNECT_PERSIST)
	
	update_synergy_displayers()


func update_synergy_displayers():
	active_and_nonactive_syn_displayer.active_synergies_res = active_synergies_res
	active_and_nonactive_syn_displayer.non_active_dominant_synergies_res = non_active_dominant_synergies_res
	active_and_nonactive_syn_displayer.non_active_composite_synergies_res = non_active_composite_synergies_res
	
	active_and_nonactive_syn_displayer.update_display()
	
	yield(get_tree(), "idle_frame")
	scroll_container.scroll_vertical = scroll_container.get_v_scrollbar().max_value


#

func _on_single_syn_displayer_tooltip_shown(syn):
	emit_signal("on_single_syn_tooltip_shown", syn)

func _on_single_syn_displayer_tooltip_hidden(syn):
	emit_signal("on_single_syn_tooltip_hidden", syn)
