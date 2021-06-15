extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")


func _init().(StoreOfTowerEffectsUUID.ING_WHITE_FRUIT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_WhiteFruit.png")
	description = "The tower's main attack damage type is now Pure instead."


func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_main_attack_module_damage_instance_constructed", self, "_convert_main_damage_to_pure"):
		tower.connect("on_main_attack_module_damage_instance_constructed", self, "_convert_main_damage_to_pure", [], CONNECT_PERSIST)


func _convert_main_damage_to_pure(damage_instance, module):
	if damage_instance.on_hit_damages.has(StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE):
		var main_on_hit : OnHitDamage = damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE]
		main_on_hit.damage_type = DamageType.PURE


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack_module_damage_instance_constructed", self, "_convert_main_damage_to_pure"):
		tower.disconnect("on_main_attack_module_damage_instance_constructed", self, "_convert_main_damage_to_pure")


