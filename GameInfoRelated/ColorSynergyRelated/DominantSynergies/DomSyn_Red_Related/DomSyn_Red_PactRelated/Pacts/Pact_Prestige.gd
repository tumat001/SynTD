extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"


var tower_per_shop_reduction : int = 0
var shop_level_odds_modi : int = 0

const gold_requirement_for_offerable : int = 10

func _init(arg_tier : int).(StoreOfPactUUID.PactUUIDs.PRESTIGE, "Prestige", arg_tier):
	
	
	if tier == 0:
		pass
	elif tier == 1:
		tower_per_shop_reduction = 1
		shop_level_odds_modi = 1
	elif tier == 2:
		tower_per_shop_reduction = 3
		shop_level_odds_modi = 1
	elif tier == 3:
		pass
	
	
	good_descriptions = [
		"Towers appear in your shop as if you were %s level higher." % str(shop_level_odds_modi)
	]
	
	bad_descriptions = [
		"%s less towers appear per shop refresh." % str(tower_per_shop_reduction)
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


