extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_DomSyn_Red_PlayingWithFireBuff = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_Red_PlayingWithFireBuff.gd")

var attk_speed_gain_val
var damage_gain_val

func _init(arg_tier : int).(StoreOfPactUUID.PLAYING_WITH_FIRE, "Playing With Fire", arg_tier):
	var possible_speed_gain_values : Array
	var possible_damage_gain_values : Array
	
	if tier == 0:
		possible_speed_gain_values = [120, 130, 140]
		possible_damage_gain_values = [19, 20, 21]
	elif tier == 1:
		possible_speed_gain_values = [80, 85, 90]
		possible_damage_gain_values = [11, 12, 13]
	elif tier == 2:
		possible_speed_gain_values = [55, 60, 65]
		possible_damage_gain_values = [5, 6, 7]
	elif tier == 3:
		possible_speed_gain_values = [40, 45, 50]
		possible_damage_gain_values = [3, 4, 5]
	
	var index_rng = pact_mag_rng.randi_range(0, 2)
	attk_speed_gain_val = possible_speed_gain_values[index_rng]
	damage_gain_val = possible_damage_gain_values[index_rng]
	
	good_descriptions = [
		"Towers gain from 0 to %s attack speed, based on current player health." % attk_speed_gain_val
	]
	
	bad_descriptions = [
		"The first enemy escape per round deals extra %s player damage." % damage_gain_val
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_PlayingWithFire_Icon.png")


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.enemy_manager.is_connected("first_enemy_escaped" , self, "_first_enemy_escaped"):
		game_elements.enemy_manager.connect("first_enemy_escaped", self, "_first_enemy_escaped", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _first_enemy_escaped(enemy, first_damage):
	game_elements.health_manager.decrease_health_by(damage_gain_val, game_elements.HealthManager.DecreaseHealthSource.SYNERGY)


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	if game_elements.enemy_manager.is_connected("first_enemy_escaped" , self, "_first_enemy_escaped"):
		game_elements.enemy_manager.disconnect("first_enemy_escaped", self, "_first_enemy_escaped")
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


#


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_PLAYING_WITH_FIRE_BUFF_GIVER):
		var effect = TowerEffect_DomSyn_Red_PlayingWithFireBuff.new(game_elements.health_manager)
		
		effect.base_max_attk_speed_amount = attk_speed_gain_val
		
		tower.add_tower_effect(effect)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_PLAYING_WITH_FIRE_BUFF_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)
