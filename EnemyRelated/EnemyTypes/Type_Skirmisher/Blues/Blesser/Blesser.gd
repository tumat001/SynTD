extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"

const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const Blesser_HealBeam_Scene = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Blesser/Subs/Blesser_HealBeam.tscn")
const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")


const _heal_range : float = 60.0
var range_module : RangeModule
var targeting_option : int = Targeting.PERCENT_EXECUTE

const _health_ratio_threshold : float = 0.8   # for activation

#
var _healing_activated : bool = false

var _current_heal_target

var heal_ability : BaseAbility
var heal_activation_clause : ConditionalClauses
var heal_effect : EnemyHealEffect

const _heal_amount : float = 0.5
const _heal_cooldown : float = 0.25

const _empowered_heal_amount : float = 5.0
const _empowered_heal_duration : float = 1.3 #1.1
const _empowered_heal_target_health_threshold : float = 0.25

var _empowered_heal_curr_duration : float
var _empowered_heal_casted : bool = false
var _is_heal_empowered : bool

var _delta_before_next_heal_tick : float = _heal_cooldown

#

var _can_heal_target__is_ability_ready : bool

#

var _heal_beam : BeamAesthetic

#

var staff_w_position := Vector2(-9, -7)
var staff_e_position := Vector2(8, -7)
onready var staff_position2d = $SpriteLayer/KnockUpLayer/StaffCenterPos

#

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.BLESSER))
	
	is_blue_and_benefits_from_ap = true

func _ready():
	range_module = RangeModule_Scene.instance()
	range_module.can_display_range = false
	range_module.base_range_radius = _heal_range
	range_module.set_range_shape(CircleShape2D.new())
	
	range_module.clear_all_targeting()
	range_module.add_targeting_option(targeting_option)
	range_module.set_current_targeting(targeting_option)
	
	range_module.connect("enemy_entered_range", self, "_enemy_entered_range_b")
	range_module.connect("enemy_left_range", self, "_enemy_exited_range_b")
	
	add_child(range_module)
	range_module.update_range()
	
	#
	
	_heal_beam = Blesser_HealBeam_Scene.instance()
	
	CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(_heal_beam)
	
	#
	
	_construct_heal_effect()
	_construct_and_connect_ability()
	
	_swap_heal_to_normal()
	
	#
	
	connect("on_current_health_changed", self, "_on_curr_health_changed")
	connect("anim_name_used_changed", self, "_on_anim_name_used_changed_c")
	connect("final_ability_potency_changed", self, "_on_final_ap_changed_b")
	
	connect("tree_exiting", self, "_on_tree_exiting_b")

func _on_finished_ready_prep():
	staff_w_position = get_position_added_pos_and_offset_modifiers(staff_w_position)
	staff_e_position = get_position_added_pos_and_offset_modifiers(staff_e_position)


#

func _enemy_entered_range_b(enemy):
	if _healing_activated and !is_instance_valid(_current_heal_target):
		_assign_heal_target_to_target_in_range()

func _enemy_exited_range_b(enemy):
	if _healing_activated and enemy == _current_heal_target and is_instance_valid(enemy):
		_untarget_current_heal_target_and_find_new()

###

func _on_curr_health_changed(curr_health):
	if curr_health / _last_calculated_max_health <= _health_ratio_threshold:
		disconnect("on_current_health_changed", self, "_on_curr_health_changed")
		
		_healing_activated = true
		_assign_heal_target_to_target_in_range()

#

func _assign_heal_target_to_target_in_range():
	var target = _get_target_valid_for_assignment()
	
	if is_instance_valid(target):
		_assign_target_as_heal_target(target)


func _get_target_valid_for_assignment():
	var targets = range_module.get_targets_without_affecting_self_current_targets(2)
	for target in targets:
		if target != self:
			return target
	
	return null

func _assign_target_as_heal_target(arg_target):
	_current_heal_target = arg_target
	
	if !_current_heal_target.is_connected("cancel_all_lockons", self, "_on_heal_target_cancel_all_lockons"):
		_current_heal_target.connect("cancel_all_lockons", self, "_on_heal_target_cancel_all_lockons")
	
	if !_empowered_heal_casted:
		if !_current_heal_target.is_connected("on_current_health_changed", self, "_on_heal_target_curr_health_changed"):
			_current_heal_target.connect("on_current_health_changed", self, "_on_heal_target_curr_health_changed")
	
	
	#
	
	set_physics_process(true)

