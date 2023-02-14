extends "res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd"

const Tutorial_WhiteArrow_Particle = preload("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/Sub/Tutorial_WhiteArrow_Particle.gd")
const Tutorial_WhiteArrow_Particle_Scene = preload("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/Sub/Tutorial_WhiteArrow_Particle.tscn")
const Tutorial_WhiteCircle_Particle = preload("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/Sub/Tutorial_WhiteCircle_Particle.gd")
const Tutorial_WhiteCircle_Particle_Scene = preload("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/Sub/Tutorial_WhiteCircle_Particle.tscn")

const StatusIcon_ContinueNext = preload("res://GameHUDRelated/NotificationPanel/TutorialPanel/Assets/TutorialPanel_Indicator_Next.png")
const StatusIcon_ActionNeeded = preload("res://GameHUDRelated/NotificationPanel/TutorialPanel/Assets/TutorialPanel_Indicator_ActionNeeded.png")
const StatusIcon_Wait = preload("res://GameHUDRelated/NotificationPanel/TutorialPanel/Assets/TutorialPanel_Indicator_Wait.png")


signal on_current_transcript_index_changed(arg_index, arg_message)
signal at_end_of_transcript()

enum ProgressMode {
	CONTINUE = 0,
	ACTION_FROM_PLAYER = 1,
	WAIT_FOR_EVENT = 2,
}

var progress_mode_to_icon_img : Dictionary = {
	ProgressMode.CONTINUE : StatusIcon_ContinueNext,
	ProgressMode.ACTION_FROM_PLAYER : StatusIcon_ActionNeeded,
	ProgressMode.WAIT_FOR_EVENT : StatusIcon_Wait
}

var progress_mode_to_default_tooltip_msg : Dictionary = {
	ProgressMode.CONTINUE : "Click anywhere or Press ENTER to continue.",
	ProgressMode.ACTION_FROM_PLAYER : "Please do the requested action to continue.",
	ProgressMode.WAIT_FOR_EVENT : "Waiting",
}


const starting_curr_transcript_index : int = -1 # do not touch
var current_transcript_index : int = starting_curr_transcript_index
var current_custom_towers_at_shop_index : int = -1

var exit_scene_if_at_end_of_transcript : bool = true

var _towers_bought_for_multiple_listen : Array = []
var _towers_placed_in_map_for_multiple_listen : Array = []
var _towers_placed_in_bench_for_multiple_listen : Array = []

#

func _init(arg_modi_id, arg_breakpoint_id : int, arg_name : String).(arg_modi_id, arg_breakpoint_id, arg_name):
	pass

func _get_transcript(): # implemented by classes
	pass

#

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	
	game_elements.tutotial_notif_panel.initialize()
	
	game_elements.connect("unhandled_input", self, "_game_elements_unhandled_input")
	game_elements.connect("unhandled_key_input", self, "_game_elements_unhandled_key_input")
	game_elements.connect("before_game_start", self, "_on_game_elements_before_game_start__base_class", [], CONNECT_ONESHOT)
	

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	

#

func _on_game_elements_before_game_start__base_class():
	set_notif_from_attempt_placing_towers(false)


func _game_elements_unhandled_input(arg_event, arg_action_taken):
	if !arg_action_taken:
		if arg_event is InputEventMouseButton:
			if arg_event.pressed and (arg_event.button_index == BUTTON_RIGHT or arg_event.button_index == BUTTON_LEFT):
				if !is_instance_valid(game_elements.tower_manager.get_tower_on_mouse_hover()):
					_player_requests_advance_to_next_transcript_message()


func _game_elements_unhandled_key_input(arg_event, arg_action_taken):
	if !arg_action_taken:
		if !arg_event.echo and arg_event.pressed:
			if game_elements.if_allow_key_inputs_due_to_conditions():
				if arg_event.is_action_pressed("ui_accept"):
					_player_requests_advance_to_next_transcript_message()


func _player_requests_advance_to_next_transcript_message():
	if _if_current_transcript_has_progress_mode(ProgressMode.CONTINUE):
		if game_elements.tutotial_notif_panel.all_text_is_visible:
			advance_to_next_transcript_message()
		else:
			game_elements.tutotial_notif_panel.show_all_text_and_icon()
		
	else:
		if !game_elements.tutotial_notif_panel.all_text_is_visible or current_transcript_index != starting_curr_transcript_index:
			game_elements.tutotial_notif_panel.show_all_text_and_icon()


