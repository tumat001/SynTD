extends MarginContainer

const BlueLine_2x2 = preload("res://MiscRelated/PlayerGUI_Category_Related/CheckboxStandard/Assets/Checkbox_Blue2x2.png")
const LightBlueLine_2x2 = preload("res://MiscRelated/PlayerGUI_Category_Related/CheckboxStandard/Assets/Checkbox_LightBlue2x2.png")
const BrownLine_2x2 = preload("res://MiscRelated/PlayerGUI_Category_Related/CheckboxStandard/Assets/Checkbox_Brown2x2.png")
const LightBrownLine_2x2 = preload("res://MiscRelated/PlayerGUI_Category_Related/CheckboxStandard/Assets/Checkbox_LightBrown2x2.png")


signal on_button_tooltip_requested()
signal on_checkbox_val_changed(arg_new_val)

const enabled_modulate : Color = Color(1, 1, 1, 1)
const disabled_modulate : Color = Color(0.3, 0.3, 0.3, 1)

export(bool) var is_button_enabled : bool = true setget set_is_button_enabled
export(bool) var is_checked : bool = true setget set_is_checked

onready var border_left = $HBoxContainer/ButtonContainer/LeftHBox/LeftBorder_Colored
onready var border_right = $HBoxContainer/ButtonContainer/RightHBox/RightBorder_Colored
onready var border_top = $HBoxContainer/ButtonContainer/TopVBox/MarginContainer/TopBorder_Colored
onready var border_bottom = $HBoxContainer/ButtonContainer/BottomVBox2/MarginContainer/BottomBorder_Colored
onready var desc_background = $HBoxContainer/DescContainer/Background

onready var adv_button = $CheckBoxButton
onready var label = $HBoxContainer/DescContainer/MarginContainer/Label

onready var check_texture_rect = $HBoxContainer/ButtonContainer/MarginContainer/CheckPic
onready var x_texture_rect = $HBoxContainer/ButtonContainer/MarginContainer/XPic

onready var desc_container = $HBoxContainer/DescContainer


func set_label_text(arg_text : String):
	label.text = arg_text
	
	if arg_text != null and arg_text.length() > 0:
		desc_container.visible = true
	else:
		desc_container.visible = false

#

func _ready():
	adv_button.connect("mouse_entered", self, "_on_mouse_hover")
	adv_button.connect("mouse_exited", self, "_on_mouse_exited")
	connect("visibility_changed", self, "_on_visibility_changed")
	adv_button.connect("released_mouse_event", self, "_on_advanced_button_released_mouse_event", [], CONNECT_PERSIST)
	
	set_is_button_enabled(is_button_enabled)
	set_is_checked(is_checked)


func _on_mouse_hover():
	border_left.texture = LightBlueLine_2x2
	border_right.texture = LightBlueLine_2x2
	border_top.texture = LightBlueLine_2x2
	border_bottom.texture = LightBlueLine_2x2
	
	desc_background.texture = LightBrownLine_2x2

func _on_mouse_exited():
	border_left.texture = BlueLine_2x2
	border_right.texture = BlueLine_2x2
	border_top.texture = BlueLine_2x2
	border_bottom.texture = BlueLine_2x2
	
	desc_background.texture = BrownLine_2x2

func _on_visibility_changed():
	if !visible:
		_on_mouse_exited()

func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	if arg_event.button_index == BUTTON_LEFT and is_button_enabled:
		set_is_checked(!is_checked)


func set_is_checked(arg_val):
	set_is_checked__do_not_emit_signal(arg_val)
	
	emit_signal("on_checkbox_val_changed", arg_val)

func set_is_checked__do_not_emit_signal(arg_val):
	is_checked = arg_val
	
	x_texture_rect.visible = !is_checked
	check_texture_rect.visible = is_checked


#

func _on_advanced_button_tooltip_requested():
	emit_signal("on_button_tooltip_requested")

#

func set_is_button_enabled(arg_val):
	is_button_enabled = arg_val
	
	if is_inside_tree():
		adv_button.disabled = !is_button_enabled
		visible = is_button_enabled
		
		if is_button_enabled:
			adv_button.modulate = enabled_modulate
		else:
			adv_button.modulate = disabled_modulate

