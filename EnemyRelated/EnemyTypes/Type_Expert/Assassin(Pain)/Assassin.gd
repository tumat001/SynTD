extends "res://EnemyRelated/AbstractEnemy.gd"


const _invis_health_ratio_threshold : float = 0.75
const _invis_duration : float = 14.0
const _invis_premature_cancel_distance : float = 75.0

var invis_effect : EnemyInvisibilityEffect
var _is_invis : bool


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.ASSASSIN))


func _ready():
	connect("on_current_health_changed", self, "_on_health_threshold_reached")
	
	_construct_effect_d()

func _construct_effect_d():
	invis_effect = EnemyInvisibilityEffect.new(_invis_duration, StoreOfEnemyEffectsUUID.ASSASSIN_INVIS_EFFECT)

#

func _on_health_threshold_reached(curr_health):
	if curr_health / _last_calculated_max_health <= _invis_health_ratio_threshold:
		disconnect("on_current_health_changed", self, "_on_health_threshold_reached")
		if distance_to_exit > 50:
			_become_invisible()


func _become_invisible():
	connect("effect_removed", self, "_on_invis_effect_removed")
	_add_effect(invis_effect)
	_is_invis = true


func _on_invis_effect_removed(effect_removed, me):
	if effect_removed.effect_uuid == StoreOfEnemyEffectsUUID.ASSASSIN_INVIS_EFFECT:
		_is_invis = false
		disconnect("effect_removed", self, "_on_invis_effect_removed")


#

func _physics_process(delta):
	if _is_invis and distance_to_exit <= 50:
		_remove_effect(invis_effect)
