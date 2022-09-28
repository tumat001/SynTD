extends MarginContainer

const StageRoundManager = preload("res://GameElementsRelated/StageRoundManager.gd")
const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")


const modulate_lose := Color(218/255.0, 2/255.0, 5/255.0, 1)
const modulate_win := Color(2/255.0, 218/255.0, 55/255.0, 1)
const modulate_curr_round := Color(1, 1, 1, 1)
const modulate_future_round := Color(0.6, 0.6, 0.6, 1)

var stage_round_manager : StageRoundManager setget set_stage_round_manager

var _round_icon_local_positions_of_slot : Array
var _all_round_icons__in_order_as_seen : Array
var _offset_stageround_amount_based_on_icon_count : int

var _all_arrows : Array

#
const _base_slide_accel : float = 10.0

var _performing_arrow_slide : bool = false
var _arrow_slide_to_x_local_pos : float
var _current_arrow_slide_speed : float = 0
var _curr_arrow_index_pointing_at : int

var _performing_icon_slide : bool = false
var _current_icon_slide_speed : float = 0
var _base_icon_slide_x_amount : float
var _current_icon_slide_total_amount : float = 0


onready var round_icon_01 = $HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon01
onready var round_icon_02 = $HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon02
onready var round_icon_03 = $HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon03
onready var round_icon_04 = $HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon04
onready var round_icon_05 = $HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon05

onready var arrow_top = $HBoxContainer/VBoxContainer/MarginContainer/ArrowContainers/ArrowTop
onready var arrow_bottom = $HBoxContainer/VBoxContainer/MarginContainer/ArrowContainers/ArrowBottom

onready var stageround_id_label = $HBoxContainer/MarginContainer/MiddlePanel2/MarginContainer/StageroundLabel

#

func _ready():
	_all_round_icons__in_order_as_seen.append(round_icon_01)
	_all_round_icons__in_order_as_seen.append(round_icon_02)
	_all_round_icons__in_order_as_seen.append(round_icon_03)
	_all_round_icons__in_order_as_seen.append(round_icon_04)
	_all_round_icons__in_order_as_seen.append(round_icon_05)
	
	for icon in _all_round_icons__in_order_as_seen:
		_round_icon_local_positions_of_slot.append(icon.rect_position)
		icon.modulate = modulate_future_round
	
	_base_icon_slide_x_amount = (_round_icon_local_positions_of_slot[1].x - _round_icon_local_positions_of_slot[0].x)
	
	_offset_stageround_amount_based_on_icon_count = _all_round_icons__in_order_as_seen.size() - 3
	
	_all_arrows.append(arrow_bottom)
	_all_arrows.append(arrow_top)
	
	for arrow in _all_arrows:
		arrow.rect_position.x = _get_arrow_to_be_pos_x_adjusted(_round_icon_local_positions_of_slot[0].x)

func _get_arrow_to_be_pos_x_adjusted(arg_intended_x):
	return (arg_intended_x + (round_icon_01.texture.get_size().x / 2) - (arrow_top.texture.get_size().x / 4))


#

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_ended_game_start_aware", [], CONNECT_PERSIST)
	stage_round_manager.connect("end_of_stagerounds", self, "_on_end_of_stagerounds", [], CONNECT_PERSIST)
	
	if stage_round_manager.stagerounds != null:
		_initialize_round_indicator_slots()
	else:
		stage_round_manager.connect("stage_rounds_set", self, "_on_stage_rounds_set", [], CONNECT_ONESHOT)

func _on_stage_rounds_set(arg_stage_rounds):
	_initialize_round_indicator_slots()

func _initialize_round_indicator_slots():
	var index : int = 0
	for icon_tex_rect in _all_round_icons__in_order_as_seen:
		_set_round_icon_to_appropriate_icon(icon_tex_rect, stage_round_manager.stagerounds.stage_rounds, index)
		index += 1

#

func _set_round_icon_to_appropriate_icon(arg_icon_text_rect : TextureRect, arg_stage_rounds : Array, arg_index : int):
	if arg_stage_rounds.size() > arg_index:
		arg_icon_text_rect.texture = arg_stage_rounds[arg_index].round_icon
		arg_icon_text_rect.visible = true
	else:
		arg_icon_text_rect.visible = false

