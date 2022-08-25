extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"

# start with 3 rebounds in the map, 1 sprinker, 1 cannon and flameburst

var towers_offered_on_shop_refresh : Array = [
	[Towers.REBOUND],
	[]
]

var transcript_to_progress_mode : Dictionary

#
func _init().(StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_04, 
		BreakpointActivation.BEFORE_MAIN_INIT, "Chapter 4: Combination"):
	
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
	transcript_to_progress_mode = {
		"Welcome to the chapter 4 of the tutorial. Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
		
		"Recall ingredient effects: which is an effect that gives stats and special buffs." : ProgressMode.CONTINUE,
		"Towers can \"absorb\" other towers, gaining the absorbed tower's ingredient effect.\nThis can be done under certain color-related conditions." : ProgressMode.CONTINUE,
		"\"Combination\" is just another way of giving ingredient effects to towers, along with its own conditions." : ProgressMode.CONTINUE,
		
		"In order to combine towers, you need 4 identical towers." : ProgressMode.CONTINUE,
		"Right now we have 3 Rebounds.\nWe only need one more Rebound to do a combination." : ProgressMode.CONTINUE,
		#6
		"Please Refresh the shop." : ProgressMode.ACTION_FROM_PLAYER,
		"A Rebound! Did you catch that?\nA shine particle is shown if buying that tower can allow you to trigger combination." : ProgressMode.CONTINUE,
		#8
		"Buy Rebound." : ProgressMode.ACTION_FROM_PLAYER,
		"Now, an indicator is shown to the 4 Rebounds that are going to be sacrificed for the Combination to take place." : ProgressMode.CONTINUE,
		#10
		"Press %s to combine the 4 Rebounds." % InputMap.get_action_list("game_combine_combinables")[0].as_text() : ProgressMode.ACTION_FROM_PLAYER,
		#11
		"Nice! We can see here (this icon) that we have indeed combined the Rebounds." : ProgressMode.CONTINUE,
		
		"But what does combining towers do? A comparison to absorbing will help clear things out." : ProgressMode.CONTINUE,
		"Absorbing towers is color-based, affects only the recepient, and takes up 1 ingredient slot.\nCombinations are tier-based, can affect multiple towers, and takes no ingredient slots." : ProgressMode.CONTINUE,
		"Combination applies the combined tower's ingredient effect\nto towers with tiers who are below, equal, and 1 tier above the combined tower." : ProgressMode.CONTINUE,
		
		"Sprinkler benefits from the combination effect of Rebound,\nsince Rebound and Sprinkler are tier 1 towers (they share tiers)." : ProgressMode.CONTINUE,
		"Cannon benefits from the combination effect of Rebound,\nsince Cannon is only 1 tier above Rebound." : ProgressMode.CONTINUE,
		"But Flameburst does not benefit from the combination effect of Rebound,\nsince Flameburst is 2 tiers above Rebound." : ProgressMode.CONTINUE,
		"Future towers bought benefit from exising combination effects." : ProgressMode.CONTINUE,
		
		#19
		"Clicking this icon shows you all of your combination effects.\nIt also shows a description of combinations, and what combinations apply to the selected tier." : ProgressMode.CONTINUE,
		"..." : ProgressMode.CONTINUE,
		"While finding 4 of the same tower may be challenging and costly,\nit has its own upsides." : ProgressMode.CONTINUE,
		"No ingredient slots are taken by the combinations, so the sky's the limit.\nAlso, it is not color dependent, so it can apply to a whole range of towers it normally would not." : ProgressMode.CONTINUE,
		
		"That concludes this chapter of the tutorial." : ProgressMode.CONTINUE,
		
	}
	
	clear_all_tower_cards_from_shop()
	set_round_is_startable(false)
	set_can_level_up(false)
	set_can_refresh_shop__panel_based(false)
	set_can_refresh_shop_at_round_end_clauses(false)
	set_enabled_buy_slots([])
	set_can_sell_towers(false)
	set_can_toggle_to_ingredient_mode(false)
	set_can_towers_swap_positions_to_another_tower(false)
	add_shop_per_refresh_modifier(-5)
	set_visiblity_of_all_placables(true)
	set_can_do_combination(false)
	#set_visiblity_of_placable(get_map_area_05__from_glade(), true)
	#set_visiblity_of_placable(get_map_area_07__from_glade(), true)
	#set_visiblity_of_placable(get_map_area_09__from_glade(), true)
	#set_visiblity_of_placable(get_map_area_04__from_glade(), true)
	#set_visiblity_of_placable(get_map_area_06__from_glade(), true)
	set_player_level(6)
	add_gold_amount(34)
	set_ingredient_limit_modi(9)
	
	var rebound_01 = create_tower_at_placable(Towers.REBOUND, get_map_area_05__from_glade())
	var rebound_02 = create_tower_at_placable(Towers.REBOUND, get_map_area_07__from_glade())
	var rebound_03 = create_tower_at_placable(Towers.REBOUND, get_map_area_09__from_glade())
	var cannon_01 = create_tower_at_placable(Towers.CANNON, get_map_area_04__from_glade())
	var flameburst_01 = create_tower_at_placable(Towers.FLAMEBURST, get_map_area_06__from_glade())
	var sprinkler_01 = create_tower_at_placable(Towers.SPRINKLER, get_map_area_10__from_glade())
	
	set_tower_is_sellable(rebound_01, false)
	set_tower_is_sellable(rebound_02, false)
	set_tower_is_sellable(rebound_03, false)
	set_tower_is_sellable(cannon_01, false)
	set_tower_is_sellable(flameburst_01, false)
	set_tower_is_sellable(sprinkler_01, false)
	
	#exit_scene_if_at_end_of_transcript = false
	#connect("at_end_of_transcript", self, "_on_end_of_transcript", [], CONNECT_ONESHOT)
	
	advance_to_next_transcript_message()
	


func _on_current_transcript_index_changed(arg_index, arg_msg):
	if arg_index == 6:
		set_can_refresh_shop__panel_based(true)
		listen_for_shop_refresh(self, "_on_shop_refresh__06")
		
	elif arg_index == 8:
		set_enabled_buy_slots([1])
		listen_for_tower_with_id__bought__then_call_func(Towers.REBOUND, "_on_rebound_bought__08", self)
		
	elif arg_index == 10:
		set_can_do_combination(true)
		listen_for_combination_effect_added(Towers.REBOUND, "_on_rebounds_combined", self)
		
	elif arg_index == 11:
		display_white_circle_at_node(get_tower_icon_with_tower_id__on_combination_top_panel(Towers.REBOUND), 12)
		
	elif arg_index == 19:
		display_white_circle_at_node(get_more_combination_info__on_combi_top_panel(), 20)


#
func _on_shop_refresh__06(arg_tower_ids):
	set_can_refresh_shop__panel_based(false)
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()
	
#
func _on_rebound_bought__08(arg_rebound):
	set_tower_is_sellable(arg_rebound, false)
	advance_to_next_transcript_message()
	

#
func _on_rebounds_combined():
	advance_to_next_transcript_message()

#




#

#func _on_end_of_transcript():
#	hide_current_transcript_message()
#
#	add_gold_amount(20)
#	set_can_refresh_shop__panel_based(true)
#
#	set_can_sell_towers(true)
#	set_visiblity_of_all_placables(true)
#	set_enabled_buy_slots([1, 2, 3, 4, 5])
#	add_shop_per_refresh_modifier(0)
#	set_can_towers_swap_positions_to_another_tower(true)
#	set_can_toggle_to_ingredient_mode(true)
