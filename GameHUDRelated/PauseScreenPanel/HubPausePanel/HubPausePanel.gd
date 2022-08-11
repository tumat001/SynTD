extends MarginContainer

const GameControlPanel = preload("res://GameHUDRelated/PauseScreenPanel/GameControlPanel/GameControlPanel.gd")
const GameControlPanel_Scene = preload("res://GameHUDRelated/PauseScreenPanel/GameControlPanel/GameControlPanel.tscn")
const GameSettingsPanel = preload("res://GameHUDRelated/PauseScreenPanel/GameSettingsPanel/GameSettingsPanel.gd")
const GameSettingsPanel_Scene = preload("res://GameHUDRelated/PauseScreenPanel/GameSettingsPanel/GameSettingsPanel.tscn")

onready var resume_button = $VBoxContainer/ContentContainer/VBoxContainer/ResumeButton
onready var game_controls_button = $VBoxContainer/ContentContainer/VBoxContainer/GameControlsButton
onready var game_settings_button = $VBoxContainer/ContentContainer/VBoxContainer/GameSettingsButton


var pause_manager
var main_pause_screen_panel
var game_elements

var game_control_panel : GameControlPanel
var game_settings_panel : GameSettingsPanel


func _ready():
	resume_button.set_text_for_text_label("Resume")
	game_controls_button.set_text_for_text_label("Controls")
	game_settings_button.set_text_for_text_label("Settings")
	
	set_process_unhandled_key_input(false)


func _on_ResumeButton_on_button_released_with_button_left():
	pause_manager.hide_or_remove_latest_from_pause_tree__and_unpause_if_empty()

func _on_GameControlsButton_on_button_released_with_button_left():
	if game_control_panel == null:
		game_control_panel = GameControlPanel_Scene.instance()
		game_control_panel.main_pause_screen_panel = main_pause_screen_panel
		game_control_panel.hub_pause_panel = self
		game_control_panel.pause_manager = pause_manager
	
	main_pause_screen_panel.show_control_at_content_panel(game_control_panel)


func _on_GameSettingsButton_on_button_released_with_button_left():
	if game_settings_panel == null:
		game_settings_panel = GameSettingsPanel_Scene.instance()
		game_settings_panel.main_pause_screen_panel = main_pause_screen_panel
		game_settings_panel.hub_pause_panel = self
		game_settings_panel.game_settings_manager = game_elements.game_settings_manager
	
	main_pause_screen_panel.show_control_at_content_panel(game_settings_panel)
