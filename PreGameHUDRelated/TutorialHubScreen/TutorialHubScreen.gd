extends MarginContainer


onready var tutorial_chapters_list_panel = $ContentContainer/HBoxContainer/ChapterListContainer/VBoxContainer/TutorialChaptersListPanel
onready var tutorial_descriptions_panel = $ContentContainer/HBoxContainer/DescContainer/VBoxContainer/TutorialDescriptionPanel

var pre_game_screen

func _ready():
	tutorial_chapters_list_panel.connect("on_tutorial_toggled", self, "_on_toggled_tutorial_button_changed")
	tutorial_descriptions_panel.pre_game_screen = pre_game_screen
	tutorial_descriptions_panel.set_game_mode_id_of_play_button(-1)
	
	connect("visibility_changed", self, "_on_visibility_changed")
	_on_visibility_changed()


func _on_visibility_changed():
	set_process_unhandled_key_input(visible)
	

#

func _on_toggled_tutorial_button_changed(arg_descs, arg_game_mode_id):
	tutorial_descriptions_panel.set_descriptions(arg_descs)
	tutorial_descriptions_panel.set_game_mode_id_of_play_button(arg_game_mode_id)


#

func _unhandled_key_input(event : InputEventKey):
	if !event.echo and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			_exit_to_previous()
	
	accept_event()

func _exit_to_previous():
	pre_game_screen.hide_or_remove_latest_from_node_tree__except_for_starting_screen()


