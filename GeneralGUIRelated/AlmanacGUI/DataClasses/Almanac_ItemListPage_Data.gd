extends Reference

const Almanac_ItemListEntry_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListEntry_Data.gd")
const Almanac_Category_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_Category_Data.gd")

#signal almanac_item_list_entries_data_changed()

signal requested_return_to_assigned_page_id(me, page_id)

var header_text : String
var header_description : Array

var _category_type_id_to_almanac_item_list_entries_data : Dictionary = {}
var _category_type_id_to_category_data_map : Dictionary = {}

var page_id_to_return_to : int

var has_at_least_one_non_page_entry_data : bool = false

#var selected_almanac_item_list_entry_button setget set_selected_almanac_item_list_entry_button

#

func add_almanac_item_list_entry_data_to_category(arg_item : Almanac_ItemListEntry_Data, arg_category_data : Almanac_Category_Data, arg_emit_signal : bool = false):
	_category_type_id_to_category_data_map[arg_category_data.cat_type_id] = arg_category_data
	
	if !_category_type_id_to_almanac_item_list_entries_data.has(arg_category_data.cat_type_id):
		_category_type_id_to_almanac_item_list_entries_data[arg_category_data.cat_type_id] = []
	_category_type_id_to_almanac_item_list_entries_data[arg_category_data.cat_type_id].append(arg_item)
	
	if !has_at_least_one_non_page_entry_data:
		has_at_least_one_non_page_entry_data = arg_item.page_id_to_go_to == 0
	arg_item.connect("page_to_go_to_changed", self, "_on_item_page_to_go_to_changed")
	
	
	if arg_emit_signal:
		emit_signal("almanac_item_list_entries_data_changed")


func _on_item_page_to_go_to_changed(arg_item):
	if !has_at_least_one_non_page_entry_data:
		has_at_least_one_non_page_entry_data = arg_item.page_id_to_go_to == 0

func emit_update_signal_for_almanac_item_list_entry_changed():
	emit_signal("almanac_item_list_entries_data_changed")


#func add_almanac_item_list_entry_data(arg_item : Almanac_ItemListEntry_Data, arg_emit_signal : bool = false):
#	_almanac_item_list_entries_data.append(arg_item)
#	if arg_emit_signal:
#		emit_signal("almanac_item_list_entries_data_changed")
#

#

func get_category_type_id_to_almanac_item_list_entries_data():
	return _category_type_id_to_almanac_item_list_entries_data

func get_category_type_id_to_category_data_map():
	return _category_type_id_to_category_data_map


func get_first_almanac_item_list_entry_data():
	return _category_type_id_to_almanac_item_list_entries_data.values()[0][0]

func get_first_unobscured_almanac_item_list_entry_data():
	var datas = _category_type_id_to_almanac_item_list_entries_data.values()[0]
	for data in datas:
		if !data.is_obscured and !data.is_hidden:
			return data
	
	return null


#

#func set_selected_almanac_item_list_entry_button(arg_button):
#	if selected_almanac_item_list_entry_button != null:
#		selected_almanac_item_list_entry_button.set_is_selected(false)
#
#	selected_almanac_item_list_entry_button = arg_button
#
#	if selected_almanac_item_list_entry_button != null:
#		selected_almanac_item_list_entry_button.set_is_selected(true)

#

func request_return_to_assigned_page_id():
	emit_signal("requested_return_to_assigned_page_id", self, page_id_to_return_to)

