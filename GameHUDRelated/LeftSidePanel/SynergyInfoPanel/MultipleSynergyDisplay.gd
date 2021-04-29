extends MarginContainer

var synergy_results : Array = []
var single_synergy_displayers : Array = []

const single_displayer_scene = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SingleSynergyDisplayer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()

func update_display():
	_kill_all_previous_displayers()
	
	for synergy_result in synergy_results:
		var single_displayer = single_displayer_scene.instance()
		single_displayer.result = synergy_result
		
		$VBoxContainer.add_child(single_displayer)
		single_synergy_displayers.append(single_displayer)

func _kill_all_previous_displayers():
	for displayer in single_synergy_displayers:
		if displayer != null:
			displayer.queue_free()
