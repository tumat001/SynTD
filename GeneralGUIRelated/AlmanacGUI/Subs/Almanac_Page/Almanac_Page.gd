extends MarginContainer

const Almanac_Category_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_Category_Data.gd")
const Almanac_ItemListEntry_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListEntry_Data.gd")
const Almanac_ItemListPage_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListPage_Data.gd")

const Almanac_Page_Category = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/Almanac_Page/Almanac_Page_CategoryPanel/Almanac_Page_Category.gd")
const Almanac_Page_Category_Scene = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/Almanac_Page/Almanac_Page_CategoryPanel/Almanac_Page_Category.tscn")


signal is_ready_finished()

#

var almanac_item_list_page_data : Almanac_ItemListPage_Data setget set_almanac_item_list_page_data

#

var is_ready = false

var enemy_info_panel_for_right_side

#

var _all_page_categories : Array

#

onready var page_category_container = $MarginContainer/HBoxContainer/MarginContainer/ScrollContainer/PageCategoryContainer
onready var scrl_container_for_metadata = $MarginContainer/HBoxContainer/RightSideContainer/ScrlContainerForSideData

onready var right_side_container = $MarginContainer/HBoxContainer/RightSideContainer

#

func _ready():
	is_ready = true
	emit_signal("is_ready_finished")
	
	connect("visibility_changed", self, "_on_visibility_changed")
	_on_visibility_changed()

func _on_visibility_changed():
	set_process_unhandled_key_input(visible)

#

func set_almanac_item_list_page_data(arg_data : Almanac_ItemListPage_Data):
	almanac_item_list_page_data = arg_data
	
	var cat_id_to_item_list_entry_datas : Dictionary = almanac_item_list_page_data.get_category_type_id_to_almanac_item_list_entries_data()
	var cat_id_to_cat_type_datas : Dictionary = almanac_item_list_page_data.get_category_type_id_to_category_data_map()
	
	#
	var page_cat_count = _all_page_categories.size()
	var item_list_entries_count = cat_id_to_item_list_entry_datas.size()
	var highest_count = page_cat_count
	if page_cat_count < item_list_entries_count:
		highest_count = item_list_entries_count
	
	for i in highest_count:
		var page_cat : Almanac_Page_Category
		
		if page_cat_count > i:
			page_cat = _all_page_categories[i]
			
			if item_list_entries_count <= i:
				page_cat.visible = false
			else:
				page_cat.visible = true
			
		elif item_list_entries_count > i:
			page_cat = _construct_page_category()
			_all_page_categories.append(page_cat)
		
		if item_list_entries_count > i:
			var cat_type = cat_id_to_cat_type_datas.values()[i]
			page_cat.set_category_data__and_item_list_entries(cat_type, cat_id_to_item_list_entry_datas[cat_type.cat_type_id])
	

func _construct_page_category():
	var page_category = Almanac_Page_Category_Scene.instance()
	page_category_container.add_child(page_category)
	
	return page_category
	



func _on_PlayerGUI_BackButtonStandard_on_button_released_with_button_left():
	_page_request_return_to_assigned_page_id()
	

func _unhandled_key_input(event : InputEventKey):
	if !event.echo and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			_page_request_return_to_assigned_page_id()
	
	accept_event()

func _page_request_return_to_assigned_page_id():
	almanac_item_list_page_data.request_return_to_assigned_page_id()


###############

func show_control_to_right_side__and_hide_others(arg_control_to_show):
	
	
	right_side_container.visible = true
	

func hide_right_side_container():
	right_side_container.visible = false
	


