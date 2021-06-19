extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

var affected_range_module

func _init().(StoreOfTowerEffectsUUID.ING_LEADER):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Leader.png")
	description = "Tower gains all targeting options."


func _make_modifications_to_tower(tower):
	if tower.main_attack_module != null and tower.main_attack_module.range_module != null:
		affected_range_module = tower.main_attack_module.range_module 
		_add_targetings(affected_range_module)
	
	tower.connect("attack_module_added", self, "_tower_attack_module_added", [], CONNECT_PERSIST)
	tower.connect("attack_module_removed", self, "_tower_attack_module_removed", [], CONNECT_PERSIST)


func _add_targetings(range_module):
	range_module.add_targeting_options(Targeting.get_all_targeting_options())

func _remove_targetings(range_module):
	range_module.remove_targeting_options(Targeting.get_all_targeting_options())


func _tower_attack_module_added(module):
	if module.module_id == StoreOfAttackModuleID.MAIN:
		_add_targetings(module.range_module)

func _tower_attack_module_removed(module):
	if module.module_id == StoreOfAttackModuleID.MAIN:
		_remove_targetings(module.range_module)


func _undo_modifications_to_tower(tower):
	if affected_range_module != null:
		_remove_targetings(affected_range_module)
	
	tower.disconnect("attack_module_added", self, "_tower_attack_module_added")
	tower.disconnect("attack_module_removed", self, "_tower_attack_module_removed")