func _if_current_transcript_has_progress_mode(arg_mode):
	var curr_transcript = _get_text_transcript_at_current_index()
	return _get_transcript()[curr_transcript] == arg_mode

func advance_to_next_transcript_message():
	#if game_elements.tutotial_notif_panel.all_text_is_visible or current_transcript_index == starting_curr_transcript_index:
	current_transcript_index += 1
	var transcript_size = _get_transcript().size()
	
	if transcript_size <= current_transcript_index:
		if exit_scene_if_at_end_of_transcript:
			CommsForBetweenScenes.goto_starting_screen(game_elements)
		
	else:
		
		if transcript_size <= current_transcript_index + 1 and !exit_scene_if_at_end_of_transcript:
			_show_transcript_msg_at_index(current_transcript_index)
			game_elements.disconnect("unhandled_input", self, "_game_elements_unhandled_input")
			game_elements.disconnect("unhandled_key_input", self, "_game_elements_unhandled_key_input")
			emit_signal("at_end_of_transcript")
			
		else:
			_show_transcript_msg_at_index(current_transcript_index)
			emit_signal("on_current_transcript_index_changed", current_transcript_index, _get_text_transcript_at_current_index())
	
	
	#else:
	#	game_elements.tutotial_notif_panel.show_all_text_and_icon()


func _show_transcript_msg_at_index(arg_index):
	var progress_mode = _get_progress_mode_of_transcript_at_current_index()
	var img_of_progress_mode = progress_mode_to_icon_img[progress_mode]
	var tooltip_for_img = progress_mode_to_default_tooltip_msg[progress_mode]
	game_elements.tutotial_notif_panel.set_text_and_icon(_get_text_transcript_at_current_index(), img_of_progress_mode, tooltip_for_img)


func _get_text_transcript_at_current_index():
	return _get_transcript().keys()[current_transcript_index]

func _get_progress_mode_of_transcript_at_current_index():
	return _get_transcript().values()[current_transcript_index]


func hide_current_transcript_message():
	game_elements.tutotial_notif_panel.hide_notif_panel()

#

func _get_custom_shop_towers():
	return null

func advance_to_next_custom_towers_at_shop():
	current_custom_towers_at_shop_index += 1
	var tower_ids = _get_custom_shop_towers()[current_custom_towers_at_shop_index]
	if tower_ids != null:
		game_elements.shop_manager.roll_towers_in_shop__specific_ids(tower_ids)

#

# automatically called (and set to false)
func set_notif_from_attempt_placing_towers(arg_val : bool):
	game_elements.tower_manager.can_show_player_desc_of_level_required = arg_val

func set_round_is_startable(arg_val : bool):
	game_elements.round_status_panel.can_start_round = arg_val
	game_elements.round_status_panel.round_speed_and_start_panel.visible = arg_val

func set_can_level_up(arg_val : bool):
	if arg_val:
		game_elements.level_manager.can_level_up_clauses.remove_clause(game_elements.LevelManager.CanLevelUpClauses.TUTORIAL_DISABLE)
	else:
		game_elements.level_manager.can_level_up_clauses.attempt_insert_clause(game_elements.LevelManager.CanLevelUpClauses.TUTORIAL_DISABLE)

func set_can_refresh_shop__panel_based(arg_val : bool):
	if arg_val:
		game_elements.panel_buy_sell_level_roll.can_refresh_shop_clauses.remove_clause(game_elements.panel_buy_sell_level_roll.CanRefreshShopClauses.TUTORIAL_DISABLE)
	else:
		game_elements.panel_buy_sell_level_roll.can_refresh_shop_clauses.attempt_insert_clause(game_elements.panel_buy_sell_level_roll.CanRefreshShopClauses.TUTORIAL_DISABLE)

