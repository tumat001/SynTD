extends MarginContainer

const GeneralDialog = preload("res://MiscRelated/PlayerGUI_Category_Related/GeneralDialog/GeneralDialog.gd")
const GeneralDialog_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/GeneralDialog/GeneralDialog.tscn")
const GameControlPanel = preload("res://GameHUDRelated/PauseScreenPanel/GameControlPanel/GameControlPanel.gd")
const GameControlPanel_Scene = preload("res://GameHUDRelated/PauseScreenPanel/GameControlPanel/GameControlPanel.tscn")
const GameSettingsPanel = preload("res://GameHUDRelated/PauseScreenPanel/GameSettingsPanel/GameSettingsPanel.gd")
const GameSettingsPanel_Scene = preload("res://GameHUDRelated/PauseScreenPanel/GameSettingsPanel/GameSettingsPanel.tscn")

onready var resume_button = $VBoxContainer/ContentContainer/VBoxContainer/ResumeButton
onready var game_controls_button = $VBoxContainer/ContentContainer/VBoxContainer/GameControlsButton
onready var game_settings_button = $VBoxContainer/ContentContainer/VBoxContainer/GameSettingsButton
onready var game_mode_label_indicator = $VBoxContainer/VBoxContainer/ModeLabel

var pause_manager
var main_pause_screen_panel
var game_elements

var game_control_panel : GameControlPanel
var game_settings_panel : GameSettingsPanel
var quit_game_general_dialog : GeneralDialog
var restart_game_dialog : GeneralDialog
var _is_a_dialog_visible : bool


func _ready():
	resume_button.set_text_for_text_label("Resume")
	game_controls_button.set_text_for_text_label("Controls")
	game_settings_button.set_text_for_text_label("Settings")
	game_mode_label_indicator.text = "Game mode: %s" % game_elements.game_mode_type_info.mode_name
	
	set_process_unhandled_key_input(false)


func _on_ResumeButton_on_button_released_with_button_left():
	pause_manager.hide_or_remove_latest_from_pause_tree__and_unpause_if_empty()

func _on_GameControlsButton_on_button_released_with_button_left():
	if !is_instance_valid(game_control_panel):
		game_control_panel = GameControlPanel_Scene.instance()
		game_control_panel.main_pause_screen_panel = main_pause_screen_panel
		game_control_panel.hub_pause_panel = self
		game_control_panel.pause_manager = pause_manager
	
	main_pause_screen_panel.show_control_at_content_panel(game_control_panel)


func _on_GameSettingsButton_on_button_released_with_button_left():
	if !is_instance_valid(game_settings_panel):
		game_settings_panel = GameSettingsPanel_Scene.instance()
		game_settings_panel.main_pause_screen_panel = main_pause_screen_panel
		game_settings_panel.hub_pause_panel = self
		game_settings_panel.game_settings_manager = game_elements.game_settings_manager
	
	main_pause_screen_panel.show_control_at_content_panel(game_settings_panel)


func _on_MainMenuButton_on_button_released_with_button_left():
	if !is_instance_valid(quit_game_general_dialog):
		quit_game_general_dialog = GeneralDialog_Scene.instance()
		quit_game_general_dialog.connect("ok_button_released", self, "_on_quit_game_dialog__ok_chosen")
		quit_game_general_dialog.connect("cancel_button_released", self, "_on_quit_game_dialog__cancel_chosen")
		quit_game_general_dialog.size_flags_horizontal = SIZE_EXPAND | SIZE_SHRINK_CENTER
		quit_game_general_dialog.size_flags_vertical = SIZE_EXPAND | SIZE_SHRINK_CENTER
		add_child(quit_game_general_dialog)
		quit_game_general_dialog.set_title_label_text("Go back to main menu?")
		quit_game_general_dialog.set_content_label_text("Note: The game is not saved.")
	
	quit_game_general_dialog.start_dialog_prompt(GeneralDialog.DialogMode.OK_CANCEL)
	_is_a_dialog_visible = true

func _on_quit_game_dialog__ok_chosen():
	_is_a_dialog_visible = false
	game_elements.quit_game()

func _on_quit_game_dialog__cancel_chosen():
	_is_a_dialog_visible = false


func _on_RestartButton_on_button_released_with_button_left():
	if !is_instance_valid(restart_game_dialog):
		restart_game_dialog = GeneralDialog_Scene.instance()
		restart_game_dialog.connect("ok_button_released", self, "_on_restart_game_dialog__ok_chosen")
		restart_game_dialog.connect("cancel_button_released", self, "_on_restart_game_dialog__cancel_chosen")
		restart_game_dialog.size_flags_horizontal = SIZE_EXPAND | SIZE_SHRINK_CENTER
		restart_game_dialog.size_flags_vertical = SIZE_EXPAND | SIZE_SHRINK_CENTER
		add_child(restart_game_dialog)
		restart_game_dialog.set_title_label_text("")
		restart_game_dialog.set_content_label_text("Restart game?")
	
	restart_game_dialog.start_dialog_prompt(GeneralDialog.DialogMode.OK_CANCEL)
	_is_a_dialog_visible = true

func _on_restart_game_dialog__ok_chosen():
	_is_a_dialog_visible = false
	pause_manager.unpause_game__accessed_for_scene_change()
	CommsForBetweenScenes.goto_game_elements(game_elements)

func _on_restart_game_dialog__cancel_chosen():
	_is_a_dialog_visible = false

#

# name matters
func _on_exit_panel():
	_on_ResumeButton_on_button_released_with_button_left()

func _is_a_dialog_visible__for_main():
	return _is_a_dialog_visible
