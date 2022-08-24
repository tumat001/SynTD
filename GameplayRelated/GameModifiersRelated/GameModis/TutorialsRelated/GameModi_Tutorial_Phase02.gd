extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"

# NOTE TO DEV: Start at level 4.
# Towers in shop:
# Shop 1: Simplex*, ember*, sprinkler*, striker*
# Shop 2: Spike, sprinkler, simplex, rebound
# Shop 3: Flameburst*, spike, striker, mini tesla
# Shop 4: pinecone, time machine, scatter*, transmutator
# Shop 5: vacuum, cannon, railgun*, sprinkler
var towers_offered_on_shop_refresh : Array = [
	[Towers.SIMPLEX, Towers.EMBER, Towers.SPRINKLER, Towers.STRIKER],
	[Towers.SPIKE, Towers.SPRINKLER, Towers.SIMPLEX, Towers.REBOUND],
	[Towers.FLAMEBURST, Towers.SPIKE, Towers.STRIKER, Towers.MINI_TESLA],
	[Towers.PINECONE, Towers.SHOCKER, Towers.SCATTER, Towers.TRANSMUTATOR],
	[Towers.VACUUM, Towers.CANNON, Towers.RAILGUN, Towers.SPRINKLER]
]
var transcript_to_progress_mode : Dictionary

var _all_towers : Array = []
var _simplex
var _railgun
var _sprinkler

#
func _init().(StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_02, 
		BreakpointActivation.BEFORE_MAIN_INIT, "Chapter 2: Tower Tiers and Synergies"):
	
	pass

func _get_transcript():
	return transcript_to_progress_mode

func _get_custom_shop_towers():
	return towers_offered_on_shop_refresh

#

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	game_elements.connect("before_game_start", self, "_on_game_elements_before_game_start", [], CONNECT_ONESHOT)
	connect("on_current_transcript_index_changed", self, "_on_current_transcript_index_changed")
	

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	


#


