extends MarginContainer

const Almanac_ItemListPage_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListPage_Data.gd")
const Almanac_Category_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_Category_Data.gd")

const Almanac_ItemListEntry_Button = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/ItemListEntryButton/Almanac_ItemListEntry_Button.gd")
const Almanac_ItemListEntry_Button_Scene = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/ItemListEntryButton/Almanac_ItemListEntry_Button.tscn")

#

var _all_buttons_in_container = []

var _category_data : Almanac_Category_Data
var _almanac_item_list_entries : Array

var _all_borders : Array = []

#

onready var header_label = $MarginContainer/VBoxContainer/MarginContainer/HeaderLabel
onready var header_desc = $MarginContainer/VBoxContainer/MarginContainer2/HeaderDesc
onready var button_container = $MarginContainer/VBoxContainer/ButtonMarginer/ButtonContainer

onready var left_border = $LeftBorder
onready var right_border = $RightBorder
onready var top_border = $TopBorder
onready var bottom_border = $BottomBorder

#

func _ready():
	_all_borders.append(left_border)
	_all_borders.append(right_border)
	_all_borders.append(top_border)
	_all_borders.append(bottom_border)

#

func set_category_data__and_item_list_entries(arg_category_data : Almanac_Category_Data,
		arg_almanac_item_list_entries_data : Array):
	
	_category_data = arg_category_data
	_almanac_item_list_entries = arg_almanac_item_list_entries_data
	
	_set_properties_based_on_category()
	_set_properties_based_on_almanac_item_list_entries()

func _set_properties_based_on_category():
	if _category_data != null:
		header_label.text = _category_data.cat_text
		header_desc.descriptions = _category_data.cat_description
	else:
		header_label.text = ""
		header_desc.descriptions = []
	
	header_desc.update_display()
	
	for border in _all_borders:
		border.texture = _category_data.border_texture
		border.modulate = _category_data.border_modulate

func _set_properties_based_on_almanac_item_list_entries():
	var count = _almanac_item_list_entries.size()
	if _all_buttons_in_container.size() > count:
		count = _all_buttons_in_container.size()
	
	var button_count = _all_buttons_in_container.size()
	var item_list_count = _almanac_item_list_entries.size()
	
	for i in count:
		var button : Almanac_ItemListEntry_Button
		
		if button_count > i:
			button = _all_buttons_in_container[i]
			if item_list_count <= i:
				button.visible = false
			else:
				button.visible = true
			
		elif item_list_count > i:
			button = _construct_almanac_item_list_entry_button()
			_all_buttons_in_container.append(button)
		
		if item_list_count > i:
			button.almanac_item_list_entry_data = _almanac_item_list_entries[i]
		

func _construct_almanac_item_list_entry_button():
	var button = Almanac_ItemListEntry_Button_Scene.instance()
	button_container.add_child(button)
	
	return button