func set_can_refresh_shop_at_round_end_clauses(arg_val):
	if arg_val:
		game_elements.shop_manager.can_refresh_shop_at_round_end_clauses.remove_clause(game_elements.ShopManager.CanRefreshShopAtRoundEndClauses.TUTORIAL_DISABLE)
	else:
		game_elements.shop_manager.can_refresh_shop_at_round_end_clauses.attempt_insert_clause(game_elements.ShopManager.CanRefreshShopAtRoundEndClauses.TUTORIAL_DISABLE)


func set_enabled_buy_slots(arg_array : Array): # ex: [1, 2] = the first and second buy slots (from the left) are enabled
	for i in game_elements.panel_buy_sell_level_roll.all_buy_slots.size():
		i += 1
		var buy_slot = game_elements.panel_buy_sell_level_roll.all_buy_slots[i - 1]
		var clause = game_elements.panel_buy_sell_level_roll.buy_slot_to_disabled_clauses[buy_slot]
		
		if arg_array.has(i):
			clause.remove_clause(game_elements.panel_buy_sell_level_roll.BuySlotDisabledClauses.TUTORIAL_DISABLE)
		else:
			clause.attempt_insert_clause(game_elements.panel_buy_sell_level_roll.BuySlotDisabledClauses.TUTORIAL_DISABLE)

func set_can_sell_towers(arg_val : bool):
	if arg_val:
		game_elements.sell_panel.can_sell_clauses.remove_clause(game_elements.SellPanel.CanSellClauses.TUTORIAL_DISABLE)
	else:
		game_elements.sell_panel.can_sell_clauses.attempt_insert_clause(game_elements.SellPanel.CanSellClauses.TUTORIAL_DISABLE)

func set_can_toggle_to_ingredient_mode(arg_val : bool):
	if arg_val:
		game_elements.tower_manager.can_toggle_to_ingredient_mode_clauses.remove_clause(game_elements.tower_manager.CanToggleToIngredientModeClauses.TUTORIAL_DISABLE)
	else:
		game_elements.tower_manager.can_toggle_to_ingredient_mode_clauses.attempt_insert_clause(game_elements.tower_manager.CanToggleToIngredientModeClauses.TUTORIAL_DISABLE)

func set_can_towers_swap_positions_to_another_tower(arg_val):
	if arg_val:
		game_elements.tower_manager.can_towers_swap_positions_clauses.remove_clause(game_elements.tower_manager.CanTowersSwapPositionsClauses.TUTORIAL_DISABLE)
	else:
		game_elements.tower_manager.can_towers_swap_positions_clauses.attempt_insert_clause(game_elements.tower_manager.CanTowersSwapPositionsClauses.TUTORIAL_DISABLE)

func set_bonus_ingredient_limit_amount(arg_amount : int):
	game_elements.tower_manager.set_tower_limit_id_amount(StoreOfIngredientLimitModifierID.TUTORIAL, arg_amount)

func add_shop_per_refresh_modifier(arg_modi : int):
	game_elements.shop_manager.add_towers_per_refresh_amount_modifier(game_elements.ShopManager.TowersPerShopModifiers.TUTORIAL, arg_modi)

func clear_all_tower_cards_from_shop():
	game_elements.panel_buy_sell_level_roll.remove_tower_card_from_all_buy_slots()

func set_can_do_combination(arg_val : bool):
	if arg_val:
		game_elements.combination_manager.can_do_combination_clauses.remove_clause(game_elements.CombinationManager.CanDoCombinationClauses.TUTORIAL_DISABLE)
	else:
		game_elements.combination_manager.can_do_combination_clauses.attempt_insert_clause(game_elements.CombinationManager.CanDoCombinationClauses.TUTORIAL_DISABLE)

#

func add_gold_amount(arg_amount : int):
	game_elements.gold_manager.increase_gold_by(arg_amount, game_elements.GoldManager.IncreaseGoldSource.SYNERGY)

func set_player_level(arg_level : int):
	game_elements.level_manager.set_current_level(arg_level)

func set_ingredient_limit_modi(arg_amount : int):
	game_elements.tower_manager.set_ing_cap_changer(StoreOfIngredientLimitModifierID.TUTORIAL, arg_amount)

func set_can_return_to_round_panel(arg_val : bool):
	game_elements.can_return_to_round_panel = arg_val

# 

