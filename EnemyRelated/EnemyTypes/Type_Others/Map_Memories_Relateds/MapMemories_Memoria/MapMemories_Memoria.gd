extends "res://EnemyRelated/AbstractEnemy.gd"



var dmg_instance_count_taken_before_invis : int
var invis_duration : float

var _current_dmg_instance_count_taken_before_invis : int


var _is_invis : bool

var invis_ability : BaseAbility


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA))
	

##

func configure_memoria_properties(arg_dmg_instance_count_taken_before_invis, arg_invis_duration):
	dmg_instance_count_taken_before_invis = arg_dmg_instance_count_taken_before_invis
	invis_duration = arg_invis_duration
	
	_current_dmg_instance_count_taken_before_invis = dmg_instance_count_taken_before_invis
	
	connect("on_post_mitigated_damage_taken", self, "_on_post_mitigated_damage_taken_m")
	



func _ready():
	_construct_and_connect_ability()


func _construct_and_connect_ability():
	invis_ability = BaseAbility.new()
	
	invis_ability.is_timebound = false
	
	register_ability(invis_ability)

######


func _on_post_mitigated_damage_taken_m(damage_instance_report, is_lethal, me):
	if !is_lethal:
		_current_dmg_instance_count_taken_before_invis -= 1
		
		_attempt_cast_invis_ability()

func _attempt_cast_invis_ability():
	if _current_dmg_instance_count_taken_before_invis <= 0:
		_cast_invis_ability()
		


func _cast_invis_ability():
	if invis_ability.is_ready_for_activation():
		invis_ability.on_ability_before_cast_start(invis_ability.ON_ABILITY_CAST_NO_COOLDOWN)
		
		_current_dmg_instance_count_taken_before_invis = dmg_instance_count_taken_before_invis
		_generate_and_add_invis_effect_d()
		
		invis_ability.on_ability_after_cast_ended(invis_ability.ON_ABILITY_CAST_NO_COOLDOWN)


func _generate_and_add_invis_effect_d():
	var duration = invis_duration
	duration *= invis_ability.get_potency_to_use(last_calculated_final_ability_potency)
	
	var invis_effect = EnemyInvisibilityEffect.new(duration, StoreOfEnemyEffectsUUID.MAP_MEMORIES__ENEMY_MEMORIA__INVIS_EFFECT)
	invis_effect.is_from_enemy = true
	
	
	_add_effect__use_provided_effect(invis_effect)
	
	return invis_effect




