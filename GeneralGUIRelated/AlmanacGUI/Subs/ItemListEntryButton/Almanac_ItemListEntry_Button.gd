extends MarginContainer

const Almanac_ItemListEntry_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListEntry_Data.gd")
const GrayLine_3x3 = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Line_OuterBorder/GrayLine_3x3.png")
const YellowLine_3x3 = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Line_OuterBorder/YellowLine_3x3.png")

#signal button_selected__with_data_non_page(me, arg_data, type_info_classification)
#signal button_selected__with_data_page(me, arg_data, type_info_classification, arg_page_id)

#

var almanac_item_list_entry_data : Almanac_ItemListEntry_Data setget set_almanac_item_list_entry_data

var _all_outer_borders : Array
var _all_inner_borders : Array

var _is_hovered : bool
var _is_selected : bool

#

onready var outer_border_left = $OuterLeftBorder
onready var outer_border_right = $OuterRightBorder
onready var outer_border_top = $OuterTopBorder
onready var outer_border_bottom = $OuterBottomBorder

onready var inner_border_left = $MarginContainer/LeftBorder
onready var inner_border_right = $MarginContainer/RightBorder
onready var inner_border_top = $MarginContainer/TopBorder
onready var inner_border_bottom = $MarginContainer/BottomBorder

onready var icon_texture_rect = $MarginContainer/MarginContainer/Icon

#

func _ready():
	_all_outer_borders.append(outer_border_left)
	_all_outer_borders.append(outer_border_right)
	_all_outer_borders.append(outer_border_top)
	_all_outer_borders.append(outer_border_bottom)
	
	_all_inner_borders.append(inner_border_left)
	_all_inner_borders.append(inner_border_right)
	_all_inner_borders.append(inner_border_top)
	_all_inner_borders.append(inner_border_bottom)
	

#

func set_almanac_item_list_entry_data(arg_data):
	if almanac_item_list_entry_data != null:
		almanac_item_list_entry_data.disconnect("is_obscured_changed", self, "_on_data_is_obscured_changed")
		almanac_item_list_entry_data.disconnect("is_hidden_changed", self, "_on_data_is_hidden_changed")
	
	almanac_item_list_entry_data = arg_data
	
	if almanac_item_list_entry_data != null:
		arg_data.button_associated = self
		
		#almanac_item_list_entry_data.connect("button_associated_pressed", self, "_on_button_associated_pressed", [], CONNECT_PERSIST)
		
		icon_texture_rect.texture = almanac_item_list_entry_data.get_texture_to_use_based_on_properties()
		update_border_texture_based_on_properties()
		
		#
		icon_texture_rect.modulate = almanac_item_list_entry_data.get_modulate_to_use_based_on_properties()
		var border_modulate = almanac_item_list_entry_data.get_border_modulate_to_use_based_on_properties()
		for border in _all_inner_borders:
			border.modulate = border_modulate
		
		visible = !almanac_item_list_entry_data.is_hidden
		
		#
		almanac_item_list_entry_data.connect("is_obscured_changed", self, "_on_data_is_obscured_changed")
		almanac_item_list_entry_data.connect("is_hidden_changed", self, "_on_data_is_hidden_changed")

func _on_data_is_obscured_changed(_arg_data : Almanac_ItemListEntry_Data):
	icon_texture_rect.modulate = almanac_item_list_entry_data.get_modulate_to_use_based_on_properties()
	
	var border_modulate = almanac_item_list_entry_data.get_border_modulate_to_use_based_on_properties()
	for border in _all_inner_borders:
		border.modulate = border_modulate

func _on_data_is_hidden_changed(_arg_data : Almanac_ItemListEntry_Data):
	visible = !almanac_item_list_entry_data.is_hidden


#

func _on_Button_released_mouse_event(event : InputEventMouseButton):
	if event.button_index == BUTTON_LEFT:
		almanac_item_list_entry_data.button_associated_pressed__called_by_button(self)
		
	

#

func _on_Button_mouse_entered():
	_is_hovered = true
	update_border_texture_based_on_properties()


func _on_Button_mouse_exited():
	_is_hovered = false
	update_border_texture_based_on_properties()


func _on_Almanac_ItemListEntry_Button_visibility_changed():
	_is_hovered = false
	update_border_texture_based_on_properties()

##

func update_border_texture_based_on_properties():
	if _is_hovered:
		_set_texture_of_inner_borders(almanac_item_list_entry_data.border_texture__highlighted)
	else:
		_set_texture_of_inner_borders(almanac_item_list_entry_data.border_texture__normal)


func _set_texture_of_inner_borders(arg_texture):
	for rect in _all_inner_borders:
		rect.texture = arg_texture

func _set_texture_of_outer_borders(arg_texture):
	for rect in _all_outer_borders:
		rect.texture = arg_texture


func set_is_selected(arg_val):
	_is_selected = arg_val
	
	if arg_val:
		_set_texture_of_outer_borders(YellowLine_3x3)
	else:
		_set_texture_of_outer_borders(GrayLine_3x3)

#

#func _on_button_associated_pressed(arg_data : Almanac_ItemListEntry_Data, type_info_classification):
#	if arg_data.get_x_type_info_classification() != Almanac_ItemListEntry_Data.TypeInfoClassification.PAGE:
#		emit_signal("button_selected__with_data_non_page", self, arg_data, type_info_classification)
#
#	else:
#		emit_signal("button_selected__with_data_page", self, arg_data, type_info_classification, arg_data.page_id_to_go_to)



