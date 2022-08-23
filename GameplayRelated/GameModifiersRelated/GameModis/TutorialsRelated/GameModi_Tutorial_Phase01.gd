extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"


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

var transcript_to_progress_mode : Dictionary = {
	"Welcome to Random Tower Defense! Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
	"In a tower defense game, you place towers to defeat the enemies." : ProgressMode.CONTINUE,
	"Left click this \"tower card\" to buy the displayed tower." : ProgressMode.ACTION_FROM_PLAYER,
	"When you buy towers, they appear in your bench.\nBenched towers do not attack; you need to place them in the map." : ProgressMode.CONTINUE,
	"You can think of the bench as your inventory for towers." : ProgressMode.CONTINUE,
	"Drag the tower to this tower slot to activate it." : ProgressMode.ACTION_FROM_PLAYER,
	"Good job! Now this tower is ready to defend." : ProgressMode.CONTINUE,
	"You can always drag the tower back to the bench, but not during the round.\n(Due to this being a tutorial, you can't do that just yet.)" : ProgressMode.CONTINUE,
	"Press %s to start the round, or click this button." % InputMap.get_action_list("game_round_toggle")[0] : ProgressMode.ACTION_FROM_PLAYER,
	
	#9
	"Now lets pracice what we just learned. Buy a tower and place it in the map." : ProgressMode.ACTION_FROM_PLAYER,
	"Nice! You're getting the hang of it." : ProgressMode.CONTINUE,
	"The number of towers you can place in the map is equal to your level. Since you are level 2, you can place 2 towers." : ProgressMode.CONTINUE,
	"Let's start the round. (Press %s. or click this button)." % InputMap.get_action_list("game_round_toggle")[0] : ProgressMode.ACTION_FROM_PLAYER,
	"While the round is started, you can fast forward the game by pressing %s.\nPressing it again resets the game speed (same for the round button)." % InputMap.get_action_list("game_round_toggle")[0] : ProgressMode.WAIT_FOR_EVENT, #wait for round to end
	
	#14 #Right click spike
	"To view a tower's description and stats, just right click a tower.\nPlease right click this tower." : ProgressMode.ACTION_FROM_PLAYER,
	"Over here you can see the tower's stats, such as base damage (red icon),\nattack speed (yellow icon), range (green icon), and more." : ProgressMode.CONTINUE,
	#16
	"Right click this little icon to view the tower's description." : ProgressMode.ACTION_FROM_PLAYER,
	"The tower's description shows what they do." : ProgressMode.CONTINUE,
	"You don't have to buy a tower to view their stats and description. You can also view those by right clicking a tower card (before it is bought)." : ProgressMode.CONTINUE,
	#19
	"Right click this tower card to view its description and stats." : ProgressMode.ACTION_FROM_PLAYER,
	"Going forward, it is important to emphasize that\nknowing a tower's description is much more important than knowing its stats." : ProgressMode.CONTINUE,
	"Towers have their own unique strenghts and weaknesses.\nAs you play the game, you will learn their quirks and interactions." : ProgressMode.CONTINUE,
	
	#22
	"Anyways, practice makes perfect. Buy this tower and place it in the map." : ProgressMode.ACTION_FROM_PLAYER,
	#23
	"Once again, let's start the round.\n(Press %s. or click this button)." : ProgressMode.ACTION_FROM_PLAYER,
	
	"Buying towers cost gold. Gold is gained at the end of the round." : ProgressMode.CONTINUE,
	"You also gain 1 extra gold for every 10 gold you have, up to 5.\nWhich means at 50 gold, you are making max interest." : ProgressMode.CONTINUE,
	"Gold is also used for leveling up, for rerolling your shop, among other things." : ProgressMode.CONTINUE,
	#27
	"Player level determines how many towers you can place.\nLet's level up to place more towers by clicking this button." : ProgressMode.ACTION_FROM_PLAYER,
	"Now that we're level 4, we can place another tower!" : ProgressMode.CONTINUE,
	"You can refresh the shop to get a new batch of towers, if you didn't like what was offered to you." : ProgressMode.CONTINUE,
	#30
	"Press %s or click this button to refresh the shop." % InputMap.get_action_list("game_shop_refresh")[0] : ProgressMode.ACTION_FROM_PLAYER,
	"Normally, you get 5 towers per shop. You only get one since this is a tutorial." : ProgressMode.CONTINUE,
	"Also, the shop refreshes every end of round." : ProgressMode.CONTINUE,
	
	"To wrap up this tutorial, let's sell a tower." : ProgressMode.CONTINUE,
	#34
	"Please sell this tower by pressing %s while hovering the tower,\nor by dragging the tower to the bottom panel (where the shop is)." % InputMap.get_action_list("game_tower_sell")[0] : ProgressMode.ACTION_FROM_PLAYER,
	
	"Good job, as always!" : ProgressMode.CONTINUE,
	"That concludes this chapter of the tutorial." : ProgressMode.CONTINUE,
	"(If you are new to the game, proceed to chapter 2.)" : ProgressMode.CONTINUE,
	
}

