extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TriaSyn_RYB_BeforeReachEndEffect = preload("res://GameInfoRelated/EnemyEffectRelated/MiscEffects/SynergySourced/TriaSyn_RYB_BeforeReachEndEffect.gd")



const heal_amount : float = 60.0

const tier_1_dmg_res_amount : float = 10.0
const tier_2_dmg_res_amount : float = 25.0
const tier_3_dmg_res_amount : float = 40.0

const tier_1_enemy_escape_count_before_deactivation : int = 16
const tier_2_enemy_escape_count_before_deactivation : int = 10
const tier_3_enemy_escape_count_before_deactivation : int = 6


var tria_syn_effect : TriaSyn_RYB_BeforeReachEndEffect

var game_elements : GameElements
var curr_tier : int
var current_enemy_escape_count_in_round : int = 0
var current_enemy_escape_count_before_deactivation : int


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	curr_tier = tier
	
	if tria_syn_effect == null:
		_construct_tria_effect()
	_configure_tria_effect_based_on_tier()
	
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_apply_syn_to_enemy"):
		game_elements.enemy_manager.connect("enemy_spawned", self, "_apply_syn_to_enemy", [], CONNECT_PERSIST)
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	#for enemy in game_elements.enemy_manager.get_all_enemies():
	#	_apply_syn_to_enemy(enemy)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)

func _construct_tria_effect():
	tria_syn_effect = TriaSyn_RYB_BeforeReachEndEffect.new(tier_3_dmg_res_amount, heal_amount, weakref(self), game_elements.stage_round_manager)

func _configure_tria_effect_based_on_tier():
	if curr_tier == 1:
		tria_syn_effect.damage_res_amount = tier_1_dmg_res_amount
		current_enemy_escape_count_before_deactivation = tier_1_enemy_escape_count_before_deactivation
	elif curr_tier == 2:
		tria_syn_effect.damage_res_amount == tier_2_dmg_res_amount
		current_enemy_escape_count_before_deactivation = tier_2_enemy_escape_count_before_deactivation
	elif curr_tier == 3:
		tria_syn_effect.damage_res_amount == tier_3_dmg_res_amount
		current_enemy_escape_count_before_deactivation = tier_3_enemy_escape_count_before_deactivation

#

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = -1
	
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


#

func _on_round_end(curr_stageround):
	current_enemy_escape_count_in_round = 0
	
	if curr_tier == -1:
		if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
			game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")

