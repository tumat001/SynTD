extends Node

var _x_type_info__name_list : Array
var _x_type_info__icon_list : Array
var _x_type_info__var_name_as_value_list : Array
var _x_type_info__descriptions_list : Array

var _x_type_info__var_value_converter_method_name_list : Array
var _x_type_info__var_value_converter_method_source_list : Array

var _x_type_info__descriptions_source_method_name_list : Array
var _x_type_info__descriptions_source_obj_list : Array

func add_x_type_info_data(arg_name, 
		arg_icon, 
		arg_var_name_as_value, 
		arg_descs,
		arg_method_name_for_conv = null,
		arg_source_for_conv = null,
		arg_desc_source_method_name = null,
		arg_desc_source_obj = null):
	
	_x_type_info__name_list.append(arg_name)
	_x_type_info__icon_list.append(arg_icon)
	_x_type_info__var_name_as_value_list.append(arg_var_name_as_value)
	_x_type_info__descriptions_list.append(arg_descs)
	
	_x_type_info__var_value_converter_method_name_list.append(arg_method_name_for_conv)
	_x_type_info__var_value_converter_method_source_list.append(arg_source_for_conv)
	
	_x_type_info__descriptions_source_method_name_list.append(arg_desc_source_method_name)
	_x_type_info__descriptions_source_obj_list.append(arg_desc_source_obj)


func clear_x_type_info_data():
	_x_type_info__name_list.clear()
	_x_type_info__icon_list.clear()
	_x_type_info__var_name_as_value_list.clear()
	_x_type_info__descriptions_list.clear()
	
	_x_type_info__var_value_converter_method_name_list.clear()
	_x_type_info__var_value_converter_method_source_list.clear()
	
	_x_type_info__descriptions_source_method_name_list.clear()
	_x_type_info__descriptions_source_obj_list.clear()


func get_info_count():
	return _x_type_info__icon_list.size()

#

func get_x_type_infos_data_at_index(arg_index) -> Array:
	return [
		_x_type_info__name_list[arg_index],
		_x_type_info__icon_list[arg_index],
		_x_type_info__var_name_as_value_list[arg_index],
		_x_type_info__descriptions_list[arg_index],
		
		_x_type_info__var_value_converter_method_name_list[arg_index],
		_x_type_info__var_value_converter_method_source_list[arg_index],
		
		_x_type_info__descriptions_source_method_name_list[arg_index],
		_x_type_info__descriptions_source_obj_list[arg_index],
	]
	



