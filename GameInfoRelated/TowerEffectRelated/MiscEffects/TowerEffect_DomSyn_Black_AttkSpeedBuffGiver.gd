extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const Black_BuffParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BuffParticle/Black_BuffParticle.tscn")

const _stack_amount_trigger : int = 5
const _attk_speed_buff_amount : float = 40.0
const _attk_speed_buff_duration : float = 8.0
const _attk_speed_buff_count : int = 5
const _buff_cooldown : float = 3.0

const _y_shift_of_particle : float = -12.0


var own_timer : Timer
var all_black_towers : Array # reference shared
var attk_speed_effect : TowerAttributesEffect

func _init().(StoreOfTowerEffectsUUID.BLACK_ATTACK_SPEED_BUFF_GIVER):
	pass


func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_main_attk_hit_enemy"):
		tower.connect("on_main_attack_module_enemy_hit", self, "_main_attk_hit_enemy", [], CONNECT_PERSIST)
	
	if own_timer == null:
		own_timer = Timer.new()
		own_timer.one_shot = true
		own_timer.wait_time = 0.1
		tower.get_tree().get_root().add_child(own_timer)
	
	if attk_speed_effect == null:
		var percent_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.BLACK_ATTACK_SPEED_BUFF)
		percent_modi.percent_amount = _attk_speed_buff_amount
		percent_modi.percent_based_on = PercentType.BASE
		
		attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, percent_modi, StoreOfTowerEffectsUUID.BLACK_ATTACK_SPEED_BUFF)
		attk_speed_effect.time_in_seconds = _attk_speed_buff_duration
		attk_speed_effect.is_timebound = true
		attk_speed_effect.count = _attk_speed_buff_count
		attk_speed_effect.is_countbound = true


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack_module_enemy_hit", self, "_main_attk_hit_enemy"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_main_attk_hit_enemy")
	
	if own_timer != null:
		own_timer.queue_free()
		own_timer = null


func _main_attk_hit_enemy(enemy, damage_register_id, damage_instance, module):
	if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.BLACK_CORRUPTION_STACK):
		var effect = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.BLACK_CORRUPTION_STACK]
		
		if effect._current_stack >= _stack_amount_trigger:
			_attempt_buff_random_tower()

func _attempt_buff_random_tower():
	if own_timer.time_left <= 0:
		_buff_random_tower()
		own_timer.start(_buff_cooldown)

func _buff_random_tower():
	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.BLACK_BUFF)
	
	var all_targetable_black_towers = all_black_towers.duplicate(false)
	for tower in all_targetable_black_towers:
		if tower == null or tower.last_calculated_is_untargetable == true:
			all_targetable_black_towers.erase(tower)
	
	if all_targetable_black_towers.size() != 0:
		var decided_num = rng.randi_range(0, all_targetable_black_towers.size() - 1)
		var decided_tower = all_targetable_black_towers[decided_num]
		
		decided_tower.add_tower_effect(attk_speed_effect._shallow_duplicate())
		
		
		var particle = Black_BuffParticle_Scene.instance()
		particle.position = decided_tower.global_position
		particle.position.y += _y_shift_of_particle
		decided_tower.get_tree().get_root().call_deferred("add_child", particle)