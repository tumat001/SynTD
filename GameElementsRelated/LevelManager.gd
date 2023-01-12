extends Node

const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const RelicManager = preload("res://GameElementsRelated/RelicManager.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const gold_currency_icon = preload("res://GameHUDRelated/BuySellPanel/GoldPic.png")
const relic_currency_icon = preload("res://GameHUDRelated/BuySellPanel/RelicPic.png")

const RelicStoreOfferOption = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Classes/RelicStoreOfferOption.gd")
const LevelUp_ToLevel10_Normal_Pic = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Assets/Buttons/LevelUp_ToLevel10_Normal.png")
const LevelUp_ToLevel10_Highlighted_Pic = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Assets/Buttons/LevelUp_ToLevel10_Highlighted.png")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const MeshScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/SpecialEffects/MeshScreenTintEffect.gd")
const MeshScreenTintEffect_Scene = preload("res://MiscRelated/ScreenEffectsRelated/SpecialEffects/MeshScreenTintEffect.tscn")



signal on_current_level_up_cost_amount_changed(new_cost)
signal on_current_level_up_cost_currency_changed(new_currency)
signal on_current_level_changed(new_level)

signal on_can_level_up_changed(can_level_up)

enum {
	LEVEL_1 = 1,
	LEVEL_2 = 2,
	LEVEL_3 = 3,
	LEVEL_4 = 4,
	LEVEL_5 = 5,
	LEVEL_6 = 6,
	LEVEL_7 = 7,
	LEVEL_8 = 8,
	LEVEL_9 = 9,
	LEVEL_10 = 10,
	
	# Reachable by red syn (not the level itself tho, used by shop manager)
	LEVEL_11 = 11,
	LEVEL_12 = 12,
}

enum Currency {
	GOLD = 100,
	RELIC = 101,
}

const base_level_up_costs : Dictionary = {
	LEVEL_1 : [2, Currency.GOLD],
	LEVEL_2 : [2, Currency.GOLD],
	LEVEL_3 : [6, Currency.GOLD],
	LEVEL_4 : [18, Currency.GOLD],
	LEVEL_5 : [36, Currency.GOLD],
	LEVEL_6 : [44, Currency.GOLD],
	LEVEL_7 : [60, Currency.GOLD],
	LEVEL_8 : [90, Currency.GOLD], #88
	LEVEL_9 : [1, Currency.RELIC],
	LEVEL_10 : [0, Currency.GOLD],
	
	#
	
#	LEVEL_1 : [2, Currency.GOLD],
#	LEVEL_2 : [2, Currency.GOLD],
#	LEVEL_3 : [6, Currency.GOLD],
#	LEVEL_4 : [18, Currency.GOLD],
#	LEVEL_5 : [38, Currency.GOLD],
#	LEVEL_6 : [48, Currency.GOLD],
#	LEVEL_7 : [60, Currency.GOLD],
#	LEVEL_8 : [80, Currency.GOLD],
#	LEVEL_9 : [1, Currency.RELIC],
#	LEVEL_10 : [0, Currency.GOLD],
}

const before_max_level : int = LEVEL_9
const max_level : int = LEVEL_10

var current_level : int setget set_current_level

#

#enum LevelUpCostModifiers {
#	NATURAL_PROGRESSION = 0, # per round, reduce level cost by x
#
#	SYN_RED__JEWELED_SWORD = 1,
#	SYN_RED__JEWELED_STAFF = 2,
#}
#
#var level_to_cost_modifier_map : Dictionary = {}


const base_level_up_gold_cost_reduction_per_round : int = 2 #Natural progression

var current_level_up_cost : int = 0 setget set_level_up_cost
var current_level_up_currency : int


# relic shop offer

var level_up_to_10_shop_offer_id : int


# screen tint related

const level_up_screen_tint_modulate__orange := Color(1, 128/255.0, 0, 0.5)
const level_up_screen_tint_modulate__green := Color(30/255.0, 218/255.0, 2/255.0, 0.5)

