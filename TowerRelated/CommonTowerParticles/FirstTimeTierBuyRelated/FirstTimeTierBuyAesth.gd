extends Node2D

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")
const FirstTimeTierBuyAesth_SingleRay = preload("res://TowerRelated/CommonTowerParticles/FirstTimeTierBuyRelated/Subs/FirstTimeTierBuyAesth_SingleRay.gd")

signal fully_invisible_and_done()

#

var all_fully_invisible_conditional_clauses : ConditionalClauses
var last_calculated_all_fully_invisible_and_done : bool = true

const shower_particle_compo_id : int = 0
var _next_id : int = 1


# SHOWER PARTICLE RELATED -- setted by a common source (ie: TowerManager) so that all of this kind of instance shares one pool
# expects a CenterBasedAttackSprite
var shower_particle_compo_pool setget set_shower_particle_compo_pool

var shower_particle_count : int
var _current_shower_particle_count : int

var shower_particle_delta : float
var _current_shower_particle_delta_left : float

var shower_particle_color : Color


var rng_to_use : RandomNumberGenerator

#

onready var main_single_ray : FirstTimeTierBuyAesth_SingleRay = $FirstTimeTierBuyAesth_SingleRay

var _all_components : Array

#

func _init():
	all_fully_invisible_conditional_clauses = ConditionalClauses.new()
	all_fully_invisible_conditional_clauses.connect("clause_inserted", self, "_on_all_fully_invisible_conditional_clauses_updated", [], CONNECT_PERSIST)
	all_fully_invisible_conditional_clauses.connect("clause_removed", self, "_on_all_fully_invisible_conditional_clauses_updated", [], CONNECT_PERSIST)
	_update_all_fully_invis_state()
	

func _on_all_fully_invisible_conditional_clauses_updated(arg_clause):
	_update_all_fully_invis_state()

func _update_all_fully_invis_state():
	var old_val = last_calculated_all_fully_invisible_and_done
	last_calculated_all_fully_invisible_and_done = all_fully_invisible_conditional_clauses.is_passed
	
	if old_val != last_calculated_all_fully_invisible_and_done and last_calculated_all_fully_invisible_and_done:
		emit_signal("fully_invisible_and_done")
		_end_display()

#

func _ready():
	_all_components.append(main_single_ray)
	
	#
	
	for component in _all_components:
		component.connect("fully_invisible_and_done", self, "_on_component_fully_invisible_and_done", [component], CONNECT_PERSIST)
		component.connect("started_display", self, "_on_component_started_display", [component], CONNECT_PERSIST)
		component.component_id = _next_id
		_next_id += 1
	
	#
	z_as_relative = false
	z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_TOWERS
	
	set_process(false)

##

func fully_reset():
	main_single_ray.end_display()
	
	

func _on_component_fully_invisible_and_done(arg_component):
	all_fully_invisible_conditional_clauses.remove_clause(arg_component.component_id)
	

func _on_component_started_display(arg_component):
	all_fully_invisible_conditional_clauses.attempt_insert_clause(arg_component.component_id)
	

##

func start_display():
	_current_shower_particle_delta_left = 0
	_current_shower_particle_count = shower_particle_count
	all_fully_invisible_conditional_clauses.attempt_insert_clause(shower_particle_compo_id)
	
	for compo in _all_components:
		compo.start_display()
	
	update()
	
	if shower_particle_compo_pool != null:
		set_process(true)

func _end_display():
	
	set_process(false)

##

func set_shower_particle_compo_pool(arg_pool):
	shower_particle_compo_pool = arg_pool
	

func _process(delta):
	_current_shower_particle_delta_left -= delta
	
	if _current_shower_particle_delta_left <= 0:
		_current_shower_particle_delta_left = shower_particle_delta
		_show_shower_particle__and_consume_stack()

func _show_shower_particle__and_consume_stack():
	_current_shower_particle_count -= 1
	#
	
	var particle = shower_particle_compo_pool.get_or_create_attack_sprite_from_pool()
	#particle.global_position = main_single_ray.relative_pos_of_ray_start
	particle.min_starting_angle = rad2deg(main_single_ray.angle_of_rel_pos_to_bottom_right)
	particle.max_starting_angle = rad2deg(main_single_ray.angle_of_rel_pos_to_bottom_left)
	
	particle.initial_speed_towards_center = rng_to_use.randf_range(-190, -220)
	particle.speed_accel_towards_center = 150
	particle.center_pos_of_basis = global_position + main_single_ray.relative_pos_of_ray_start
	
	particle.lifetime = 1.0
	
	particle.modulate = shower_particle_color
	particle.visible = true
	
	particle.is_enabled_mov_toward_center = true
	
	particle.reset_for_another_use()
	
	#
	if _current_shower_particle_count <= 0:
		all_fully_invisible_conditional_clauses.remove_clause(shower_particle_compo_id)
		set_process(false)



