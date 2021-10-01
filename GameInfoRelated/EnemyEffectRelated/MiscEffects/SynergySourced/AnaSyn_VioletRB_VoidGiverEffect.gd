extends "res://GameInfoRelated/EnemyEffectRelated/BaseEnemyModifyingEffect.gd"

const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const Void_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB/Assets/Void_StatusBarIcon.png")

var health_trigger_threshold : float
var damage_percent_decrease_amount : float


func _init(arg_health_trigger_threshold : float, arg_dmg_percent_decrease : float).(StoreOfEnemyEffectsUUID.VIOLETRB_VOID_GIVER_EFFECT):
	health_trigger_threshold = arg_health_trigger_threshold
	damage_percent_decrease_amount = arg_dmg_percent_decrease
	
	is_clearable = false


func _make_modifications_to_enemy(enemy):
	if !enemy.is_connected("on_current_health_changed", self, "_on_enemy_curr_health_changed"):
		enemy.connect("on_current_health_changed", self, "_on_enemy_curr_health_changed", [enemy])


func _on_enemy_curr_health_changed(current_health, enemy):
	var ratio = current_health / enemy._last_calculated_max_health
	
	if ratio < health_trigger_threshold:
		_give_void_effect_to_enemy(enemy)


func _give_void_effect_to_enemy(enemy):
	var damage_dec_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.VIOLETRB_PLAYER_DMG_DEC_EFFECT)
	damage_dec_modi.percent_amount = damage_percent_decrease_amount
	damage_dec_modi.percent_based_on = PercentType.MAX
	
	var damage_dec_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_PLAYER_DAMAGE, damage_dec_modi, StoreOfEnemyEffectsUUID.VIOLETRB_PLAYER_DMG_DEC_EFFECT)
	damage_dec_effect.status_bar_icon = Void_StatusBarIcon
	damage_dec_effect.is_clearable = false
	
	enemy._add_effect(damage_dec_effect)
	
	if enemy.is_connected("on_current_health_changed", self, "_on_enemy_curr_health_changed"):
		enemy.disconnect("on_current_health_changed", self, "_on_enemy_curr_health_changed")

#

func _undo_modifications_to_enemy(enemy):
	if enemy.is_connected("on_current_health_changed", self, "_on_enemy_curr_health_changed"):
		enemy.disconnect("on_current_health_changed", self, "_on_enemy_curr_health_changed")
	
	if enemy.percent_player_damage_id_effect_map.has(StoreOfEnemyEffectsUUID.VIOLETRB_PLAYER_DMG_DEC_EFFECT):
		enemy._remove_effect(enemy.percent_player_damage_id_effect_map[StoreOfEnemyEffectsUUID.VIOLETRB_PLAYER_DMG_DEC_EFFECT])

#

func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	var copy = get_script().new(health_trigger_threshold, damage_percent_decrease_amount)
	_configure_copy_to_match_self(copy)
	
	return copy


