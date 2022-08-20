extends MarginContainer

const MapTypeInformation = preload("res://MapsRelated/MapTypeInformation.gd")
const Line_Dark = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/DarkLine_7x7.png")
const Line_Yellow = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/BrightYellowLine_7x7.png")


signal toggle_mode_changed(arg_val)
signal on_button_tooltip_requested()

onready var advanced_button_with_tooltip = $Button

onready var card_leftborder = $LeftBorder
onready var card_rightborder = $RightBorder
onready var card_topborder = $TopBorder
onready var card_bottomborder = $BottomBorder
onready var nameplate_topborder = $ContentContainer/NameContainer/TopBorder
onready var nameplate_rightborder = $ContentContainer/NameContainer/RightBorder

onready var map_name_label = $ContentContainer/NameContainer/NameContainer/MapNameLabel
onready var map_texture_rect = $MapImageContainer/MapImage

var is_toggle_mode_on : bool = false setget set_is_toggle_mode_on, get_is_toggle_mode_on
var current_button_group
var map_name : String setget set_map_name
var map_image : Texture setget set_map_image
var map_id : int setget set_map_id

#

func _ready():
	advanced_button_with_tooltip.connect("released_mouse_event", self, "_on_advanced_button_released_mouse_event", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("about_tooltip_construction_requested", self, "_on_advanced_button_tooltip_requested", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_entered", self, "_on_advanced_button_mouse_entered", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_exited", self, "_on_advanced_button_mouse_exited", [], CONNECT_PERSIST)
	
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST)


func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	if arg_event.button_index == BUTTON_LEFT:
		set_is_toggle_mode_on(!is_toggle_mode_on)

func _on_advanced_button_tooltip_requested():
	emit_signal("on_button_tooltip_requested")

func give_requested_tooltip(arg_about_tooltip):
	advanced_button_with_tooltip.display_requested_about_tooltip(arg_about_tooltip)

#


func _on_advanced_button_mouse_entered():
	_make_borders_glow()

func _on_advanced_button_mouse_exited():
	_update_border_glow_state()

func _on_visibility_changed():
	_update_border_glow_state()

#

func _update_border_glow_state():
	if is_toggle_mode_on:
		_make_borders_glow()
		
	else:
		_make_borders_not_glow()
	
	emit_signal("toggle_mode_changed", is_toggle_mode_on)

func _make_borders_not_glow():
	card_leftborder.texture = Line_Dark
	card_rightborder.texture = Line_Dark
	card_topborder.texture = Line_Dark
	card_bottomborder.texture = Line_Dark
	nameplate_rightborder.texture = Line_Dark
	nameplate_topborder.texture = Line_Dark

func _make_borders_glow():
	card_leftborder.texture = Line_Yellow
	card_rightborder.texture = Line_Yellow
	card_topborder.texture = Line_Yellow
	card_bottomborder.texture = Line_Yellow
	nameplate_rightborder.texture = Line_Yellow
	nameplate_topborder.texture = Line_Yellow


#

func set_is_toggle_mode_on(arg_mode):
	is_toggle_mode_on = arg_mode
	
	if is_toggle_mode_on:
		_make_borders_glow()
	else:
		_make_borders_not_glow()

func get_is_toggle_mode_on():
	return is_toggle_mode_on

func configure_self_with_button_group(arg_group):
	if current_button_group != arg_group:
		arg_group._add_toggle_button_to_group(self)
		current_button_group = arg_group # this should be below the add button to group

func unconfigure_self_from_button_group(arg_group):
	if current_button_group == null or current_button_group == arg_group:
		arg_group._remove_toggle_button_from_group(self)
		current_button_group = null


#

func set_map_info_based_on_type_information(arg_info : MapTypeInformation):
	set_map_id(arg_info.map_id)
	set_map_image(arg_info.map_display_texture)
	set_map_name(arg_info.map_name)


func set_map_name(arg_text):
	map_name = arg_text
	
	map_name_label.text = map_name

func set_map_image(arg_image):
	map_image = arg_image
	
	map_texture_rect.texture = map_image

func set_map_id(arg_id):
	map_id = arg_id

#

func reset_map_card_to_empty():
	set_is_toggle_mode_on(false)
	
	set_map_name("")
	set_map_image(null)
	set_map_id(-1)


