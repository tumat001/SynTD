extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

const NextDmgStunApply_StatusBarIcon = preload("res://TowerRelated/Color_Violet/Impede/IngAssets/NextDmgStunApply_StatusBarIcon.png")

#

const base_stun_duration : float = 1.0


var _current_scale : float = 1.0

var _tower
var _effects_applied : bool

var _is_next_dmg_instance_apply_stun : bool

#

func _init().(StoreOfTowerEffectsUUID.ING_IMPEDE):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_ImpedeIngEffect.png")
	_update_description()
	
	_can_be_scaled_by_yel_vio = true


func _update_description():
	var plain_fragment__stuns = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stuns")
	var plain_fragment__enemy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "enemy")
	
	description = ["After killing an |0|, the next damage instance |1| for %s second(s).%s" % [(base_stun_duration * _current_scale * _current_additive_scale), _generate_desc_for_persisting_total_additive_scaling(true)], [plain_fragment__enemy, plain_fragment__stuns]]
	
	emit_signal("description_updated")


###

func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_effects_applied:
		_effects_applied = true
		
		_tower.connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt", [], CONNECT_PERSIST)


func _on_any_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	if !_is_next_dmg_instance_apply_stun:
		if killed:
			_is_next_dmg_instance_apply_stun = true
			_tower.status_bar.add_status_icon(StoreOfTowerEffectsUUID.ING_IMPEDE_STUN_EFFECT_STAT_BAR_ICON, NextDmgStunApply_StatusBarIcon)
		
	else:
		if !killed:
			_is_next_dmg_instance_apply_stun = false
			_tower.status_bar.remove_status_icon(StoreOfTowerEffectsUUID.ING_IMPEDE_STUN_EFFECT_STAT_BAR_ICON)
			
			_apply_stun_effect_to_enemy(enemy)

func _apply_stun_effect_to_enemy(arg_enemy):
	var stun_effect = EnemyStunEffect.new(base_stun_duration * _current_scale, StoreOfEnemyEffectsUUID.IMPEDE_ING_EFFECT_STUN_EFFECT)
	
	arg_enemy._add_effect(stun_effect)


#

func _undo_modifications_to_tower(tower):
	if _effects_applied:
		_effects_applied = false
		
		_tower.status_bar.remove_status_icon(StoreOfTowerEffectsUUID.ING_IMPEDE_STUN_EFFECT_STAT_BAR_ICON)
		
		_tower.disconnect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt")


