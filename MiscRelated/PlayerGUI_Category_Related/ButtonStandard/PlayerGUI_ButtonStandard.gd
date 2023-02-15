extends MarginContainer

const Background_HighlightedTexture = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/Assets/PlayerGUI_ButtonStandard_FillBackground_Highlighted.png")
const Background_NormalTexture = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/Assets/PlayerGUI_ButtonStandard_FillBackground_Normal.png")

const SideBorder_Normal_Texture = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/Assets/PlayerGUI_ButtonStandard_SideBorder.png")


signal on_button_tooltip_requested()
signal on_button_released_with_button_left()

const enabled_modulate : Color = Color(1, 1, 1, 1)
const disabled_modulate : Color = Color(0.3, 0.3, 0.3, 1)

export(String, MULTILINE) var text_for_label : String setget set_text_for_text_label
export(Texture) var border_texture : Texture = SideBorder_Normal_Texture setget set_border_texture

export(Texture) var background_texture_normal : Texture = Background_NormalTexture setget set_body_background_normal_texture
export(Texture) var background_texture_highlighted : Texture = Background_HighlightedTexture setget set_body_background_highlighted_texture

export(bool) var is_button_enabled : bool = true setget set_is_button_enabled

export(Font) var custom_font : Font setget set_custom_font
#export(int) var custom_font_size : int = 16 setget set_custom_font_size
export(Color) var custom_color : Color = Color(1, 1, 1, 1) setget set_custom_color
export(Color) var custom_color_highlighted := Color(1, 1, 1, 1) setget set_custom_color_highlighted

export(Texture) var custom_button_icon : Texture = null setget set_custom_button_icon

onready var advanced_button_with_tooltip = $AdvancedButtonWithTooltip
onready var text_label = $ContentPanel/HBoxContainer/MarginContainer/TextLabel
onready var button_icon = $ContentPanel/HBoxContainer/ButtonIcon
onready var body_background_texture_rect = $BodyBackground

onready var left_border = $LeftBorder
onready var right_border = $RightBorder
onready var top_border = $TopBorder
onready var bottom_border = $BottomBorder

var _is_highlighted : bool

#


func _ready():
	advanced_button_with_tooltip.connect("released_mouse_event", self, "_on_advanced_button_released_mouse_event", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("about_tooltip_construction_requested", self, "_on_advanced_button_tooltip_requested", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_entered", self, "_on_advanced_button_mouse_entered", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_exited", self, "_on_advanced_button_mouse_exited", [], CONNECT_PERSIST)
	
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST)
	
	set_text_for_text_label(text_for_label)
	set_border_texture(border_texture)
	set_body_background_normal_texture(background_texture_normal)
	set_body_background_highlighted_texture(background_texture_highlighted)
	set_is_button_enabled(is_button_enabled)
	
	set_custom_font(custom_font)
	set_custom_color(custom_color)
	
	set_custom_button_icon(custom_button_icon)

func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	if arg_event.button_index == BUTTON_LEFT and is_button_enabled:
		emit_signal("on_button_released_with_button_left")

func _on_advanced_button_tooltip_requested():
	emit_signal("on_button_tooltip_requested")

#

func _on_advanced_button_mouse_entered():
	if is_button_enabled:
		_set_highlighted_disp_properties()

func _on_advanced_button_mouse_exited():
	_set_normal_disp_properties()

func _on_visibility_changed():
	_set_normal_disp_properties()


func _set_highlighted_disp_properties():
	body_background_texture_rect.texture = background_texture_highlighted
	text_label.set("custom_colors/font_color", custom_color_highlighted)
	_is_highlighted = true

func _set_normal_disp_properties():
	body_background_texture_rect.texture = background_texture_normal
	text_label.set("custom_colors/font_color", custom_color)
	_is_highlighted = false


#

func give_requested_tooltip(arg_about_tooltip):
	advanced_button_with_tooltip.display_requested_about_tooltip(arg_about_tooltip)

func set_text_for_text_label(arg_text : String):
	text_for_label = arg_text
	
	if is_inside_tree():
		text_label.text = arg_text

#

func set_border_texture(arg_texture):
	border_texture = arg_texture
	
	if is_inside_tree():
		left_border.texture = border_texture
		right_border.texture = border_texture
		top_border.texture = border_texture
		bottom_border.texture = border_texture

func set_body_background_normal_texture(arg_texture):
	background_texture_normal = arg_texture
	
	if is_inside_tree():
		body_background_texture_rect.texture = background_texture_normal


func set_body_background_highlighted_texture(arg_texture):
	background_texture_highlighted = arg_texture

#

func set_is_button_enabled(arg_val):
	is_button_enabled = arg_val
	
	if is_inside_tree():
		advanced_button_with_tooltip.disabled = !is_button_enabled
		#visible = is_button_enabled
		
		if is_button_enabled:
			advanced_button_with_tooltip.modulate = enabled_modulate
			modulate = enabled_modulate
		else:
			advanced_button_with_tooltip.modulate = disabled_modulate
			modulate = disabled_modulate
		
		_set_normal_disp_properties()
#

func set_custom_font(arg_font):
	custom_font = arg_font
	
	if custom_font != null and is_inside_tree():
		text_label.add_font_override("font", custom_font)

#func set_custom_font_size(arg_font_size):
#	custom_font_size = arg_font_size
#
#	if custom_font != null and is_inside_tree():
#		text_label.add_font_override("font", custom_font)


func set_custom_color(arg_color):
	custom_color = arg_color
	
	if custom_color != null and is_inside_tree() and !_is_highlighted:
		text_label.set("custom_colors/font_color", custom_color)

func set_custom_color_highlighted(arg_color):
	custom_color_highlighted = arg_color
	
	if custom_color != null and is_inside_tree() and _is_highlighted:
		text_label.set("custom_colors/font_color", custom_color_highlighted)

func set_custom_button_icon(arg_icon):
	custom_button_icon = arg_icon
	
	if custom_button_icon != null and is_inside_tree():
		button_icon.texture = custom_button_icon
		button_icon.visible = true
	else:
		if is_inside_tree():
			button_icon.visible = false