const level_up_screen_tint_modulate_transparent := Color(0, 0, 0, 0)
#const level_up_screen_tint_modulate_transparent := level_up_screen_tint_modulate__orange


#

var game_elements
var stage_round_manager setget set_stage_round_manager
var gold_manager : GoldManager setget set_gold_manager
var relic_manager : RelicManager setget set_relic_manager
var whole_screen_relic_general_store_panel setget set_whole_screen_relic_general_store_panel

# clauses

enum CanLevelUpClauses {
	END_OF_GAME = 100,
	
	TUTORIAL_DISABLE = 1000
}
var can_level_up_clauses : ConditionalClauses
var last_calculated_can_level_up : bool


# setters

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end_game_start_aware", [], CONNECT_PERSIST)

func set_gold_manager(arg_manager : GoldManager):
	gold_manager = arg_manager
	
	gold_manager.connect("current_gold_changed", self, "_gold_amount_changed", [], CONNECT_PERSIST)

func set_relic_manager(arg_manager : RelicManager):
	relic_manager = arg_manager
	
	relic_manager.connect("current_relic_count_changed", self, "_relic_count_changed", [], CONNECT_PERSIST)

func set_whole_screen_relic_general_store_panel(arg_manager):
	whole_screen_relic_general_store_panel = arg_manager

#

func _ready():
	can_level_up_clauses = ConditionalClauses.new()
	can_level_up_clauses.connect("clause_inserted", self, "_on_can_level_up_cond_clause_inserted_or_removed", [], CONNECT_PERSIST)
	can_level_up_clauses.connect("clause_removed", self, "_on_can_level_up_cond_clause_inserted_or_removed", [], CONNECT_PERSIST)
	
	#
	set_current_level(LEVEL_1)


# on round end

func _on_round_end_game_start_aware(curr_stageround, is_game_start):
	if !is_game_start:
		reduce_level_up_gold_cost()


# level costs related

func reduce_level_up_gold_cost(amount : int = base_level_up_gold_cost_reduction_per_round):
	if _if_can_reduce_next_level_cost():
		set_level_up_cost(current_level_up_cost - amount)

func _if_can_reduce_next_level_cost():
	return !is_in_max_level() and current_level != before_max_level


func set_level_up_cost(val : int):
	current_level_up_cost = val
	emit_signal("on_current_level_up_cost_amount_changed", val)
	
	if val <= 0:
		level_up_with_spend_currency()

func set_level_up_cost_currency(curr : int):
	current_level_up_currency = curr
	
	emit_signal("on_current_level_up_cost_currency_changed", curr)


# level related

func is_in_max_level() -> bool:
	return current_level == max_level


func can_level_up():
	if can_level_up_clauses.is_passed:
		if !is_in_max_level():
			if current_level_up_currency == Currency.GOLD:
				return gold_manager.current_gold >= current_level_up_cost
			else: # RELIC
				return relic_manager.current_relic_count >= current_level_up_cost
	
	return false


func level_up_with_spend_currency__from_game_elements():
	if current_level == LEVEL_9 and whole_screen_relic_general_store_panel.is_shop_offer_id_exists(level_up_to_10_shop_offer_id):
		whole_screen_relic_general_store_panel.trigger_relic_store_offer_option(level_up_to_10_shop_offer_id)
		
	else:
		level_up_with_spend_currency()

func level_up_with_spend_currency():
	if can_level_up():
		if current_level_up_currency == Currency.GOLD:
			gold_manager.decrease_gold_by(current_level_up_cost, GoldManager.DecreaseGoldSource.LEVEL_UP)
		elif current_level_up_currency == Currency.RELIC:
			relic_manager.decrease_relic_count_by(current_level_up_cost, RelicManager.DecreaseRelicSource.LEVEL_UP)
		
		set_current_level(current_level + 1, true)
		return true
	
	return false



func set_current_level(new_level, arg_play_tint : bool = false):
	if max_level >= new_level:
		current_level = new_level
		
		emit_signal("on_current_level_changed", new_level)
		
		set_level_up_cost(base_level_up_costs[current_level][0])
		set_level_up_cost_currency(base_level_up_costs[current_level][1])
		
		_on_current_level_changed__for_store_purposes()
		
		if arg_play_tint:
			_on_current_level_changed__for_tint_purposes()

