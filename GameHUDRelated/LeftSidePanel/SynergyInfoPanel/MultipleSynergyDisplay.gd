extends MarginContainer

const SingleDisplayer_Scene = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SingleSynergyDisplayer.tscn")


signal on_single_syn_tooltip_shown(synergy)
signal on_single_syn_tooltip_hidden(synergy)

var synergy_results : Array = []
var single_synergy_displayers : Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()

func update_display():
	_kill_all_previous_displayers()
	
	for synergy_result in synergy_results:
		var single_displayer = SingleDisplayer_Scene.instance()
		single_displayer.result = synergy_result
		
		single_displayer.connect("on_single_syn_tooltip_displayed", self, "_on_single_syn_displayer_tooltip_shown", [], CONNECT_PERSIST)
		single_displayer.connect("on_single_syn_tooltip_hidden", self, "_on_single_syn_displayer_tooltip_hidden", [], CONNECT_PERSIST)
		
		$VBoxContainer.add_child(single_displayer)
		single_synergy_displayers.append(single_displayer)

func _kill_all_previous_displayers():
	for displayer in single_synergy_displayers:
		if displayer != null:
			displayer.queue_free()


#

func _on_single_syn_displayer_tooltip_shown(syn):
	emit_signal("on_single_syn_tooltip_shown", syn)

func _on_single_syn_displayer_tooltip_hidden(syn):
	emit_signal("on_single_syn_tooltip_hidden", syn)

