extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"

const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


# Shops:
# 1) Spike*
# 2) Sprinkler*
# 3) Rebound*
# 4) Mini tesla

var towers_offered_on_shop_refresh : Array = [
	[Towers.SPIKE],
	[Towers.SPRINKLER],
	[Towers.REBOUND],
	[Towers.MINI_TESLA],
]

var transcript_to_progress_mode : Dictionary

var _spike_tower
var _arrows

#
func _init().(StoreOfGameModifiers.GameModiIds__ModiTutorialPhase_01, 
		BreakpointActivation.BEFORE_MAIN_INIT, "Chapter 1: Game Basics"):
	
	pass

func _get_transcript():
	return transcript_to_progress_mode

func _get_custom_shop_towers():
	return towers_offered_on_shop_refresh

#

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
	var plain_fragment__base_damage = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BASE_DAMAGE, "base damage")
	var plain_fragment__attack_speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ATTACK_SPEED, "attack speed")
	var plain_fragment__range = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.RANGE, "range")
	var plain_fragment__gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "gold")
	var plain_fragment__end_of_the_round = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "end of the round")
	var plain_fragment__level_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.LEVEL_UP_ORANGE, "level up")
	var plain_fragment__refresh_or_reroll = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "refresh or reroll")
	var plain_fragment__refresh = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "refresh")
	var plain_fragment__refreshes = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "refreshes")
	var plain_fragment__end_of_round = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "end of round")
	var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "tower")
	
	var plain_fragment__leveling_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.LEVEL_UP_ORANGE, "leveling up")
	var plain_fragment__rerolling_your_shop = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "rerolling your shop")
	
	
	transcript_to_progress_mode = {
		"Welcome to Synergy Tower Defense! Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
		["In a tower defense game, you place |0| to defeat the enemies.", [plain_fragment__towers]] : ProgressMode.CONTINUE,
		["Left click this \"tower card\" to buy the displayed |0|.", [plain_fragment__tower]] : ProgressMode.ACTION_FROM_PLAYER,
		"When you buy towers, they appear in your bench. Benched towers do not attack; you need to first place them in the map." : ProgressMode.CONTINUE,
		"You can think of the bench as your inventory for towers." : ProgressMode.CONTINUE,
		["Drag the |0| to this tower slot to activate it.", [plain_fragment__tower]] : ProgressMode.ACTION_FROM_PLAYER,
		["Good job! Now this |0| is ready to defend.", [plain_fragment__tower]] : ProgressMode.CONTINUE,
		"You can always drag the tower back to the bench, but not during the round. (Due to this being a tutorial, you can't do that just yet.)" : ProgressMode.CONTINUE,
		"Press %s to start the round, or click this button." % InputMap.get_action_list("game_round_toggle")[0].as_text() : ProgressMode.ACTION_FROM_PLAYER,
		
		#9
		"Now let's practice what we just learned. Buy a tower and place it in the map." : ProgressMode.ACTION_FROM_PLAYER,
		"Nice! You're getting the hang of it." : ProgressMode.CONTINUE,
		"The number of towers you can place in the map is equal to your level. Since you are level 2, you can place 2 towers." : ProgressMode.CONTINUE,
		"Let's start the round. (Press %s, or click this button)." % InputMap.get_action_list("game_round_toggle")[0].as_text() : ProgressMode.ACTION_FROM_PLAYER,
		#13
		"While the round is started, you can fast forward the game by pressing %s, or by pressing the speed buttons here." % InputMap.get_action_list("game_round_toggle")[0].as_text() : ProgressMode.WAIT_FOR_EVENT, #wait for round to end
		
		#14 #Right click spike
		"To view a tower's description and stats, just right click a tower. Please right click this tower." : ProgressMode.ACTION_FROM_PLAYER,
		#"Over here you can see the tower's stats, such as base damage (red icon), attack speed (yellow icon), range (green icon), and more." : ProgressMode.CONTINUE,
		["Over here you can see the tower's stats, such as |0|, |1|, |2|, and more.", [plain_fragment__base_damage, plain_fragment__attack_speed, plain_fragment__range]] : ProgressMode.CONTINUE,
		#16
		"Right click this little icon, or press %s, to view the tower's description." % InputMap.get_action_list("game_show_tower_extra_info_panel")[0].as_text() : ProgressMode.ACTION_FROM_PLAYER,
		"The tower's description shows what they do." : ProgressMode.CONTINUE,
		"You don't have to buy a tower to view their stats and description. You can also view those by right clicking a tower card (before it is bought)." : ProgressMode.CONTINUE,
		#19
		"Right click this tower card to view its description and stats." : ProgressMode.ACTION_FROM_PLAYER,
		"Going forward, it is important to emphasize that knowing a tower's description is much more important than knowing its stats." : ProgressMode.CONTINUE,
		"Towers have their own unique strenghts and weaknesses. As you play the game, you will learn their quirks and interactions." : ProgressMode.CONTINUE,
		
		#22
		"Anyways, practice makes perfect. Buy this tower and place it in the map." : ProgressMode.ACTION_FROM_PLAYER,
		#23
		"Once again, let's start the round. (Press %s. or click this button)." % InputMap.get_action_list("game_round_toggle")[0].as_text() : ProgressMode.ACTION_FROM_PLAYER,
		
		["Buying towers cost |0|. Gold is gained at the |1|.", [plain_fragment__gold, plain_fragment__end_of_the_round]] : ProgressMode.CONTINUE,
		["You also gain 1 extra |0| for every 10 |0| you have, up to 5. Which means at 50 |0|, you are making max interest.", [plain_fragment__gold]] : ProgressMode.CONTINUE,
		["Gold is also used for |0|, for |1|, and many more!", [plain_fragment__leveling_up, plain_fragment__rerolling_your_shop]] : ProgressMode.CONTINUE,
		#27
		["Player level determines how many towers you can place. Let's |0| to place more |1| by clicking this button.", [plain_fragment__level_up, plain_fragment__towers]] : ProgressMode.ACTION_FROM_PLAYER,
		"Now that we're level 4, we can place another tower!" : ProgressMode.CONTINUE,
		["You can |0| the shop to get a new batch of towers, if you didn't like what was offered to you.", [plain_fragment__refresh_or_reroll]] : ProgressMode.CONTINUE,
		#30
		["Press %s or click this button to |0| the shop." % InputMap.get_action_list("game_shop_refresh")[0].as_text(), [plain_fragment__refresh]] : ProgressMode.ACTION_FROM_PLAYER,
		"Normally, you get 5 towers per shop. In this case, you only get one, since this is a tutorial." : ProgressMode.CONTINUE,
		["Also, the shop |0| every |1| for free!", [plain_fragment__refreshes, plain_fragment__end_of_round]] : ProgressMode.CONTINUE,
		
		"To wrap up this tutorial, let's sell a tower." : ProgressMode.CONTINUE,
		#34
		["Please sell this |0| by pressing %s while hovering the tower, or by dragging the tower to the bottom panel (where the shop is)." % InputMap.get_action_list("game_tower_sell")[0].as_text(), [plain_fragment__tower]] : ProgressMode.ACTION_FROM_PLAYER,
		"Good job, as always!" : ProgressMode.CONTINUE,
		
		"That concludes this chapter of the tutorial." : ProgressMode.CONTINUE,
		"(If you are new to the game, proceed to chapter 1.5.)" : ProgressMode.CONTINUE,
	}
	
	._apply_game_modifier_to_elements(arg_elements)
	
	game_elements.connect("before_game_start", self, "_on_game_elements_before_game_start", [], CONNECT_ONESHOT)
	connect("on_current_transcript_index_changed", self, "_on_current_transcript_index_changed")

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	

