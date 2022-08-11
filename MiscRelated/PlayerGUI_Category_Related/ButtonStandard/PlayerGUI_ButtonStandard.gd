extends MarginContainer

const HighlightedTexture = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/Assets/PlayerGUI_ButtonStandard_FillBackground_Highlighted.png")
const NormalTexture = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/Assets/PlayerGUI_ButtonStandard_FillBackground_Normal.png")

signal on_button_tooltip_requested()
signal on_button_released_with_button_left()

onready var advanced_button_with_tooltip = $AdvancedButtonWithTooltip
onready var text_label = $ContentPanel/TextLabel
onready var body_background_texture_rect = $BodyBackground

func _ready():
	advanced_button_with_tooltip.connect("released_mouse_event", self, "_on_advanced_button_released_mouse_event", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("about_tooltip_construction_requested", self, "_on_advanced_button_tooltip_requested", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_entered", self, "_on_advanced_button_mouse_entered", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_exited", self, "_on_advanced_button_mouse_exited", [], CONNECT_PERSIST)
	
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST)


func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	if arg_event.button_index == BUTTON_LEFT:
		emit_signal("on_button_released_with_button_left")

func _on_advanced_button_tooltip_requested():
	emit_signal("on_button_tooltip_requested")

#

func _on_advanced_button_mouse_entered():
	body_background_texture_rect.texture = HighlightedTexture

func _on_advanced_button_mouse_exited():
	body_background_texture_rect.texture = NormalTexture

func _on_visibility_changed():
	body_background_texture_rect.texture = NormalTexture

#

func give_requested_tooltip(arg_about_tooltip):
	advanced_button_with_tooltip.display_requested_about_tooltip(arg_about_tooltip)

func set_text_for_text_label(arg_text : String):
	text_label.text = arg_text