func _gold_amount_changed(gold_amount):
	#emit_signal("on_can_level_up_changed", can_level_up())
	_update_if_can_level_up()

func _relic_count_changed(relic_amount):
	#emit_signal("on_can_level_up_changed", can_level_up())
	_update_if_can_level_up()


# used by some red syns
func get_level_after_current():
	if !is_in_max_level():
		return current_level + 1
	else:
		return max_level

# miscs

func get_currency_icon(currency : int) -> Texture:
	if currency == Currency.GOLD:
		return gold_currency_icon
	elif currency == Currency.RELIC:
		return relic_currency_icon
	
	return null

###

func _on_can_level_up_cond_clause_inserted_or_removed(arg_clause):
	_update_if_can_level_up()


func _update_if_can_level_up():
	last_calculated_can_level_up = can_level_up()
	emit_signal("on_can_level_up_changed", last_calculated_can_level_up)


#func can_level_up() -> bool:
#	if !is_in_max_level():
#		if current_level_up_currency == Currency.GOLD:
#			return gold_manager.current_gold >= current_level_up_cost
#		else: # RELIC
#			return relic_manager.current_relic_count >= current_level_up_cost
#
#	return false



########## RELIC offer

func _on_current_level_changed__for_store_purposes():
	if current_level == LEVEL_9:
		_create_relic_store_offer_options()
	elif current_level == LEVEL_10:
		_remove_level_up_to_10_relic_store_offer_option()

func _create_relic_store_offer_options():
	var plain_fragment__level_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.LEVEL_UP_GREEN, "Level up")
	var plain_fragment__tier_6_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_06, "tier 6 towers")
	
	
	var level_up_desc = [
		["|0| to 10, gaining access to |1|.", [plain_fragment__level_up, plain_fragment__tier_6_towers]],
		"However, you do not gain an additional tower slot."
	]
	
	var level_up_shop_offer := RelicStoreOfferOption.new(self, "_on_level_up_to_10_shop_offer_selected", LevelUp_ToLevel10_Normal_Pic, LevelUp_ToLevel10_Highlighted_Pic)
	level_up_shop_offer.descriptions = level_up_desc
	level_up_shop_offer.header_left_text = "Level Up To 10"
	
	level_up_to_10_shop_offer_id = whole_screen_relic_general_store_panel.add_relic_store_offer_option(level_up_shop_offer)

func _on_level_up_to_10_shop_offer_selected():
	return level_up_with_spend_currency()


func _remove_level_up_to_10_relic_store_offer_option():
	whole_screen_relic_general_store_panel.remove_relic_store_offer_option(level_up_to_10_shop_offer_id)


#####

func _on_current_level_changed__for_tint_purposes():
	if current_level != LEVEL_1 and is_instance_valid(game_elements):
		
		var gradient_texture : GradientTexture2D = game_elements.get_rect_gradient_texture__based_on_play_map()
		
		if current_level == LEVEL_10:
			gradient_texture.gradient = game_elements.construct_gradient_two_color(level_up_screen_tint_modulate_transparent, level_up_screen_tint_modulate__green)
		else:
			gradient_texture.gradient = game_elements.construct_gradient_two_color(level_up_screen_tint_modulate_transparent, level_up_screen_tint_modulate__orange)
		
		var tint_effect = MeshScreenTintEffect_Scene.instance()
		tint_effect.main_duration = 1.0
		tint_effect.fade_in_duration = 0.5
		tint_effect.fade_out_duration = 0.5
		tint_effect.ins_uuid = StoreOfScreenEffectsUUID.PLAYER_LEVEL_UP
		tint_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS
		tint_effect.initial_modulate_a = 1
		tint_effect.configure_self_to_gradient_texture_2d(game_elements.get_playable_map_size(), game_elements.get_middle_coordinates_of_playable_map(), gradient_texture)
		
		game_elements.screen_effect_manager.add_screen_tint_effect(tint_effect)