func _set_latest_round_icon_to_appropriate_icon(arg_stage_rounds : Array, arg_index : int):
	if _all_round_icons__in_order_as_seen.size() != 0:
		_set_round_icon_to_appropriate_icon(_all_round_icons__in_order_as_seen[_all_round_icons__in_order_as_seen.size() - 1], arg_stage_rounds, arg_index)


func _on_round_ended_game_start_aware(arg_stage_round, arg_is_game_start):
	if !arg_is_game_start:
		
		_set_modulate_of_curr_round_icon()
		
		var icon_at_next = _all_round_icons__in_order_as_seen[_curr_arrow_index_pointing_at + 1]
		icon_at_next.modulate = modulate_curr_round
		
		if _curr_arrow_index_pointing_at == 0:
			_perform_sliding_animation_of_arrows(_get_arrow_to_be_pos_x_adjusted(_round_icon_local_positions_of_slot[1].x), 1)
		else:
			var index_to_configure = stage_round_manager.current_stageround_index + _offset_stageround_amount_based_on_icon_count
			_set_latest_round_icon_to_appropriate_icon(stage_round_manager.stagerounds.stage_rounds, index_to_configure)
			
			_perform_sliding_animation_of_icons()
		
		
	else:
		var icon_at_curr = _all_round_icons__in_order_as_seen[_curr_arrow_index_pointing_at]
		icon_at_curr.modulate = modulate_curr_round
	
	stageround_id_label.text = "%s-%s" % [stage_round_manager.current_stageround.stage_num, stage_round_manager.current_stageround.round_num]

func _set_modulate_of_curr_round_icon():
	var icon_at_curr = _all_round_icons__in_order_as_seen[_curr_arrow_index_pointing_at]
	if stage_round_manager.current_round_lost:
		icon_at_curr.modulate = modulate_lose
	else:
		icon_at_curr.modulate = modulate_win


func _on_end_of_stagerounds():
	_set_modulate_of_curr_round_icon()


#

func _perform_sliding_animation_of_icons():
	_current_icon_slide_speed = 0
	_current_icon_slide_total_amount = 0
	_performing_icon_slide = true
	set_process(true)

func _perform_sliding_animation_of_arrows(arg_to_x_pos : float, arg_icon_index : int):
	_arrow_slide_to_x_local_pos = arg_to_x_pos
	_current_arrow_slide_speed = 0
	_performing_arrow_slide = true
	set_process(true)
	
	_curr_arrow_index_pointing_at = arg_icon_index


func _process(delta):
	if _performing_arrow_slide:
		_current_arrow_slide_speed += _base_slide_accel * delta
		
		for arrow in _all_arrows:
			arrow.rect_position.x += _current_arrow_slide_speed
			if arrow.rect_position.x >= _arrow_slide_to_x_local_pos:
				_performing_arrow_slide = false
				arrow.rect_position.x = _arrow_slide_to_x_local_pos
	
	
	if _performing_icon_slide:
		_current_icon_slide_speed += _base_slide_accel * delta
		_current_icon_slide_total_amount += _current_icon_slide_speed
		
		var icon_index : int = 0
		for icon in _all_round_icons__in_order_as_seen:
			icon.rect_position.x -= _current_icon_slide_speed
			
			if _base_icon_slide_x_amount <= _current_icon_slide_total_amount:
				_performing_icon_slide = false
				icon.rect_position.x = (_base_icon_slide_x_amount * icon_index) - _base_icon_slide_x_amount
			
			icon_index += 1
		
		if !_performing_icon_slide: #ended slide, do swapping here
			var icon = _all_round_icons__in_order_as_seen.pop_front()
			icon.rect_position.x = _round_icon_local_positions_of_slot.back().x
			icon.modulate = modulate_future_round
			_all_round_icons__in_order_as_seen.append(icon)
			
	
	if !_performing_arrow_slide and !_performing_icon_slide:
		set_process(false)

###