func set_tower_is_draggable(arg_tower, arg_val):
	if arg_val:
		arg_tower.tower_is_draggable_clauses.remove_clause(arg_tower.TowerDraggableClauseIds.TUTORIAL_DISABLED)
	else:
		arg_tower.tower_is_draggable_clauses.attempt_insert_clause(arg_tower.TowerDraggableClauseIds.TUTORIAL_DISABLED)

func set_tower_is_sellable(arg_tower, arg_val):
	if arg_val:
		arg_tower.can_be_sold_conditonal_clauses.remove_clause(arg_tower.CanBeSoldClauses.TUTORIAL_DISABLED_CLAUSE)
	else:
		arg_tower.can_be_sold_conditonal_clauses.attempt_insert_clause(arg_tower.CanBeSoldClauses.TUTORIAL_DISABLED_CLAUSE)

#

func create_tower_at_placable(arg_tower_id, arg_placable):
	var tower = game_elements.tower_inventory_bench.create_tower_and_add_to_scene(arg_tower_id, arg_placable)
	return tower

##

# expects a method that accepts a tower instance
func listen_for_tower_with_id__bought__then_call_func(arg_tower_id : int, arg_func_name : String, arg_func_source):
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added", [arg_tower_id, arg_func_name, arg_func_source])

func _on_tower_added(arg_tower_instance, arg_expected_tower_id, arg_func_name, arg_func_source):
	if arg_tower_instance.tower_id == arg_expected_tower_id:
		game_elements.tower_manager.disconnect("tower_added", self, "_on_tower_added")
		arg_func_source.call(arg_func_name, arg_tower_instance)


# expects a method that accepts an array (of tower instances)
func listen_for_towers_with_ids__bought__then_call_func(arg_tower_ids : Array, arg_func_name : String, arg_func_source):
	_towers_bought_for_multiple_listen.clear()
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added__multiple_needed", [arg_tower_ids, arg_func_name, arg_func_source])

func _on_tower_added__multiple_needed(arg_tower_instance, arg_expected_tower_ids, arg_func_name, arg_func_source):
	var tower_id = arg_tower_instance.tower_id
	
	set_tower_is_sellable(arg_tower_instance, false)
	set_tower_is_draggable(arg_tower_instance, false)
	
	if arg_expected_tower_ids.has(tower_id):
		arg_expected_tower_ids.erase(tower_id)
		_towers_bought_for_multiple_listen.append(arg_tower_instance)
	
	if arg_expected_tower_ids.size() == 0:
		game_elements.tower_manager.disconnect("tower_added", self, "_on_tower_added__multiple_needed")
		arg_func_source.call(arg_func_name, _towers_bought_for_multiple_listen.duplicate())
		_towers_bought_for_multiple_listen.clear()


# expects a method that accepts an array (of tower instances)
func listen_for_towers_with_ids__placed_in_map__then_call_func(arg_tower_ids : Array, arg_func_name : String, arg_func_source):
	_towers_placed_in_map_for_multiple_listen.clear()
	game_elements.tower_manager.connect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_drag__multiple_needed", [arg_tower_ids, arg_func_name, arg_func_source])
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_must_be_placed_in_map")

func _on_tower_must_be_placed_in_map(arg_tower):
	set_tower_is_sellable(arg_tower, false)
	#set_tower_is_draggable(arg_tower, false)

func _on_tower_dropped_from_drag__multiple_needed(arg_tower_instance, arg_expected_tower_ids : Array, arg_func_name, arg_func_source):
	var tower_id = arg_tower_instance.tower_id
	var is_placable_in_map = arg_tower_instance.is_current_placable_in_map()
	
	if arg_expected_tower_ids.has(tower_id):
		if is_placable_in_map and !_towers_placed_in_map_for_multiple_listen.has(arg_tower_instance):
			_towers_placed_in_map_for_multiple_listen.append(arg_tower_instance)
		elif !is_placable_in_map and _towers_placed_in_map_for_multiple_listen.has(arg_tower_instance):
			_towers_placed_in_map_for_multiple_listen.erase(arg_tower_instance)
	
	if _if_tower_arr_matches_tower_id_arr(_towers_placed_in_map_for_multiple_listen, arg_expected_tower_ids):
		game_elements.tower_manager.disconnect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_drag__multiple_needed")
		game_elements.tower_manager.disconnect("tower_added", self, "_on_tower_must_be_placed_in_map")
		arg_func_source.call(arg_func_name, _towers_placed_in_map_for_multiple_listen.duplicate())
		_towers_placed_in_map_for_multiple_listen.clear()