#

func _on_game_elements_before_game_start():
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
	
	advance_to_next_transcript_message()
	


####

func _on_current_transcript_index_changed(arg_index, arg_msg):
	if arg_index == 2: # buy spike
		listen_for_tower_with_id__bought__then_call_func(Towers.SPIKE, "_on_tower_bought__buy_spike", self)
		advance_to_next_custom_towers_at_shop()
		call_deferred("_transcript_02_deferred_call")
		
	elif arg_index == 5: # drag spike to tower slot
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.SPIKE], "_on_spike_placed_in_map", self)
		set_tower_is_draggable(_spike_tower, true)
		#display_white_arrows_pointed_at_node(get_map_area_05__from_glade(), 6)
		display_white_circle_at_node(get_map_area_05__from_glade(), 6)
		
	elif arg_index == 8: # round start prompt
		set_round_is_startable(true)
		var arrows = display_white_arrows_pointed_at_node(get_round_status_button(), 9)
		arrows[1].y_offset = -20
		#display_white_circle_at_node(get_round_status_button(), 9)
		listen_for_round_start__then_listen_for_round_end__call_func_for_both(self, "_on_transc_08__round_start", "_on_transc_08__round_end")
		
	elif arg_index == 9:
		#set_enabled_buy_slots([1])
		set_player_level(2)
		set_visiblity_of_placable(get_map_area_07__from_glade(), true)
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.SPRINKLER], "_on_sprinkler_placed_in_map", self)
		call_deferred("_transcript_09_deferred_call")
		
	elif arg_index == 12:
		set_round_is_startable(true)
		var arrows = display_white_arrows_pointed_at_node(get_round_status_button(), 13)
		arrows[1].y_offset = -20
		listen_for_round_start__then_listen_for_round_end__call_func_for_both(self, "_on_transc_12__round_start", "_on_transc_12__round_end")
		
	elif arg_index == 13:
		var arrows = display_white_arrows_pointed_at_node(get_round_speed_button_01(), 14, true, false)
		arrows[0].x_offset = -35
		
	elif arg_index == 14:
		set_enabled_buy_slots([0])
		display_white_circle_at_node(_spike_tower, 15)
		listen_for_view_tower_info_panel(Towers.SPIKE, self, "_on_open_tower_info_panel__for_transc_14")
		
	elif arg_index == 15:
		set_can_return_to_round_panel(false)
		display_white_arrows_pointed_at_node(get_tower_stats_panel_from_tower_info_panel(), 16)
		
	elif arg_index == 16:
		var button = get_extra_info_button_from_tower_info_panel()
		display_white_circle_at_node(button, 17)
		var arrows = display_white_arrows_pointed_at_node(button, 17)
		arrows[0].x_offset = -55
		arrows[1].y_offset = 70
		arrows[1].flip_h = true
		
		listen_for_view_extra_info_panel(Towers.SPIKE, self, "_on_open_tower_extra_info_panel__for_16")
		
	elif arg_index == 19: #rightclick on tower card
		set_can_return_to_round_panel(true)
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(0), 20)
		listen_for_tower_buy_card_view_description_tooltip(Towers.REBOUND, self, "_on_open_tower_card_description_panel__for_19")
		
	elif arg_index == 22:
		set_enabled_buy_slots([1])
		set_player_level(3)
		set_visiblity_of_placable(get_map_area_09__from_glade(), true)
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(0), 23)
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.REBOUND], "_on_rebound_placed_in_map__for_22", self)
		
	elif arg_index == 23:
		set_round_is_startable(true)
		_arrows = display_white_arrows_pointed_at_node(get_round_status_button(), 13)
		_arrows[1].y_offset = -20
		listen_for_round_start__then_listen_for_round_end__call_func_for_both(self, "_on_transc_23__round_start", "_on_transc_23__round_end")
		
	elif arg_index == 27:
		set_can_level_up(true)
		display_white_arrows_pointed_at_node(get_level_up_button_from_shop_panel(), 28)
		listen_for_player_level_up(4, self, "_on_player_level_up__on_transc_27")
		
	elif arg_index == 30:
		set_can_refresh_shop__panel_based(true)
		display_white_arrows_pointed_at_node(get_reroll_button_from_shop_panel(), 31)
		listen_for_shop_refresh(self, "_on_shop_refreshed__on_transc_30")
		
	elif arg_index == 34: # sell this tower (spike)
		set_tower_is_sellable(_spike_tower, true)
		set_tower_is_draggable(_spike_tower, true)
		display_white_circle_at_node(_spike_tower, 35)
		listen_for_tower_sold(Towers.SPIKE, self, "_on_tower_sold__on_transc_34")
		
	

