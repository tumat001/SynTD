extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TriaSyn_RYB_BeforeReachEndEffect = preload("res://GameInfoRelated/EnemyEffectRelated/MiscEffects/SynergySourced/TriaSyn_RYB_BeforeReachEndEffect.gd")


const heal_amount : float = 40.0

const tier_1_dmg_res_amount : float = 20.0
const tier_2_dmg_res_amount : float = 40.0
const tier_3_dmg_res_amount : float = 65.0


var tria_syn_effect : TriaSyn_RYB_BeforeReachEndEffect

var game_elements
var curr_tier : int

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	curr_tier = tier
	
	if tria_syn_effect == null:
		_construct_tria_effect()
	_configure_tria_effect_based_on_tier()
	
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_apply_syn_to_enemy"):
		game_elements.enemy_manager.connect("enemy_spawned", self, "_apply_syn_to_enemy", [], CONNECT_PERSIST)
	
	#for enemy in game_elements.enemy_manager.get_all_enemies():
	#	_apply_syn_to_enemy(enemy)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)

func _construct_tria_effect():
	tria_syn_effect = TriaSyn_RYB_BeforeReachEndEffect.new(tier_3_dmg_res_amount, heal_amount)

func _configure_tria_effect_based_on_tier():
	if curr_tier == 1:
		tria_syn_effect.damage_res_amount = tier_1_dmg_res_amount
	elif curr_tier == 2:
		tria_syn_effect.damage_res_amount == tier_2_dmg_res_amount
	elif curr_tier == 3:
		tria_syn_effect.damage_res_amount == tier_3_dmg_res_amount

#

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements.enemy_manager.is_connected("enemy_spawned", self, "_apply_syn_to_enemy"):
		game_elements.enemy_manager.disconnect("enemy_spawned", self, "_apply_syn_to_enemy")
	
	for enemy in game_elements.enemy_manager.get_all_enemies():
		_remove_syn_from_enemy(enemy)
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


#

func _apply_syn_to_enemy(enemy):
	if !enemy._before_reaching_end_path_effects_map.has(StoreOfEnemyEffectsUUID.RYB_BEFORE_END_REACH_EFFECT) and !enemy._before_reaching_end_path_effects_map.has(StoreOfEnemyEffectsUUID.RYB_ENEMY_DAMAGE_RESISTANCE_EFFECT):
		enemy._add_effect(tria_syn_effect)


#

func _remove_syn_from_enemy(enemy):
	if enemy._before_reaching_end_path_effects_map.has(StoreOfEnemyEffectsUUID.RYB_BEFORE_END_REACH_EFFECT):
		enemy._remove_effect(enemy._before_reaching_end_path_effects_map[StoreOfEnemyEffectsUUID.RYB_BEFORE_END_REACH_EFFECT])