func _if_tower_arr_matches_tower_id_arr(arg_tower_arr : Array, arg_tower_id_arr : Array):
	if arg_tower_arr.size() == arg_tower_id_arr.size():
		var copy_tower_arr = arg_tower_arr.duplicate()
		var copy_tower_id_arr = arg_tower_id_arr.duplicate()
		
		for tower_inst in copy_tower_arr:
			var tower_id = tower_inst.tower_id
			if copy_tower_id_arr.has(tower_id):
				copy_tower_arr.erase(tower_inst)
				copy_tower_id_arr.erase(tower_id)
			else:
				return false
		
		return true
	
	return false

# expects method that accepts no args
func listen_for_round_start__then_listen_for_round_end__call_func_for_both(arg_func_source, arg_func_name_for_start, arg_func_name_for_end):
	game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [arg_func_source, arg_func_name_for_start], CONNECT_ONESHOT)
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [arg_func_source, arg_func_name_for_end], CONNECT_ONESHOT)


func _on_round_start(arg_stageround, arg_func_source, arg_func_name_to_call):
	if arg_func_source.has_method(arg_func_name_to_call):
		arg_func_source.call(arg_func_name_to_call)

func _on_round_end(arg_stageround, arg_func_source, arg_func_name_to_call):
	if arg_func_source.has_method(arg_func_name_to_call):
		arg_func_source.call(arg_func_name_to_call)


# expects a method that accepts a tower id (int) and a buy slot (node)
func listen_for_tower_buy_card_view_description_tooltip(arg_expected_tower_id : int, arg_func_source, arg_func_name):
	game_elements.panel_buy_sell_level_roll.connect("viewing_tower_description_tooltip", self, "_on_viewing_tower_buy_card_description_tooltip", [arg_expected_tower_id, arg_func_source, arg_func_name])

func _on_viewing_tower_buy_card_description_tooltip(arg_tower_id : int, arg_tower_buy_slot, arg_expected_tower_id : int, arg_func_source, arg_func_name):
	if arg_tower_id == arg_expected_tower_id:
		arg_func_source.call(arg_func_name, arg_tower_id, arg_tower_buy_slot)
		game_elements.panel_buy_sell_level_roll.disconnect("viewing_tower_description_tooltip", self, "_on_viewing_tower_buy_card_description_tooltip")

# expects a method that accepts a tower instance
func listen_for_view_tower_info_panel(arg_expected_tower_id : int, arg_func_source, arg_func_name):
	game_elements.tower_manager.connect("tower_info_panel_shown", self, "_on_viewing_tower_info_panel", [arg_expected_tower_id, arg_func_source, arg_func_name])

func _on_viewing_tower_info_panel(arg_tower, arg_expected_tower_id, arg_func_source, arg_func_name):
	if arg_expected_tower_id == -1 or arg_tower.tower_id == arg_expected_tower_id:
		game_elements.tower_manager.disconnect("tower_info_panel_shown", self, "_on_viewing_tower_info_panel")
		arg_func_source.call(arg_func_name, arg_tower)


# expects a method that accepts tower info panel, and tower instance
func listen_for_view_extra_info_panel(arg_expected_tower_id : int, arg_func_source, arg_func_name):
	game_elements.tower_info_panel.connect("on_extra_info_panel_shown", self, "_on_extra_info_panel_shown", [arg_expected_tower_id, arg_func_source, arg_func_name])

func _on_extra_info_panel_shown(arg_info_panel, arg_tower, arg_expected_id, arg_func_source, arg_func_name):
	if arg_expected_id == -1 or arg_tower.tower_id == arg_expected_id:
		game_elements.tower_info_panel.disconnect("on_extra_info_panel_shown", self, "_on_extra_info_panel_shown")
		arg_func_source.call(arg_func_name, arg_info_panel, arg_tower)


