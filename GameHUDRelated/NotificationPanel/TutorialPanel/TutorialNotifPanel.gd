extends MarginContainer

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")


var timer_for_char_appear : Timer
const char_appear_delay_delta : float = 0.03
const char_appear_count_per_delta : int = 2

var all_text_is_visible : bool
var _current_tooltip : BaseTowerSpecificTooltip
var _current_text_for_tooltip : String

onready var text_label = $MarginContainer/ContentPanel/HBoxContainer/TextLabel
onready var status_icon = $MarginContainer/ContentPanel/HBoxContainer/StatusIcon

#

func initialize():
	timer_for_char_appear = Timer.new()
	timer_for_char_appear.one_shot = false
	timer_for_char_appear.connect("timeout", self, "_on_char_timer_timeout", [], CONNECT_PERSIST)
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(timer_for_char_appear)

#

func set_text_and_icon(arg_text : String, arg_icon : Texture, arg_text_for_tooltip : String):
	_reset_num_of_char_visible()
	text_label.text = arg_text
	status_icon.texture = arg_icon
	_current_text_for_tooltip = arg_text_for_tooltip
	
	status_icon.modulate.a = 0
	
	_start_char_timer()
	visible = true

func _reset_num_of_char_visible():
	text_label.visible_characters = 0
	all_text_is_visible = false

func _start_char_timer():
	_turn_char_to_visible()
	timer_for_char_appear.start(char_appear_delay_delta)

func _on_char_timer_timeout():
	_turn_char_to_visible()
	

func _turn_char_to_visible(var amount = char_appear_count_per_delta):
	text_label.visible_characters += amount
	
	if text_label.percent_visible >= 1.0:
		timer_for_char_appear.stop()
		status_icon.modulate.a = 1
		all_text_is_visible = true

##

func hide_notif_panel():
	visible = false

func show_all_text_and_icon():
	_turn_char_to_visible(text_label.text.length())

##

func _on_StatusIcon_mouse_entered():
	if _current_tooltip == null:
		_current_tooltip = _construct_tooltip_for_status_icon()
	
	_current_tooltip.visible = true
	_current_tooltip.tooltip_owner = status_icon
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_current_tooltip)
	_current_tooltip.update_display()

func _construct_tooltip_for_status_icon() -> BaseTowerSpecificTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		_current_text_for_tooltip
	]
	
	return a_tooltip



