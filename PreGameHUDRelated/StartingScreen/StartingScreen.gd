extends Control

const GeneralDialog = preload("res://MiscRelated/PlayerGUI_Category_Related/GeneralDialog/GeneralDialog.gd")
const GeneralDialog_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/GeneralDialog/GeneralDialog.tscn")
const WholeMapSelectionScreen = preload("res://PreGameHUDRelated/MapSelectionScreen/WholeMapSelectionScreen.gd")
const WholeMapSelectionScreen_Scene = preload("res://PreGameHUDRelated/MapSelectionScreen/WholeMapSelectionScreen.tscn")
const TutorialHubScreen = preload("res://PreGameHUDRelated/TutorialHubScreen/TutorialHubScreen.gd")
const TutorialHubScreen_Scene = preload("res://PreGameHUDRelated/TutorialHubScreen/TutorialHubScreen.tscn")
const AboutPanel = preload("res://PreGameHUDRelated/AboutPanel/AboutPanel.gd")
const AboutPanel_Scene = preload("res://PreGameHUDRelated/AboutPanel/AboutPanel.tscn")
const Almanac_Page = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/Almanac_Page/Almanac_Page.gd")
const Almanac_Page_Scene = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/Almanac_Page/Almanac_Page.tscn")

const StartingScreen_WholeScreen_Phase_02_01 = preload("res://PreGameHUDRelated/StartingScreen/Assets/StartingScreen_WholeScreen_Phase02_01.png")
const StartingScreen_WholeScreen_Phase_02_02 = preload("res://PreGameHUDRelated/StartingScreen/Assets/StartingScreen_WholeScreen_Phase02_02.png")

#

const background_selection : Array = [
	StartingScreen_WholeScreen_Phase_02_01,
	StartingScreen_WholeScreen_Phase_02_02
]

#

var pre_game_screen setget set_pre_game_screen

var quit_game_general_dialog : GeneralDialog
var whole_map_selection_screen : WholeMapSelectionScreen
var tutorial_hub_screen : TutorialHubScreen
var about_panel : AboutPanel
var almanac_page : Almanac_Page

onready var general_container = $GeneralContainer

onready var whole_screen_texture_rect = $Aesthetics/WholeScreen

#

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")
	
	_set_background_to_random_wholescreen_background()
	
	_on_visibility_changed()


func _set_background_to_random_wholescreen_background():
	var texture = StoreOfRNG.randomly_select_one_element(background_selection, StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL))
	whole_screen_texture_rect.texture = texture


#

func _on_visibility_changed():
	set_process_unhandled_key_input(visible)
	
	if is_instance_valid(pre_game_screen):
		pre_game_screen.set_should_show_back_button(!visible)

func set_pre_game_screen(arg_screen):
	pre_game_screen = arg_screen
	
	pre_game_screen.set_should_show_back_button(!visible)


#

func _on_PlayButton_on_button_released_with_button_left():
	if !is_instance_valid(whole_map_selection_screen):
		whole_map_selection_screen = WholeMapSelectionScreen_Scene.instance()
		whole_map_selection_screen.pre_game_screen = pre_game_screen
	
	pre_game_screen.show_control(whole_map_selection_screen)


#

func _on_TutorialButton_on_button_released_with_button_left():
	if !is_instance_valid(tutorial_hub_screen):
		tutorial_hub_screen = TutorialHubScreen_Scene.instance()
		tutorial_hub_screen.pre_game_screen = pre_game_screen
	
	pre_game_screen.show_control(tutorial_hub_screen)

#

func _on_AlmanacButton_on_button_released_with_button_left():
	if !is_instance_valid(almanac_page):
		almanac_page = Almanac_Page_Scene.instance()
		if !AlmanacManager.is_connected("requested_exit_almanac", self, "_on_requested_exit_almanac"):
			AlmanacManager.connect("requested_exit_almanac", self, "_on_requested_exit_almanac", [], CONNECT_PERSIST)
	
	pre_game_screen.show_control(almanac_page)
	AlmanacManager.set_almanac_page_gui(almanac_page)
	
	pre_game_screen.set_should_show_back_button(false)

func _on_requested_exit_almanac():
	pre_game_screen.hide_control(almanac_page)
	pre_game_screen.set_should_show_back_button(false)


#

func _on_QuitButton_on_button_released_with_button_left():
	if !is_instance_valid(quit_game_general_dialog):
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

func _on_AboutButton_on_button_released_with_button_left():
	if !is_instance_valid(about_panel):
		about_panel = AboutPanel_Scene.instance()
		general_container.add_child(about_panel)
	
	about_panel.show_panel()

#

func _unhandled_key_input(event : InputEventKey):
	if !event.echo and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			_on_QuitButton_on_button_released_with_button_left()
	
	accept_event()

