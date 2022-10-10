extends MarginContainer

const SingleDisplayer_Scene = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SingleSynergyDisplayer.tscn")

signal on_single_syn_tooltip_shown(synergy)
signal on_single_syn_tooltip_hidden(synergy)

signal on_single_syn_displayer_pressed(input_mouse_event, syn_check_result)

var synergy_results : Array = []
var single_synergy_displayers : Array = []
var game_settings_manager


# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()

func update_display():
	_kill_all_previous_displayers()
	
	for synergy_result in synergy_results:
		var single_displayer = SingleDisplayer_Scene.instance()
		single_displayer.result = synergy_result
		single_displayer.game_settings_manager = game_settings_manager
		
		single_displayer.connect("on_single_syn_tooltip_displayed", self, "_on_single_syn_displayer_tooltip_shown", [], CONNECT_PERSIST)
		single_displayer.connect("on_single_syn_tooltip_hidden", self, "_on_single_syn_displayer_tooltip_hidden", [], CONNECT_PERSIST)
		single_displayer.connect("on_single_syn_displayer_pressed", self, "_on_single_syn_displayer_pressed", [], CONNECT_PERSIST)
		
		$VBoxContainer.add_child(single_displayer)
		single_synergy_displayers.append(single_displayer)


func _kill_all_previous_displayers():
	for displayer in single_synergy_displayers:
		if is_instance_valid(displayer):
			displayer.queue_free()
			# do not erase displayer from the single_synergy_displayers

#

func _on_single_syn_displayer_tooltip_shown(syn):
	emit_signal("on_single_syn_tooltip_shown", syn)

func _on_single_syn_displayer_tooltip_hidden(syn):
	emit_signal("on_single_syn_tooltip_hidden", syn)

func _on_single_syn_displayer_pressed(event, syn_check_result):
	emit_signal("on_single_syn_displayer_pressed", event, syn_check_result)

#

func get_single_syn_displayer_with_synergy_name(arg_syn_name : String):
	for single_syn in single_synergy_displayers:
		if is_instance_valid(single_syn) and arg_syn_name == single_syn.get_synergy_name():
			return single_syn
	
	return null



