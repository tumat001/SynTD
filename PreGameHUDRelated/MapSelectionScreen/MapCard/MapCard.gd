extends MarginContainer

const MapTypeInformation = preload("res://MapsRelated/MapTypeInformation.gd")
#const Line_Dark = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/DarkLine_7x7.png")
#const Line_Yellow = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/BrightYellowLine_7x7.png")

const OuterBorder_GrayLine = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_OuterBorder_GrayLine_3x3.png")
const OuterBorder_YellowLine = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_OuterBorder_BrightYellowLine_3x3.png")

const MapCard_BorderTier01_Highlighted = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier01_Highlighted.png")
const MapCard_BorderTier02_Highlighted = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier02_Highlighted.png")
const MapCard_BorderTier03_Highlighted = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier03_Highlighted.png")
const MapCard_BorderTier04_Highlighted = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier04_Highlighted.png")
const MapCard_BorderTier05_Highlighted = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier05_Highlighted.png")
const MapCard_BorderTier06_Highlighted = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier06_Highlighted.png")

const MapCard_BorderTier01_Normal = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier01_Normal.png")
const MapCard_BorderTier02_Normal = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier02_Normal.png")
const MapCard_BorderTier03_Normal = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier03_Normal.png")
const MapCard_BorderTier04_Normal = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier04_Normal.png")
const MapCard_BorderTier05_Normal = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier05_Normal.png")
const MapCard_BorderTier06_Normal = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/MapCardAssets/MapCard_BorderTier06_Normal.png")


signal toggle_mode_changed(arg_val)
signal on_button_tooltip_requested()

onready var advanced_button_with_tooltip = $Button

onready var card_tier_leftborder = $MarginContainer/LeftBorder
onready var card_tier_rightborder = $MarginContainer/RightBorder
onready var card_tier_topborder = $MarginContainer/TopBorder
onready var card_tier_bottomborder = $MarginContainer/BottomBorder

onready var card_outer_leftborder = $OuterLeftBorder
onready var card_outer_rightborder = $OuterRightBorder
onready var card_outer_topborder = $OuterTopBorder
onready var card_outer_bottomborder = $OuterBottomBorder

onready var nameplate_topborder = $MarginContainer/ContentContainer/NameContainer/TopBorder
onready var nameplate_rightborder = $MarginContainer/ContentContainer/NameContainer/RightBorder

onready var map_name_label = $MarginContainer/ContentContainer/NameContainer/NameContainer/MapNameLabel
onready var map_texture_rect = $MarginContainer/MapImageContainer/MapImage

var is_toggle_mode_on : bool = false setget set_is_toggle_mode_on, get_is_toggle_mode_on
var current_button_group
var map_name : String setget set_map_name
var map_image : Texture setget set_map_image
var map_id setget set_map_id

var map_tier : int setget set_map_tier
var map_tier_border_normal : Texture
var map_tier_border_selected : Texture


export(bool) var can_be_untoggled_if_is_toggled : bool = false


#

func _ready():
	advanced_button_with_tooltip.connect("released_mouse_event", self, "_on_advanced_button_released_mouse_event", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("about_tooltip_construction_requested", self, "_on_advanced_button_tooltip_requested", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_entered", self, "_on_advanced_button_mouse_entered", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_exited", self, "_on_advanced_button_mouse_exited", [], CONNECT_PERSIST)
	
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST)
	

func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	if arg_event.button_index == BUTTON_LEFT:
		if can_be_untoggled_if_is_toggled or (!is_toggle_mode_on and !can_be_untoggled_if_is_toggled):
			set_is_toggle_mode_on(!is_toggle_mode_on)

func _on_advanced_button_tooltip_requested():
	emit_signal("on_button_tooltip_requested")

func give_requested_tooltip(arg_about_tooltip):
	advanced_button_with_tooltip.display_requested_about_tooltip(arg_about_tooltip)

#


func _on_advanced_button_mouse_entered():
	_make_tier_borders_glow()
	#_make_outer_borders_glow()

func _on_advanced_button_mouse_exited():
	_make_tier_borders_not_glow()
	#_make_outer_borders_not_glow()


