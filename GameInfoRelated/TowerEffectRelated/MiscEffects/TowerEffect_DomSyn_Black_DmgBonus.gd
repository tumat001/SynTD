extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const _stack_amount_trigger : int = 2
const _dmg_scale : float = 1.2


func _init().(StoreOfTowerEffectsUUID.BLACK_ATTACK_DAMAGE_BUFF):
	pass


func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_any_attack_module_enemy_hit", self, "_attempt_buff_dmg_instance_base_dmg"):
		tower.connect("on_any_attack_module_enemy_hit", self, "_attempt_buff_dmg_instance_base_dmg", [], CONNECT_PERSIST)

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_attack_module_enemy_hit", self, "_attempt_buff_dmg_instance_base_dmg"):
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_attempt_buff_dmg_instance_base_dmg")



func _attempt_buff_dmg_instance_base_dmg(enemy, damage_register_id, damage_instance, module):
	if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.BLACK_CORRUPTION_STACK):
		var effect = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.BLACK_CORRUPTION_STACK]
		
		if effect._current_stack >= _stack_amount_trigger:
			damage_instance.scale_only_damage_by(_dmg_scale)


