extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const EnemyDmgOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyDmgOverTimeEffect.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")


const bleed_duration : float = 15.0

var player_damage_per_round
var enemy_bleed_per_second

var enemy_bleed_effect : EnemyDmgOverTimeEffect

var tier_to_player_dmg_per_round_map : Dictionary = {
	0 : 4,
	1 : 3,
	2 : 2,
	3 : 1
}
const round_multiplier_forgiveness_for_offerable : int = 6

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.TIGER_SOUL, "Tiger Soul", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		#player_damage_per_round = 4
		enemy_bleed_per_second = 4 #60
	elif tier == 1:
		#player_damage_per_round = 3
		enemy_bleed_per_second = 2 #30
	elif tier == 2:
		#player_damage_per_round = 2
		enemy_bleed_per_second = 1.25 #18.75
	elif tier == 3:
		#player_damage_per_round = 1
		enemy_bleed_per_second = 0.5 #7.5
	player_damage_per_round = tier_to_player_dmg_per_round_map[tier]
	
	
	good_descriptions = [
		"The Tiger causes bleed to enemies hit by attacks. The bleed deals %s physical damage per second for %s seconds. Does not stack." % [enemy_bleed_per_second, bleed_duration]
	]
	
	bad_descriptions = [
		"The Tiger causes you to bleed for %s health per end of round." % player_damage_per_round
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_TigerSoul_Icon.png")


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_on_enemy_spawned"):
		game_elements.enemy_manager.connect("enemy_spawned", self, "_on_enemy_spawned", [], CONNECT_PERSIST)
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST | CONNECT_DEFERRED)
		
	
	_construct_effect()

func _on_round_end(curr_stageround):
	game_elements.health_manager.decrease_health_by(player_damage_per_round, game_elements.HealthManager.DecreaseHealthSource.SYNERGY)


func _construct_effect():
	var bleed_dmg : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.RED_TIGER_SOUL_BLEED_DAMAGE)
	bleed_dmg.flat_modifier = enemy_bleed_per_second
	
	var bleed_on_hit : OnHitDamage = OnHitDamage.new(StoreOfEnemyEffectsUUID.RED_TIGER_SOUL_BLEED_DAMAGE, bleed_dmg, DamageType.PHYSICAL)
	var bleed_dmg_instance = DamageInstance.new()
	bleed_dmg_instance.on_hit_damages[bleed_on_hit.internal_id] = bleed_on_hit
	
	enemy_bleed_effect = EnemyDmgOverTimeEffect.new(bleed_dmg_instance, StoreOfEnemyEffectsUUID.RED_TIGER_SOUL_BLEED_DAMAGE, 1)
	enemy_bleed_effect.is_timebound = true
	enemy_bleed_effect.time_in_seconds = 15


func _on_enemy_spawned(enemy):
	enemy.connect("on_hit", self, "_on_enemy_hit", [], CONNECT_PERSIST | CONNECT_DEFERRED)

func _on_enemy_hit(enemy, damage_reg_id, damage_instance):
	if is_instance_valid(enemy):
		enemy._add_effect(enemy_bleed_effect)



#
func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.enemy_manager.is_connected("enemy_spawned", self, "_on_enemy_spawned"):
		game_elements.enemy_manager.disconnect("enemy_spawned", self, "_on_enemy_spawned")
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
		


#

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	var player_dmg_per_round = tier_to_player_dmg_per_round_map[arg_tier_to_be_offered]
	
	return (player_dmg_per_round * round_multiplier_forgiveness_for_offerable) > arg_game_elements.health_manager.current_health


