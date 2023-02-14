extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"

const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

# Towers in shop:
# Shop 1: Simplex*, ember*, sprinkler*, striker*
# Shop 2: Spike, sprinkler, simplex, rebound
# Shop 3: Flameburst*, spike, striker, mini tesla
# Shop 4: pinecone, time machine, scatter*, transmutator
# Shop 5: vacuum, cannon, railgun*, sprinkler
# Shop 6: Campfire*, entropy*, propel*
var towers_offered_on_shop_refresh : Array = [
	[Towers.SIMPLEX, Towers.EMBER, Towers.SPRINKLER, Towers.STRIKER],
	[Towers.SPIKE, Towers.SPRINKLER, Towers.SIMPLEX, Towers.REBOUND],
	[Towers.FLAMEBURST, Towers.SPIKE, Towers.STRIKER, Towers.MINI_TESLA],
	[Towers.PINECONE, Towers.SHOCKER, Towers.SCATTER, Towers.TRANSMUTATOR],
	[Towers.VACUUM, Towers.CANNON, Towers.RAILGUN, Towers.SPRINKLER],
	[Towers.CAMPFIRE, Towers.ENTROPY, Towers.PROPEL],
	[Towers.BEACON_DISH, Towers.PROBE]
]
var transcript_to_progress_mode : Dictionary

var _all_towers : Array = []
var _simplex
var _railgun
var _sprinkler

