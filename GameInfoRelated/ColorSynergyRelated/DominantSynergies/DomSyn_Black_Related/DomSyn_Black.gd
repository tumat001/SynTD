extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerEffect_DomSynBlack_DmgBonus = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_Black_DmgBonus.gd")
const TowerEffect_DomSynBlack_AttkSpeedGiver = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_Black_AttkSpeedBuffGiver.gd")
#const TowerEffect_DomSynBlack_BlackBeam = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_Black_BlackBeam.gd")
#const TowerEffect_DomSynBlack_CorruptionStacksGiver = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_Black_CorruptionStacksGiver.gd")

const SYN_INACTIVE : int = -1

const SYN_TIER_ATTK_SPD_GIVER : int = 3
const SYN_TIER_PATH_BASIC_LEVEL : int = 2
const SYN_TIER_PATH_ADV_LEVEL : int = 1

var all_black_towers : Array = []
var game_elements : GameElements

var curr_tier : int


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if !game_elements.stage_round_manager.is_connected("round_started", self, "_on_round_start"):
		game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	curr_tier = tier
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = SYN_INACTIVE
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	
	
	if game_elements.stage_round_manager.is_connected("round_started", self, "_on_round_start"):
		game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_start")
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


# Giving related

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	if tower._tower_colors.has(TowerColors.BLACK):
		_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLACK_ATTACK_DAMAGE_BUFF):
		tower.add_tower_effect(TowerEffect_DomSynBlack_DmgBonus.new())
	
	if curr_tier <= SYN_TIER_ATTK_SPD_GIVER:
		if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLACK_ATTACK_SPEED_BUFF_GIVER):
			var effect = TowerEffect_DomSynBlack_AttkSpeedGiver.new()
			effect.all_black_towers = all_black_towers
			tower.add_tower_effect(effect)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var dmg_bonus_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.BLACK_ATTACK_DAMAGE_BUFF)
	if dmg_bonus_effect != null:
		tower.remove_tower_effect(dmg_bonus_effect)
	
	var atk_spd_giver_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.BLACK_ATTACK_SPEED_BUFF_GIVER)
	if atk_spd_giver_effect != null:
		tower.remove_tower_effect(atk_spd_giver_effect)
	

# Attk speed buff giver related

func _on_round_start(curr_stageround):
	if curr_tier <= SYN_TIER_ATTK_SPD_GIVER and curr_tier != SYN_INACTIVE:
		all_black_towers.clear()
		for tower in game_elements.tower_manager.get_all_active_towers_with_color(TowerColors.BLACK):
			all_black_towers.append(tower)


# Path related



