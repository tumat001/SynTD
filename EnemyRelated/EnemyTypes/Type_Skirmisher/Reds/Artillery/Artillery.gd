extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"



var artillery_ability : BaseAbility
const _artillery_cooldown : float = 18.0 #14.0
const _artillery_no_target_cooldown : float = 3.0


var skirmisher_gen_purpose_rng : RandomNumberGenerator

#var center_pos_of_map : Vector2

#

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.ARTILLERY))

func _ready():
	skirmisher_gen_purpose_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SKIRMISHER_GEN_PURPOSE)
	#center_pos_of_map = game_elements.get_middle_coordinates_of_playable_map()
	
	#
	
	_construct_and_connect_ability()

#

func _construct_and_connect_ability():
	artillery_ability = BaseAbility.new()
	
	artillery_ability.is_timebound = true
	artillery_ability._time_current_cooldown = get_random_cd(0, _artillery_cooldown / 8.0)
	artillery_ability.connect("updated_is_ready_for_activation", self, "_artillery_ready_for_activation_updated")
	
	register_ability(artillery_ability)

func _artillery_ready_for_activation_updated(arg_val):
	if arg_val:
		_cast_artillery_ability()

func _cast_artillery_ability():
	var target = get_target_for_artillery()
	
	if is_instance_valid(target):
		var placable = target.current_placable
		
		if is_instance_valid(placable):
			var cd = _artillery_cooldown
			artillery_ability.on_ability_before_cast_start(cd)
			
			skirmisher_faction_passive.request_artillery_bullet_to_shoot(self, global_position, placable.global_position, placable)
			
			artillery_ability.start_time_cooldown(cd)
			artillery_ability.on_ability_after_cast_ended(cd)
			
			return
	
	# else
	
	artillery_ability.start_time_cooldown(_artillery_no_target_cooldown)

##########

func get_target_for_artillery():
	return skirmisher_faction_passive.get_target_for_artillery()

