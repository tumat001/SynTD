extends "res://EnemyRelated/AbstractEnemy.gd"


const _health_ratio_threshold : float = 0.5
const _starting_boost_amount : float = 100.0
const _decrease_rate_of_boost_per_sec : float = 80.0
const _boost_duration : float = 1.3

var speed_bonus_modi : FlatModifier
var speed_bonus_effect : EnemyAttributesEffect
var _is_dashing : bool = false

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.DASH))


func _ready():
	connect("on_current_health_changed", self, "_on_health_threshold_reached")
	
	_construct_effect_d()

func _construct_effect_d():
	speed_bonus_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.DASH_SPEED_BOOST)
	speed_bonus_modi.flat_modifier = _starting_boost_amount
	
	speed_bonus_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_MOV_SPEED, speed_bonus_modi, StoreOfEnemyEffectsUUID.DASH_SPEED_BOOST)
	speed_bonus_effect.respect_scale = false
	speed_bonus_effect.is_timebound = true
	speed_bonus_effect.time_in_seconds = _boost_duration


#

func _on_health_threshold_reached(curr_health):
	if curr_health / _last_calculated_max_health <= _health_ratio_threshold:
		disconnect("on_current_health_changed", self, "_on_health_threshold_reached")
		_perform_dash()


func _perform_dash():
	connect("effect_added", self, "_speed_effect_added")
	_add_effect(speed_bonus_effect)
	connect("effect_removed", self, "_on_speed_effect_removed")
	_is_dashing = true


func _process(delta):
	if _is_dashing:
		speed_bonus_modi.flat_modifier -= _decrease_rate_of_boost_per_sec * delta
		calculate_final_movement_speed()

#

func _speed_effect_added(effect_added, me):
	if effect_added.effect_uuid == StoreOfEnemyEffectsUUID.DASH_SPEED_BOOST:
		speed_bonus_modi = effect_added.attribute_as_modifier
		disconnect("effect_added", self, "_speed_effect_added")


func _on_speed_effect_removed(effect_removed, me):
	if effect_removed.effect_uuid == StoreOfEnemyEffectsUUID.DASH_SPEED_BOOST:
		_is_dashing = false
		disconnect("effect_removed", self, "_on_speed_effect_removed")
