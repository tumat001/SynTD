extends MarginContainer

const Black_PathChoiceButton_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/GUI/PathChoiceButton/Black_PathChoiceButton.tscn")


signal on_path_hovered(path)
signal on_path_selected(path)

#

var black_dom_syn setget set_black_dom_syn

onready var path_choice_button_container = $VBoxContainer/Marginer/PathChoiceButtonContainer


func set_black_dom_syn(arg_syn):
	black_dom_syn = arg_syn
	
	_create_path_choice_buttons()


func _create_path_choice_buttons():
	for path in black_dom_syn.all_black_paths:
		var path_choice_button = Black_PathChoiceButton_Scene.instance()
		
		path_choice_button.set_black_path(path)
		path_choice_button.connect("on_path_hovered", self, "_on_path_button_hovered", [], CONNECT_PERSIST)
		path_choice_button.connect("on_path_selected", self, "_on_path_button_selected", [], CONNECT_PERSIST)
		
		#path_choice_button_container.add_child(path_choice_button)
		path_choice_button_container.call_deferred("add_child", path_choice_button)
		


#

func _on_path_button_hovered(arg_path):
	emit_signal("on_path_hovered", arg_path)

func _on_path_button_selected(arg_path):
	emit_signal("on_path_selected", arg_path)

