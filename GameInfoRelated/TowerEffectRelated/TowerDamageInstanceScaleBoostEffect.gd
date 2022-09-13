extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

enum DmgInstanceTypesToBoost {
	MAIN_ONLY = 20,
	
	ANY = 21,
	ANY_BUT_MAIN = 22,
}

enum DmgInstanceBoostType {
	BASE_DMG_ONLY = 10,
	ON_HIT_DMG_ONLY = 11,
	BASE_AND_ON_HIT_DMG_ONLY = 12,
	
	ON_HIT_EFFECT_ONLY = 13,
	ALL = 14,
}


var boost_scale_amount : float
var _dmg_instance_types_to_boost : int
var _dmg_instance_boost_type : int

var _dmg_instance_boost_func_name_to_use : String

func _init(arg_dmg_instance_types_to_boost : int, 
		arg_boost_type : int, 
		arg_boost_amount : float, 
		arg_uuid : int).(arg_uuid):
	
	_dmg_instance_types_to_boost = arg_dmg_instance_types_to_boost
	_dmg_instance_boost_type = arg_boost_type
	boost_scale_amount = arg_boost_amount


#

func _make_modifications_to_tower(tower):
	if _dmg_instance_types_to_boost == DmgInstanceTypesToBoost.MAIN_ONLY:
		_connect_boost_main_only(tower)
	elif _dmg_instance_types_to_boost == DmgInstanceTypesToBoost.ANY:
		_connect_boost_any(tower)
	elif _dmg_instance_types_to_boost == DmgInstanceTypesToBoost.ANY_BUT_MAIN:
		_connect_boost_any_but_main(tower)
	
	if _dmg_instance_boost_type == DmgInstanceBoostType.BASE_DMG_ONLY:
		_dmg_instance_boost_func_name_to_use = "_boost_base_dmg_of_dmg_instance"
	elif _dmg_instance_boost_type == DmgInstanceBoostType.ON_HIT_DMG_ONLY:
		_dmg_instance_boost_func_name_to_use = "_boost_on_hit_dmg_of_dmg_instance"
	elif _dmg_instance_boost_type == DmgInstanceBoostType.BASE_AND_ON_HIT_DMG_ONLY:
		_dmg_instance_boost_func_name_to_use = "_boost_dmgs_of_dmg_instance"
	elif _dmg_instance_boost_type == DmgInstanceBoostType.ON_HIT_EFFECT_ONLY:
		_dmg_instance_boost_func_name_to_use = "_boost_on_hit_effect_of_dmg_instance"
	elif _dmg_instance_boost_type == DmgInstanceBoostType.ALL:
		_dmg_instance_boost_func_name_to_use = "_boost_all_of_dmg_instance"
	

#

func _connect_boost_main_only(tower):
	if !tower.is_connected("on_main_attack_module_damage_instance_constructed", self, "_on_dmg_inst_constructed"):
		tower.connect("on_main_attack_module_damage_instance_constructed", self, "_on_dmg_inst_constructed", [], CONNECT_PERSIST)

func _connect_boost_any(tower):
	if !tower.is_connected("on_damage_instance_constructed", self, "_on_dmg_inst_constructed"):
		tower.connect("on_damage_instance_constructed", self, "_on_dmg_inst_constructed", [], CONNECT_PERSIST)

func _connect_boost_any_but_main(tower):
	if !tower.is_connected("on_damage_instance_constructed", self, "_on_dmg_inst_constructed_any_but_main"):
		tower.connect("on_damage_instance_constructed", self, "_on_dmg_inst_constructed_any_but_main", [], CONNECT_PERSIST)

#

func _on_dmg_inst_constructed(damage_instance, module):
	call(_dmg_instance_boost_func_name_to_use, damage_instance)

func _on_dmg_inst_constructed_any_but_main(damage_instance, module):
	if module.module_id != StoreOfAttackModuleID.MAIN:
		call(_dmg_instance_boost_func_name_to_use, damage_instance)

#

func _boost_base_dmg_of_dmg_instance(damage_instance):
	damage_instance.scale_only_base_damage_by(boost_scale_amount)

func _boost_on_hit_dmg_of_dmg_instance(damage_instance):
	damage_instance.scale_only_on_hit_damage_by(boost_scale_amount)

func _boost_dmgs_of_dmg_instance(damage_instance):
	damage_instance.scale_only_damage_by(boost_scale_amount)

func _boost_on_hit_effect_of_dmg_instance(damage_instance):
	damage_instance.scale_only_on_hit_effect_by(boost_scale_amount)

func _boost_all_of_dmg_instance(damage_instance):
	damage_instance.scale_by(boost_scale_amount)


#

func _undo_modifications_to_tower(tower):
	if _dmg_instance_types_to_boost == DmgInstanceTypesToBoost.MAIN_ONLY:
		_disconnect_boost_main_only(tower)
	elif _dmg_instance_types_to_boost == DmgInstanceTypesToBoost.ANY:
		_disconnect_boost_any(tower)
	elif _dmg_instance_types_to_boost == DmgInstanceTypesToBoost.ANY_BUT_MAIN:
		_disconnect_boost_any_but_main(tower)

#

func _disconnect_boost_main_only(tower):
	if tower.is_connected("on_main_attack_module_damage_instance_constructed", self, "_on_dmg_inst_constructed"):
		tower.disconnect("on_main_attack_module_damage_instance_constructed", self, "_on_dmg_inst_constructed")

func _disconnect_boost_any(tower):
	if tower.is_connected("on_damage_instance_constructed", self, "_on_dmg_inst_constructed"):
		tower.disconnect("on_damage_instance_constructed", self, "_on_dmg_inst_constructed")

func _disconnect_boost_any_but_main(tower):
	if tower.is_connected("on_damage_instance_constructed", self, "_on_dmg_inst_constructed_any_but_main"):
		tower.disconnect("on_damage_instance_constructed", self, "_on_dmg_inst_constructed_any_but_main")


#

func _shallow_duplicate():
	var copy = get_script().new(_dmg_instance_types_to_boost, _dmg_instance_boost_type, boost_scale_amount, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy

