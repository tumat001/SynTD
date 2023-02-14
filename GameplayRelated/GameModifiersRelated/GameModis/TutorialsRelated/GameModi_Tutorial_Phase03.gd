extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"

const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


var towers_offered_on_shop_refresh : Array = [
	[Towers.REBOUND, Towers.MINI_TESLA, Towers.EMBER, Towers.TIME_MACHINE, Towers.SHACKLED],
	[Towers.REBOUND]
]

var transcript_to_progress_mode : Dictionary

var _rebound
var _striker
var _all_towers : Array

#
func _init().(StoreOfGameModifiers.GameModiIds__ModiTutorialPhase_01, 
		BreakpointActivation.BEFORE_MAIN_INIT, "Chapter 3: Ingredient Effects"):
	
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
	var plain_fragment__Ingredient_Effect = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "Ingredient Effect")
	var plain_fragment__Ingredient_Effects = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "Ingredient Effects")
	var plain_fragment__ingredient_effects = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredient effects")
	var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
	var plain_fragment__Rebound = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Rebound")
	var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "tower")
	var plain_fragment__Striker = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Striker")
	var plain_fragment__Rebounds = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Rebound's")
	var plain_fragment__ingredient = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredient")
	var plain_fragment__Mini_Tesla = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Mini Tesla")
	
	var plain_fragment__Red = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_RED, "Red")
	var plain_fragment__Reds = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_RED, "Red's")
	var plain_fragment__Orange = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_ORANGE, "Orange")
	var plain_fragment__Violet = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_VIOLET, "Violet")
	var plain_fragment__Yellow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_YELLOW, "Yellow")
	var plain_fragment__Ember = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Ember")
	var plain_fragment__Orange_tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_ORANGE, "Orange tower")
	
	var plain_fragment__Time_Machine = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Time Machine")
	var plain_fragment__Shackled = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Shackled")
	var plain_fragment__Blue = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_BLUE, "Blue")
	var plain_fragment__Green = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_GREEN, "Green")
	
	var plain_fragment__absorbed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorbed")
	var plain_fragment__absorb = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorb")
	
	
	transcript_to_progress_mode = {
		"Welcome to the chapter 3 of the tutorial. Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
		
		#1
		"Right click this tower card to view its descriptions and stats." : ProgressMode.ACTION_FROM_PLAYER,
		["Over here, you can see that tower's |0|. Rebound's ingredient effect allows bullets to pass through 1 extra times.", [plain_fragment__Ingredient_Effect]] : ProgressMode.CONTINUE,
		["|0| are bonus stats and special effects that a tower gives to its recepient when |1|.", [plain_fragment__Ingredient_Effects, plain_fragment__absorbed]] : ProgressMode.CONTINUE,
		["You can think of |0| as tower upgrades. In this game, the |1| are the upgrades!", [plain_fragment__ingredient_effects, plain_fragment__towers]] : ProgressMode.CONTINUE,
		#5 buy rebound
		["Let's demonstrate that. Buy |0|.", [plain_fragment__Rebound]] : ProgressMode.ACTION_FROM_PLAYER,
		#6
		"Now, press %s or click this color wheel to toggle to Absorb Mode." % InputMap.get_action_list("game_ingredient_toggle")[0].as_text() : ProgressMode.ACTION_FROM_PLAYER,
		"You are now in the Absorb Mode." : ProgressMode.CONTINUE,
		["Normally, dragging a |0| to another |0| just switches their positions.", [plain_fragment__tower]] : ProgressMode.CONTINUE,
		["But in the Absorb Mode, the dragged |0| gives its |1| to the |0| where it is dropped.", [plain_fragment__tower, plain_fragment__Ingredient_Effect]] : ProgressMode.CONTINUE,
		#10
		["Let's try that. Drag |0| and drop it to |1|.", [plain_fragment__Rebound, plain_fragment__Striker]] : ProgressMode.ACTION_FROM_PLAYER,
		["Great! |0| |1| |2| |3|. (You can check this by right clicking Striker and looking at the right side panel.)", [plain_fragment__Striker, plain_fragment__absorbed, plain_fragment__Rebounds, plain_fragment__Ingredient_Effect]] : ProgressMode.CONTINUE,
		["Normally, towers can |0| only 1 |1|. But this can be increased by other means.", [plain_fragment__absorb, plain_fragment__ingredient]] : ProgressMode.CONTINUE,
		"(Also, since this is a tutorial, towers here can absorb many ingredients.)" : ProgressMode.CONTINUE,
		
		"..." : ProgressMode.CONTINUE,
		["There are restrictions as to what towers can be |0| by another tower. Allow the next situation to demonstrate that.", [plain_fragment__absorbed]] : ProgressMode.CONTINUE,
		#16
		["Disable Absorb Mode (by pressing %s or by clicking the color wheel), then buy |0| from the shop." % InputMap.get_action_list("game_ingredient_toggle")[0].as_text(), [plain_fragment__Mini_Tesla]] : ProgressMode.ACTION_FROM_PLAYER,
		["Notice that you can't offer |0| as an |1| for |2|. In other words, |2| cannot |3| |0|.", [plain_fragment__Mini_Tesla, plain_fragment__ingredient, plain_fragment__Striker, plain_fragment__absorb]] : ProgressMode.CONTINUE,
		["But why? That's because a tower only |0| towers of the same color and its 'neighbor' colors. |1| neighbor colors include |2| and |3|.", [plain_fragment__absorb, plain_fragment__Reds, plain_fragment__Orange, plain_fragment__Violet]] : ProgressMode.CONTINUE,
		["You can look at the color wheel to quickly see a tower's neighbor colors. |0| has |1| and |2| beside it, but not |3|.", [plain_fragment__Red, plain_fragment__Orange, plain_fragment__Violet, plain_fragment__Yellow]] : ProgressMode.CONTINUE,
		#20
		["Buy |0| from the shop.", [plain_fragment__Ember]] : ProgressMode.ACTION_FROM_PLAYER,
		["Since |0| is an |1|, |2| can absorb |0|. The reverse is also true.", [plain_fragment__Ember, plain_fragment__Orange_tower, plain_fragment__Striker]] : ProgressMode.CONTINUE,
		
		#22
		["Buy |0| from the shop.", [plain_fragment__Time_Machine]] : ProgressMode.ACTION_FROM_PLAYER,
		#23
		["Also, buy |0| from the shop", [plain_fragment__Shackled]] : ProgressMode.ACTION_FROM_PLAYER,
		"Towers with two colors work exactly the same way." : ProgressMode.CONTINUE,
		["|0| can |6| |1| and |2| towers since those are its colors, and can absorb |3|, |4| and |5| towers since those are its neighbor colors.", [plain_fragment__Time_Machine, plain_fragment__Yellow, plain_fragment__Blue, plain_fragment__Green, plain_fragment__Orange, plain_fragment__Violet, plain_fragment__absorb]] : ProgressMode.CONTINUE,
		["With that said, |0| can |4| |1|, |2| and |3|. You can check that right now.", [plain_fragment__Time_Machine, plain_fragment__Mini_Tesla, plain_fragment__Ember, plain_fragment__Shackled, plain_fragment__absorb]] : ProgressMode.CONTINUE,
		
		#27
		"...." : ProgressMode.CONTINUE,
		["One last rule. Towers cannot |0| the same tower more than once.", [plain_fragment__absorb]] : ProgressMode.CONTINUE,
		#29
		["Buy |0| from the shop.", [plain_fragment__Rebound]] : ProgressMode.ACTION_FROM_PLAYER,
		#30
		["Notice that |0| cannot |1| it, even if the colors are compatible. That is because |0| already has absorbed a |2|.", [plain_fragment__Striker, plain_fragment__absorb, plain_fragment__Rebound]] : ProgressMode.CONTINUE,
		
		["Remember that by default, towers can only |0| 1 |1|, so use that limit wisely.", [plain_fragment__absorb, plain_fragment__ingredient]] : ProgressMode.CONTINUE,
		
		"That concludes this chapter of the tutorial. Feel free to tinker with the towers." : ProgressMode.CONTINUE,
		"(If you are new to the game, and have played chapters 1 and 2, you can now play the game. You now know the game's basics.)" : ProgressMode.CONTINUE,
		"(You can proceed to chapter 4 once you have a bit of a feel for the game, or if you just want to.)" : ProgressMode.CONTINUE,
		
		#35
		"(Once you're done experimenting, you can exit the game by pressing ESC and quitting the game.)" : ProgressMode.WAIT_FOR_EVENT,
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
	set_visiblity_of_all_placables(false)
	set_visiblity_of_placable(get_map_area_05__from_glade(), true)
	set_visiblity_of_placable(get_map_area_07__from_glade(), true)
	set_visiblity_of_placable(get_map_area_09__from_glade(), true)
	set_visiblity_of_placable(get_map_area_04__from_glade(), true)
	set_visiblity_of_placable(get_map_area_06__from_glade(), true)
	set_player_level(5)
	add_gold_amount(34)
	set_ingredient_limit_modi(9)
	
	_striker = create_tower_at_placable(Towers.STRIKER, get_map_area_05__from_glade())
	set_tower_is_draggable(_striker, false)
	set_tower_is_sellable(_striker, false)
	
	exit_scene_if_at_end_of_transcript = false
	connect("at_end_of_transcript", self, "_on_end_of_transcript", [], CONNECT_ONESHOT)
	
	advance_to_next_transcript_message()
	


func _on_current_transcript_index_changed(arg_index, arg_msg):
	if arg_index == 1:
		advance_to_next_custom_towers_at_shop()
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(0), 2)
		listen_for_tower_buy_card_view_description_tooltip(Towers.REBOUND, self, "_on_view_tower_card_desc_panel__01")
		
	elif arg_index == 5:
		set_enabled_buy_slots([1])
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(0), 6)
		listen_for_tower_with_id__bought__then_call_func(Towers.REBOUND, "_on_rebound_bought__05", self)
		
	elif arg_index == 6:
		set_can_toggle_to_ingredient_mode(true)
		display_white_arrows_pointed_at_node(get_color_wheel_on_bottom_panel_side(), 7, false, true)
		listen_for_ingredient_mode_toggle(true, "_on_toggle_ing_mode_activated__06", self)
		
	elif arg_index == 7:
		set_can_toggle_to_ingredient_mode(false)
		
	elif arg_index == 10:
		set_tower_is_draggable(_rebound, true)
		listen_for_tower_to_absorb_ing_id(_striker, StoreOfTowerEffectsUUID.ING_REBOUND, "_on_toggle_ing_mode_activated__10", self)
		
	elif arg_index == 16:
		set_can_toggle_to_ingredient_mode(true)
		set_enabled_buy_slots([2])
		listen_for_ingredient_mode_toggle(false, "_on_ing_mode_turned_off__16", self)
		
	elif arg_index == 20:
		set_enabled_buy_slots([3])
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(2), 21)
		listen_for_tower_with_id__bought__then_call_func(Towers.EMBER, "_on_ember_bought__20", self)
		
	elif arg_index == 22:
		set_enabled_buy_slots([4])
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(3), 23)
		listen_for_tower_with_id__bought__then_call_func(Towers.TIME_MACHINE, "_on_time_machine_bought__22", self)
		
	elif arg_index == 23:
		set_enabled_buy_slots([5])
		display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(4), 24)
		listen_for_tower_with_id__bought__then_call_func(Towers.SHACKLED, "_on_shackled_bought__23", self)
		
	elif arg_index == 29:
		set_enabled_buy_slots([1])
		advance_to_next_custom_towers_at_shop()
		listen_for_tower_with_id__bought__then_call_func(Towers.REBOUND, "_on_rebound_bought__29", self)
		
	elif arg_index == 35:
		_on_end_of_transcript()