func _on_game_elements_before_game_start():
	var tier_3_odds_at_level_5 = get_tower_tier_odds_at_player_level(3, 5)
	var tier_2_odds_at_level_5 = get_tower_tier_odds_at_player_level(2, 5)
	
	transcript_to_progress_mode = {
		"Welcome to the chapter 2 of the tutorial. Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
		
		#1
		"First, buy all the towers in the shop." : ProgressMode.ACTION_FROM_PLAYER,
		"Right now, you have tier 1 towers, which is the weakest tier." : ProgressMode.CONTINUE,
		"Leveling up allows you to gain higher tier towers." : ProgressMode.CONTINUE,
		#4
		"Level up by clicking this button." : ProgressMode.ACTION_FROM_PLAYER,
		
		"Now that you've leveled up, there is a higher chance to find better towers." : ProgressMode.CONTINUE,
		#6
		"As indicated by this panel, you now have a %s%% chance of finding a tier 2 tower, and a %s%% for a tier 3 tower." % [str(tier_2_odds_at_level_5), str(tier_3_odds_at_level_5)]: ProgressMode.CONTINUE,
		"Let's refresh the shop to get a tier 2 or 3 tower. (Press %s or click this button.)" % InputMap.get_action_list("game_shop_refresh")[0].as_text() : ProgressMode.ACTION_FROM_PLAYER,
		#8
		"Tough luck! We didn't get what we want. Refresh the shop again." : ProgressMode.ACTION_FROM_PLAYER,
		"Nice! Buy that tier 3 tower." : ProgressMode.ACTION_FROM_PLAYER,
		"In general, higher tier towers are much stronger than lower tier ones." : ProgressMode.CONTINUE,
		#11
		"Let's place all those towers in the map." : ProgressMode.ACTION_FROM_PLAYER,
		"Let's start the round." : ProgressMode.ACTION_FROM_PLAYER,
		
		"Now we proceed to synergies. Take your time understanding the next passages." : ProgressMode.CONTINUE,
		"Each tower has tower color(s).\nTowers contribute to their color synergy(ies) if placed in the map." : ProgressMode.CONTINUE,
		#15
		"Right now, we have 2 orange towers.\nTo activate the orange synergy, we need 3, as stated here." : ProgressMode.CONTINUE,
		#16
		"You can read the orange synergy's description by hovering this." : ProgressMode.CONTINUE,
		#17
		"Refresh the shop to hopefully find an orange tower." : ProgressMode.ACTION_FROM_PLAYER,
		#18
		"There's an orange tower! Sell sprinkler for space,\nthen buy Scatter and place it in the map." : ProgressMode.ACTION_FROM_PLAYER,
		"The orange synergy is now activated since you have 3 orange towers." : ProgressMode.CONTINUE,
		"A single colored synergy is called a \"Dominant Synergy\".\nYou can only have one active at a time." : ProgressMode.CONTINUE,
		"Attempting to play two dominant synergies kills you instantly!" : ProgressMode.CONTINUE,
		"Just kidding. Attempting to play two dominant synergies cancels out the weaker synergy,\nor both of them if they are equal in number." : ProgressMode.CONTINUE,
		"For example, having 3 orange towers and 3 yellow towers diables both synergies.\nbut having 4 orange instead of 3 allows orange to be active despite the 3 yellows." : ProgressMode.CONTINUE,
		"Likewise, having 4 yellows against 3 oranges makes the yellow synergy active (instead of orange)." : ProgressMode.CONTINUE,
		
		# 25
		"Recall that a single colored synergy is called a \"Dominant Synergy\"\n consisting of a singluar color.": ProgressMode.CONTINUE,
		"Now, there is another type of synergy called a \"Composite Synergy\", or \"Group Synergy\".": ProgressMode.CONTINUE,
		"\"Composite Synergies\" involve multiple colors.": ProgressMode.CONTINUE,
		"Just like \"Dominant Synergies\", you can only have one of it at a time,\nand will deactivate other weaker \"Composite Synergies\"." : ProgressMode.CONTINUE,
		"The catch is, \"Composite Synergies\" can work with \"Dominant Synergies\".\nThey do not cancel each other out.": ProgressMode.CONTINUE,
		#30
		"If we look here, we can see that we are 1 yellow tower off of activating OrangeYR synergy.": ProgressMode.CONTINUE,
		# 31
		"Refresh the shop to see if we get a yellow tower." : ProgressMode.ACTION_FROM_PLAYER,
		# 32
		"We got a yellow tower! Buy it!" : ProgressMode.ACTION_FROM_PLAYER,
		# 33
		"To activate the OrangeYR (Orange Yellow Red) synergy,\nlet's first put Simplex back to the bench." : ProgressMode.ACTION_FROM_PLAYER,
		# 34
		"Now that there is space, let's place Railgun in the map." : ProgressMode.ACTION_FROM_PLAYER,
		"With this setup, we have both Orange synergy activated,\nand OrangeYR synergy activated." : ProgressMode.CONTINUE,
		
		"Synergies also have multiple tiers.\nThe more orange towers you place, the more powerful the Orange synergy becomes." : ProgressMode.CONTINUE,
		"For the case of the Orange synergy: placing 6 Orange towers increases its power.\nOther synergies also have multiple tiers." : ProgressMode.CONTINUE,
		
		
		"That concludes this chapter of the tutorial.\nFeel free to tinker with the towers." : ProgressMode.CONTINUE,
		"(If you are new to the game, proceed to chapter 3.)" : ProgressMode.CONTINUE,
	}
	
	clear_all_tower_cards_from_shop()
	set_round_is_startable(false)
	set_can_level_up(false)
	set_can_refresh_shop__panel_based(false)
	set_can_refresh_shop_at_round_end_clauses(false)
	set_enabled_buy_slots([1, 2, 3, 4])
	set_can_sell_towers(true)
	set_can_toggle_to_ingredient_mode(false)
	set_can_towers_swap_positions_to_another_tower(false)
	add_shop_per_refresh_modifier(-5)
	set_visiblity_of_all_placables(false)
	set_visiblity_of_placable(get_map_area_05__from_glade(), true)
	set_visiblity_of_placable(get_map_area_07__from_glade(), true)
	set_visiblity_of_placable(get_map_area_09__from_glade(), true)
	set_visiblity_of_placable(get_map_area_04__from_glade(), true)
	set_visiblity_of_placable(get_map_area_06__from_glade(), true)
	set_player_level(4)
	add_gold_amount(34)
	
	exit_scene_if_at_end_of_transcript = false
	connect("at_end_of_transcript", self, "_on_end_of_transcript", [], CONNECT_ONESHOT)
	advance_to_next_transcript_message()
	

