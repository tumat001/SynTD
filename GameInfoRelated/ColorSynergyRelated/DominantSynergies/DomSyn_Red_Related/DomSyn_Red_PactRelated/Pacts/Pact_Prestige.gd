extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"


var tower_per_shop_reduction : int = 0
var shop_level_odds_modi : int = 0

const gold_requirement_for_offerable : int = 10

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.PRESTIGE, "Prestige", arg_tier, arg_tier_for_activation):
	
	
	if tier == 0:
		pass
	elif tier == 1:
		tower_per_shop_reduction = 2
		shop_level_odds_modi = 1
	elif tier == 2:
		tower_per_shop_reduction = 3
		shop_level_odds_modi = 1
	elif tier == 3:
		tower_per_shop_reduction = 4
		shop_level_odds_modi = 1
	
	
	var plain_fragment__shop = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "shop")
	var plain_fragment__shop_refresh = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHOP, "shop refresh")
	
	
	good_descriptions = [
		["Towers appear in your |0| as if you were %s level higher." % str(shop_level_odds_modi), [plain_fragment__shop]]
	]
	
	bad_descriptions = [
		["%s less towers appear per |0|." % str(tower_per_shop_reduction), [plain_fragment__shop_refresh]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_Prestige_Icon.png")


#


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	game_elements.shop_manager.add_shop_level_odds_modi(game_elements.shop_manager.ShopLevelOddsModifiers.SYN_RED__PRESTIGE, shop_level_odds_modi)
	game_elements.shop_manager.add_towers_per_refresh_amount_modifier(game_elements.shop_manager.TowersPerShopModifiers.SYN_RED__PRESTIGE, -tower_per_shop_reduction)

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	game_elements.shop_manager.remove_shop_level_odds_modi_id(game_elements.shop_manager.ShopLevelOddsModifiers.SYN_RED__PRESTIGE)
	game_elements.shop_manager.remove_towers_per_refresh_amount_modifier(game_elements.shop_manager.TowersPerShopModifiers.SYN_RED__PRESTIGE)

#

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.gold_manager.current_gold >= gold_requirement_for_offerable


