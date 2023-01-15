extends MarginContainer

const AbilityPanel = preload("res://GameHUDRelated/AbilityPanel/AbilityPanel.gd")

signal round_start_pressed()
#signal round_fast_forward_pressed
#signal round_normal_speed_pressed


const pic_round_start_button = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStartButton.png")
const pic_round_fast_forward_button = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundFastForwardButton.png")
const pic_round_normal_speed_button = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundNormalSpeedButton.png")

#onready var round_status_button : TextureButton = $VBoxContainer/MarginContainer/RoundStatusButton
#onready var round_info_panel : RoundInfoPanel = $VBoxContainer/RoundInfoPanel
onready var ability_panel : AbilityPanel = $VBoxContainer/AbilityPanel
onready var round_info_panel_v2 = $VBoxContainer/RoundInfoPanel_V2
onready var round_speed_and_start_panel = $RoundSpeedAndStartPanel

var round_started : bool
#var round_fast_forwarded : bool

var game_settings_manager setget set_game_settings_manager
var game_elements setget set_game_elements
var enemy_manager setget set_enemy_manager

var can_start_round : bool = true setget set_can_start_round

#

func _ready():
	set_can_start_round(can_start_round)


func set_enemy_manager(arg_manager):
	enemy_manager = arg_manager
	round_info_panel_v2.set_enemy_manager(arg_manager)

func set_game_settings_manager(arg_manager):
	game_settings_manager = arg_manager
	ability_panel.game_settings_manager = arg_manager

func set_game_elements(arg_elements):
	game_elements = arg_elements
	
	round_info_panel_v2.set_heath_manager(game_elements.health_manager)
	round_info_panel_v2.set_stage_round_manager(game_elements.stage_round_manager)
	
	round_speed_and_start_panel.stage_round_manager = game_elements.stage_round_manager
	round_speed_and_start_panel.connect("round_start_pressed", self, "_on_button_for_round_ready_start", [], CONNECT_PERSIST)
	round_speed_and_start_panel.set_game_stats_manager(game_elements.game_stats_manager)

func set_game_result_manager(arg_manager):
	round_speed_and_start_panel.set_game_result_manager(arg_manager)

#


#func _update_round_started():
#	emit_signal("round_start_pressed")
#	if round_fast_forwarded:
#		_update_fast_forwarded()
#	else:
#		_update_normal_speed()
#
#	round_started = true
#
#
#func _update_round_ended():
#	round_status_button.texture_normal = pic_round_start_button
#	round_started = false
#
#	Engine.time_scale = 1.0
#
#
#func _update_fast_forwarded():
#	round_fast_forwarded = true
#	round_status_button.texture_normal = pic_round_fast_forward_button
#	Engine.time_scale = 2.0
#
#func _update_normal_speed():
#	round_fast_forwarded = false
#	round_status_button.texture_normal = pic_round_normal_speed_button
#	Engine.time_scale = 1.0
#
#
#func _on_RoundStatusButton_pressed(): # used by game elements when space is pressed (or whatever control is used for round advance)
#	if !round_started:
#		if can_start_round:
#			_update_round_started()
#	else:
#		if round_fast_forwarded:
#			_update_normal_speed()
#		else:
#			_update_fast_forwarded()

func start_round_or_speed_toggle(): # used by game elements
	round_speed_and_start_panel.start_round_or_speed_toggle()

func _on_button_for_round_ready_start():
	emit_signal("round_start_pressed")


#

func set_can_start_round(arg_val : bool):
	can_start_round = arg_val
	
	round_speed_and_start_panel.can_start_round = can_start_round
	#round_status_button.visible = can_start_round


#


func _on_MainMenuButton_released_mouse_event(event : InputEventMouseButton):
	if event.button_index == BUTTON_LEFT:
		game_elements._esc_no_wholescreen_gui_pressed()

#

func get_heart_icon_global_pos():
	return round_info_panel_v2.get_heart_icon_global_pos()