####

func _on_current_transcript_index_changed(arg_index, arg_msg):
	if arg_index == 1:
		advance_to_next_custom_towers_at_shop()
		listen_for_towers_with_ids__bought__then_call_func([Towers.SIMPLEX, Towers.STRIKER, Towers.EMBER, Towers.SPRINKLER], "_on_towers_bought__for_01", self)
		
	elif arg_index == 4:
		set_can_level_up(true)
		listen_for_player_level_up(5, self, "_on_player_lvl_changed")
		display_white_arrows_pointed_at_node(get_level_up_button_from_shop_panel(), 5)
		
	elif arg_index == 6:
		var arrows = display_white_arrows_pointed_at_node(get_shop_odds_panel(), 7, true, true)
		arrows[0].x_offset = 60
		arrows[1].y_offset = -30
		
	elif arg_index == 7:
		set_can_refresh_shop__panel_based(true)
		set_enabled_buy_slots([])
		display_white_arrows_pointed_at_node(get_reroll_button_from_shop_panel(), 9) # 9, not 8. intended
		listen_for_shop_refresh(self, "_on_shop_refresh__07")
		
	elif arg_index == 8:
		listen_for_shop_refresh(self, "_on_shop_refresh__08")
		
	elif arg_index == 9:
		set_enabled_buy_slots([1])
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(0), 10)
		listen_for_tower_with_id__bought__then_call_func(Towers.FLAMEBURST, "_on_tower_bought__09", self)
		
	elif arg_index == 11:
		for tower in _all_towers:
			set_tower_is_draggable(tower, true)
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.SIMPLEX, Towers.FLAMEBURST, Towers.SPRINKLER, Towers.EMBER, Towers.STRIKER], "_on_towers_placed_in_map__11", self)
		
	elif arg_index == 12:
		set_round_is_startable(true)
		listen_for_round_start__then_listen_for_round_end__call_func_for_both(self, "_on_round_start__12", "_on_round_end__12")
		
	elif arg_index == 15:
		var arrows = display_white_arrows_pointed_at_node(get_single_syn_displayer_with_synergy_name__from_left_panel(TowerDominantColors.synergy_id_to_syn_name_dictionary[TowerDominantColors.SynergyId.ORANGE]), 17, true, true)
		arrows[0].x_offset = 180
		arrows[0].flip_h = true
		arrows[1].y_offset = -30
		
	elif arg_index == 17:
		set_can_refresh_shop__panel_based(true)
		listen_for_shop_refresh(self, "_on_shop_refresh__on_17")
		
	elif arg_index == 18: # scatter bought
		set_can_refresh_shop__panel_based(false)
		set_enabled_buy_slots([3])
		set_tower_is_sellable(_sprinkler, true)
		set_tower_is_draggable(_sprinkler, true)
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(2), 19)
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.SCATTER], "_on_towers_placed_on_map__on_18", self)
		
	elif arg_index == 30:
		var arrows = display_white_arrows_pointed_at_node(get_single_syn_displayer_with_synergy_name__from_left_panel(TowerCompositionColors.synergy_id_to_syn_name_dictionary[TowerCompositionColors.SynergyId.OrangeYR]), 31, true, true)
		arrows[0].x_offset = 180
		arrows[0].flip_h = true
		arrows[1].y_offset = -30
		
	elif arg_index == 31:
		set_can_refresh_shop__panel_based(true)
		listen_for_shop_refresh(self, "_on_shop_refresh__on_31")
		
	elif arg_index == 32:
		set_can_refresh_shop__panel_based(false)
		set_enabled_buy_slots([3])
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(2), 33)
		listen_for_tower_with_id__bought__then_call_func(Towers.RAILGUN, "_on_railgun_bought__on_32", self)
		
	elif arg_index == 33:
		set_tower_is_draggable(_simplex, true)
		display_white_circle_at_node(_simplex, 34)
		listen_for_towers_with_ids__placed_in_bench__then_call_func([Towers.SIMPLEX], "_on_simplex_placed_in_bench__on_33", self)
		
	elif arg_index == 34:
		set_tower_is_draggable(_railgun, true)
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.RAILGUN], "_on_railgun_placed_in_map__on_34", self)



