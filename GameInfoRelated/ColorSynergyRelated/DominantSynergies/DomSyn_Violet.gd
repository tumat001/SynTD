extends "res://GameInfoRelated/ColorSynergyRelated/AbstractTowerModifyingSynergyEffect.gd"

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const tier_4_tower_ing_limit : int = 25
const tier_3_tower_ing_limit : int = 11
const tier_2_tower_ing_limit : int = 8
const tier_1_tower_ing_limit : int = 9

func _apply_syn_to_tower(tower : AbstractTower, tier : int):
	if tower._tower_colors.has(TowerColors.VIOLET):
		if tier == 4: # 2 violet towers
			tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_SYNERGY, tier_4_tower_ing_limit)
			
		elif tier == 3:
			tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_SYNERGY, tier_3_tower_ing_limit)
			
		elif tier == 2:
			tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_SYNERGY, tier_2_tower_ing_limit)
			
		elif tier == 1:
			tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_SYNERGY, tier_1_tower_ing_limit)
			


func _remove_syn_from_tower(tower : AbstractTower):
	tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_SYNERGY, 0)
