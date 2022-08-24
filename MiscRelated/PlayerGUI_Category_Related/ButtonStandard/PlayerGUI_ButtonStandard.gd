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

onready var advanced_button_with_tooltip = $AdvancedButtonWithTooltip
onready var text_label = $ContentPanel/TextLabel
onready var body_background_texture_rect = $BodyBackground

onready var left_border = $LeftBorder
onready var right_border = $RightBorder
onready var top_border = $TopBorder
onready var bottom_border = $BottomBorder


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


func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	if arg_event.button_index == BUTTON_LEFT and is_button_enabled:
		emit_signal("on_button_released_with_button_left")

func _on_advanced_button_tooltip_requested():
	emit_signal("on_button_tooltip_requested")

#

func _on_advanced_button_mouse_entered():
	body_background_texture_rect.texture = background_texture_highlighted

func _on_advanced_button_mouse_exited():
	body_background_texture_rect.texture = background_texture_normal

func _on_visibility_changed():
	body_background_texture_rect.texture = background_texture_normal

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
		visible = is_button_enabled
		
		if is_button_enabled:
			advanced_button_with_tooltip.modulate = enabled_modulate
		else:
			advanced_button_with_tooltip.modulate = disabled_modulate


