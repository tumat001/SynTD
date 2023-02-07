extends Reference

const TowerTypeInfo_RightSide_Background = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/XTypeInfo_RightSide/XTypeInfo_RightSide_Background.png")
const TowerTypeInfo_RightSide_Border = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/XTypeInfo_RightSide/XTypeInfo_RightSide_Border_6x6.png")
const EnemyTypeInfo_RightSide_Background = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/XTypeInfo_RightSide/EnemyTypeInfo_RightSide_Background.png")
const EnemyTypeInfo_RightSide_Border = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/XTypeInfo_RightSide/EnemyTypeInfo_RightSide_Border_6x6.png")
const SynergyTypeInfo_RightSide_Background = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/SynergyPage_RightSide/SynergyTypeInfo_RightSide_Background.png")
const SynergyTypeInfo_RightSide_Border = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/SynergyPage_RightSide/SynergyTypeInfo_RightSide_Border_6x6.png")
const TidbitTypeInfo_RightSide_Background = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage_RightSide/TidbitTypeInfo_RightSide_Background.png")
const TidbitTypeInfo_RightSide_Border = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage_RightSide/TidbitTypeInfo_RightSide_Border_6x6.png")


signal button_associated_pressed(me, type_info_classification)
signal update_display_requested(me)

signal page_to_go_to_changed(me)
signal is_obscured_changed(me)
signal is_hidden_changed(me)


var is_hidden : bool setget set_is_hidden
var is_obscured : bool setget set_is_obscured

var footer_text : String

var _max_texture_index : int
var _current_texture_index : int
var _texture_list : Array

#

var is_hidden_determiner_func_name
var is_hidden_determiner_source

#

var border_texture__normal : Texture
var border_texture__highlighted : Texture
var background_texture : Texture

#

#var is_obscured_state_determiner_func_name
#var is_obscured_state_determiner_source

#

enum TypeInfoClassification {
	PAGE = 1,  # transfer to next page
	
	TOWER = 10,
	ENEMY = 11,
	SYNERGY = 12,
	TEXT_TIDBIT = 13,
}
var _x_type_info_classification : int


var _x_type_info  #tower_type_info, enemy_type_info, almanac_texttidbit or color_synergy. Depends on TypeInfoClassification
var page_id_to_go_to : int setget set_page_id_to_go_to

#


var right_side_panel__border_texture : Texture
var right_side_panel__background_texture : Texture

#
var button_associated

##

func add_texture_to_texture_list(arg_texture):
	_texture_list.append(arg_texture)

func increment_texture_index():
	_current_texture_index += 1
	if _current_texture_index > _max_texture_index:
		_current_texture_index = 0


####

func get_texture_to_use_based_on_properties():
	return _texture_list[_current_texture_index]

func get_modulate_to_use_based_on_properties():
	if !is_obscured:
		return Color(1, 1, 1)
	else:
		return Color(0.05, 0.05, 0.05)

func get_border_modulate_to_use_based_on_properties():
	if !is_obscured:
		return Color(1, 1, 1)
	else:
		return Color(0.3, 0.3, 0.3)


#

#func update_is_obscured_state_based_on_properties():
#	if is_obscured_state_determiner_source != null:
#		is_obscured = is_obscured_state_determiner_source.call(is_obscured_state_determiner_func_name, self)
#	else:
#		is_obscured = true

##

func set_x_type_info(arg_info, arg_info_classification : int):
	_x_type_info = arg_info
	set_x_type_info_classification(arg_info_classification)
	
	_texture_list.clear()
	_texture_list.append_array(_x_type_info.get_atlased_image_as_list__for_almanac_use())
	_max_texture_index = _x_type_info.get_altasted_image_list_size()
	_current_texture_index = 0
	footer_text = _x_type_info.get_name__for_almanac_use()

func set_x_type_info_classification(arg_info_classification : int):
	_x_type_info_classification = arg_info_classification
	
	if _x_type_info_classification == TypeInfoClassification.TOWER:
		right_side_panel__border_texture = TowerTypeInfo_RightSide_Border
		right_side_panel__background_texture = TowerTypeInfo_RightSide_Background
		
	elif _x_type_info_classification == TypeInfoClassification.ENEMY:
		right_side_panel__border_texture = EnemyTypeInfo_RightSide_Border
		right_side_panel__background_texture = EnemyTypeInfo_RightSide_Background
		
	elif _x_type_info_classification == TypeInfoClassification.SYNERGY:
		right_side_panel__border_texture = SynergyTypeInfo_RightSide_Border
		right_side_panel__background_texture = SynergyTypeInfo_RightSide_Background
		
	elif _x_type_info_classification == TypeInfoClassification.TEXT_TIDBIT:
		right_side_panel__border_texture = TidbitTypeInfo_RightSide_Border
		right_side_panel__background_texture = TidbitTypeInfo_RightSide_Background
		


func get_x_type_info_classification():
	return _x_type_info_classification

func get_x_type_info():
	return _x_type_info

func set_page_id_to_go_to(arg_id):
	page_id_to_go_to = arg_id
	
	emit_signal("page_to_go_to_changed", self)


##

func button_associated_pressed__called_by_button(arg_button):
	emit_signal("button_associated_pressed", arg_button, _x_type_info_classification)

func update_display_requested():
	emit_signal("update_display_requested", self)

##

func set_is_obscured(arg_val):
	is_obscured = arg_val
	
	emit_signal("is_obscured_changed", self)

func set_is_hidden(arg_val):
	is_hidden = arg_val

	emit_signal("is_hidden_changed", self)


#func calculate_is_hidden__factoring_all_properties():
#	var _is_hidden_var_from_source : bool = false
#	if is_hidden_determiner_source != null:
#		_is_hidden_var_from_source = get_is_hidden__from_source_only()
#
#	return is_hidden and _is_hidden_var_from_source

func calculate_is_hidden__from_source_only():
	if is_hidden_determiner_source != null:
		return is_hidden_determiner_source.call(is_hidden_determiner_func_name)
	else:
		return false

