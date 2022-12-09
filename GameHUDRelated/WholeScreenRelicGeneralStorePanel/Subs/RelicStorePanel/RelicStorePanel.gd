extends MarginContainer

const RelicStoreOfferOption = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Classes/RelicStoreOfferOption.gd")
const RelicStoreOfferButton = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Subs/RelicStoreOfferButton/RelicStoreOfferButton.gd")
const RelicStoreOfferButton_Scene = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Subs/RelicStoreOfferButton/RelicStoreOfferButton.tscn")

#

signal before_call_obj_source_on_click_on_button(arg_relic_store_offer_option, arg_button_id)
signal after_call_obj_source_on_click_on_button(arg_relic_store_offer_option, arg_success, arg_button_id)


const default_grid_column_count : int = 4

var _id_to_relic_offer_button_map : Dictionary
var _next_id : int = 0
var relic_manager

onready var button_grid_panel = $ContentPanel/ButtonGridPanel

#

func _ready():
	set_grid_column_count(default_grid_column_count)

#

func add_relic_store_offer_option(arg_relic_store_offer_option : RelicStoreOfferOption) -> int:
	return _create_relic_store_offer_button(arg_relic_store_offer_option)
	

func _create_relic_store_offer_button(arg_relic_store_offer_option : RelicStoreOfferOption) -> int:
	var button = RelicStoreOfferButton_Scene.instance()
	button.relic_store_offer_option = arg_relic_store_offer_option
	button.relic_manager = relic_manager
	
	button.connect("before_call_obj_source_on_click", self, "_on_before_call_obj_source_on_click", [_next_id], CONNECT_PERSIST)
	button.connect("after_call_obj_source_on_click", self, "_on_after_call_obj_source_on_click", [_next_id], CONNECT_PERSIST)
	
	button_grid_panel.add_child(button)
	
	
	_id_to_relic_offer_button_map[_next_id] = button
	_next_id += 1
	
	return _next_id - 1


func remove_relic_store_offer_option(arg_offer_id):
	if _id_to_relic_offer_button_map.has(arg_offer_id):
		var button = _id_to_relic_offer_button_map[arg_offer_id]
		
		if is_instance_valid(button) and !button.is_queued_for_deletion():
			button.queue_free()
			_id_to_relic_offer_button_map.erase(arg_offer_id)

func trigger_relic_store_offer_option(arg_offer_id):
	if _id_to_relic_offer_button_map.has(arg_offer_id):
		var button = _id_to_relic_offer_button_map[arg_offer_id]
		
		if is_instance_valid(button) and !button.is_queued_for_deletion():
			button.trigger_button()


func is_shop_offer_id_exists(arg_offer_id):
	return _id_to_relic_offer_button_map.has(arg_offer_id)

#

func set_grid_column_count(arg_count : int):
	button_grid_panel.columns = arg_count

####

func _on_before_call_obj_source_on_click(arg_relic_store_offer_option, arg_button_id):
	emit_signal("before_call_obj_source_on_click_on_button", arg_relic_store_offer_option, arg_button_id)

func _on_after_call_obj_source_on_click(arg_relic_store_offer_option, arg_success, arg_button_id):
	emit_signal("after_call_obj_source_on_click_on_button", arg_relic_store_offer_option, arg_success, arg_button_id)