#
func _on_view_tower_card_desc_panel__01(arg_tower_id, arg_buy_slot):
	advance_to_next_transcript_message()
	
	var tooltip_area = arg_buy_slot.get_current_tower_buy_card().current_tooltip.ing_info_body #ingredient_tooltip_body
	var arrows = display_white_arrows_pointed_at_node(tooltip_area, 3, true, false)
	arrows[0].x_offset = 25
	#arrows[1].y_offset = -30
	
	

#
func _on_rebound_bought__05(arg_tower):
	_rebound = arg_tower
	set_tower_is_sellable(arg_tower, false)
	set_tower_is_draggable(arg_tower, false)
	_all_towers.append(arg_tower)
	
	advance_to_next_transcript_message()

#
func _on_toggle_ing_mode_activated__06():
	advance_to_next_transcript_message()

#
func _on_toggle_ing_mode_activated__10(arg_ing):
	advance_to_next_transcript_message()

#
func _on_ing_mode_turned_off__16():
	display_white_arrows_pointed_at_node(get_tower_buy_card_at_buy_slot_index(1), 16)
	listen_for_tower_with_id__bought__then_call_func(Towers.MINI_TESLA, "_on_mini_tesla_bought__15", self)
	set_can_toggle_to_ingredient_mode(false)

