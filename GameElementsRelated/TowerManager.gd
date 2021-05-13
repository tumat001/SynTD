extends Node

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const GameElements = preload("res://GameElementsRelated/GameElements.gd")
const InMapPlacablesManager = preload("res://GameElementsRelated/InMapPlacablesManager.gd")
const RightSidePanel = preload("res://GameHUDRelated/RightSidePanel/RightSidePanel.gd")
const TowerStatsPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerStatsPanel/TowerStatsPanel.gd")
const ActiveIngredientsPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/ActiveIngredientsPanel/ActiveIngredientsPanel.gd")
const TowerColorsPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerColorsPanel/TowerColorsPanel.gd")


signal ingredient_mode_turned_into(on_or_off)
signal show_ingredient_acceptability(ingredient_effect, tower_selected)
signal hide_ingredient_acceptability

var tower_inventory_bench
var game_elements : GameElements
var in_map_placables_manager : InMapPlacablesManager

var is_in_ingredient_mode : bool = false
var tower_being_dragged : AbstractTower

var tower_being_shown_in_info : AbstractTower

var right_side_panel : RightSidePanel
var tower_stats_panel : TowerStatsPanel
var active_ing_panel : ActiveIngredientsPanel
var tower_colors_panel : TowerColorsPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Generic things that can branch out to other resp.

func _tower_in_queue_free():
	_update_active_synergy()


func _unhandled_key_input(event):
	if !event.echo and event.scancode == KEY_SPACE and event.pressed:
		_toggle_ingredient_combine_mode()


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if game_elements.right_side_panel.panel_showing == game_elements.right_side_panel.Panels.TOWER_INFO:
			if event.pressed and (event.button_index == BUTTON_RIGHT or event.button_index == BUTTON_LEFT):
				_show_round_panel()
		


# Adding tower as child of this to monitor it
func add_tower(tower_instance : AbstractTower):
	add_child(tower_instance)
	tower_instance.connect("tower_being_dragged", self, "_tower_being_dragged")
	tower_instance.connect("tower_dropped_from_dragged", self, "_tower_dropped_from_dragged")
	tower_instance.connect("tower_toggle_show_info", self, "_tower_toggle_show_info")
	tower_instance.connect("tower_in_queue_free", self, "_tower_in_queue_free")
	tower_instance.connect("update_active_synergy", self, "_update_active_synergy")
	
	connect("ingredient_mode_turned_into", tower_instance, "_set_is_in_ingredient_mode")
	connect("show_ingredient_acceptability", tower_instance, "show_acceptability_with_ingredient")
	connect("hide_ingredient_acceptability", tower_instance, "hide_acceptability_with_ingredient")

# Movement drag related

func _tower_being_dragged(tower_dragged : AbstractTower):
	tower_being_dragged = tower_dragged
	tower_inventory_bench.make_all_slots_glow()
	in_map_placables_manager.make_all_placables_glow()
	
	if is_in_ingredient_mode:
		emit_signal("show_ingredient_acceptability", tower_being_dragged.ingredient_of_self, tower_being_dragged)

func _tower_dropped_from_dragged(tower_released : AbstractTower):
	tower_being_dragged = null
	tower_inventory_bench.make_all_slots_not_glow()
	in_map_placables_manager.make_all_placables_not_glow()
	
	if is_in_ingredient_mode:
		emit_signal("hide_ingredient_acceptability")

# Ingredient drag related

func _toggle_ingredient_combine_mode():
	is_in_ingredient_mode = !is_in_ingredient_mode
	
	emit_signal("ingredient_mode_turned_into", is_in_ingredient_mode)
	
	if is_in_ingredient_mode:
		if tower_being_dragged != null:
			emit_signal("show_ingredient_acceptability", tower_being_dragged.ingredient_of_self, tower_being_dragged)
		
		
		game_elements.inner_bottom_panel.show_ingredient_notification_mode()
	else:
		emit_signal("hide_ingredient_acceptability")
		game_elements.inner_bottom_panel.show_buy_sell_panel()
	


# Synergy Related

func _update_active_synergy():
	game_elements.synergy_manager.update_synergies(_get_all_synegy_contributing_towers())

func _get_all_synegy_contributing_towers() -> Array:
	var bucket : Array = []
	for tower in get_children():
		if tower is AbstractTower and tower.is_contributing_to_synergy:
			bucket.append(tower)
	
	return bucket


# Tower info show related

func _tower_toggle_show_info(tower : AbstractTower):
	if right_side_panel.panel_showing != right_side_panel.Panels.TOWER_INFO:
		_show_tower_info_panel(tower)
	else:
		_show_round_panel()
	


func _show_tower_info_panel(tower : AbstractTower):
	right_side_panel.show_tower_info_panel(tower)
	
	tower_being_shown_in_info = tower
	tower.connect("final_range_changed", self, "_update_final_range_in_info")
	tower.connect("final_attack_speed_changed", self, "_update_final_attack_speed_in_info")
	tower.connect("final_base_damage_changed", self, "_update_final_base_damage_in_info")
	tower.connect("ingredients_absorbed_changed", self, "_update_ingredients_absorbed_in_info")
	tower.connect("tower_colors_changed", self, "_update_tower_colors_in_info")


func _update_final_range_in_info():
	tower_stats_panel.update_final_range()

func _update_final_attack_speed_in_info():
	tower_stats_panel.update_final_attack_speed()

func _update_final_base_damage_in_info():
	tower_stats_panel.update_final_base_damage()

func _update_ingredients_absorbed_in_info():
	active_ing_panel.update_display()

func _update_tower_colors_in_info():
	tower_colors_panel.update_display()


func _show_round_panel():
	right_side_panel.show_round_panel()
	
	tower_being_shown_in_info.disconnect("final_range_changed", self, "_update_final_range_in_info")
	tower_being_shown_in_info.disconnect("final_attack_speed_changed", self, "_update_final_attack_speed_in_info")
	tower_being_shown_in_info.disconnect("final_base_damage_changed", self, "_update_final_base_damage_in_info")
	tower_being_shown_in_info.disconnect("ingredients_absorbed_changed", self, "_update_ingredients_absorbed_in_info")
	tower_being_shown_in_info.disconnect("tower_colors_changed", self, "_update_tower_colors_in_info")
	
	tower_being_shown_in_info = null
