extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


var _attached_tower

var _base_attack_count_for_double : int = 3
var _current_attack_count : int = 0


func _init().(StoreOfTowerEffectsUUID.ING_PROMINENCE):
	description = "Main attacks trigger on hit events twice, and every third main attack applies on hit effects twice."
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Prominence.png")


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_tower_on_hit_enemy"):
		tower.connect("on_main_attack_module_enemy_hit", self, "_tower_on_hit_enemy", [], CONNECT_PERSIST)
		tower.connect("on_main_attack_module_damage_instance_constructed", self, "_on_tower_main_dmg_instance_constructed", [], CONNECT_PERSIST)
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)

#

func _tower_on_hit_enemy(enemy, damage_register_id, damage_instance, module):
	call_deferred("_check_for_re_emit_on_hit_enemy", enemy, damage_register_id, damage_instance, module)

func _check_for_re_emit_on_hit_enemy(enemy, damage_register_id, damage_instance, module):
	if enemy != null and module != null and _attached_tower != null and damage_register_id != StoreOfTowerEffectsUUID.ING_PROMINENCE_DMG_INSTANCE_REAPPLIED:
		damage_instance = damage_instance.get_copy_scaled_by(1)
		damage_instance.on_hit_damages.clear()
		damage_instance.on_hit_effects.clear()
		#_attached_tower._emit_on_main_attack_module_enemy_hit(enemy, StoreOfTowerEffectsUUID.ING_PROMINENCE_DMG_INSTANCE_REAPPLIED, damage_instance, module)
		module.on_enemy_hit(enemy, StoreOfTowerEffectsUUID.ING_PROMINENCE_DMG_INSTANCE_REAPPLIED, damage_instance)

#

func _on_tower_main_dmg_instance_constructed(damage_instance, module):
	_current_attack_count += 1
	
	if _base_attack_count_for_double <= _current_attack_count:
		damage_instance.current_on_hit_effect_reapply_count = 1
		_current_attack_count = 0

#

func _on_round_end():
	_current_attack_count = 0

#

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack_module_enemy_hit", self, "_tower_on_hit_enemy"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_tower_on_hit_enemy")
		tower.disconnect("on_main_attack_module_damage_instance_constructed", self, "_on_tower_main_dmg_instance_constructed")
		tower.disconnect("on_round_end", self, "_on_round_end")
	
	_attached_tower = null

