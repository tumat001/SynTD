extends "res://EnemyRelated/EnemyTypes/Type_Faithful/AbstractFaithfulEnemy.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")

const Providence_Debuff_StatusBarIcon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Providence_Debuff.png")


var attk_speed_debuff_amount : float = -30.0
var base_dmg_debuff_amount : float = -20.0
var debuff_duration : float = 4.0

var attk_speed_debuff_effect : TowerAttributesEffect
var base_dmg_debuff_effect : TowerAttributesEffect

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.PROVIDENCE))


func _ready():
	connect("on_hit_by_attack_module", self, "_on_hit_by_attk_module_p")
	
	_construct_debuff_effects()

func _construct_debuff_effects():
	var attk_speed_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.PROVIDENCE_ATTK_SPEED_DEBUFF_EFFECT)
	attk_speed_modi.percent_amount = attk_speed_debuff_amount
	attk_speed_modi.percent_based_on = PercentType.MAX
	
	attk_speed_debuff_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_modi, StoreOfTowerEffectsUUID.PROVIDENCE_ATTK_SPEED_DEBUFF_EFFECT)
	attk_speed_debuff_effect.time_in_seconds = debuff_duration
	attk_speed_debuff_effect.is_timebound = true
	attk_speed_debuff_effect.is_from_enemy = true
	
	
	var base_dmg_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.PROVIDENCE_BASE_DMG_DEBUFF_EFFECT)
	base_dmg_modi.percent_amount = base_dmg_debuff_amount
	base_dmg_modi.percent_based_on = PercentType.MAX
	
	base_dmg_debuff_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS, base_dmg_modi, StoreOfTowerEffectsUUID.PROVIDENCE_BASE_DMG_DEBUFF_EFFECT)
	base_dmg_debuff_effect.time_in_seconds = debuff_duration
	base_dmg_debuff_effect.is_timebound = true
	base_dmg_debuff_effect.is_from_enemy = true
	base_dmg_debuff_effect.status_bar_icon = Providence_Debuff_StatusBarIcon


#

func _on_hit_by_attk_module_p(me, damage_reg_id, damage_instance, attk_module):
	if is_instance_valid(attk_module.parent_tower):
		attk_module.parent_tower.add_tower_effect(attk_speed_debuff_effect)
		attk_module.parent_tower.add_tower_effect(base_dmg_debuff_effect)


