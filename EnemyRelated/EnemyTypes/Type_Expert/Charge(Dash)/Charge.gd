extends "res://EnemyRelated/AbstractEnemy.gd"


signal speed_boost_started()
signal speed_boost_ended()

const _health_ratio_threshold_01 : float = 0.75
const _health_ratio_threshold_02 : float = 0.25
const _starting_boost_amount : float = 100.0
const _decrease_rate_of_boost_per_sec : float = 80.0
const _boost_duration : float = 1.3

var speed_bonus_modi : FlatModifier
var speed_bonus_effect : EnemyAttributesEffect
var _is_dashing : bool = false

var dash_ability : BaseAbility


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.CHARGE))


func _ready():
	connect("on_current_health_changed", self, "_on_health_threshold_01_reached")
	connect("on_current_health_changed", self, "_on_health_threshold_02_reached")
	
	_construct_effect_d()
	_construct_and_connect_ability()

func _construct_effect_d():
	speed_bonus_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.CHARGE_SPEED_BOOST)
	speed_bonus_modi.flat_modifier = _starting_boost_amount
	
	speed_bonus_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_MOV_SPEED, speed_bonus_modi, StoreOfEnemyEffectsUUID.CHARGE_SPEED_BOOST)
	speed_bonus_effect.respect_scale = true
	speed_bonus_effect.is_timebound = true
	speed_bonus_effect.time_in_seconds = _boost_duration
	speed_bonus_effect.is_from_enemy = true

func _construct_and_connect_ability():
	dash_ability = BaseAbility.new()
	
	dash_ability.is_timebound = false
	
	register_ability(dash_ability)

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
		dash_ability.on_ability_before_cast_start(dash_ability.ON_ABILITY_CAST_NO_COOLDOWN)
		
		connect("effect_added", self, "_speed_effect_added")
		
		var effect = _add_effect(speed_bonus_effect._get_copy_scaled_by(last_calculated_final_ability_potency))
		
		if effect != null:
			connect("effect_removed", self, "_on_speed_effect_removed")
			_is_dashing = true
		else:
			disconnect("effect_added", self, "_speed_effect_added")
		
		dash_ability.on_ability_after_cast_ended(dash_ability.ON_ABILITY_CAST_NO_COOLDOWN)

func _process(delta):
	if _is_dashing:
		speed_bonus_modi.flat_modifier -= _decrease_rate_of_boost_per_sec * delta
		calculate_final_movement_speed()

#

func _speed_effect_added(effect_added, me):
	if effect_added.effect_uuid == StoreOfEnemyEffectsUUID.CHARGE_SPEED_BOOST:
		speed_bonus_modi = effect_added.attribute_as_modifier
		disconnect("effect_added", self, "_speed_effect_added")
		emit_signal("speed_boost_started")

func _on_speed_effect_removed(effect_removed, me):
	if effect_removed.effect_uuid == StoreOfEnemyEffectsUUID.CHARGE_SPEED_BOOST:
		_is_dashing = false
		disconnect("effect_removed", self, "_on_speed_effect_removed")
		emit_signal("speed_boost_ended")