var _spike_tower

#
func _init().(StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_01, 
		BreakpointActivation.BEFORE_MAIN_INIT, "Chapter 1: Game Basics"):
	
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
	clear_all_tower_cards_from_shop()
	set_round_is_startable(false)
	set_can_level_up(false)
	set_can_refresh_shop__panel_based(false)
	set_enabled_buy_slots([1])
	set_can_sell_towers(true)
	set_can_toggle_to_ingredient_mode(false)
	set_can_towers_swap_positions_to_another_tower(false)
	add_shop_per_refresh_modifier(-5)
	set_visiblity_of_all_placables(false)
	set_visiblity_of_placable(get_map_area_05__from_glade(), true)
	
	advance_to_next_transcript_message()
	advance_to_next_custom_towers_at_shop()
	


####

func _on_current_transcript_index_changed(arg_index, arg_msg):
	if arg_index == 2: # buy spike
		listen_for_tower_with_id__bought__then_call_func(Towers.SPIKE, "_on_tower_bought__buy_spike", self)
		call_deferred("_transcript_02_deferred_call")
		
	elif arg_index == 5: # drag spike to tower slot
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.SPIKE], "_on_spike_placed_in_map", self)
		display_white_arrows_pointed_at_node(get_map_area_05__from_glade(), 6)
		
	elif arg_index == 8: # round start prompt
		display_white_arrows_pointed_at_node(get_round_status_button(), 9)
		listen_for_round_start__then_listen_for_round_end__call_func_for_both(self, "_on_transc_08__round_start", "_on_transc_08__round_end")
		
	elif arg_index == 9:
		advance_to_next_custom_towers_at_shop()
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.SPRINKLER], "_on_sprinkler_placed_in_map", self)
		call_deferred("_transcript_09_deferred_call")
		
	elif arg_index == 12:
		display_white_arrows_pointed_at_node(get_round_status_button(), 13)
		listen_for_round_start__then_listen_for_round_end__call_func_for_both(self, "_on_transc_12__round_start", "_on_transc_12__round_end")
		
	elif arg_index == 14:
		display_white_arrows_pointed_at_node(_spike_tower, 15)
		listen_for_view_tower_info_panel(Towers.SPIKE, self, "_on_open_tower_info_panel__for_transc_14")
		
	elif arg_index == 15:
		display_white_arrows_pointed_at_node(get_tower_stats_panel_from_tower_info_panel(), 16)
		
	elif arg_index == 16:
		display_white_arrows_pointed_at_node(get_extra_info_button_from_tower_info_panel(), 17)
		listen_for_view_extra_info_panel(Towers.SPIKE, self, "_on_open_tower_extra_info_panel__for_16")
		
	elif arg_index == 19: #rightclick on tower card
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(0), 20)
		listen_for_tower_buy_card_view_description_tooltip(Towers.REBOUND, self, "_on_open_tower_card_description_panel__for_19")
		
	elif arg_index == 22:
		set_enabled_buy_slots([1])
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(0), 23)
		listen_for_towers_with_ids__placed_in_map__then_call_func([Towers.REBOUND], "_on_rebound_placed_in_map__for_22", self)
		
	elif arg_index == 23:
		display_white_arrows_pointed_at_node(get_round_status_button(), 13)
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
		display_white_arrows_pointed_at_node(_spike_tower, 35)
		listen_for_tower_sold(Towers.SPIKE, self, "_on_tower_sold__on_transc_34")
		
	

#
func _transcript_02_deferred_call():
	var tower_buy_card = get_tower_buy_card_at_buy_slot_index(0)
	if tower_buy_card != null:
		display_white_arrows_pointed_at_node(tower_buy_card, 3)

func _on_tower_bought__buy_spike(arg_tower):
	_spike_tower = arg_tower
	set_tower_is_sellable(arg_tower, false)
	advance_to_next_transcript_message()

#
func _on_spike_placed_in_map(arg_towers : Array):
	set_tower_is_draggable(arg_towers[0], false)
	advance_to_next_transcript_message()

#
func _on_transc_08__round_start():
	hide_current_transcript_message()

func _on_transc_08__round_end():
	advance_to_next_transcript_message()

#
func _transcript_09_deferred_call():
	var tower_buy_card = get_tower_buy_card_at_buy_slot_index(0)
	if tower_buy_card != null:
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
	set_enabled_buy_slots([])

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
	hide_current_transcript_message()

func _on_transc_23__round_end():
	advance_to_next_transcript_message()

#

func _on_player_level_up__on_transc_27(arg_player_lvl):
	set_can_level_up(false)
	advance_to_next_transcript_message()
	

#
func _on_shop_refreshed__on_transc_30(arg_tower_ids):
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()


#
func _on_tower_sold__on_transc_34(arg_sellback_gold, arg_tower_id):
	advance_to_next_transcript_message()

