extends Control

const GeneralDialog = preload("res://MiscRelated/PlayerGUI_Category_Related/GeneralDialog/GeneralDialog.gd")
const GeneralDialog_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/GeneralDialog/GeneralDialog.tscn")
const WholeMapSelectionScreen = preload("res://PreGameHUDRelated/MapSelectionScreen/WholeMapSelectionScreen.gd")
const WholeMapSelectionScreen_Scene = preload("res://PreGameHUDRelated/MapSelectionScreen/WholeMapSelectionScreen.tscn")
const TutorialHubScreen = preload("res://PreGameHUDRelated/TutorialHubScreen/TutorialHubScreen.gd")
const TutorialHubScreen_Scene = preload("res://PreGameHUDRelated/TutorialHubScreen/TutorialHubScreen.tscn")


var pre_game_screen

var quit_game_general_dialog : GeneralDialog
var whole_map_selection_screen : WholeMapSelectionScreen
var tutorial_hub_screen : TutorialHubScreen

onready var general_container = $GeneralContainer

#

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")
	_on_visibility_changed()

func _on_visibility_changed():
	set_process_unhandled_key_input(visible)

#

func _on_PlayButton_on_button_released_with_button_left():
	if whole_map_selection_screen == null:
		whole_map_selection_screen = WholeMapSelectionScreen_Scene.instance()
		whole_map_selection_screen.pre_game_screen = pre_game_screen
	
	pre_game_screen.show_control(whole_map_selection_screen)


#

func _on_TutorialButton_on_button_released_with_button_left():
	if tutorial_hub_screen == null:
		tutorial_hub_screen = TutorialHubScreen_Scene.instance()
		tutorial_hub_screen.pre_game_screen = pre_game_screen
	
	pre_game_screen.show_control(tutorial_hub_screen)



#

func _on_QuitButton_on_button_released_with_button_left():
	if quit_game_general_dialog == null:
		quit_game_general_dialog = GeneralDialog_Scene.instance()
		quit_game_general_dialog.connect("ok_button_released", self, "_on_quit_game_dialog__ok_chosen")
		quit_game_general_dialog.size_flags_horizontal = SIZE_EXPAND | SIZE_SHRINK_CENTER
		quit_game_general_dialog.size_flags_vertical = SIZE_EXPAND | SIZE_SHRINK_CENTER
		general_container.add_child(quit_game_general_dialog)
		quit_game_general_dialog.set_title_label_text("")
		quit_game_general_dialog.set_content_label_text("Quit the game?")
	
	quit_game_general_dialog.start_dialog_prompt(GeneralDialog.DialogMode.OK_CANCEL)

func _on_quit_game_dialog__ok_chosen():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)



#

func _unhandled_key_input(event : InputEventKey):
	if !event.echo and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			_on_QuitButton_on_button_released_with_button_left()
	
	accept_event()

