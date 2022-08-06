extends VBoxContainer

signal on_single_syn_tooltip_shown(synergy)
signal on_single_syn_tooltip_hidden(synergy)

signal on_single_syn_displayer_pressed(input_mouse_event, syn_check_result)

var active_synergies_res : Array = []
var non_active_dominant_synergies_res : Array = []
var non_active_composite_synergies_res : Array = []
var game_settings_manager setget set_game_settings_manager

onready var active_synergies_disp = $ActiveSynergies

onready var non_active_compo_syn_disp = $NonActiveCompositionSynergies
onready var non_active_dominant_syn_disp = $NonActiveDominantSynergies

onready var non_active_dom_separator = $NonActiveDominantSeparator
onready var non_active_compo_separator = $NonActiveCompositionSeparator


func set_game_settings_manager(arg_manager):
	game_settings_manager = arg_manager
	
	if is_inside_tree():
		active_synergies_disp.game_settings_manager = game_settings_manager
		non_active_compo_syn_disp.game_settings_manager = game_settings_manager
		non_active_dominant_syn_disp.game_settings_manager = game_settings_manager



# Called when the node enters the scene tree for the first time.
func _ready():
	active_synergies_disp.connect("on_single_syn_tooltip_shown", self, "_on_single_syn_displayer_tooltip_shown", [], CONNECT_PERSIST)
	active_synergies_disp.connect("on_single_syn_tooltip_hidden", self, "_on_single_syn_displayer_tooltip_hidden", [], CONNECT_PERSIST)
	active_synergies_disp.connect("on_single_syn_displayer_pressed", self, "_on_single_syn_displayer_pressed", [], CONNECT_PERSIST)
	
	non_active_compo_syn_disp.connect("on_single_syn_tooltip_shown", self, "_on_single_syn_displayer_tooltip_shown", [], CONNECT_PERSIST)
	non_active_compo_syn_disp.connect("on_single_syn_tooltip_hidden", self, "_on_single_syn_displayer_tooltip_hidden", [], CONNECT_PERSIST)
	non_active_compo_syn_disp.connect("on_single_syn_displayer_pressed", self, "_on_single_syn_displayer_pressed", [], CONNECT_PERSIST)
	
	non_active_dominant_syn_disp.connect("on_single_syn_tooltip_shown", self, "_on_single_syn_displayer_tooltip_shown", [], CONNECT_PERSIST)
	non_active_dominant_syn_disp.connect("on_single_syn_tooltip_hidden", self, "_on_single_syn_displayer_tooltip_hidden", [], CONNECT_PERSIST)
	non_active_dominant_syn_disp.connect("on_single_syn_displayer_pressed", self, "_on_single_syn_displayer_pressed", [], CONNECT_PERSIST)
	
	
	active_synergies_disp.game_settings_manager = game_settings_manager
	non_active_compo_syn_disp.game_settings_manager = game_settings_manager
	non_active_dominant_syn_disp.game_settings_manager = game_settings_manager
	
	update_display()


func update_display():
	active_synergies_disp.synergy_results = active_synergies_res
	active_synergies_disp.update_display()
	#if active_synergies_res.size() == 0:
		#$ActiveSeparator.visible = false
	#else:
		#$ActiveSeparator.visible = true
	
	non_active_dominant_syn_disp.synergy_results = non_active_dominant_synergies_res
	non_active_dominant_syn_disp.update_display()
	if non_active_dominant_synergies_res.size() == 0:
		non_active_dom_separator.visible = false
	else:
		non_active_dom_separator.visible = true
	
	non_active_compo_syn_disp.synergy_results = non_active_composite_synergies_res
	non_active_compo_syn_disp.update_display()
	if non_active_composite_synergies_res.size() == 0:
		non_active_compo_separator.visible = false
	else:
		non_active_compo_separator.visible = true


# 

func _on_single_syn_displayer_tooltip_shown(syn):
	emit_signal("on_single_syn_tooltip_shown", syn)

func _on_single_syn_displayer_tooltip_hidden(syn):
	emit_signal("on_single_syn_tooltip_hidden", syn)

func _on_single_syn_displayer_pressed(event, syn_check_result):
	emit_signal("on_single_syn_displayer_pressed", event, syn_check_result)
