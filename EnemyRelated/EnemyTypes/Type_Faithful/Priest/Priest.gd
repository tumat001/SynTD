extends "res://EnemyRelated/EnemyTypes/Type_Faithful/AbstractFaithfulEnemy.gd"

const invul_cooldown : float = 14.0      #12.0
const invul_base_duration : float = 1.75    #2.0
#const invul_no_movement_duration : float = 1.5

const no_diety_in_range_clause : int = -10

var invul_ability : BaseAbility
var invul_activation_clause : ConditionalClauses

var invul_effect : EnemyInvulnerabilityEffect

var movement_timer : Timer

#

var _diety_beam_active : bool
const invul_beam_color := Color(218/255.0, 164/255.0, 2/255.0, 0.5)

var _pos_for_invul_beam_start__W : Vector2
var _pos_for_invul_beam_start__E : Vector2

var _pos_for_invul_beam_to_use : Vector2

#

onready var pos_2d_for_invul_beam_start = $SpriteLayer/KnockUpLayer/InvulBeamPosition2D

#

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.PRIEST))


func _ready():
	_construct_and_connect_ability()
	_construct_effect()
	
	movement_timer = Timer.new()
	movement_timer.one_shot = true
	add_child(movement_timer)
	movement_timer.connect("timeout", self, "_movement_timer_timeout")
	
	_pos_for_invul_beam_start__W = pos_2d_for_invul_beam_start.position
	_pos_for_invul_beam_start__E = Vector2(-pos_2d_for_invul_beam_start.position.x, pos_2d_for_invul_beam_start.position.y)
	
	connect("anim_name_used_changed", self, "_on_anim_name_used_changed_p")

#

func _construct_effect():
	invul_effect = EnemyInvulnerabilityEffect.new(StoreOfEnemyEffectsUUID.PRIEST_INVUL_EFFECT, invul_base_duration)
	invul_effect.is_from_enemy = true

func _construct_and_connect_ability():
	invul_ability = BaseAbility.new()
	
	invul_ability.is_timebound = true
	invul_ability._time_current_cooldown = invul_cooldown / 2
	invul_ability.connect("updated_is_ready_for_activation", self, "_invul_ready_for_activation_updated")
	
	invul_activation_clause = invul_ability.activation_conditional_clauses
	invul_activation_clause.attempt_insert_clause(no_diety_in_range_clause)
	
	register_ability(invul_ability)


func _invul_ready_for_activation_updated(is_ready):
	if is_ready:
		call_deferred("_give_invul_to_diety")

func _give_invul_to_diety():
	if is_instance_valid(deity):
		invul_ability.on_ability_before_cast_start(invul_cooldown)
		
		var copy_of_effect = invul_effect._get_copy_scaled_by(invul_ability.get_potency_to_use(last_calculated_final_ability_potency))
		deity._add_effect__use_provided_effect(copy_of_effect)
		
		no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
		#movement_timer.start(invul_no_movement_duration)
		movement_timer.start(copy_of_effect.time_in_seconds)
		_create_invul_beam_to_diety()
		
		invul_ability.start_time_cooldown(invul_cooldown)
		
		invul_ability.on_ability_after_cast_ended(invul_cooldown)
	else:
		invul_ability.start_time_cooldown(2) # refresh


func _movement_timer_timeout():
	no_movement_from_self_clauses.remove_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
	_destroy_invul_deam_to_diety()

#

func on_self_enter_deity_range(deity):
	.on_self_enter_deity_range(deity)
	invul_activation_clause.remove_clause(no_diety_in_range_clause)


func on_self_leave_deity_range(deity):
	.on_self_leave_deity_range(deity)
	invul_activation_clause.attempt_insert_clause(no_diety_in_range_clause)
	

func on_deity_tree_exiting():
	.on_deity_tree_exiting()
	invul_activation_clause.attempt_insert_clause(no_diety_in_range_clause)
	
	_destroy_invul_deam_to_diety()

#

func _create_invul_beam_to_diety():
	_diety_beam_active = true
	

func _destroy_invul_deam_to_diety():
	_diety_beam_active = false
	update()


func _process(delta):
	if _diety_beam_active:
		update()

func _draw():
	if _diety_beam_active:
		draw_line(_pos_for_invul_beam_to_use, deity.get_offset_modifiers() + deity.global_position - global_position, invul_beam_color, 4)
		


#

func _on_anim_name_used_changed_p(arg_prev_name, arg_curr_name):
	if arg_prev_name != arg_curr_name:
		if arg_curr_name == "W":
			_pos_for_invul_beam_to_use = _pos_for_invul_beam_start__W
			
		elif arg_curr_name == "E":
			_pos_for_invul_beam_to_use = _pos_for_invul_beam_start__E
			
		
		update()

