extends Node

const GameResultPanel = preload("res://GameHUDRelated/GameResult_VicDefPanel/GameResultPanel.gd")
const GameResultPanel_Scene = preload("res://GameHUDRelated/GameResult_VicDefPanel/GameResultPanel.tscn")

const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")


signal game_result_decided()


enum GameResult {
	ONGOING = 0, # not decided yet
	VICTORY = 1,
	DEFEAT = 2,
	DRAW = 3, # never happens, yet. ~ooooooooooo
}
var game_result : int
var game_result_panel : GameResultPanel

var whole_screen_gui
var game_elements


# queue related

var reservation_for_whole_screen_gui

#

func _ready():
	game_result = GameResult.ONGOING
	
	_initialize_queue_reservation()

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	#reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	#reservation_for_whole_screen_gui.on_removed_method
	
	reservation_for_whole_screen_gui.queue_mode = AdvancedQueue.QueueMode.FORCED__REMOVE_ALL_AND_FLUSH_NEW_WHILE_ACTIVE


#

func set_health_manager(arg_manager):
	arg_manager.connect("zero_health_reached", self, "_on_zero_health_reached", [], CONNECT_PERSIST)

func set_stage_round_manager(arg_manager):
	arg_manager.connect("end_of_stagerounds", self, "_on_end_of_stagerounds", [], CONNECT_PERSIST)


#

func _on_zero_health_reached():
	_set_game_result(GameResult.DEFEAT)

func _on_end_of_stagerounds():
	_set_game_result(GameResult.VICTORY)

func set_game_result__accessed_from_outside(arg_result : int):
	_set_game_result(arg_result)

#

func _set_game_result(arg_result : int):
	if game_result == GameResult.ONGOING and arg_result != GameResult.ONGOING:
		game_result = arg_result
		
		_initialize_game_result_panel()
		_set_properties_of_game_elements_to_post_battle()
		game_elements.enemy_manager.end_run()
		
		emit_signal("game_result_decided")


func _initialize_game_result_panel():
	if game_result_panel == null:
		game_result_panel = GameResultPanel_Scene.instance()
		#whole_screen_gui.show_control(game_result_panel)
		whole_screen_gui.queue_control(game_result_panel, reservation_for_whole_screen_gui)
		
		if game_result == GameResult.VICTORY:
			game_result_panel.display_as_victory()
		elif game_result == GameResult.DEFEAT:
			game_result_panel.display_as_defeat()
		
		game_result_panel.connect("option_view_battlefield_selected", self, "_game_result_panel__view_battlefield_selected")
		game_result_panel.connect("option_main_menu_selected", self, "_game_result_panel__main_menu_selected")



func _set_properties_of_game_elements_to_post_battle():
	game_elements.panel_buy_sell_level_roll.can_refresh_shop_clauses.attempt_insert_clause(game_elements.panel_buy_sell_level_roll.CanRefreshShopClauses.END_OF_GAME)
	game_elements.level_manager.can_level_up_clauses.attempt_insert_clause(game_elements.LevelManager.CanLevelUpClauses.END_OF_GAME)
	game_elements.round_status_panel.can_start_round = false
	
	var all_towers = game_elements.tower_manager.get_all_towers_except_in_queue_free()
	for tower in all_towers:
		tower.tower_is_draggable_clauses.attempt_insert_clause(tower.TowerDraggableClauseIds.END_OF_GAME)
		tower.can_be_sold_conditonal_clauses.attempt_insert_clause(tower.CanBeSoldClauses.END_OF_GAME)
	
	set_enabled_buy_slots([])


func set_enabled_buy_slots(arg_array : Array): # ex: [1, 2] = the first and second buy slots (from the left) are enabled
	for i in game_elements.panel_buy_sell_level_roll.all_buy_slots.size():
		i += 1
		var buy_slot = game_elements.panel_buy_sell_level_roll.all_buy_slots[i - 1]
		var clause = game_elements.panel_buy_sell_level_roll.buy_slot_to_disabled_clauses[buy_slot]
		
		if arg_array.has(i):
			clause.remove_clause(game_elements.panel_buy_sell_level_roll.BuySlotDisabledClauses.END_OF_GAME)
		else:
			clause.attempt_insert_clause(game_elements.panel_buy_sell_level_roll.BuySlotDisabledClauses.END_OF_GAME)


#

func _game_result_panel__view_battlefield_selected():
	whole_screen_gui.hide_control(game_result_panel)
	
	# note: if you want to do actions when this option is selected,
	# 		take into account the fact that the panel can be exited
	#		by pressing ESC, bypassing this method


func _game_result_panel__main_menu_selected():
	CommsForBetweenScenes.goto_starting_screen(game_elements)