# expects a method that accepts player level
func listen_for_player_level_up(arg_expected_level : int, arg_func_source, arg_func_name):
	game_elements.level_manager.connect("on_current_level_changed", self, "_on_player_curr_level_changed", [arg_expected_level, arg_func_source, arg_func_name])

func _on_player_curr_level_changed(arg_level, arg_expected_lvl, arg_func_source, arg_func_name):
	if arg_expected_lvl == -1 or arg_level == arg_expected_lvl:
		game_elements.level_manager.disconnect("on_current_level_changed", self, "_on_player_curr_level_changed")
		arg_func_source.call(arg_func_name, arg_level)


# expects a method that accepts tower ids (array)
func listen_for_shop_refresh(arg_func_source, arg_func_name):
	game_elements.shop_manager.connect("shop_rolled_with_towers", self, "_on_shop_rolled_with_towers", [arg_func_source, arg_func_name])

func _on_shop_rolled_with_towers(arg_tower_ids, arg_func_source, arg_func_name):
	game_elements.shop_manager.disconnect("shop_rolled_with_towers", self, "_on_shop_rolled_with_towers")
	arg_func_source.call(arg_func_name, arg_tower_ids)


# expects a method that accepts sellback gold (int) and tower id
func listen_for_tower_sold(arg_expected_id, arg_func_source, arg_func_name):
	game_elements.tower_manager.connect("tower_being_sold", self, "_on_tower_being_sold", [arg_expected_id, arg_func_source, arg_func_name])

func _on_tower_being_sold(arg_sellback_gold, arg_tower_sold, arg_expected_id, arg_func_source, arg_func_name):
	if arg_expected_id == -1 or arg_tower_sold.tower_id == arg_expected_id:
		game_elements.tower_manager.disconnect("tower_being_sold", self, "_on_tower_being_sold")
		arg_func_source.call(arg_func_name, arg_sellback_gold, arg_expected_id)


# expects a method that accepts an array (of tower instances)
func listen_for_towers_with_ids__placed_in_bench__then_call_func(arg_tower_ids : Array, arg_func_name : String, arg_func_source):
	_towers_placed_in_bench_for_multiple_listen.clear()
	game_elements.tower_manager.connect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_drag__to_place_in_bench_multiple_needed", [arg_tower_ids, arg_func_name, arg_func_source])


func _on_tower_dropped_from_drag__to_place_in_bench_multiple_needed(arg_tower_instance, arg_expected_tower_ids : Array, arg_func_name, arg_func_source):
	var tower_id = arg_tower_instance.tower_id
	var is_not_placable_in_map = !arg_tower_instance.is_current_placable_in_map()
	
	if arg_expected_tower_ids.has(tower_id):
		if is_not_placable_in_map and !_towers_placed_in_bench_for_multiple_listen.has(arg_tower_instance):
			_towers_placed_in_bench_for_multiple_listen.append(arg_tower_instance)
		elif !is_not_placable_in_map and _towers_placed_in_bench_for_multiple_listen.has(arg_tower_instance):
			_towers_placed_in_bench_for_multiple_listen.erase(arg_tower_instance)
	
	if _if_tower_arr_matches_tower_id_arr(_towers_placed_in_bench_for_multiple_listen, arg_expected_tower_ids):
		game_elements.tower_manager.disconnect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_drag__to_place_in_bench_multiple_needed")
		arg_func_source.call(arg_func_name, _towers_placed_in_bench_for_multiple_listen.duplicate())
		_towers_placed_in_bench_for_multiple_listen.clear()


# expects a method that accepts no args
func listen_for_ingredient_mode_toggle(arg_expected_ing_mode_active : bool, arg_func_name, arg_func_source):
	game_elements.tower_manager.connect("ingredient_mode_turned_into", self, "_on_ing_mode_toggled", [arg_expected_ing_mode_active, arg_func_name, arg_func_source])

func _on_ing_mode_toggled(arg_ing_mode_active : bool, arg_expected_ing_mode_active : bool, arg_func_name, arg_func_source):
	if arg_ing_mode_active == arg_expected_ing_mode_active:
		game_elements.tower_manager.disconnect("ingredient_mode_turned_into", self, "_on_ing_mode_toggled")
		arg_func_source.call(arg_func_name)


