extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"

const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


var towers_offered_on_shop_refresh : Array = [
	[Towers.PROMINENCE]
]

var transcript_to_progress_mode : Dictionary

var _arrows

var _prominence
var _striker

#
func _init().(StoreOfGameModifiers.GameModiIds__ModiTutorialPhase_01_01, 
		BreakpointActivation.BEFORE_MAIN_INIT, "Chapter 1.5: Game Basics Part 2"):
	
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
	var tier_2_odds_at_level_3 = get_tower_tier_odds_at_player_level(2, 3)
	var tier_1_odds_at_level_3 = get_tower_tier_odds_at_player_level(1, 3)
	
	
	var plain_fragment__player_level = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.LEVEL_UP_ORANGE, "player level")
	var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
	var plain_fragment__shop = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "shop")
	var plain_fragment__tier_1_tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_01, "tier 1 tower")
	var plain_fragment__tier_2_tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_02, "tier 2 tower")
	var plain_fragment__striker = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Striker")
	var plain_fragment__tier_6_tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_06, "tier 6 tower")
	var plain_fragment__prominence = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Prominence")
	
	var plain_fragment__Gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "Gold")
	var plain_fragment__buying_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "buying towers")
	var plain_fragment__refresh_the_shop = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "refreshing the shop")
	var plain_fragment__leveling_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.LEVEL_UP_ORANGE, "leveling up")
	var plain_fragment__end_of_the_round = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "end of the round")
	
	transcript_to_progress_mode = {
		"Welcome to Synergy Tower Defense! Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
		
		
		["First, lets talk about |0|.", [plain_fragment__player_level]] : ProgressMode.CONTINUE,
		#2
		["The |0| dictates how many |1| you can place. Your player level is indicated here.", [plain_fragment__player_level, plain_fragment__towers]] : ProgressMode.CONTINUE,
		["The player level also dictates the tiers of towers that are offered in the |0|.", [plain_fragment__shop]] : ProgressMode.CONTINUE,
		#4
		"This panel displays the chances of finding a specific tier of tower." : ProgressMode.CONTINUE,
		["Right now, you have %s%% chance of finding a |0|, and a %s%% chance of finding a |1|." % [str(tier_1_odds_at_level_3), str(tier_2_odds_at_level_3)], [plain_fragment__tier_1_tower, plain_fragment__tier_2_tower]] : ProgressMode.CONTINUE,
		
		"In general, higher tier towers are more powerful than lower tier towers." : ProgressMode.CONTINUE,
		#7
		["Let's see how |0|, a |1|, holds against a powerful wave. Please start the round (Press %s, or click this button)." % InputMap.get_action_list("game_round_toggle")[0].as_text(), [plain_fragment__striker, plain_fragment__tier_1_tower]] : ProgressMode.ACTION_FROM_PLAYER,
		"While the round is started, you can fast forward the game by pressing %s, or by pressing the speed buttons here." % InputMap.get_action_list("game_round_toggle")[0].as_text() : ProgressMode.WAIT_FOR_EVENT,
		
		"Looks like Striker didn't do so well. To be fair, the enemies were quite numerous." : ProgressMode.CONTINUE,
		#10
		["We need a better tower. Press %s or click this button to refresh the |0|." % InputMap.get_action_list("game_shop_refresh")[0].as_text(), [plain_fragment__shop]] : ProgressMode.ACTION_FROM_PLAYER,
		"Buy this tower." : ProgressMode.ACTION_FROM_PLAYER,
		["Now behold, a |0|, |1|, is at your bench. Tier 6 is the highest and most powerful tier. (You can right click it if you want to view its stats.)", [plain_fragment__tier_6_tower, plain_fragment__prominence]] : ProgressMode.CONTINUE,
		#13
		["Place |0| in the map. Note: You can place |0| over |1| to swap their positions.", [plain_fragment__prominence, plain_fragment__striker]] : ProgressMode.ACTION_FROM_PLAYER,
		
		["We now have the power of a |0|. Let's start the round.", [plain_fragment__tier_6_tower]] : ProgressMode.ACTION_FROM_PLAYER,
		"It did very well, as expected for a high tier tower." : ProgressMode.CONTINUE,
		"Do note that this is a rather cherry picked example, since we are comparing a tier 1 to a tier 6." : ProgressMode.CONTINUE,
		
		#17
		"Now we shift our focus to gold." : ProgressMode.CONTINUE,
		["|0| is the main currency in this game. |0| is mainly used in |1|, |2|, and |3|.", [plain_fragment__Gold, plain_fragment__buying_towers, plain_fragment__refresh_the_shop, plain_fragment__leveling_up]] : ProgressMode.CONTINUE,
		"Higher tier towers cost more gold, so it is important to earn lots of gold! To be precise, a tower costs as much as its tier." : ProgressMode.CONTINUE,
		["|0| is gained at the |1|. The baseline amount increases as the game goes on.", [plain_fragment__Gold, plain_fragment__end_of_the_round]] : ProgressMode.CONTINUE,
		"The amount of gold you gain per round can be increased by other means." : ProgressMode.CONTINUE,
		"You gain 1 extra gold for every 10 gold you have, up to 5. Which means at 50 gold, you are making max interest." : ProgressMode.CONTINUE,
		"You gain 1 extra gold if you win the round." : ProgressMode.CONTINUE,
		"And finally, you gain gold for win steaks and lose streaks." : ProgressMode.CONTINUE,
		"If you're winning rounds, you gain more gold for winning more rounds. Similarly, if you're losing rounds, then you gain more gold for losing more rounds." : ProgressMode.CONTINUE,
		#26
		"Your current win streak (or lose streak) can be viewed here." : ProgressMode.CONTINUE,
		"Also, you don't gain streaks for the first 3 rounds." : ProgressMode.CONTINUE,
		"You can click on the gold panel to see the amount of gold you'll gain at the end of the round." : ProgressMode.CONTINUE,
		
		"As for the last part of the tutorial, we shift our focus to the top right of the screen." : ProgressMode.CONTINUE,
		#30
		"Over here we can see whether we won or lost the previous round, the future rounds to come, and the current stage-round." : ProgressMode.CONTINUE,
		"Enemies keep coming up until 9-4, which is the last round. If you survive after that round, you win the game." : ProgressMode.CONTINUE,
		
		"Over here is your player health. You lose the game if it reaches 0, so be careful." : ProgressMode.CONTINUE,
		"You start the game with 150 health." : ProgressMode.CONTINUE,
		
		"That concludes this chapter of the tutorial." : ProgressMode.CONTINUE,
		"(If you are new to the game, proceed to chapter 2.)" : ProgressMode.CONTINUE,
	}
	
	clear_all_tower_cards_from_shop()
	set_round_is_startable(false)
	set_can_level_up(false)
	set_can_refresh_shop__panel_based(false)
	set_can_refresh_shop_at_round_end_clauses(false)
	set_enabled_buy_slots([1])
	set_can_sell_towers(true)
	set_can_toggle_to_ingredient_mode(false)
	set_can_towers_swap_positions_to_another_tower(false)
	add_shop_per_refresh_modifier(-5)
	set_visiblity_of_all_placables(false)
	set_visiblity_of_placable(get_map_area_05__from_glade(), true)
	set_player_level(3)
	add_gold_amount(3)
	
	var striker_01 = create_tower_at_placable(Towers.STRIKER, get_map_area_05__from_glade())
	set_tower_is_sellable(striker_01, false)
	set_tower_is_draggable(striker_01, false)
	_striker = striker_01
	
	advance_to_next_transcript_message()


