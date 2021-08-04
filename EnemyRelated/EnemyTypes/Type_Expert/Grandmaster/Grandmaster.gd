extends "res://EnemyRelated/AbstractEnemy.gd"

const _health_ratio_threshold_01 : float = 0.75
const _health_ratio_threshold_02 : float = 0.25
const _starting_boost_amount : float = 100.0
const _decrease_rate_of_boost_per_sec : float = 80.0
const _boost_duration : float = 1.3

var speed_bonus_modi : FlatModifier
var speed_bonus_effect : EnemyAttributesEffect
var _is_dashing : bool = false


const _invis_health_ratio_threshold : float = 0.5
const _invis_duration : float = 2.0
const _invis_premature_cancel_distance : float = 100.0

var invis_effect : EnemyInvisibilityEffect
var _is_invis : bool


const _shield_ratio : float = 75.0
var shield_effect : EnemyShieldEffect


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.GRANDMASTER))


# DASH RELATED

func _ready():
	connect("on_current_health_changed", self, "_on_health_threshold_01_reached")
	connect("on_current_health_changed", self, "_on_health_threshold_02_reached")
	connect("on_current_health_changed", self, "_on_health_invis_threshold_reached")
	
	_construct_speed_effect_d()
	_construct_invis_effect_g()
	_construct_shield_effect()

func _construct_speed_effect_d():
	speed_bonus_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.GRANDMASTER_SPEED_BOOST)
	speed_bonus_modi.flat_modifier = _starting_boost_amount
	
	speed_bonus_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_MOV_SPEED, speed_bonus_modi, StoreOfEnemyEffectsUUID.GRANDMASTER_SPEED_BOOST)
	speed_bonus_effect.respect_scale = true
	speed_bonus_effect.is_timebound = true
	speed_bonus_effect.time_in_seconds = _boost_duration
	speed_bonus_effect.is_from_enemy = true


#

func _on_health_threshold_01_reached(curr_health):
	if curr_health / _last_calculated_max_health <= _health_ratio_threshold_01:
		disconnect("on_current_health_changed", self, "_on_health_threshold_01_reached")
		_perform_dash()

func _on_health_threshold_02_reached(curr_health):
	if curr_health / _last_calculated_max_health <= _health_ratio_threshold_02:
		disconnect("on_current_health_changed", self, "_on_health_threshold_02_reached")
		_perform_dash()


func _perform_dash():
	if !_is_dashing:
		connect("effect_added", self, "_speed_effect_added")
		_add_effect(speed_bonus_effect)
		_add_effect(shield_effect)
		connect("effect_removed", self, "_on_speed_effect_removed")
		_is_dashing = true


func _process(delta):
	if _is_dashing:
		speed_bonus_modi.flat_modifier -= _decrease_rate_of_boost_per_sec * delta
		calculate_final_movement_speed()

#

func _speed_effect_added(effect_added, me):
	if effect_added.effect_uuid == StoreOfEnemyEffectsUUID.GRANDMASTER_SPEED_BOOST:
		speed_bonus_modi = effect_added.attribute_as_modifier
		disconnect("effect_added", self, "_speed_effect_added")


func _on_speed_effect_removed(effect_removed, me):
	if effect_removed.effect_uuid == StoreOfEnemyEffectsUUID.GRANDMASTER_SPEED_BOOST:
		_is_dashing = false
		disconnect("effect_removed", self, "_on_speed_effect_removed")



# INVIS RELATED


func _construct_invis_effect_g():
	invis_effect = EnemyInvisibilityEffect.new(_invis_duration, StoreOfEnemyEffectsUUID.GRANDMASTER_INVIS_EFFECT)
	invis_effect.is_from_enemy = true



func _on_health_invis_threshold_reached(curr_health):
	if curr_health / _last_calculated_max_health <= _invis_health_ratio_threshold:
		disconnect("on_current_health_changed", self, "_on_health_invis_threshold_reached")
		if distance_to_exit > 50:
			_become_invisible()

func _become_invisible():
	connect("effect_removed", self, "_on_invis_effect_removed")
	_add_effect(invis_effect)
	_is_invis = true


func _on_invis_effect_removed(effect_removed, me):
	if effect_removed.effect_uuid == StoreOfEnemyEffectsUUID.GRANDMASTER_INVIS_EFFECT:
		_is_invis = false
		disconnect("effect_removed", self, "_on_invis_effect_removed")


func _physics_process(delta):
	if _is_invis and distance_to_exit <= 50:
		_remove_effect(invis_effect)


# SHIELD RELATED

func _construct_shield_effect():
	var shield_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.GRANDMASTER_SHIELD_EFFECT)
	shield_modi.percent_amount = _shield_ratio
	shield_modi.percent_based_on = PercentType.MAX
	
	shield_effect = EnemyShieldEffect.new(shield_modi, StoreOfEnemyEffectsUUID.GRANDMASTER_SHIELD_EFFECT)
	shield_effect.time_in_seconds = 2
	shield_effect.is_timebound = true
	shield_effect.is_from_enemy = true