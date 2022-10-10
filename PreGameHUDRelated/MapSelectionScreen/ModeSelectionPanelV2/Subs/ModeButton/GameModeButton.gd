extends MarginContainer

const GameModeTypeInformation = preload("res://GameplayRelated/GameModeRelated/GameModeTypeInformation.gd")
const BaseTooltip = preload("res://GameHUDRelated/Tooltips/BaseTooltip.gd")
const TooltipStandard = preload("res://MiscRelated/PlayerGUI_Category_Related/TooltipStandard/TooltipStandard.gd")
const TooltipStandard_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/TooltipStandard/TooltipStandard.tscn")

signal mode_button_up()
signal on_mouse_entered()


onready var mode_button = $ModeButton
onready var mode_label = $ModeLabel

#

var about_tooltip : BaseTooltip
enum _button_indexes {
	BUTTON_LEFT = BUTTON_LEFT,
	BUTTON_RIGHT = BUTTON_RIGHT
	BUTTON_MIDDLE = BUTTON_MIDDLE
	MOUSE_HOVER = -1001
	NONE = -1002
}
export(_button_indexes) var about_button_index_trigger : int = _button_indexes.MOUSE_HOVER

# true when extending the button and defining tooltip construction in the button
export(bool) var define_tooltip_construction_in_button : bool = true

#

var mode_type_info : GameModeTypeInformation

#

func _ready():
	mode_button.connect("gui_input", self, "_on_mode_button_gui_input")
	mode_button.connect("mouse_entered", self, "_on_mode_button_mouse_entered")
	mode_button.connect("mouse_exited", self, "_on_mode_button_mouse_exited")

func change_mode_pic_and_label(arg_mode_type_info : GameModeTypeInformation, arg_display_highlighted : bool = true):
	mode_type_info = arg_mode_type_info
	
	mode_button.texture_normal = arg_mode_type_info.game_mode_button_normal_texture
	if arg_display_highlighted:
		mode_button.texture_hover = arg_mode_type_info.game_mode_button_highlighted_texture
	else:
		mode_button.texture_hover = arg_mode_type_info.game_mode_button_normal_texture
	
	mode_label.text = arg_mode_type_info.mode_name


#

func _on_ModeButton_button_up():
	trigger_button_up()

func trigger_button_up():
	emit_signal("mode_button_up")

#


func _on_mode_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == about_button_index_trigger:
			_trigger_create_about_tooltip()
	

func _on_mode_button_mouse_entered():
	if about_button_index_trigger == _button_indexes.MOUSE_HOVER:
		_trigger_create_about_tooltip()
	
	emit_signal("on_mouse_entered")

func _on_mode_button_mouse_exited():
	if is_instance_valid(about_tooltip):
		about_tooltip.queue_free()
		about_tooltip = null


func _trigger_create_about_tooltip():
	if define_tooltip_construction_in_button:
		if !is_instance_valid(about_tooltip):
			display_requested_about_tooltip(_construct_about_tooltip())
		else:
			about_tooltip.queue_free()
			about_tooltip = null
		
	else:
		if !is_instance_valid(about_tooltip):
			emit_signal("about_tooltip_construction_requested")
		else:
			about_tooltip.queue_free()
			about_tooltip = null


#

func _construct_about_tooltip() -> BaseTooltip:
	var tooltip = TooltipStandard_Scene.instance()
	tooltip.tooltip_descriptions = mode_type_info.mode_descriptions
	tooltip.header_text = mode_type_info.mode_name
	tooltip.rect_min_size.x = 300
	tooltip.rect_min_size.y = 200
	
	return tooltip

#
# use this only when define_tooltip_construction_in_button is false
func display_requested_about_tooltip(arg_about_tooltip : BaseTooltip):
	if is_instance_valid(arg_about_tooltip):
		about_tooltip = arg_about_tooltip
		about_tooltip.visible = true
		about_tooltip.tooltip_owner = self
		get_tree().get_root().add_child(about_tooltip)
		about_tooltip.update_display()