####

func _on_current_transcript_index_changed(arg_index, arg_msg):
	if arg_index == 2:
		var arrows = display_white_arrows_pointed_at_node(get_player_level_panel(), 3)
		arrows[0].x_offset = -85
		arrows[1].y_offset = -30
		
	elif arg_index == 4:
		var arrows = display_white_arrows_pointed_at_node(get_shop_odds_panel(), 6, true, true)
		arrows[0].x_offset = 60
		arrows[1].y_offset = -30
		
	elif arg_index == 7:
		set_round_is_startable(true)
		var arrows = display_white_arrows_pointed_at_node(get_round_status_button(), 8)
		arrows[1].y_offset = -20
		listen_for_round_start__then_listen_for_round_end__call_func_for_both(self, "_on_transc_07__round_start", "_on_transc_07__round_end")
		
	elif arg_index == 8:
		var arrows = display_white_arrows_pointed_at_node(get_round_speed_button_01(), 9, true, false)
		arrows[0].x_offset = -35
		
	elif arg_index == 10:
		var arrows = display_white_arrows_pointed_at_node(get_reroll_button_from_shop_panel(), 11)
		set_can_refresh_shop__panel_based(true)
		listen_for_shop_refresh(self, "_on_shop_refreshed__on_transc_10")
		
	elif arg_index == 11:
		var arrows = display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(0), 12)
		listen_for_tower_with_id__bought__then_call_func(Towers.PROMINENCE, "_on_prominence_bought__on_11", self)
		
	elif arg_index == 13:
		set_tower_is_draggable(_striker, true)
		set_tower_is_draggable(_prominence, true)
		set_can_towers_swap_positions_to_another_tower(true)
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.PROMINENCE], "_on_prominence_placed_in_map__13", self)
		
	elif arg_index == 14:
		set_round_is_startable(true)
		listen_for_round_start__then_listen_for_round_end__call_func_for_both(self, "_on_transc_14__round_start", "_on_transc_14__round_end")
		
	elif arg_index == 26:
		var arrows = display_white_arrows_pointed_at_node(get_streak_panel(), 27)
		arrows[0].x_offset = -20
		arrows[1].y_offset = -30
		
	elif arg_index == 28:
		var arrows = display_white_arrows_pointed_at_node(get_gold_panel(), 29)
		arrows[0].x_offset = -80
		arrows[1].y_offset = -35
		
	elif arg_index == 30:
		var arrows = display_white_arrows_pointed_at_node(get_round_indicator_panel(), 31)
		arrows[0].x_offset = 10
		arrows[0].y_offset = -10
		arrows[1].y_offset = 100
		arrows[1].flip_h = true
		
	elif arg_index == 32:
		var arrows = display_white_arrows_pointed_at_node(get_player_health_bar_panel(), 33, true, true)
		arrows[0].x_offset = 10
		arrows[1].y_offset = 80
		arrows[1].flip_h = true

#

func _on_transc_07__round_start():
	advance_to_next_transcript_message()
	var arrows = display_white_arrows_pointed_at_node(get_round_status_button(), 9, true, true)
	arrows[1].y_offset = -20

func _on_transc_07__round_end():
	set_round_is_startable(false)
	advance_to_next_transcript_message()
	

func _on_shop_refreshed__on_transc_10(arg_tower_ids):
	set_can_refresh_shop__panel_based(false)
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()

func _on_prominence_bought__on_11(arg_prominence):
	set_tower_is_sellable(arg_prominence, false)
	
	_prominence = arg_prominence
	
	advance_to_next_transcript_message()

func _on_prominence_placed_in_map__13(arg_prominence):
	set_tower_is_draggable(_striker, false)
	set_tower_is_draggable(_prominence, false)
	set_can_towers_swap_positions_to_another_tower(false)
	advance_to_next_transcript_message()

func _on_transc_14__round_start():
	hide_current_transcript_message()

func _on_transc_14__round_end():
	set_round_is_startable(false)
	advance_to_next_transcript_message()


