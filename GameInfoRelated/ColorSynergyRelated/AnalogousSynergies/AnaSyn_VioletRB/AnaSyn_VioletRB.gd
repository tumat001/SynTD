extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"


const AnaSyn_VioletRB_VoidGiverEffect = preload("res://GameInfoRelated/EnemyEffectRelated/MiscEffects/SynergySourced/AnaSyn_VioletRB_VoidGiverEffect.gd")



const tier_2_ability_void_stun_duration : float = 3.0
const tier_3_player_dec_damage_amount : float = -50.0

const health_trigger_threshold : float = 0.85

var game_elements
var curr_tier : int
var current_enemy_escape_count_in_round : int = 0

var void_effect : AnaSyn_VioletRB_VoidGiverEffect

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	curr_tier = tier
	
	if void_effect == null:
		_construct_void_effect()
	_configure_void_effect_based_on_tier()
	
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_apply_syn_to_enemy"):
		game_elements.enemy_manager.connect("enemy_spawned", self, "_apply_syn_to_enemy", [], CONNECT_PERSIST)
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	#for enemy in game_elements.enemy_manager.get_all_enemies():
	#	_apply_syn_to_enemy(enemy)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _construct_void_effect():
	void_effect = AnaSyn_VioletRB_VoidGiverEffect.new()

func _configure_void_effect_based_on_tier():
	void_effect.health_trigger_threshold = health_trigger_threshold
	
	void_effect.damage_percent_decrease_amount = tier_3_player_dec_damage_amount
	void_effect.ability_void_stun_duration = tier_2_ability_void_stun_duration
	
	if curr_tier == 1:
		void_effect.if_give_ability_void_effect = true
		void_effect.if_give_pride_void_effect = true
		void_effect.if_give_damage_dec_effect = true
	elif curr_tier == 2:
		void_effect.if_give_ability_void_effect = true
		void_effect.if_give_pride_void_effect = false
		void_effect.if_give_damage_dec_effect = true
	elif curr_tier == 3:
		void_effect.if_give_ability_void_effect = false
		void_effect.if_give_pride_void_effect = false
		void_effect.if_give_damage_dec_effect = true

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
	if !enemy._base_enemy_modifying_effects_map.has(StoreOfEnemyEffectsUUID.VIOLETRB_VOID_GIVER_EFFECT):
		enemy._add_effect(void_effect)


#

func _remove_syn_from_enemy(enemy):
	if enemy._base_enemy_modifying_effects_map.has(StoreOfEnemyEffectsUUID.VIOLETRB_VOID_GIVER_EFFECT):
		enemy._remove_effect(enemy._base_enemy_modifying_effects_map[StoreOfEnemyEffectsUUID.VIOLETRB_VOID_GIVER_EFFECT])


#

func _on_round_end(curr_stageround):
	if curr_tier == -1:
		if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
			game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")