#
func _transcript_02_deferred_call():
	var tower_buy_card = get_tower_buy_card_at_buy_slot_index(0)
	if is_instance_valid(tower_buy_card):
		display_white_arrows_pointed_at_node(tower_buy_card, 3)
		#display_white_circle_at_node(tower_buy_card, 3)


func _on_tower_bought__buy_spike(arg_tower):
	_spike_tower = arg_tower
	set_tower_is_sellable(arg_tower, false)
	#set_enabled_buy_slots([])
	set_tower_is_draggable(arg_tower, false)
	
	advance_to_next_transcript_message()

#
func _on_spike_placed_in_map(arg_towers : Array):
	set_tower_is_draggable(arg_towers[0], false)
	advance_to_next_transcript_message()

#
func _on_transc_08__round_start():
	hide_current_transcript_message()
	set_round_is_startable(false)

func _on_transc_08__round_end():
	advance_to_next_transcript_message()

#
func _transcript_09_deferred_call():
	advance_to_next_custom_towers_at_shop()
	var tower_buy_card = get_tower_buy_card_at_buy_slot_index(0)
	if is_instance_valid(tower_buy_card):
		#display_white_circle_at_node(tower_buy_card, 10)
		display_white_arrows_pointed_at_node(tower_buy_card, 10)

func _on_sprinkler_placed_in_map(arg_towers : Array):
	set_tower_is_draggable(arg_towers[0], false)
	advance_to_next_transcript_message()


#
func _on_transc_12__round_start():
	advance_to_next_transcript_message()

func _on_transc_12__round_end(): # technically transc 13
	advance_to_next_transcript_message()
	advance_to_next_custom_towers_at_shop()
	#set_enabled_buy_slots([])
	set_round_is_startable(false)
	


#
func _on_open_tower_info_panel__for_transc_14(arg_tower):
	advance_to_next_transcript_message()
	

#
func _on_open_tower_extra_info_panel__for_16(arg_info_panel, arg_tower):
	advance_to_next_transcript_message()
	

#
func _on_open_tower_card_description_panel__for_19(tower_id, buy_slot):
	advance_to_next_transcript_message()
	

#
func _on_rebound_placed_in_map__for_22(arg_instances : Array):
	advance_to_next_transcript_message()

#
func _on_transc_23__round_start():
	for arrow in _arrows:
		arrow.queue_free()
	hide_current_transcript_message()

func _on_transc_23__round_end():
	set_round_is_startable(false)
	advance_to_next_transcript_message()

#

func _on_player_level_up__on_transc_27(arg_player_lvl):
	set_can_level_up(false)
	advance_to_next_transcript_message()
	

#
func _on_shop_refreshed__on_transc_30(arg_tower_ids):
	set_can_refresh_shop__panel_based(false)
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()


#
func _on_tower_sold__on_transc_34(arg_sellback_gold, arg_tower_id):
	advance_to_next_transcript_message()

