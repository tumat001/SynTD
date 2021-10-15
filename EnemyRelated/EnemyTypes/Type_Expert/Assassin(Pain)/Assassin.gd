extends "res://EnemyRelated/AbstractEnemy.gd"


const _invis_health_ratio_threshold : float = 0.33
const _invis_duration : float = 8.0
const _invis_premature_cancel_distance : float = 120.0

var invis_effect : EnemyInvisibilityEffect
var _is_invis : bool

var invis_ability : BaseAbility

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.ASSASSIN))


func _ready():
	connect("on_current_health_changed", self, "_on_health_threshold_reached")
	
	_construct_effect_d()
	_construct_and_connect_ability()

func _construct_effect_d():
	invis_effect = EnemyInvisibilityEffect.new(_invis_duration, StoreOfEnemyEffectsUUID.ASSASSIN_INVIS_EFFECT)
	invis_effect.is_from_enemy = true

func _construct_and_connect_ability():
	invis_ability = BaseAbility.new()
	
	invis_ability.is_timebound = false
	
	register_ability(invis_ability)


#

func _on_health_threshold_reached(curr_health):
	if curr_health / _last_calculated_max_health <= _invis_health_ratio_threshold:
		disconnect("on_current_health_changed", self, "_on_health_threshold_reached")
		if distance_to_exit > 50:
			_become_invisible()


func _become_invisible():
	invis_ability.on_ability_before_cast_start(invis_ability.ON_ABILITY_CAST_NO_COOLDOWN)
	
	connect("effect_removed", self, "_on_invis_effect_removed")
	
	var effect = _add_effect(invis_effect._get_copy_scaled_by(invis_ability.get_potency_to_use(last_calculated_final_ability_potency)))
	
	if effect != null:
		_is_invis = true
	else:
		disconnect("effect_removed", self, "_on_invis_effect_removed")
	
	invis_ability.on_ability_after_cast_ended(invis_ability.ON_ABILITY_CAST_NO_COOLDOWN)


func _on_invis_effect_removed(effect_removed, me):
	if effect_removed.effect_uuid == StoreOfEnemyEffectsUUID.ASSASSIN_INVIS_EFFECT:
		_is_invis = false
		disconnect("effect_removed", self, "_on_invis_effect_removed")


#

func _physics_process(delta):
	if _is_invis and distance_to_exit <= 50:
		_remove_effect(invis_effect)
