extends "res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/PlayerGUI_ButtonStandard.gd"

const SideBar_Highlighted = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/Assets/PlayerGUI_ButtonToggleStandard_SideBorder_Highlighted.png")

# blue
const PlayerGUI_ButtonStandard_FillBackground_Normal = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/Assets/PlayerGUI_ButtonStandard_FillBackground_Normal.png")
const PlayerGUI_ButtonStandard_FillBackground_Highlighted = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/Assets/PlayerGUI_ButtonStandard_FillBackground_Highlighted.png")
# maroon
const PlayerGUI_ButtonToggleStandard_HoverTypeFillBackground = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/Assets/PlayerGUI_ButtonToggleStandard_HoverTypeFillBackground.png")



signal toggle_mode_changed(val)


var is_toggle_mode_on : bool = false setget set_is_toggle_mode_on, get_is_toggle_mode_on
var current_button_group
export(bool) var is_toggle_on_by_hover_instead_of_click : bool = false setget set_is_toggle_on_by_hover_instead_of_click

export(bool) var can_be_untoggled_if_is_toggled : bool = true

#

func _ready():
	advanced_button_with_tooltip.connect("on_mouse_entered", self, "_on_mouse_entered", [], CONNECT_PERSIST)
	set_is_toggle_on_by_hover_instead_of_click(is_toggle_on_by_hover_instead_of_click)

func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	if can_be_untoggled_if_is_toggled or (!is_toggle_mode_on and !can_be_untoggled_if_is_toggled):
		._on_advanced_button_released_mouse_event(arg_event)
		
		if !is_toggle_on_by_hover_instead_of_click:
			set_is_toggle_mode_on(!is_toggle_mode_on)

func _on_mouse_entered():
	if is_toggle_on_by_hover_instead_of_click:
		set_is_toggle_mode_on(true)


#

func set_is_toggle_on_by_hover_instead_of_click(arg_val):
	is_toggle_on_by_hover_instead_of_click = arg_val
	
	if !is_toggle_on_by_hover_instead_of_click: #default
		set_body_background_normal_texture(PlayerGUI_ButtonStandard_FillBackground_Normal)
		set_body_background_highlighted_texture(PlayerGUI_ButtonStandard_FillBackground_Highlighted)
	else:
		set_body_background_normal_texture(PlayerGUI_ButtonToggleStandard_HoverTypeFillBackground)
		set_body_background_highlighted_texture(PlayerGUI_ButtonToggleStandard_HoverTypeFillBackground)


func set_is_toggle_mode_on(arg_mode):
	is_toggle_mode_on = arg_mode
	
	if is_toggle_mode_on:
		set_border_texture(SideBar_Highlighted)
	else:
		set_border_texture(SideBorder_Normal_Texture)
	
	emit_signal("toggle_mode_changed", is_toggle_mode_on)

func get_is_toggle_mode_on():
	return is_toggle_mode_on

##

func configure_self_with_button_group(arg_group):
	if current_button_group == null or current_button_group != arg_group:
		arg_group._add_toggle_button_to_group(self)
		current_button_group = arg_group # this should be below the add button to group



