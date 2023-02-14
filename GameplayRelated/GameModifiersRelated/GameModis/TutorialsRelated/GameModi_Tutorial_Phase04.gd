extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"

const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


# start with x y in the map, 1 sprinker, 1 cannon and flameburst

var towers_offered_on_shop_refresh : Array = [
	[Towers.STRIKER],
	[]
]

var transcript_to_progress_mode : Dictionary
var _same_towers_needed_for_combi : int

#
func _init().(StoreOfGameModifiers.GameModiIds__ModiTutorialPhase_01, 
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
	_same_towers_needed_for_combi = game_elements.combination_manager.base_combination_amount
	
	var plain_fragment__ingredient_effects = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredient effects")
	var plain_fragment__ingredient_effect = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredient effect")
	var plain_fragment__absorb = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorb")
	var plain_fragment__Combination = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COMBINATION, "Combination")
	var plain_fragment__identical_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "identical towers")
	var plain_fragment__combine = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COMBINATION, "combine")
	var plain_fragment__Strikers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Strikers")
	var plain_fragment__Striker = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Striker")
	var plain_fragment__combination = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COMBINATION, "combination")
	
	var plain_fragment__refresh_the_shop = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "refresh the shop")
	var plain_fragment__combined = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COMBINATION, "combined")
	var plain_fragment__Absorbing = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "Absorbing")
	var plain_fragment__1_ingredient_slot = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "1 ingredient slot")
	var plain_fragment__no_ingredient_slots = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "no ingredient slots")
	
	var plain_fragment__Sprinkler = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Sprinker")
	var plain_fragment__tier_1_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_01, "tier 1 towers")
	var plain_fragment__Cannon = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Cannon")
	var plain_fragment__Flameburst = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Flameburst")
	var plain_fragment__combinations = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COMBINATION, "combinations")
	
	var plain_fragment__tier_1 = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_01, "tier 1")
	var plain_fragment__tier_2 = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_02, "tier 2")
	var plain_fragment__combinable = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COMBINATION, "combinable")
	
	
	transcript_to_progress_mode = {
		"Welcome to the chapter 4 of the tutorial. Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
		
		["Recall |0|: which is an effect that gives special buffs.", [plain_fragment__ingredient_effects]] : ProgressMode.CONTINUE,
		["We have established that towers can |0| other towers, gaining the absorbed tower's |1|. This can be done under certain color-related conditions.", [plain_fragment__absorb, plain_fragment__ingredient_effect]] : ProgressMode.CONTINUE,
		["|0| is just another way of giving |1| to towers, along with its own conditions.", [plain_fragment__Combination, plain_fragment__ingredient_effects]] : ProgressMode.CONTINUE,
		
		["In order to |0| towers, you need %s |1|." % str(_same_towers_needed_for_combi), [plain_fragment__combine, plain_fragment__identical_towers]] : ProgressMode.CONTINUE,
		["Right now we have %s |0|. We only need one more |1| to do a |2|." % str(_same_towers_needed_for_combi - 1), [plain_fragment__Strikers, plain_fragment__Striker, plain_fragment__combination]] : ProgressMode.CONTINUE,
		#6
		["Please |0|.", [plain_fragment__refresh_the_shop]] : ProgressMode.ACTION_FROM_PLAYER,
		["A |0|! A shine particle is briefly shown if buying that tower allows you to trigger a |1|.", [plain_fragment__Striker, plain_fragment__combination]] : ProgressMode.CONTINUE,
		#8
		["Buy |0|.", [plain_fragment__Striker]] : ProgressMode.ACTION_FROM_PLAYER,
		["Now, an indicator is shown to the %s |0| that are going to be sacrificed for the |1| to take place." % str(_same_towers_needed_for_combi), [plain_fragment__Strikers, plain_fragment__combination]] : ProgressMode.CONTINUE,
		#10
		["Press %s to |0| the %s |1|." % [InputMap.get_action_list("game_combine_combinables")[0].as_text(), str(_same_towers_needed_for_combi)], [plain_fragment__combine, plain_fragment__Strikers]] : ProgressMode.ACTION_FROM_PLAYER,
		#11
		["Nice! We can see here (this icon) that we have indeed |0| the |1|.", [plain_fragment__combined, plain_fragment__Strikers]] : ProgressMode.CONTINUE,
		
		"But what does combining towers do? A comparison to absorbing will help clear things out." : ProgressMode.CONTINUE,
		["|0| towers is color-based, affects only the recepient, and takes up |1|. |2| is tier-based, affects multiple towers, and takes |3|.", [plain_fragment__Absorbing, plain_fragment__1_ingredient_slot, plain_fragment__Combination, plain_fragment__no_ingredient_slots]] : ProgressMode.CONTINUE,
		["|0| applies the combined tower's |1| to all towers with tiers who are below, equal, and 1 tier above the combined tower.", [plain_fragment__Combination, plain_fragment__ingredient_effect]] : ProgressMode.CONTINUE,
		
		["|0| benefits from the |1| of |2|, since |2| and |0| are |3| (they have the same tier).", [plain_fragment__Sprinkler, plain_fragment__combination, plain_fragment__Striker, plain_fragment__tier_1_towers]] : ProgressMode.CONTINUE,
		["|0| benefits from the |1| of |2|, since |0| is only 1 tier above |2|.", [plain_fragment__Cannon, plain_fragment__combination, plain_fragment__Striker]] : ProgressMode.CONTINUE,
		["But |0| does not benefit from the |1| of |2|, since |0| is 2 tiers above |2|.", [plain_fragment__Flameburst, plain_fragment__combination, plain_fragment__Striker]] : ProgressMode.CONTINUE,
		["Future towers bought benefit from exising |0|.", [plain_fragment__combinations]] : ProgressMode.CONTINUE,
		
		#19
		"There is one more rule about combinations." : ProgressMode.CONTINUE,
		["By default, only |0| and |1| towers are |2|.", [plain_fragment__tier_1, plain_fragment__tier_2, plain_fragment__combinable]] : ProgressMode.CONTINUE,
		"When the time comes, you are able to break that limitation, if you want to." : ProgressMode.CONTINUE,
		
		#22
		["Clicking this icon shows you all of your |0|. It also shows a description of combinations, and what combinations apply to the selected tier.", [plain_fragment__combinations]] : ProgressMode.CONTINUE,
		"..." : ProgressMode.CONTINUE,
		"While finding %s of the same tower may be challenging and costly, it has its own upsides." % str(_same_towers_needed_for_combi): ProgressMode.CONTINUE,
		"No ingredient slots are taken by the combinations, so the sky's the limit. Also, it is not color dependent, so it can apply to a whole range of towers it normally would not." : ProgressMode.CONTINUE,
		
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
	set_player_level(8)
	add_gold_amount(34)
	set_ingredient_limit_modi(9)
	
	
#	var Striker_01 = create_tower_at_placable(Towers.STRIKER, get_map_area_05__from_glade())
#	var Striker_02 = create_tower_at_placable(Towers.STRIKER, get_map_area_07__from_glade())
#	var Striker_03 = create_tower_at_placable(Towers.STRIKER, get_map_area_09__from_glade())
#	var cannon_01 = create_tower_at_placable(Towers.CANNON, get_map_area_04__from_glade())
#	var flameburst_01 = create_tower_at_placable(Towers.FLAMEBURST, get_map_area_06__from_glade())
#	var sprinkler_01 = create_tower_at_placable(Towers.SPRINKLER, get_map_area_10__from_glade())
#
#	set_tower_is_sellable(Striker_01, false)
#	set_tower_is_sellable(Striker_02, false)
#	set_tower_is_sellable(Striker_03, false)
#	set_tower_is_sellable(cannon_01, false)
#	set_tower_is_sellable(flameburst_01, false)
#	set_tower_is_sellable(sprinkler_01, false)
	
	var area_placables = get_map_area__for_defaults__from_glade()
	
	var cannon_01 = create_tower_at_placable(Towers.CANNON, area_placables[0])
	var flameburst_01 = create_tower_at_placable(Towers.FLAMEBURST, area_placables[1])
	var sprinkler_01 = create_tower_at_placable(Towers.SPRINKLER, area_placables[2])
	
	area_placables.remove(0)
	area_placables.remove(0)
	area_placables.remove(0)
	
	set_tower_is_sellable(cannon_01, false)
	set_tower_is_sellable(flameburst_01, false)
	set_tower_is_sellable(sprinkler_01, false)
	
	for i in _same_towers_needed_for_combi - 1:
		var Striker = create_tower_at_placable(Towers.STRIKER, area_placables[i])
		set_tower_is_sellable(Striker, false)
	
	#exit_scene_if_at_end_of_transcript = false
	#connect("at_end_of_transcript", self, "_on_end_of_transcript", [], CONNECT_ONESHOT)
	
	advance_to_next_transcript_message()
	


func _on_current_transcript_index_changed(arg_index, arg_msg):
	if arg_index == 6:
		set_can_refresh_shop__panel_based(true)
		listen_for_shop_refresh(self, "_on_shop_refresh__06")
		
	elif arg_index == 8:
		set_enabled_buy_slots([1])
		listen_for_tower_with_id__bought__then_call_func(Towers.STRIKER, "_on_Striker_bought__08", self)
		
	elif arg_index == 10:
		set_can_do_combination(true)
		listen_for_combination_effect_added(Towers.STRIKER, "_on_Strikers_combined", self)
		
	elif arg_index == 11:
		display_white_circle_at_node(get_tower_icon_with_tower_id__on_combination_top_panel(Towers.STRIKER), 12)
		
	elif arg_index == 22:
		display_white_circle_at_node(get_more_combination_info__on_combi_top_panel(), 20)


#
func _on_shop_refresh__06(arg_tower_ids):
	set_can_refresh_shop__panel_based(false)
	advance_to_next_custom_towers_at_shop()
	advance_to_next_transcript_message()
	
#
func _on_Striker_bought__08(arg_Striker):
	set_tower_is_sellable(arg_Striker, false)
	advance_to_next_transcript_message()
	

#
func _on_Strikers_combined():
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