#
func _init().(StoreOfGameModifiers.GameModiIds__ModiTutorialPhase_02, 
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
	
	var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
	var plain_fragment__shop = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "shop")
	var plain_fragment__tier_1_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_01, "tier 1 towers")
	var plain_fragment__Level_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.LEVEL_UP_ORANGE, "Level up")
	var plain_fragment__tier_2_tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_02, "tier 2 tower")
	var plain_fragment__tier_3_tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_03, "tier 3 tower")
	var plain_fragment__refresh_the_shop = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "refresh the shop")
	
	var plain_fragment__orange_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_ORANGE, "orange towers")
	var plain_fragment__synergies = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY, "synergies")
	var plain_fragment__color_synergy_ies = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY, "color synergy(ies)")
	var plain_fragment__Orange_synergy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_DOMINANT, "Orange synergy")
	
	var plain_fragment__Sprinkler = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Sprinkler")
	var plain_fragment__Scatter = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Scatter")
	
	var plain_fragment__Dominant_Synergy_quotes = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_DOMINANT, "\"Dominant Synergy\"")
	var plain_fragment__dominant_synergy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_DOMINANT, "dominant synergy")
	var plain_fragment__Composite_Synergy_quotes = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_COMPOSITE, "\"Composite Synergy\"")
	var plain_fragment__Group_Synergy_quotes = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_COMPOSITE, "\"Group Synergy\"")
	var plain_fragment__OrangeYR_synergy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_COMPOSITE, "OrangeYR synergy")
	var plain_fragment__1_yellow_tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_YELLOW, "1 yellow tower")
	
	var plain_fragment__OrangeYR_whole_word_synergy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_COMPOSITE, "OrangeYR (Orange Yellow Red) synergy")
	var plain_fragment__Simplex = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Simplex")
	var plain_fragment__Railgun = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Railgun")
	
	var plain_fragment__Synergies = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY, "Synergies")
	var plain_fragment__level_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.LEVEL_UP_ORANGE, "level up")
	
	var plain_fragment__6_Orange = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_DOMINANT, "6 Orange")
	var plain_fragment__3_Orange = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_DOMINANT, "3 Orange")
	
	var plain_fragment__2_OrangeYR = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_COMPOSITE, "2 OrangeYR")
	var plain_fragment__2_orange_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_ORANGE, "2 orange towers")
	var plain_fragment__2_yellow_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_YELLOW, "2 yellow towers")
	var plain_fragment__2_red_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_RED, "2 red towers")
	var plain_fragment__1_OrangeYR = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_COMPOSITE, "1 OrangeYR")
	
	transcript_to_progress_mode = {
		"Welcome to the chapter 2 of the tutorial. Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
		
		#1
		["First, buy all the |0| in the |1|.", [plain_fragment__towers, plain_fragment__shop]] : ProgressMode.ACTION_FROM_PLAYER,
		["Right now, you have |0|, which is the weakest tier.", [plain_fragment__tier_1_towers]] : ProgressMode.CONTINUE,
		"Leveling up allows you to gain higher tier towers." : ProgressMode.CONTINUE,
		#4
		["|0| by clicking this button.", [plain_fragment__Level_up]] : ProgressMode.ACTION_FROM_PLAYER,
		
		"Now that you've leveled up, there is a higher chance to find better towers." : ProgressMode.CONTINUE,
		#6
		["As indicated by this panel, you now have a %s%% chance of finding a |0|, and a %s%% for a |1|." % [str(tier_2_odds_at_level_5), str(tier_3_odds_at_level_5)], [plain_fragment__tier_2_tower, plain_fragment__tier_3_tower]]: ProgressMode.CONTINUE,
		["Let's |0| to get a tier 2 or 3 tower. (Press %s or click this button.)" % InputMap.get_action_list("game_shop_refresh")[0].as_text(), [plain_fragment__refresh_the_shop]] : ProgressMode.ACTION_FROM_PLAYER,
		#8
		"Tough luck! We didn't get what we want. Refresh the shop again." : ProgressMode.ACTION_FROM_PLAYER,
		["Nice! Buy that |0|.", [plain_fragment__tier_3_tower]] : ProgressMode.ACTION_FROM_PLAYER,
		"In general, higher tier towers are stronger than lower tier ones." : ProgressMode.CONTINUE,
		#11
		"Let's place all those towers in the map." : ProgressMode.ACTION_FROM_PLAYER,
		"Let's start the round." : ProgressMode.ACTION_FROM_PLAYER,
		
		["Now we proceed to |0|. Take your time understanding the next passages.", [plain_fragment__synergies]] : ProgressMode.CONTINUE,
		["Each tower has tower color(s). Towers contribute to their |0| if placed in the map.", [plain_fragment__color_synergy_ies]] : ProgressMode.CONTINUE,
		#15
		["Right now, we have 2 |0|. To activate the |1|, we need 3 |0|, as stated here.", [plain_fragment__orange_towers, plain_fragment__Orange_synergy]] : ProgressMode.CONTINUE,
		#16
		"You can read the orange synergy's description by hovering this." : ProgressMode.CONTINUE,
		#17
		"Refresh the shop to hopefully find an orange tower." : ProgressMode.ACTION_FROM_PLAYER,
		#18
		["There's an orange tower! Sell |0| for space, then buy |1| and place it in the map.", [plain_fragment__Sprinkler, plain_fragment__Scatter]] : ProgressMode.ACTION_FROM_PLAYER,
		["The |0| is now activated since you have 3 |1|.", [plain_fragment__Orange_synergy, plain_fragment__orange_towers]] : ProgressMode.CONTINUE,
		["A single colored synergy is called a |0|. You can only have one active at a time.", [plain_fragment__Dominant_Synergy_quotes]] : ProgressMode.CONTINUE,
		"Attempting to play two dominant synergies kills you instantly!" : ProgressMode.CONTINUE,
		"Just kidding. Attempting to play two dominant synergies cancels out the weaker synergy, or both of them if they are equal in number." : ProgressMode.CONTINUE,
		"For example, having 3 orange towers and 3 yellow towers diables both synergies. but having 4 orange instead of 3 allows orange to be active despite the 3 yellows." : ProgressMode.CONTINUE,
		"Likewise, having 4 yellows against 3 oranges makes the yellow synergy active (instead of orange)." : ProgressMode.CONTINUE,
		
		# 25
		["Recall that a single colored synergy is called a |0| consisting of a singluar color.", [plain_fragment__Dominant_Synergy_quotes]]: ProgressMode.CONTINUE,
		["Now, there is another type of synergy called a |0|, or |1|.", [plain_fragment__Composite_Synergy_quotes, plain_fragment__Group_Synergy_quotes]] : ProgressMode.CONTINUE,
		["|0| involve multiple colors.", [plain_fragment__Composite_Synergy_quotes]] : ProgressMode.CONTINUE,
		["Just like |0|, you can only have one |1| at a time, and will deactivate other weaker |1|.", [plain_fragment__Dominant_Synergy_quotes, plain_fragment__Composite_Synergy_quotes]] : ProgressMode.CONTINUE,
		["The catch is, |0| can work with |1|. They do not cancel each other out.", [plain_fragment__Composite_Synergy_quotes, plain_fragment__Dominant_Synergy_quotes]] : ProgressMode.CONTINUE,
		#30
		["If we look here, we can see that we are |0| off of activating |1|.", [plain_fragment__1_yellow_tower, plain_fragment__OrangeYR_synergy]] : ProgressMode.CONTINUE,
		# 31
		"Refresh the shop to see if we get a yellow tower." : ProgressMode.ACTION_FROM_PLAYER,
		# 32
		"We got a yellow tower! Buy it!" : ProgressMode.ACTION_FROM_PLAYER,
		# 33
		["To activate the |0|, let's first put |1| back to the bench.", [plain_fragment__OrangeYR_whole_word_synergy, plain_fragment__Simplex]] : ProgressMode.ACTION_FROM_PLAYER,
		# 34
		["Now that there is space, let's place |0| in the map.", [plain_fragment__Railgun]] : ProgressMode.ACTION_FROM_PLAYER,
		["With this setup, we have both |0| and |1| activated.", [plain_fragment__Orange_synergy, plain_fragment__OrangeYR_synergy]] : ProgressMode.CONTINUE,
		
		["|0| also have multiple tiers. The more |1| you place, the more powerful the |2| becomes.", [plain_fragment__Synergies, plain_fragment__orange_towers, plain_fragment__Orange_synergy]] : ProgressMode.CONTINUE,
		"For the case of the Orange synergy: placing 6 Orange towers increases its power. Other synergies also have multiple tiers." : ProgressMode.CONTINUE,
		
		# 38
		["Let's demonstrate activating |0| instead of just |1|.", [plain_fragment__6_Orange, plain_fragment__3_Orange]] : ProgressMode.CONTINUE,
		#39
		"Please refresh the shop." : ProgressMode.ACTION_FROM_PLAYER,
		#40
		"Buy the three orange towers" : ProgressMode.ACTION_FROM_PLAYER,
		#41
		["Since we only have 5 tower slots available, we need to level up. Let's |0| for more tower slots!", [plain_fragment__level_up]] : ProgressMode.ACTION_FROM_PLAYER,
		"Please place the three orange towers, replacing the non-orange towers in the process. Note: you can swap two tower's positions by dragging one and dropping it to the other." : ProgressMode.ACTION_FROM_PLAYER,
		"Good job! 6 Orange allows your orange towers to be a lot more powerful than with just 3 Orange." : ProgressMode.CONTINUE,
		
		# 44
		["Now lets try activating |0|.", [plain_fragment__2_OrangeYR]] : ProgressMode.CONTINUE,
		# 45
		"Please refresh the shop once more." : ProgressMode.ACTION_FROM_PLAYER,
		"Buy every tower in the shop." : ProgressMode.ACTION_FROM_PLAYER,
		#47
		["Now activate |0| by placing |1|, |2|, and |3| in the map.", [plain_fragment__2_OrangeYR, plain_fragment__2_orange_towers, plain_fragment__2_yellow_towers, plain_fragment__2_red_towers]] : ProgressMode.ACTION_FROM_PLAYER,
		["Nice job! |0| allows your towers to be a lot more stronger than with |1|.", [plain_fragment__2_OrangeYR, plain_fragment__1_OrangeYR]] : ProgressMode.CONTINUE,
		["But which is better? |0| or |1|? That's up to you to decide.", [plain_fragment__6_Orange, plain_fragment__2_OrangeYR]] : ProgressMode.CONTINUE,
		
		"That concludes this chapter of the tutorial. Feel free to tinker with the towers." : ProgressMode.CONTINUE,
		"(If you are new to the game, proceed to chapter 3.)" : ProgressMode.CONTINUE,
		
		#52
		"(Once you're done experimenting, you can exit the game by pressing ESC and quitting the game.)" : ProgressMode.WAIT_FOR_EVENT,
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
		set_can_refresh_shop__panel_based(true)
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
		display_white_circle_at_node(_sprinkler, 19)
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
		
	elif arg_index == 39:
		add_gold_amount(90)
		set_can_refresh_shop__panel_based(true)
		listen_for_shop_refresh(self, "_on_shop_refresh__on_39")
		
	elif arg_index == 40:
		set_enabled_buy_slots([1, 2, 3])
		listen_for_towers_with_ids__bought__then_call_func([Towers.CAMPFIRE, Towers.ENTROPY, Towers.PROPEL], "_on_towers_bought__for_40", self)
		
	elif arg_index == 41:
		set_can_level_up(true)
		listen_for_player_level_up(6, self, "_on_player_lvl_changed_41")
		set_visiblity_of_placable(get_map_area_11__from_glade(), true)
		
	elif arg_index == 42:
		for tower in _all_towers:
			if is_instance_valid(tower):
				set_tower_is_draggable(tower, true)
		set_can_towers_swap_positions_to_another_tower(true)
		listen_for_synergy_to_be_activated(TowerDominantColors.synergy_id_to_syn_name_dictionary[TowerDominantColors.SynergyId.ORANGE], 3, "_on_orange_syn_met__42", self)
		
	elif arg_index == 45:
		set_can_refresh_shop__panel_based(true)
		listen_for_shop_refresh(self, "_on_shop_refresh__on_45")
		
	elif arg_index == 46:
		listen_for_towers_with_ids__bought__then_call_func([Towers.BEACON_DISH, Towers.PROBE], "_on_towers_bought__for_46", self)
		
	elif arg_index == 47:
		for tower in _all_towers:
			if is_instance_valid(tower):
				set_tower_is_draggable(tower, true)
		listen_for_synergy_to_be_activated(TowerCompositionColors.synergy_id_to_syn_name_dictionary[TowerCompositionColors.SynergyId.OrangeYR], 3, "_on_syn_met__47", self)


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
	set_can_refresh_shop__panel_based(false)
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
func _on_shop_refresh__on_39(arg_tower_ids : Array):
	set_can_refresh_shop__panel_based(false)
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()


func _on_towers_bought__for_40(arg_towers : Array):
	for tower in arg_towers:
		_all_towers.append(tower)
		set_tower_is_sellable(tower, false)
	
	advance_to_next_transcript_message()

func _on_player_lvl_changed_41(arg_player_lvl):
	set_can_level_up(false)
	advance_to_next_transcript_message()


func _on_orange_syn_met__42():
	advance_to_next_transcript_message()

func _on_shop_refresh__on_45(arg_tower_ids):
	set_can_refresh_shop__panel_based(false)
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()


func _on_towers_bought__for_46(arg_towers):
	for tower in arg_towers:
		_all_towers.append(tower)
		set_tower_is_sellable(tower, false)
	
	advance_to_next_transcript_message()


func _on_syn_met__47():
	advance_to_next_transcript_message()


#
func _on_end_of_transcript():
	#hide_current_transcript_message()
	
	add_gold_amount(20)
	set_can_refresh_shop__panel_based(true)
	for tower in _all_towers:
		if is_instance_valid(tower):
			set_tower_is_draggable(tower, true)
			set_tower_is_sellable(tower, true)
	
	set_visiblity_of_all_placables(true)
	set_enabled_buy_slots([1, 2, 3, 4, 5])
	add_shop_per_refresh_modifier(0)
	set_can_towers_swap_positions_to_another_tower(true)
	


