extends MarginContainer

const StageRoundManager = preload("res://GameElementsRelated/StageRoundManager.gd")
const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")
const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
const BaseTowerSpecificTooltip_GreenHeader_Pic = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip_HeaderBackground_Green.png")

const SV_Border_Pic_01 = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/RoundIndicatorPanel/Assets/StrengthValueBorder_01.png")
const SV_Border_Pic_02 = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/RoundIndicatorPanel/Assets/StrengthValueBorder_02.png")
const SV_Border_Pic_03 = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/RoundIndicatorPanel/Assets/StrengthValueBorder_03.png")
const SV_Border_Pic_04 = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/RoundIndicatorPanel/Assets/StrengthValueBorder_04.png")
const SV_Border_Pic_05 = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/RoundIndicatorPanel/Assets/StrengthValueBorder_05.png")


const modulate_lose := Color(218/255.0, 2/255.0, 5/255.0, 1)
const modulate_win := Color(2/255.0, 218/255.0, 55/255.0, 1)
const modulate_curr_round := Color(1, 1, 1, 1)
const modulate_future_round := Color(0.6, 0.6, 0.6, 1)

var stage_round_manager : StageRoundManager setget set_stage_round_manager
var enemy_manager setget set_enemy_manager

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

const round_count_left_base_string = "%s\n%s"

var _current_tooltip : BaseTowerSpecificTooltip

onready var round_icon_01 = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon01
onready var round_icon_02 = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon02
onready var round_icon_03 = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon03
onready var round_icon_04 = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon04
onready var round_icon_05 = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/MiddlePanel/ContentPanel/RoundIconsPanel/RoundIcon05

onready var arrow_top = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/ArrowContainers/ArrowTop
onready var arrow_bottom = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/ArrowContainers/ArrowBottom

onready var stageround_id_label = $VBoxContainer/HBoxContainer/MarginContainer/MiddlePanel2/MarginContainer/StageroundLabel

onready var stageround_count_label = $VBoxContainer/HBoxContainer2/MarginContainer2/MiddlePanel2/RoundsCountContaner/RoundsCountLabel
onready var stageround_count_container = $VBoxContainer/HBoxContainer2/MarginContainer2/MiddlePanel2/RoundsCountContaner

onready var first_enemy_damage_label = $VBoxContainer/HBoxContainer2/MarginContainer3/MiddlePanel2/FirstEnemyDamageContainer/HBoxContainer/FirstEnemyDamageLabel
onready var first_enemy_damage_container = $VBoxContainer/HBoxContainer2/MarginContainer3/MiddlePanel2/FirstEnemyDamageContainer

onready var sv_texture_rect = $VBoxContainer/HBoxContainer2/MarginContainerSV/SVArt
onready var sv_label = $VBoxContainer/HBoxContainer2/MarginContainerSV/TextMarginer/SVLabel
onready var sv_container = $VBoxContainer/HBoxContainer2/MarginContainerSV

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
	
	sv_container.visible = false

func _get_arrow_to_be_pos_x_adjusted(arg_intended_x):
	return (arg_intended_x + (round_icon_01.texture.get_size().x / 2) - (arrow_top.texture.get_size().x / 4))


#

func set_enemy_manager(arg_manager):
	enemy_manager = arg_manager
	
	enemy_manager.connect("enemy_strength_value_changed", self, "_on_enemy_strength_value_changed", [], CONNECT_PERSIST)

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
	
	update_round_count_and_first_enemy_dmg_label()

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

func update_round_count_and_first_enemy_dmg_label():
	stageround_count_label.text = round_count_left_base_string % [str(stage_round_manager.current_stageround_index + 1), str(stage_round_manager.stageround_total_count)]
	first_enemy_damage_label.text = str(enemy_manager.enemy_first_damage)

##


func _on_FirstEnemyDamageContainer_mouse_entered():
	if !is_instance_valid(_current_tooltip):
		_current_tooltip = BaseTowerSpecificTooltip_Scene.instance()
		_current_tooltip.descriptions = ["The first enemy that escapes in this round deals additional %s damage." % first_enemy_damage_label.text]
		_current_tooltip.custom_header_texture = BaseTowerSpecificTooltip_GreenHeader_Pic
		_current_tooltip.visible = true
		_current_tooltip.tooltip_owner = first_enemy_damage_container
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_current_tooltip)
		_current_tooltip.update_display()
	else:
		_current_tooltip.queue_free()
		_current_tooltip = null

func _on_RoundsCountContaner_mouse_entered():
	if !is_instance_valid(_current_tooltip):
		_current_tooltip = BaseTowerSpecificTooltip_Scene.instance()
		_current_tooltip.descriptions = ["You are at wave %s out of %s" % [str(stage_round_manager.current_stageround_index + 1), str(stage_round_manager.stageround_total_count)]]
		_current_tooltip.custom_header_texture = BaseTowerSpecificTooltip_GreenHeader_Pic
		_current_tooltip.visible = true
		_current_tooltip.tooltip_owner = first_enemy_damage_container
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_current_tooltip)
		_current_tooltip.update_display()
	else:
		_current_tooltip.queue_free()
		_current_tooltip = null


func _on_RoundsCountContaner_mouse_exited():
	if is_instance_valid(_current_tooltip):
		_current_tooltip.queue_free()
		_current_tooltip = null

func _on_FirstEnemyDamageContainer_mouse_exited():
	if is_instance_valid(_current_tooltip):
		_current_tooltip.queue_free()
		_current_tooltip = null

########

func _on_enemy_strength_value_changed(arg_val):
	sv_container.visible = true
	
	if arg_val == 1:
		sv_texture_rect.texture = SV_Border_Pic_01
	elif arg_val == 2:
		sv_texture_rect.texture = SV_Border_Pic_02
	elif arg_val == 3:
		sv_texture_rect.texture = SV_Border_Pic_03
	elif arg_val == 4:
		sv_texture_rect.texture = SV_Border_Pic_04
	elif arg_val == 5:
		sv_texture_rect.texture = SV_Border_Pic_05
	
	sv_label.text = str(arg_val)



func _on_SVArt_mouse_entered():
	if !is_instance_valid(_current_tooltip):
		_current_tooltip = BaseTowerSpecificTooltip_Scene.instance()
		_current_tooltip.descriptions = _get_descriptions_based_on_sv()
		_current_tooltip.custom_header_texture = BaseTowerSpecificTooltip_GreenHeader_Pic
		_current_tooltip.visible = true
		_current_tooltip.tooltip_owner = sv_texture_rect
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_current_tooltip)
		_current_tooltip.update_display()
	else:
		_current_tooltip.queue_free()
		_current_tooltip = null

func _get_descriptions_based_on_sv():
	var sv = enemy_manager.get_current_strength_value()
	
	if sv == 1:
		return ["The enemies sent in this round are rather weak."]
	elif sv == 2:
		return ["The enemies sent in this round are standard in strength."]
	elif sv == 3:
		return ["The enemies sent in this round are quite strong."]
	elif sv == 4:
		return ["The enemies sent in this round are very powerful."]
	elif sv == 5:
		return ["The enemies sent is this round are overwhelming."]

func _on_SVArt_mouse_exited():
	if is_instance_valid(_current_tooltip):
		_current_tooltip.queue_free()
		_current_tooltip = null
