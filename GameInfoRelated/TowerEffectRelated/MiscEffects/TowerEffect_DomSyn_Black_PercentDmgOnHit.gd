extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const Black_HitParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/HitParticle/Black_HitParticle.tscn")

const _stack_amount_trigger : int = 10
const _dmg_ratio : float = 10.0
const _dmg_flat_maximum : float = 7.0


var dmg_on_hit : OnHitDamage

func _init().(StoreOfTowerEffectsUUID.BLACK_PERCENT_HEALTH_DAMAGE_GIVER):
	pass


func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_any_attack_module_enemy_hit", self, "_attempt_give_on_hit_dmg"):
		tower.connect("on_any_attack_module_enemy_hit", self, "_attempt_give_on_hit_dmg", [], CONNECT_PERSIST)
	
	if dmg_on_hit == null:
		var percent_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.BLACK_PERCENT_HEALTH_DAMAGE)
		percent_modi.percent_amount = _dmg_ratio
		percent_modi.percent_based_on = PercentType.MISSING
		percent_modi.flat_maximum = _dmg_flat_maximum
		percent_modi.ignore_flat_limits = false
		
		dmg_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.BLACK_PERCENT_HEALTH_DAMAGE, percent_modi, DamageType.ELEMENTAL)

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_attack_module_enemy_hit", self, "_attempt_give_on_hit_dmg"):
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_attempt_give_on_hit_dmg")



func _attempt_give_on_hit_dmg(enemy, damage_register_id, damage_instance, module):
	if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.BLACK_CORRUPTION_STACK):
		var effect = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.BLACK_CORRUPTION_STACK]
		
		if effect._current_stack >= _stack_amount_trigger:
			_enemy_hit(enemy, damage_register_id, damage_instance, module)

func _enemy_hit(enemy, damage_register_id, damage_instance, module):
	damage_instance.on_hit_damages[dmg_on_hit.internal_id] = dmg_on_hit.get_copy_scaled_by(1)
	if is_instance_valid(enemy):
		_summon_particle(enemy)

func _summon_particle(enemy):
	var particle = Black_HitParticle_Scene.instance()
	particle.global_position = enemy.global_position
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)