func _on_mini_tesla_bought__15(arg_tower):
	set_tower_is_sellable(arg_tower, false)
	_all_towers.append(arg_tower)
	set_can_toggle_to_ingredient_mode(true)
	
	advance_to_next_transcript_message()

#
func _on_ember_bought__20(arg_tower):
	set_tower_is_sellable(arg_tower, false)
	_all_towers.append(arg_tower)
	
	advance_to_next_transcript_message()

#
func _on_time_machine_bought__22(arg_tower):
	set_tower_is_sellable(arg_tower, false)
	_all_towers.append(arg_tower)
	
	advance_to_next_transcript_message()

#
func _on_shackled_bought__23(arg_tower):
	set_tower_is_sellable(arg_tower, false)
	_all_towers.append(arg_tower)
	
	advance_to_next_transcript_message()

#
func _on_rebound_bought__29(arg_tower):
	set_tower_is_sellable(arg_tower, false)
	_all_towers.append(arg_tower)
	
	advance_to_next_transcript_message()

#

func _on_end_of_transcript():
	#hide_current_transcript_message()
	
	add_gold_amount(30)
	set_can_refresh_shop__panel_based(true)
	for tower in _all_towers:
		if is_instance_valid(tower):
			set_tower_is_draggable(tower, true)
			set_tower_is_sellable(tower, true)
	
	set_tower_is_draggable(_striker, true)
	set_tower_is_sellable(_striker, true)
	
	set_can_sell_towers(true)
	set_visiblity_of_all_placables(true)
	set_enabled_buy_slots([1, 2, 3, 4, 5])
	add_shop_per_refresh_modifier(0)
	set_can_towers_swap_positions_to_another_tower(true)
	set_can_toggle_to_ingredient_mode(true)
