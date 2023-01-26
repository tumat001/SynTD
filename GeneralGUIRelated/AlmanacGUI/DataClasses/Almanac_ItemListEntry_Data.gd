extends Reference

signal button_associated_pressed(me, type_info_classification)
signal update_display_requested(me)

var is_hidden : bool
var is_obscured : bool

var footer_text : String

var _max_texture_index : int
var _current_texture_index : int
var _texture_list : Array

#

var border_texture__normal : Texture
var border_texture__highlighted : Texture
var background_texture : Texture

#

enum TypeInfoClassification {
	PAGE = 1,  # transfer to next page
	
	TOWER = 10,
	ENEMY = 11,
}
var _x_type_info_classification : int


var _x_type_info  #tower_type_info, or enemy_type_info. Depends on TypeInfoClassification
var page_id_to_go_to : int setget set_page_id_to_go_to

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
		return Color(0.1, 0.1, 0.1)

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

func get_x_type_info_classification():
	return _x_type_info_classification


func set_page_id_to_go_to(arg_id):
	page_id_to_go_to = arg_id


##

func button_associated_pressed__called_by_button():
	emit_signal("button_associated_pressed", self, _x_type_info_classification)

func update_display_requested():
	emit_signal("update_display_requested", self)

