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

var curr_selected_button

#

var _all_page_categories : Array

#

onready var page_category_container = $MarginContainer/HBoxContainer/MarginContainer/ScrollContainer/PageCategoryContainer
onready var scrl_container_for_metadata = $MarginContainer/HBoxContainer/RightSideContainer/HBoxContainer/VBoxContainer/ScrlContainerForSideData

onready var right_side_container = $MarginContainer/HBoxContainer/RightSideContainer

onready var tooltip_container = $TooltipContainer

onready var descriptive_mode_checkbox = $MarginContainer/HBoxContainer/RightSideContainer/HBoxContainer/VBoxContainer/ToggleDescriptiveMode

#

onready var x_type_info_panel = $MarginContainer/HBoxContainer/RightSideContainer/HBoxContainer/VBoxContainer/ScrlContainerForSideData/Almanac_XTypeInfoPanel


#

func _ready():
	is_ready = true
	emit_signal("is_ready_finished")
	
	connect("visibility_changed", self, "_on_visibility_changed")
	_on_visibility_changed()
	
	hide_right_side_container()
	
	#
	
	descriptive_mode_checkbox.connect("on_checkbox_val_changed", self, "_on_ToggleDescriptiveMode_on_checkbox_val_changed")
	descriptive_mode_checkbox.set_label_text("Descriptive Mode (Press T to toggle)")
	_update_descriptive_mode_checkbox_based_on_properties()

func _on_visibility_changed():
	set_process_unhandled_key_input(visible)
	
	if visible:
		if AlmanacManager != null:
			AlmanacManager.update_state_of__all_options()


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
			
		elif event.is_action("game_description_mode_toggle"):
			descriptive_mode_checkbox.set_is_checked(!descriptive_mode_checkbox.is_checked)
			
	
	accept_event()

func _page_request_return_to_assigned_page_id():
	almanac_item_list_page_data.request_return_to_assigned_page_id()

#

func _on_ToggleDescriptiveMode_on_checkbox_val_changed(_arg_new_val):
	_toggle_desc_mode()

func _toggle_desc_mode():
	if is_inside_tree():
		GameSettingsManager.toggle_descriptions_mode()
		if right_side_container != null and right_side_container.visible:
			x_type_info_panel.update_descriptions_panel()
		
		_update_descriptive_mode_checkbox_based_on_properties()
		

func _update_descriptive_mode_checkbox_based_on_properties():
	descriptive_mode_checkbox.set_is_checked__do_not_emit_signal(GameSettingsManager.descriptions_mode == GameSettingsManager.DescriptionsMode.COMPLEX)

###############

func configure_almanac_x_type_info_panel(arg_item_list_entry : Almanac_ItemListEntry_Data,
		arg_x_type_info_multi_stats_data,
		arg_x_type_info,
		arg_selected_button):
	
	right_side_container.visible = true
	
	#x_type_info_panel.x_type_info = arg_x_type_info
	x_type_info_panel.visible = true
	x_type_info_panel.set_properties(arg_item_list_entry, arg_x_type_info_multi_stats_data)
	
	if curr_selected_button != null:
		curr_selected_button.set_is_selected(false)
	curr_selected_button = arg_selected_button
	if curr_selected_button != null:
		curr_selected_button.set_is_selected(true)

func hide_right_side_container():
	
	x_type_info_panel.visible = false
	right_side_container.visible = false
	
	if curr_selected_button != null:
		curr_selected_button.set_is_selected(false)
	curr_selected_button = null


#func configure_almanac_synergy_info_panel(arg_item_list_entry : Almanac_ItemListEntry_Data,
#		arg_x_type_info_multi_stats_data,
#		arg_x_type_info,
#		arg_selected_button):
#
#
#	pass



