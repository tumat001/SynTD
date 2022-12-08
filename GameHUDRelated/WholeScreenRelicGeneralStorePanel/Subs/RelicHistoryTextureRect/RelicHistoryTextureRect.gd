extends TextureRect

const RelicStoreBuyHistory = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Classes/RelicStoreBuyHistory.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")


var relic_store_buy_history : RelicStoreBuyHistory setget set_relic_store_buy_history
var tooltip


func set_relic_store_buy_history(arg_relic_store_buy_history : RelicStoreBuyHistory):
	relic_store_buy_history = arg_relic_store_buy_history
	if is_inside_tree():
		_update_display()

#

func _ready():
	_update_display()
	connect("mouse_entered", self, "_on_mouse_entered_self", [], CONNECT_PERSIST)

func _update_display():
	if relic_store_buy_history != null:
		texture = relic_store_buy_history.texture_to_use

#

func _on_mouse_entered_self():
	_trigger_create_tooltip()


func _trigger_create_tooltip():
	if !is_instance_valid(tooltip):
		_display_requested_tooltip(_construct_tooltip())
	else:
		tooltip.queue_free()
		tooltip = null


func _display_requested_tooltip(arg_tooltip):
	if is_instance_valid(arg_tooltip):
		tooltip = arg_tooltip
		tooltip.visible = true
		tooltip.tooltip_owner = self
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(tooltip)
		tooltip.update_display()

func _construct_tooltip():
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = relic_store_buy_history.descriptions
	a_tooltip.header_left_text = relic_store_buy_history.header_left_text
	
	return a_tooltip


