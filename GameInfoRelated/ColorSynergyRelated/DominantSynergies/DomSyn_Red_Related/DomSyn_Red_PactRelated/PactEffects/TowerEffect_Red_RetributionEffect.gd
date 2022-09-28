extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const Retribution_HitParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/Pact_Retribution_HitParticle/Pact_Retribution_HitParticle.tscn")


var bonus_dmg_on_retribution_scale : float


var _enemies_that_exited_range : Array = []
var _enemies_to_apply_retribution_on : Array = []

var _tower


func _init().(StoreOfTowerEffectsUUID.RED_PACT_RETRIBUTION_EFFECT_GIVER):
	pass


func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_tower.is_connected("on_range_module_enemy_entered", self, "_on_enemy_entered_range_of_tower"):
		_tower.connect("on_range_module_enemy_exited", self, "_on_enemy_exited_range_of_tower", [], CONNECT_PERSIST)
		_tower.connect("on_range_module_enemy_entered", self, "_on_enemy_entered_range_of_tower", [], CONNECT_PERSIST)
		_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
		_tower.connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_module_enemy_hit", [], CONNECT_PERSIST)
	

#

func _on_enemy_exited_range_of_tower(enemy, module, range_module):
	if range_module == _tower.main_attack_module.range_module and !enemy.is_queued_for_deletion():
		if !_enemies_that_exited_range.has(enemy):
			_enemies_that_exited_range.append(enemy)
		
		if !enemy.is_connected("tree_exiting", self, "_on_enemy_tree_exiting"):
			enemy.connect("tree_exiting", self, "_on_enemy_tree_exiting", [enemy], CONNECT_ONESHOT)


func _on_enemy_tree_exiting(enemy):
	_enemies_that_exited_range.erase(enemy)
	_enemies_to_apply_retribution_on.erase(enemy)


#

func _on_enemy_entered_range_of_tower(enemy, module, range_module):
	if range_module == _tower.main_attack_module.range_module:
		if _enemies_that_exited_range.has(enemy):
			_enemies_to_apply_retribution_on.append(enemy)
			_enemies_that_exited_range.erase(enemy)

#

func _on_round_end():
	_enemies_that_exited_range.clear()
	_enemies_to_apply_retribution_on.clear()

#

func _on_main_attack_module_enemy_hit(enemy, damage_register_id, damage_instance, module):
	if _enemies_to_apply_retribution_on.has(enemy):
		_construct_hit_particle_on_position(enemy.global_position)
		damage_instance.scale_only_damage_by(bonus_dmg_on_retribution_scale)
		_enemies_to_apply_retribution_on.erase(enemy)
		
		if enemy.has_effect_uuid(StoreOfEnemyEffectsUUID.RED_RETRIBUTION_DAMAGE_RESISTANCE):
			var effect = enemy.get_effect_with_uuid(StoreOfEnemyEffectsUUID.RED_RETRIBUTION_DAMAGE_RESISTANCE)
			if effect != null:
				enemy._remove_effect(effect)


func _construct_hit_particle_on_position(arg_pos):
	var particle = Retribution_HitParticle_Scene.instance()
	particle.global_position = arg_pos
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)


##

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_range_module_enemy_entered", self, "_on_enemy_entered_range_of_tower"):
		tower.disconnect("on_range_module_enemy_exited", self, "_on_enemy_exited_range_of_tower")
		tower.disconnect("on_range_module_enemy_entered", self, "_on_enemy_entered_range_of_tower")
		tower.disconnect("on_round_end", self, "_on_round_end")
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_main_attack_module_enemy_hit")
	