# expects a method that accepts an ing effect
func listen_for_tower_to_absorb_ing_id(arg_expected_tower, arg_expected_ing_id, arg_func_name, arg_func_source):
	arg_expected_tower.connect("on_ingredient_absorbed", self, "_on_tower_absorbed_ingredient", [arg_expected_tower, arg_expected_ing_id, arg_func_name, arg_func_source])

func _on_tower_absorbed_ingredient(arg_ing_effect, arg_expected_tower, arg_expected_ing_id, arg_func_name, arg_func_source):
	if arg_ing_effect.tower_base_effect.effect_uuid == arg_expected_ing_id:
		arg_expected_tower.disconnect("on_ingredient_absorbed", self, "_on_tower_absorbed_ingredient")
		arg_func_source.call(arg_func_name, arg_ing_effect)


# expects a method that accepts no args
func listen_for_combination_effect_added(arg_expected_combi_id, arg_func_name, arg_func_source):
	game_elements.combination_manager.connect("on_combination_effect_added", self, "_on_combination_effect_added", [arg_expected_combi_id, arg_func_name, arg_func_source])
	

func _on_combination_effect_added(arg_combi_effect_id, arg_expected_combi_id, arg_func_name, arg_func_source):
	if arg_combi_effect_id == arg_expected_combi_id:
		game_elements.combination_manager.disconnect("on_combination_effect_added", self, "_on_combination_effect_added")
		arg_func_source.call(arg_func_name)


func listen_for_synergy_to_be_activated(arg_expected_synergy_name : String, arg_expected_syn_tier : int, arg_func_name, arg_func_source):
	game_elements.synergy_manager.connect("synergies_updated", self, "_on_synergies_updated", [arg_expected_synergy_name, arg_expected_syn_tier, arg_func_name, arg_func_source])

func _on_synergies_updated(arg_expected_synergy_name : String, arg_expected_syn_tier : int, arg_func_name, arg_func_source):
	var is_active = game_elements.synergy_manager.is_color_synergy_name_active__with_tier_being_equal_to(arg_expected_synergy_name, arg_expected_syn_tier)
	
	if is_active:
		game_elements.synergy_manager.disconnect("synergies_updated", self, "_on_synergies_updated")
		arg_func_source.call(arg_func_name)

########

# Get nodes related

func get_tower_buy_card_at_buy_slot_index(arg_index):
	var buy_slot = game_elements.panel_buy_sell_level_roll.all_buy_slots[arg_index]
	return buy_slot.get_current_tower_buy_card()


func get_round_speed_button_01():
	return game_elements.round_status_panel.round_speed_and_start_panel.speed_button_01

func get_round_status_button():
	return game_elements.round_status_panel.round_speed_and_start_panel.start_button

func get_round_start_and_speed_panel():
	return game_elements.round_status_panel.round_speed_and_start_panel


func get_extra_info_button_from_tower_info_panel(): # the little "i" button that displays the tower's description
	return game_elements.tower_info_panel.tower_name_and_pic_panel.extra_info_button

func get_tower_stats_panel_from_tower_info_panel():
	return game_elements.tower_info_panel.tower_stats_panel

func get_level_up_button_from_shop_panel():
	return game_elements.panel_buy_sell_level_roll.level_up_panel

func get_reroll_button_from_shop_panel():
	return game_elements.panel_buy_sell_level_roll.reroll_panel

func get_shop_odds_panel():
	return game_elements.general_stats_panel.shop_percentage_stat_panel

func get_single_syn_displayer_with_synergy_name__from_left_panel(arg_syn_name):
	return game_elements.left_panel.get_single_syn_displayer_with_synergy_name(arg_syn_name)

func get_color_wheel_on_bottom_panel_side():
	#return game_elements.color_wheel_sprite_button
	return game_elements.color_wheel_gui

func get_tower_icon_with_tower_id__on_combination_top_panel(arg_id):
	return game_elements.combination_top_panel.get_tower_icon_with_tower_id(arg_id)

func get_more_combination_info__on_combi_top_panel():
	return game_elements.combination_top_panel.combination_more_details_button

func get_player_level_panel():
	return game_elements.general_stats_panel.level_label

func get_streak_panel():
	return game_elements.general_stats_panel.streak_panel

