extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")

const _dmg_threshold_for_increase : float = 5.5
const _increased_stack_amount : int = 3
const _base_stack_amount : int = 1

const _corruption_time_in_seconds : float = 15.0


var tower_side_stack_effect : TowerOnHitEffectAdderEffect
var attached_tower

func _init().(StoreOfTowerEffectsUUID.BLACK_CORRUPTION_STACK_GIVER):
	pass


func _make_modifications_to_tower(tower):
	attached_tower = tower
	
	if tower_side_stack_effect == null:
		_construct_stack_effect()
		tower.add_tower_effect(tower_side_stack_effect)
	
	if !tower.is_connected("final_base_damage_changed", self, "_tower_base_dmg_changed"):
		tower.connect("final_base_damage_changed", self, "_tower_base_dmg_changed", [], CONNECT_PERSIST)
	
	_tower_base_dmg_changed()


func _undo_modifications_to_tower(tower):
	if tower.is_connected("final_base_damage_changed", self, "_tower_base_dmg_changed"):
		tower.disconnect("final_base_damage_changed", self, "_tower_base_dmg_changed")
	
	if tower_side_stack_effect != null:
		tower.remove_tower_effect(tower_side_stack_effect)

#

func _construct_stack_effect():
	var enemy_side_stack_effect : EnemyStackEffect = EnemyStackEffect.new(null, _base_stack_amount, 999999, StoreOfEnemyEffectsUUID.BLACK_CORRUPTION_STACK, true, false)
	enemy_side_stack_effect.time_in_seconds = _corruption_time_in_seconds
	enemy_side_stack_effect.is_timebound = true
	
	tower_side_stack_effect = TowerOnHitEffectAdderEffect.new(enemy_side_stack_effect, StoreOfTowerEffectsUUID.BLACK_CORRUPTION_STACK)


func _tower_base_dmg_changed():
	if is_instance_valid(attached_tower.main_attack_module):
		var final_base_dmg = attached_tower.main_attack_module.last_calculated_final_damage
		
		if final_base_dmg >= _dmg_threshold_for_increase:
			tower_side_stack_effect.enemy_base_effect.num_of_stacks_per_apply = _increased_stack_amount
		else:
			tower_side_stack_effect.enemy_base_effect.num_of_stacks_per_apply = _base_stack_amount

