extends MarginContainer


var _header_text : String
var _content_text : String

onready var _header_label = $VBoxContainer/BodyMarginer/ContentContainer/VBoxContainer/HeaderLabel
onready var _content_label = $VBoxContainer/BodyMarginer/ContentContainer/VBoxContainer/ContentLabel
onready var _vbox = $VBoxContainer

const INFINITE_DURATION = -1
const default_notif_duration : float = 5.0
var _push_notif_timer : Timer

#

func push_notification(arg_content_text : String, arg_header_text : String = "", arg_duration : float = default_notif_duration, arg_ignore_game_speed : bool = true):
	_vbox.rect_size.x = 0
	_vbox.rect_size.y = 0
	
	_set_content_text(arg_content_text)
	_set_header_text(arg_header_text)
	visible = true
	
	if arg_ignore_game_speed:
		arg_duration *= Engine.time_scale
	
	if arg_duration != INFINITE_DURATION:
		_push_notif_timer.start(arg_duration)


func _on_push_notif_timer_expired():
	hide_notification()


#

func hide_notification():
	visible = false

#

func _set_header_text(arg_text):
	_header_text = arg_text
	
	if is_inside_tree():
		_update_header_label()

func _set_content_text(arg_text):
	_content_text = arg_text
	
	if is_inside_tree():
		_update_content_label()


func _update_header_label():
	_header_label.text = _header_text
	_header_label.visible = (_header_text.length() != 0)

func _update_content_label():
	_content_label.text = _content_text
	_content_label.visible = (_content_text.length() != 0)


##

func _ready():
	_set_header_text(_header_text)
	_set_content_text(_content_text)
	
	_push_notif_timer = Timer.new()
	_push_notif_timer.one_shot = true
	_push_notif_timer.connect("timeout", self, "_on_push_notif_timer_expired", [], CONNECT_PERSIST)
	add_child(_push_notif_timer)