func get_gold_panel():
	return game_elements.general_stats_panel.gold_amount_label

func get_round_indicator_panel():
	return game_elements.right_side_panel.round_status_panel.round_info_panel_v2.round_indicator_panel

func get_player_health_bar_panel():
	return game_elements.right_side_panel.round_status_panel.round_info_panel_v2.player_health_panel

# INDICATORS

# returns the two arrows (or one, as specified). Returns [horizontal, vertical]
func display_white_arrows_pointed_at_node(arg_node, arg_queue_free_arrows_at_index : int, arg_display_for_horizontal = true, arg_display_for_vertical = true) -> Array:
	var bucket = []
	if arg_display_for_horizontal:
		var arrow = _construct_tutorial_white_arrow(arg_node, false, arg_queue_free_arrows_at_index)
		bucket.append(arrow)
	
	if arg_display_for_vertical:
		var arrow = _construct_tutorial_white_arrow(arg_node, true, arg_queue_free_arrows_at_index)
		bucket.append(arrow)
	
	return bucket

func _construct_tutorial_white_arrow(arg_node, arg_is_vertical : bool, arg_queue_free_at_index : int):
	var arrow = Tutorial_WhiteArrow_Particle_Scene.instance()
	arrow.node_to_point_at = arg_node
	arrow.is_vertical = arg_is_vertical
	arrow.queue_free_at_transcript_index = arg_queue_free_at_index
	
	connect("on_current_transcript_index_changed", arrow, "_on_current_transcript_index_changed__for_white_arrow_monitor")
	#game_elements.get_tree().get_root().add_child(arrow)
	CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(arrow)
	
	return arrow


func display_white_circle_at_node(arg_node, arg_queue_free_at_index : int):
	var circle = Tutorial_WhiteCircle_Particle_Scene.instance()
	circle.node_to_point_at = arg_node
	circle.queue_free_at_transcript_index = arg_queue_free_at_index
	
	connect("on_current_transcript_index_changed", circle, "_on_current_transcript_index_changed__for_white_arrow_monitor")
	#game_elements.get_tree().get_root().add_child(circle)
	CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(circle)
	
	return circle


# get values related

func get_tower_tier_odds_at_player_level(arg_tower_tier, arg_player):
	return game_elements.shop_manager.get_tower_tier_odds_at_player_level(arg_tower_tier, arg_player)


#### Map related

func set_visiblity_of_all_placables(arg_val):
	for placable in game_elements.map_manager.base_map.all_in_map_placables:
		placable.visible = arg_val

func set_visiblity_of_placable(arg_placable, arg_val):
	arg_placable.visible = arg_val



# Map related (GLADE)

func get_map_area_05__from_glade():
	return get_map_area_with_name__from_glade("InMapAreaPlacable5")

func get_map_area_07__from_glade():
	return get_map_area_with_name__from_glade("InMapAreaPlacable7")

func get_map_area_09__from_glade():
	return get_map_area_with_name__from_glade("InMapAreaPlacable9")

func get_map_area_04__from_glade():
	return get_map_area_with_name__from_glade("InMapAreaPlacable2")

func get_map_area_06__from_glade():
	return get_map_area_with_name__from_glade("InMapAreaPlacable6")

func get_map_area_10__from_glade():
	return get_map_area_with_name__from_glade("InMapAreaPlacable")

func get_map_area_11__from_glade():
	return get_map_area_with_name__from_glade("InMapAreaPlacable8")

func get_map_area_14__from_glade():
	return get_map_area_with_name__from_glade("InMapAreaPlacable14")


func get_map_area__for_defaults__from_glade():
	var bucket = []
	bucket.append(get_map_area_05__from_glade())
	bucket.append(get_map_area_07__from_glade())
	bucket.append(get_map_area_09__from_glade())
	bucket.append(get_map_area_04__from_glade())
	bucket.append(get_map_area_06__from_glade())
	bucket.append(get_map_area_10__from_glade())
	bucket.append(get_map_area_11__from_glade())
	bucket.append(get_map_area_14__from_glade())
	
	return bucket


func get_map_area_with_name__from_glade(arg_name):
	return game_elements.map_manager.base_map.get_placable_with_node_name(arg_name)
