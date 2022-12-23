extends MarginContainer

const Mesa_ChoicePanel = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI/ChoicePanel/Mesa_ChoicePanel.gd")
const Mesa_ChoicePanel_Scene = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI/ChoicePanel/Mesa_ChoicePanel.tscn")


var choices : Array setget set_choices

var _is_choices_set : bool = false

onready var hbox_container = $VBoxContainer/HBoxContainer

#

func set_choices(arg_choices : Array):
	choices = arg_choices
	
	if is_inside_tree():
		_update_display()


func _ready():
	if choices.size() > 0:
		_update_display()


func _update_display():
	if !_is_choices_set:
		_is_choices_set = true
		
		for choice in choices:
			var choice_panel = Mesa_ChoicePanel_Scene.instance()
			
			hbox_container.add_child(choice_panel)
			choice_panel.mesa_choice_details = choice