func _on_heal_target_cancel_all_lockons():
	_untarget_current_heal_target_and_find_new()

func _untarget_current_heal_target_and_find_new():
	if is_instance_valid(_current_heal_target):
		if _current_heal_target.is_connected("cancel_all_lockons", self, "_on_heal_target_cancel_all_lockons"):
			_current_heal_target.disconnect("cancel_all_lockons", self, "_on_heal_target_cancel_all_lockons")
		
		if _current_heal_target.is_connected("on_current_health_changed", self, "_on_heal_target_curr_health_changed"):
			_current_heal_target.disconnect("on_current_health_changed", self, "_on_heal_target_curr_health_changed")
	
	
	_current_heal_target = null
	_heal_beam.visible = false
	set_physics_process(false)
	
	_assign_heal_target_to_target_in_range()


#############

func _construct_and_connect_ability():
	heal_ability = BaseAbility.new()
	
	heal_ability.is_timebound = true
	heal_ability._time_current_cooldown = _heal_cooldown
	heal_ability.connect("updated_is_ready_for_activation", self, "_heal_ready_for_activation_updated")
	
	register_ability(heal_ability)

func _construct_heal_effect():
	var heal_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.BLESSER_HEAL_EFFECT)
	
	heal_effect = EnemyHealEffect.new(heal_modi, StoreOfEnemyEffectsUUID.BLESSER_HEAL_EFFECT)
	heal_effect.is_from_enemy = true

#

func _heal_ready_for_activation_updated(arg_ready):
	_can_heal_target__is_ability_ready = arg_ready

func _check_and_swap_if_curr_heal_target_has_full_health():
	if is_equal_approx(_current_heal_target.current_health / _current_heal_target._last_calculated_max_health, 1):
		_assign_heal_target_to_target_in_range()


#

func _process(delta):
	_delta_before_next_heal_tick -= delta
	
	if _empowered_heal_curr_duration > 0:
		_empowered_heal_curr_duration -= delta
		
		if _empowered_heal_curr_duration <= 0:
			_swap_heal_to_normal()
	
	if _delta_before_next_heal_tick <= 0:
		_attempt_heal_current_heal_target()
		_delta_before_next_heal_tick += _heal_cooldown

func _attempt_heal_current_heal_target():
	if _can_heal_target__is_ability_ready and is_instance_valid(_current_heal_target):
		_current_heal_target._add_effect(heal_effect)
		
		_check_and_swap_if_curr_heal_target_has_full_health()


func _physics_process(delta):
	if is_instance_valid(_current_heal_target):
		_heal_beam.global_position = global_position + get_position_added_knockup_offset_modifiers(staff_position2d.position)
		_heal_beam.update_destination_position(_current_heal_target.get_position_added_knockup_offset_modifiers(_current_heal_target.global_position))
		
		_heal_beam.visible = true

#

func _on_heal_target_curr_health_changed(arg_curr_health):
	if !_empowered_heal_casted and is_instance_valid(_current_heal_target) and arg_curr_health / _current_heal_target._last_calculated_max_health <= _empowered_heal_target_health_threshold:
		_swap_heal_to_empowered()

#

func _swap_heal_to_empowered():
	_empowered_heal_casted = true
	_is_heal_empowered = true
	
	_empowered_heal_curr_duration = _empowered_heal_duration
	_heal_beam.play("empowered")
	
	_update_heal_amount()

func _swap_heal_to_normal():
	_is_heal_empowered = false
	_heal_beam.play("default")
	
	_update_heal_amount()


func _on_final_ap_changed_b(arg_potency):
	_update_heal_amount()

func _update_heal_amount():
	if _is_heal_empowered:
		heal_effect.heal_as_modifier.flat_modifier = _empowered_heal_amount * last_calculated_final_ability_potency
	else:
		heal_effect.heal_as_modifier.flat_modifier = _heal_amount * last_calculated_final_ability_potency

###############

func _on_tree_exiting_b():
	if is_instance_valid(_heal_beam):
		_heal_beam.visible = false
		_heal_beam.queue_free()
	

func _on_anim_name_used_changed_c(arg_prev_name, arg_curr_name):
	if arg_curr_name == "W":
		staff_position2d.position = staff_w_position
	elif arg_curr_name == "E":
		staff_position2d.position = staff_e_position