#
func _on_towers_bought__for_01(arg_towers : Array):
	for tower in arg_towers:
		_all_towers.append(tower)
		
		if tower.tower_id == Towers.SIMPLEX:
			_simplex = tower
		elif tower.tower_id == Towers.SPRINKLER:
			_sprinkler = tower
	
	advance_to_next_transcript_message()

#
func _on_player_lvl_changed(arg_player_lvl):
	set_can_level_up(false)
	
	advance_to_next_transcript_message()

#
func _on_shop_refresh__07(arg_tower_ids : Array):
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()
	

#
func _on_shop_refresh__08(arg_tower_ids : Array):
	set_can_refresh_shop__panel_based(false)
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()

#
func _on_tower_bought__09(arg_tower):
	_all_towers.append(arg_tower)
	set_tower_is_sellable(arg_tower, false)
	advance_to_next_transcript_message()

#
func _on_towers_placed_in_map__11(arg_towers):
	for tower in _all_towers:
		set_tower_is_draggable(tower, false)
	advance_to_next_transcript_message()


#
func _on_round_start__12():
	hide_current_transcript_message()

func _on_round_end__12():
	set_round_is_startable(false)
	advance_to_next_transcript_message()

#
func _on_shop_refresh__on_17(arg_tower_ids):
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()

#
func _on_towers_placed_on_map__on_18(arg_towers):
	_all_towers.append(arg_towers[0])
	set_tower_is_sellable(arg_towers[0], false)
	set_tower_is_draggable(arg_towers[0], false)
	advance_to_next_transcript_message()
	

#
func _on_shop_refresh__on_31(arg_tower_ids):
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()

#
func _on_railgun_bought__on_32(arg_tower):
	_all_towers.append(arg_tower)
	_railgun = arg_tower
	set_tower_is_sellable(arg_tower, false)
	advance_to_next_transcript_message()
	

#
func _on_simplex_placed_in_bench__on_33(arg_towers):
	set_tower_is_draggable(_simplex, false)
	advance_to_next_transcript_message()

func _on_railgun_placed_in_map__on_34(arg_towers):
	set_tower_is_draggable(_railgun, false)
	advance_to_next_transcript_message()


#
func _on_end_of_transcript():
	hide_current_transcript_message()
	
	add_gold_amount(10)
	set_can_refresh_shop__panel_based(true)
	for tower in _all_towers:
		if tower != null:
			set_tower_is_draggable(tower, true)
			set_tower_is_sellable(tower, true)
	
	set_visiblity_of_all_placables(true)
	set_enabled_buy_slots([1, 2, 3, 4, 5])
	add_shop_per_refresh_modifier(0)
	set_can_towers_swap_positions_to_another_tower(true)
	


