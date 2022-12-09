extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButtonWithTooltip.gd"

const RelicStoreOfferOption = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Classes/RelicStoreOfferOption.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")


signal before_call_obj_source_on_click(arg_relic_store_offer_option)
signal after_call_obj_source_on_click(arg_relic_store_offer_option, arg_success)


const modulate_on_relic_req_not_met : Color = Color(0.4, 0.4, 0.4)

var relic_store_offer_option : RelicStoreOfferOption setget set_relic_store_offer_option
var relic_manager setget set_relic_manager
var _relic_count_met : bool = false

#

func set_relic_store_offer_option(arg_relic_store_offer_option):
	relic_store_offer_option = arg_relic_store_offer_option
	if is_inside_tree():
		_update_display()

func set_relic_manager(arg_manager):
	relic_manager = arg_manager
	relic_manager.connect("current_relic_count_changed", self, "_on_current_relic_count_changed", [], CONNECT_PERSIST)
	
	if is_inside_tree():
		_update_display()

#

func _ready():
	_update_display()
	connect("about_tooltip_construction_requested", self, "_on_about_tooltip_construction_requested", [], CONNECT_PERSIST)
	connect("released_mouse_event", self, "_on_released_mouse_event", [], CONNECT_PERSIST)
	
	

func _update_display():
	if relic_store_offer_option != null:
		texture_normal = relic_store_offer_option.button_texture_normal
		texture_hover = relic_store_offer_option.button_texture_highlighted
	
	if relic_manager != null:
		_on_current_relic_count_changed(relic_manager.current_relic_count)

#

func _on_about_tooltip_construction_requested():
	display_requested_about_tooltip(_construct_about_tooltip())
	

func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = relic_store_offer_option.get_descriptions_to_use()
	a_tooltip.header_left_text = relic_store_offer_option.get_left_header_text_to_use()
	
	return a_tooltip

#

func _on_released_mouse_event(arg_event : InputEventMouseButton):
	if _relic_count_met:
		if arg_event.button_index == BUTTON_LEFT:
			trigger_button()

func trigger_button():
	if relic_store_offer_option.obj_source_for_on_click != null:
		emit_signal("before_call_obj_source_on_click", relic_store_offer_option)
		var success : bool = relic_store_offer_option.obj_source_for_on_click.call(relic_store_offer_option.obj_method_for_on_click)
		emit_signal("after_call_obj_source_on_click", relic_store_offer_option, success)



#

func _on_current_relic_count_changed(arg_curr_relic_count):
	_relic_count_met = relic_store_offer_option.relic_count_requirement <= arg_curr_relic_count
	disabled = !_relic_count_met
	
	if _relic_count_met:
		modulate = Color(1, 1, 1)
		
	else:
		modulate = modulate_on_relic_req_not_met
		

