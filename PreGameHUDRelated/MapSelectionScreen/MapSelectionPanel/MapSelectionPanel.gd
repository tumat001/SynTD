extends MarginContainer


const MapCard_Scene = preload("res://PreGameHUDRelated/MapSelectionScreen/MapCard/MapCard.tscn")
const MapCard = preload("res://PreGameHUDRelated/MapSelectionScreen/MapCard/MapCard.gd")

const ButtonGroup_Custom = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/ButtonGroup.gd")

signal on_current_selected_map_id_changed(arg_id)

const map_card_per_row : int = 4
const row_count : int = 2

var _map_id_list : Array = []
var current_page_index : int = 0
var current_page_count : int = 1

onready var left_page_switch_button = $HBoxContainer/LeftButton
onready var right_page_switch_button = $HBoxContainer/RightButton

onready var map_row_01 = $HBoxContainer/MarginContainer/MarginContainer/VBoxContainer/MapRow01
onready var map_row_02 = $HBoxContainer/MarginContainer/MarginContainer/VBoxContainer/MapRow02

var row_index_to_map_row_dict : Dictionary = {
	
}


const NO_MAP_SELECTED = null

var all_map_cards : Array = [] # does not change

var current_map_ids_displayed : Array = []
var current_map_id_selected = NO_MAP_SELECTED

var button_group_for_map_cards : ButtonGroup_Custom

#

func add_map_ids_to_list(arg_ids : Array):
	for id in arg_ids:
		add_map_id_to_list(id , false)
	
	_update_current_page_count_and_leftright_buttons()
	_update_map_card_selection_display()

func add_map_id_to_list(arg_id, arg_update_states : bool = true):
	if !_map_id_list.has(arg_id):
		_map_id_list.append(arg_id)
	
	if arg_update_states:
		_update_current_page_count_and_leftright_buttons()
		_update_map_card_selection_display()


func _update_current_page_count_and_leftright_buttons():
	var map_per_page : int = map_card_per_row * row_count
	
	current_page_count = ceil((_map_id_list.size() / float(map_per_page)))
	
	_update_display_of_leftright_buttons()


func _update_display_of_leftright_buttons():
	var right_visible = current_page_count > current_page_index + 1
	var left_visible = current_page_index != 0
	
	right_page_switch_button.visible = right_visible
	left_page_switch_button.visible = left_visible


func _on_LeftButton_button_up():
	set_current_page_index(current_page_index - 1)

func _on_RightButton_button_up():
	set_current_page_index(current_page_index + 1)

func set_current_page_index(arg_val):
	if arg_val > current_page_count - 1:
		arg_val = current_page_count - 1
	
	current_page_index = arg_val
	
	_update_current_page_count_and_leftright_buttons()
	_update_map_card_selection_display()
	
	
	clear_current_map_id_selected()


#

func _ready():
	button_group_for_map_cards = ButtonGroup_Custom.new()
	row_index_to_map_row_dict[0] = map_row_01
	row_index_to_map_row_dict[1] = map_row_02
	
	_initialize_map_cards()
	_update_map_card_selection_display()


func _initialize_map_cards():
	var maps_per_page = map_card_per_row * row_count
	var curr_map_card_in_row : int = 0
	var curr_row : int = 0
	
	for i in maps_per_page:
		var map_card = MapCard_Scene.instance()
		
		all_map_cards.append(map_card)
		
		var container : HBoxContainer = row_index_to_map_row_dict[curr_row]
		container.add_child(map_card)
		
		map_card.map_id = NO_MAP_SELECTED
		map_card.configure_self_with_button_group(button_group_for_map_cards)
		map_card.connect("toggle_mode_changed", self, "_on_map_card_toggle_mode_changed", [map_card])
		
		curr_map_card_in_row += 1
		if curr_map_card_in_row >= map_card_per_row:
			curr_map_card_in_row = 0
			curr_row += 1


func _update_map_card_selection_display():
	current_map_ids_displayed = _get_map_ids_based_on_index()
	clear_current_map_id_selected()
	
	var map_type_informations : Array = []
	for id in current_map_ids_displayed:
		map_type_informations.append(StoreOfMaps.get_map_type_information_from_id(id))
	
	for i in map_card_per_row * row_count:
		if current_map_ids_displayed.size() > i:
			all_map_cards[i].set_map_info_based_on_type_information(map_type_informations[i])
			all_map_cards[i].visible = true
		else:
			all_map_cards[i].visible = false


func _get_map_ids_based_on_index():
	var maps_per_page = map_card_per_row * row_count
	var maps_skipped = current_page_index * maps_per_page
	
	var bucket : Array = []
	for i in _map_id_list.size():
		if i < maps_skipped:
			continue
		else:
			if bucket.size() < maps_per_page:
				bucket.append(_map_id_list[i])
			else:
				break
	
	return bucket

#

func clear_current_map_id_selected():
	set_current_map_id_selected(NO_MAP_SELECTED)

func set_current_map_id_selected(arg_id):
	current_map_id_selected = arg_id
	
	if current_map_id_selected == NO_MAP_SELECTED:
		var curr_button_toggled = button_group_for_map_cards.get_toggled_on_button()
		if is_instance_valid(curr_button_toggled):
			curr_button_toggled.set_is_toggle_mode_on(false)
	
	
	emit_signal("on_current_selected_map_id_changed", current_map_id_selected)

#

func _on_map_card_toggle_mode_changed(arg_val : bool, arg_map_card : MapCard):
	if arg_val:
		set_current_map_id_selected(arg_map_card.map_id)
		
	elif !arg_val and current_map_id_selected == arg_map_card.map_id:
		clear_current_map_id_selected()


#
#
#func select_first_visible_map_card():
#	if current_map_ids_displayed.size() > 0:
#		var first_id_displayed = current_map_ids_displayed[0]
#		set_current_map_id_selected(first_id_displayed)
#
#		var first_card_displayed
#		for map_card in all_map_cards:
#			if map_card.map_id == first_id_displayed and first_id_displayed != -1:
#				first_card_displayed = map_card
#				break
#		if first_card_displayed != null:
#			first_card_displayed.set_is_toggle_mode_on(true)


func select_map_card_with_id(arg_id):
	if !StoreOfMaps.MapIdsAvailableFromMenu.has(arg_id):
		arg_id = StoreOfMaps.default_map_id_for_empty
	
	var first_id_displayed = arg_id
	set_current_map_id_selected(first_id_displayed)
	
	var first_card_displayed
	for map_card in all_map_cards:
		if map_card.map_id == first_id_displayed and first_id_displayed != NO_MAP_SELECTED:
			first_card_displayed = map_card
			break
	if first_card_displayed != null:
		first_card_displayed.set_is_toggle_mode_on(true)


