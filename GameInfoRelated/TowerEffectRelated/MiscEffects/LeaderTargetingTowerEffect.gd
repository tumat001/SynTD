extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")

const armor_pierce_amount : float = 5.0
const toughness_pierce_amount : float = 5.0

var affected_range_module
var armor_pierce_effect : TowerAttributesEffect
var toughness_pierce_effect : TowerAttributesEffect


func _init().(StoreOfTowerEffectsUUID.ING_LEADER):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Leader.png")
	description = "Tower gains all targeting options, and receives 5 armor and toughness pierce."


func _make_modifications_to_tower(tower):
	if tower.main_attack_module != null and tower.main_attack_module.range_module != null:
		affected_range_module = tower.main_attack_module.range_module 
		_add_targetings(affected_range_module)
	
	tower.connect("attack_module_added", self, "_tower_attack_module_added", [], CONNECT_PERSIST)
	tower.connect("attack_module_removed", self, "_tower_attack_module_removed", [], CONNECT_PERSIST)
	
	if armor_pierce_effect == null:
		_construct_pierce_effects()
	
	tower.add_tower_effect(armor_pierce_effect)
	tower.add_tower_effect(toughness_pierce_effect)


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

#

func _construct_pierce_effects():
	var armor_pierce_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_LEADER_ARMOR_PIERCE)
	armor_pierce_modi.flat_modifier = armor_pierce_amount
	
	var toughness_pierce_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_LEADER_TOUGHNESS_PIERCE)
	toughness_pierce_modi.flat_modifier = toughness_pierce_amount
	
	armor_pierce_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ARMOR_PIERCE, armor_pierce_modi, StoreOfTowerEffectsUUID.ING_LEADER_ARMOR_PIERCE)
	
	toughness_pierce_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_TOUGHNESS_PIERCE, toughness_pierce_modi, StoreOfTowerEffectsUUID.ING_LEADER_TOUGHNESS_PIERCE)


#

func _undo_modifications_to_tower(tower):
	if affected_range_module != null:
		_remove_targetings(affected_range_module)
	
	tower.disconnect("attack_module_added", self, "_tower_attack_module_added")
	tower.disconnect("attack_module_removed", self, "_tower_attack_module_removed")
	
	tower.remove_tower_effect(armor_pierce_effect)
	tower.remove_tower_effect(toughness_pierce_effect)

