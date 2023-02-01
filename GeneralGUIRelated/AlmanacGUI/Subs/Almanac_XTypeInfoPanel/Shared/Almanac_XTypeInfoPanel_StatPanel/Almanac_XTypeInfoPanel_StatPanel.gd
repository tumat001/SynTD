extends MarginContainer


const NormalBorder = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Almanac_DarkGrayBorder_ForDescriptions_4x4.png")
const HighlightedBorder = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Almanac_DarkGrayBorder_ForDescriptions_4x4_Highlighted.png")

const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")


onready var stat_texture_rect = $MarginContainer/HBoxContainer/StatIcon
onready var stat_name_label = $MarginContainer/HBoxContainer/MarginContainer/StatNameLabel
onready var stat_value_label = $MarginContainer/HBoxContainer/MarginContainer2/StatValueLabel

onready var top_border = $TopBorder
onready var left_border = $LeftBorder
onready var right_border = $RightBorder
onready var bottom_border = $BottomBorder


var _all_borders : Array = []

var x_type_info
var x_type_info__var_name_as_value : String

var x_type_info_name : String
var x_type_info_icon : Texture

var x_type_info_descriptions


var x_type_info__var_value_conv_method_name
var x_type_info__var_value_conv_source

var x_type_info__descriptions_source_method_name
var x_type_info__descriptions_source_obj

#

var show_bottom_border : bool = true setget set_show_bottom_border
#

var _is_hovered : bool
var _current_tooltip

#

func _ready():
	_all_borders.append(left_border)
	_all_borders.append(right_border)
	_all_borders.append(top_border)
	_all_borders.append(bottom_border)

#

func update_display():
	stat_name_label.text = x_type_info_name
	stat_texture_rect.texture = x_type_info_icon
	
	if x_type_info__var_value_conv_source == null:
		stat_value_label.text = str(x_type_info.get(x_type_info__var_name_as_value))
	else:
		var val = x_type_info.get(x_type_info__var_name_as_value)
		var final_val = x_type_info__var_value_conv_source.call(x_type_info__var_value_conv_method_name, val, x_type_info)
		stat_value_label.text = str(final_val)

func set_show_bottom_border(arg_val):
	show_bottom_border = arg_val
	
	bottom_border.visible = show_bottom_border

##





func _on_Almanac_XTypeInfoPanel_StatPanel_mouse_entered():
	_is_hovered = true
	_create_or_destroy_tooltip()
	_update_borders_based_on_properties()

func _on_Almanac_XTypeInfoPanel_StatPanel_mouse_exited():
	_is_hovered = false
	_update_borders_based_on_properties()

func _on_Almanac_XTypeInfoPanel_StatPanel_visibility_changed():
	_is_hovered = false
	_update_borders_based_on_properties()

func _update_borders_based_on_properties():
	if _is_hovered:
		_set_border_textures(HighlightedBorder)
		
	else:
		_set_border_textures(NormalBorder)
		

func _set_border_textures(arg_texture):
	for border in _all_borders:
		border.texture = arg_texture

###

func _create_or_destroy_tooltip():
	if !is_instance_valid(_current_tooltip):
		_current_tooltip = _construct_about_tooltip()
		_current_tooltip.visible = true
		_current_tooltip.tooltip_owner = self
		#CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_current_tooltip)
		AlmanacManager.almanac_page_gui.tooltip_container.add_child(_current_tooltip)
		_current_tooltip.update_display()
		
	else:
		_current_tooltip.queue_free()
		_current_tooltip = null

func _construct_about_tooltip():
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	
	if x_type_info__descriptions_source_obj == null:
		a_tooltip.descriptions = x_type_info_descriptions
	else:
		a_tooltip.descriptions = x_type_info__descriptions_source_obj.call(x_type_info__descriptions_source_method_name, x_type_info)
	#a_tooltip.header_left_text = "Partner Configuration"
	
	return a_tooltip