func _make_outer_borders_glow():
	card_outer_leftborder.texture = OuterBorder_YellowLine
	card_outer_rightborder.texture = OuterBorder_YellowLine
	card_outer_topborder.texture = OuterBorder_YellowLine
	card_outer_bottomborder.texture = OuterBorder_YellowLine
	

func _make_outer_borders_not_glow():
	card_outer_leftborder.texture = OuterBorder_GrayLine
	card_outer_rightborder.texture = OuterBorder_GrayLine
	card_outer_topborder.texture = OuterBorder_GrayLine
	card_outer_bottomborder.texture = OuterBorder_GrayLine
	



func _on_visibility_changed():
	#_update_outer_border_glow_state()
	#_make_outer_borders_not_glow()
	
	_make_tier_borders_not_glow()
	_update_outer_border_glow_state()

#

func _update_outer_border_glow_state():
	if is_toggle_mode_on:
		#_make_tier_borders_glow()
		_make_outer_borders_glow()
		
	else:
		#_make_tier_borders_not_glow()
		_make_outer_borders_not_glow()


func _make_tier_borders_not_glow():
	card_tier_leftborder.texture = map_tier_border_normal
	card_tier_rightborder.texture = map_tier_border_normal
	card_tier_topborder.texture = map_tier_border_normal
	card_tier_bottomborder.texture = map_tier_border_normal
	
	nameplate_rightborder.texture = map_tier_border_normal
	nameplate_topborder.texture = map_tier_border_normal


func _make_tier_borders_glow():
	card_tier_leftborder.texture = map_tier_border_selected
	card_tier_rightborder.texture = map_tier_border_selected
	card_tier_topborder.texture = map_tier_border_selected
	card_tier_bottomborder.texture = map_tier_border_selected
	
	nameplate_rightborder.texture = map_tier_border_selected
	nameplate_topborder.texture = map_tier_border_selected



#

func set_is_toggle_mode_on(arg_mode):
	is_toggle_mode_on = arg_mode
	
	_update_outer_border_glow_state()
	
	emit_signal("toggle_mode_changed", is_toggle_mode_on)

func get_is_toggle_mode_on():
	return is_toggle_mode_on

func configure_self_with_button_group(arg_group):
	if current_button_group == null or current_button_group != arg_group:
		arg_group._add_toggle_button_to_group(self)
		current_button_group = arg_group # this should be below the add button to group

func unconfigure_self_from_button_group(arg_group):
	if current_button_group == arg_group:
		arg_group._remove_toggle_button_from_group(self)
		current_button_group = null


#

func set_map_info_based_on_type_information(arg_info : MapTypeInformation):
	set_map_id(arg_info.map_id)
	set_map_image(arg_info.map_display_texture)
	set_map_name(arg_info.map_name)
	set_map_tier(arg_info.map_tier)


func set_map_name(arg_text):
	map_name = arg_text
	
	map_name_label.text = map_name

func set_map_image(arg_image):
	map_image = arg_image
	
	map_texture_rect.texture = map_image

func set_map_id(arg_id):
	map_id = arg_id

func set_map_tier(arg_tier):
	map_tier = arg_tier
	
	if map_tier == 1:
		map_tier_border_normal = MapCard_BorderTier01_Normal
		map_tier_border_selected = MapCard_BorderTier01_Highlighted
	elif map_tier == 2:
		map_tier_border_normal = MapCard_BorderTier02_Normal
		map_tier_border_selected = MapCard_BorderTier02_Highlighted
		
	elif map_tier == 3:
		map_tier_border_normal = MapCard_BorderTier03_Normal
		map_tier_border_selected = MapCard_BorderTier03_Highlighted
		
	elif map_tier == 4:
		map_tier_border_normal = MapCard_BorderTier04_Normal
		map_tier_border_selected = MapCard_BorderTier04_Highlighted
		
	elif map_tier == 5:
		map_tier_border_normal = MapCard_BorderTier05_Normal
		map_tier_border_selected = MapCard_BorderTier05_Highlighted
		
	elif map_tier == 6:
		map_tier_border_normal = MapCard_BorderTier06_Normal
		map_tier_border_selected = MapCard_BorderTier06_Highlighted
	
	_update_outer_border_glow_state()


#

func reset_map_card_to_empty():
	set_is_toggle_mode_on(false)
	
	set_map_name("")
	set_map_image(null)
	set_map_id(-1)


