extends MarginContainer

const CustomButtonGroup = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/ButtonGroup.gd")
const GameResultManager = preload("res://GameElementsRelated/GameResultManager.gd")


signal round_start_pressed()


onready var speed_button_01 = $ContentPanel/Control/SpeedButton01
onready var speed_button_02 = $ContentPanel/Control/SpeedButton02
onready var speed_button_03 = $ContentPanel/Control/SpeedButton03

onready var arrow_pic_texture_rect = $ContentPanel/Control/ArrowPic
onready var start_button = $Control/ReadyButton

onready var status_label = $Control/StatusLabel

onready var stats_button = $StatsButton

#

var speed_of_engine_time_scale_arr : Array = [
	1, 2, 3
]
var all_speed_buttons : Array = []

var stage_round_manager setget set_stage_round_manager
var game_result_manager setget set_game_result_manager
var game_stats_manager setget set_game_stats_manager

var _curr_time_scale_to_use_on_ongoing_round : int = speed_of_engine_time_scale_arr[0]
var _curr_time_scale_index : int
var _button_group : CustomButtonGroup
var can_start_round : bool

#

func _ready():
	speed_button_01.set_text_for_text_label(str(ceil(speed_of_engine_time_scale_arr[0])))
	speed_button_02.set_text_for_text_label(str(ceil(speed_of_engine_time_scale_arr[1])))
	speed_button_03.set_text_for_text_label(str(ceil(speed_of_engine_time_scale_arr[2])))
	
	_button_group = CustomButtonGroup.new()
	
	all_speed_buttons.append(speed_button_01)
	all_speed_buttons.append(speed_button_02)
	all_speed_buttons.append(speed_button_03)
	
	for button in all_speed_buttons:
		button.can_be_untoggled_if_is_toggled = false
		button.configure_self_with_button_group(_button_group)
	
	stats_button.visible = false

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)
	stage_round_manager.connect("round_started", self, "_on_round_started", [], CONNECT_PERSIST)
	
	_make_arrow_follow_button(all_speed_buttons[0], true)
	
	stage_round_manager.connect("last_calculated_block_start_of_round_changed", self, "_on_SRM_last_calculated_block_start_of_round_changed", [], CONNECT_PERSIST)
	_on_SRM_last_calculated_block_start_of_round_changed(null) # val doesnt matter

func set_game_result_manager(arg_manager):
	#NOTE, manager is not yet initalized at this time, so don't do any calling of methods/vars of that manager. But connecting signals is fine.
	game_result_manager = arg_manager
	
	game_result_manager.connect("game_result_decided", self, "_on_game_result_decided", [], CONNECT_PERSIST)


func set_game_stats_manager(arg_manager):
	game_stats_manager = arg_manager


#

func _on_round_ended(arg_stageround):
	_update_engine_time_scale_based_on_curr_settings()
	start_button.visible = true

func _on_round_started(arg_stageround):
	_update_engine_time_scale_based_on_curr_settings()
	start_button.visible = false

func _update_engine_time_scale_based_on_curr_settings():
	if stage_round_manager.round_started:
		Engine.time_scale = _curr_time_scale_to_use_on_ongoing_round
	else:
		Engine.time_scale = 1.0


func _on_SpeedButton01_on_button_released_with_button_left():
	_curr_time_scale_to_use_on_ongoing_round = speed_of_engine_time_scale_arr[0]
	_curr_time_scale_index = 0
	_update_engine_time_scale_based_on_curr_settings()
	_make_arrow_follow_button(speed_button_01)

func _on_SpeedButton02_on_button_released_with_button_left():
	_curr_time_scale_to_use_on_ongoing_round = speed_of_engine_time_scale_arr[1]
	_curr_time_scale_index = 1
	_update_engine_time_scale_based_on_curr_settings()
	_make_arrow_follow_button(speed_button_02)

func _on_SpeedButton03_on_button_released_with_button_left():
	_curr_time_scale_to_use_on_ongoing_round = speed_of_engine_time_scale_arr[2]
	_curr_time_scale_index = 2
	_update_engine_time_scale_based_on_curr_settings()
	_make_arrow_follow_button(speed_button_03)



func _on_ReadyButton_on_button_released_with_button_left():
	_start_round()


func _start_round():
	if !stage_round_manager.round_started and can_start_round and !stage_round_manager.last_calculated_block_start_of_round:
		emit_signal("round_start_pressed")
		return true
	
	return false

# activated by game elements when [space] is pressed
func start_round_or_speed_toggle():
	var started = _start_round()
	if !started:
		_curr_time_scale_index += 1
		if _curr_time_scale_index >= speed_of_engine_time_scale_arr.size():
			_curr_time_scale_index = 0
		
		_curr_time_scale_to_use_on_ongoing_round = speed_of_engine_time_scale_arr[_curr_time_scale_index]
		_update_engine_time_scale_based_on_curr_settings()
		
		_make_arrow_follow_button(all_speed_buttons[_curr_time_scale_index], true)

##

func _make_arrow_follow_button(arg_button : Control, arg_do_setting : bool = false):
	arrow_pic_texture_rect.rect_position.x = (arg_button.rect_position.x) + (arg_button.rect_size.x / 2) - (arrow_pic_texture_rect.rect_size.x / 2)
	
	if arg_do_setting:
		arg_button.set_is_toggle_mode_on(true)

########

func _on_game_result_decided():
	stats_button.visible = true
	
	_on_SpeedButton01_on_button_released_with_button_left()
#	var game_result = game_result_manager.game_result
#
#	if game_result == GameResultManager.GameResult.DEFEAT:
#		status_label.text = "Defeat"
#	elif game_result == GameResultManager.GameResult.VICTORY:
#		status_label.text = "Victory"
#	elif game_result == GameResultManager.GameResult.DRAW:
#		status_label.text = "Draw"
#


func _on_StatsButton_on_button_released_with_button_left():
	if game_stats_manager != null:
		game_stats_manager.show_game_stats_panel()


###########

func _on_SRM_last_calculated_block_start_of_round_changed(_arg_val):  # val is unused
	start_button.is_button_enabled = !stage_round_manager.last_calculated_block_start_of_round
	
