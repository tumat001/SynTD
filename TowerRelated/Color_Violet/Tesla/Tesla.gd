extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

const Tesla_Bolt_01 = preload("res://TowerRelated/Color_Violet/Tesla/Tesla_Bolt_01.png")
const Tesla_Bolt_02 = preload("res://TowerRelated/Color_Violet/Tesla/Tesla_Bolt_02.png")
const Tesla_Bolt_03 = preload("res://TowerRelated/Color_Violet/Tesla/Tesla_Bolt_03.png")

const Tesla_Hit_Particle = preload("res://TowerRelated/Color_Violet/Tesla/TeslaHitParticle.tscn")


const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")

const Jolt_Particle_Pic_01 = preload("res://TowerRelated/Color_Violet/Tesla/OtherAssets/Tesla_Jolt_01.png")
const Jolt_AttackModuleIcon = preload("res://TowerRelated/Color_Violet/Tesla/OtherAssets/Tesla_Jolt_AttackModuleIcon.png")
const OrbitIncrease_Pic = preload("res://TowerRelated/Color_Violet/Tesla/GUI/GUIAssets/Tesla_IncreaseOrbitRadius_Icon.png")
const OrbitDecrease_Pic = preload("res://TowerRelated/Color_Violet/Tesla/GUI/GUIAssets/Tesla_DecreaseOrbitRadius_Icon.png")
const OrbitChangeRotPic = preload("res://TowerRelated/Color_Violet/Tesla/GUI/GUIAssets/Tesla_ChangeOrbitRotation_Icon.png")

const TeslaJoltPathFollow2D = preload("res://TowerRelated/Color_Violet/Tesla/TeslaJoltPathFollow2D.gd")
const TeslaJoltPathFollow2D_Scene = preload("res://TowerRelated/Color_Violet/Tesla/TeslaJoltPathFollow2D.tscn")

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")


signal on_offset_to_add(arg_val)

#

const stun_duration : float = 0.25
var tesla_main_attack_module : AbstractAttackModule

const energy_module_on_count_of_main_attk : int = 2

#

const jolt_flat_damage : float = 2.0

const base_jolt_orbit_speed_per_sec : float = 100.0
var current_jolt_orbit_speed_per_sec : float

var jolt_aoe_attack_module : AOEAttackModule

var amp_up_ability : BaseAbility
var amp_up_is_ready : bool
const base_amp_up_cooldown : float = 5.0

const stack_count_gain_per_main_attk : int = 1
const stack_count_gain_per_main_attk_against_stunned : int = 2
const stack_count_needed_for_cast : int = 20
var current_stack_count : int

const orbit_circle_slice : int = 120 # increase value to increase steepness of curve
const starting_orbit_radius : int = 80
const orbit_radius_minimum : int = 70
var current_orbit_radius : int = starting_orbit_radius


const ORBIT_CANNOT_INCREASE_CLAUSE : int = -10
const ORBIT_CANNOT_DECREASE_CLAUSE : int = -11

const orbit_incre_decre_amount_per_cast : float = 10.0
var orbit_increase_radius_ability : BaseAbility
var orbit_increase_activation_condi_clause : ConditionalClauses

var orbit_decrease_radius_ability : BaseAbility
var orbit_decrease_activation_condi_clause : ConditionalClauses

var orbit_change_rotation_ability : BaseAbility
var orbit_change_rotation_condi_clause : ConditionalClauses
var current_orbit_rotation : int = 1 # 1 (clockwise) or -1 (counter)
const orbit_change_rotation_base_description = [
	"Toggles orbit direction.",
	"",
]

const trail_color : Color = Color(78.0/255.0, 187.0/255.0, 253.0/255.0, 0.7)
var multiple_trail_component : MultipleTrailsForNodeComponent


#


onready var tesla_orbit_path = $TeslaOrbitPath


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.TESLA)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 40
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 40
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.attack_sprite_scene = Tesla_Hit_Particle
	attack_module.attack_sprite_follow_enemy = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Tesla_Bolt_01)
	beam_sprite_frame.add_frame("default", Tesla_Bolt_02)
	beam_sprite_frame.add_frame("default", Tesla_Bolt_03)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.2
	
	add_attack_module(attack_module)
	
	tesla_main_attack_module = attack_module
	
	#
	
	jolt_aoe_attack_module = AOEAttackModule_Scene.instance()
	jolt_aoe_attack_module.base_damage = jolt_flat_damage
	jolt_aoe_attack_module.base_damage_type = DamageType.ELEMENTAL
	jolt_aoe_attack_module.base_attack_speed = 0
	jolt_aoe_attack_module.base_attack_wind_up = 0
	jolt_aoe_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	jolt_aoe_attack_module.is_main_attack = false
	jolt_aoe_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	jolt_aoe_attack_module.benefits_from_bonus_explosion_scale = true
	jolt_aoe_attack_module.benefits_from_bonus_base_damage = false
	jolt_aoe_attack_module.benefits_from_bonus_attack_speed = false
	jolt_aoe_attack_module.benefits_from_bonus_on_hit_damage = false
	jolt_aoe_attack_module.benefits_from_bonus_on_hit_effect = true
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Jolt_Particle_Pic_01)
	
	jolt_aoe_attack_module.aoe_sprite_frames = sprite_frames
	jolt_aoe_attack_module.sprite_frames_only_play_once = false
	jolt_aoe_attack_module.pierce = -1
	jolt_aoe_attack_module.duration = 1
	jolt_aoe_attack_module.damage_repeat_count = 1
	jolt_aoe_attack_module.is_decrease_duration = false
	
	jolt_aoe_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	jolt_aoe_attack_module.base_aoe_scene = BaseAOE_Scene
	jolt_aoe_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	jolt_aoe_attack_module.can_be_commanded_by_tower = false
	
	jolt_aoe_attack_module.set_image_as_tracker_image(Jolt_AttackModuleIcon)
	
	add_attack_module(jolt_aoe_attack_module)

	
	#
	
	_construct_and_register_abilities()
	
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_module_enemy_hit_t", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_t", [], CONNECT_PERSIST)
	connect("final_ability_potency_changed", self, "_on_last_calculated_ap_changed", [], CONNECT_PERSIST)
	connect("final_range_changed", self, "_on_final_range_changed_t", [], CONNECT_PERSIST)
	
	
	multiple_trail_component = MultipleTrailsForNodeComponent.new()
	multiple_trail_component.node_to_host_trails = self
	multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	
	
	#
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	var enemy_effect : EnemyStunEffect = EnemyStunEffect.new(stun_duration, StoreOfEnemyEffectsUUID.TESLA_STUN)
	var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.TESLA_STUN)
	
	add_tower_effect(tower_effect)
	
	#
	
	_update_orbit_speed()
	
	_initialize_orbit_curve()
	_update_orbit_curve()


# energy module related

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Tesla's main attack now attacks up to %s enemies." % str(energy_module_on_count_of_main_attk)
		]


func _module_turned_on(_first_time_per_round : bool):
	main_attack_module.number_of_unique_targets = energy_module_on_count_of_main_attk
	
	if !is_connected("attack_module_added", self, "_attack_module_attached"):
		connect("attack_module_added", self, "_attack_module_attached")
		connect("attack_module_removed", self, "_attack_module_detached")


func _module_turned_off():
	main_attack_module.number_of_unique_targets = 1
	
	if is_connected("attack_module_added", self, "_attack_module_attached"):
		disconnect("attack_module_added", self, "_attack_module_attached")
		disconnect("attack_module_removed", self, "_attack_module_detached")



func _attack_module_detached(attack_module : AbstractAttackModule):
	if energy_module != null:
		if attack_module == tesla_main_attack_module:
			tesla_main_attack_module.number_of_unique_targets = 1

func _attack_module_attached(attack_module : AbstractAttackModule):
	if attack_module == main_attack_module:
		if energy_module != null and energy_module.is_turned_on:
			main_attack_module.number_of_unique_targets = energy_module_on_count_of_main_attk
		else:
			main_attack_module.number_of_unique_targets = 1


######

func _construct_and_register_abilities():
	amp_up_ability = BaseAbility.new()
	
	amp_up_ability.is_timebound = true
	
	amp_up_ability.set_properties_to_usual_tower_based()
	amp_up_ability.tower = self
	
	amp_up_ability.connect("updated_is_ready_for_activation", self, "_can_cast_amp_up_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(amp_up_ability, false)
	
	###
	
	orbit_increase_radius_ability = BaseAbility.new()
	
	orbit_increase_radius_ability.is_timebound = true
	orbit_increase_radius_ability.connect("ability_activated", self, "_on_orbit_radius_increase_activated", [], CONNECT_PERSIST)
	orbit_increase_radius_ability.icon = OrbitIncrease_Pic
	
	orbit_increase_radius_ability.set_properties_to_usual_tower_based()
	orbit_increase_radius_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	orbit_increase_radius_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	orbit_increase_radius_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	orbit_increase_radius_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	orbit_increase_activation_condi_clause = orbit_increase_radius_ability.activation_conditional_clauses
	
	orbit_increase_activation_condi_clause.blacklisted_clauses.erase(BaseAbility.ActivationClauses.ROUND_ONGOING_STATE)
	
	orbit_increase_radius_ability.tower = self
	
	orbit_increase_radius_ability.descriptions = [
		"Increases the orbit radius of the summoned Amps.",
		"Max orbit radius is equal to Tesla's range."
	]
	orbit_increase_radius_ability.display_name = "Increase Orbit Radius"
	
	register_ability_to_manager(orbit_increase_radius_ability, false)
	
	#
	
	orbit_decrease_radius_ability = BaseAbility.new()
	
	orbit_decrease_radius_ability.is_timebound = true
	orbit_decrease_radius_ability.connect("ability_activated", self, "_on_orbit_radius_decrease_activated", [], CONNECT_PERSIST)
	orbit_decrease_radius_ability.icon = OrbitDecrease_Pic
	
	orbit_decrease_radius_ability.set_properties_to_usual_tower_based()
	orbit_decrease_radius_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	orbit_decrease_radius_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	orbit_decrease_radius_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	orbit_decrease_radius_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	orbit_decrease_activation_condi_clause = orbit_decrease_radius_ability.activation_conditional_clauses
	
	orbit_decrease_activation_condi_clause.blacklisted_clauses.erase(BaseAbility.ActivationClauses.ROUND_ONGOING_STATE)
	
	orbit_decrease_radius_ability.tower = self
	
	orbit_decrease_radius_ability.descriptions = [
		"Decreases the orbit radius of the summoned Amps.",
		"Minimum orbit radius is %s units away from Tesla." % str(orbit_radius_minimum)
	]
	orbit_decrease_radius_ability.display_name = "Decrease Orbit Radius"
	
	register_ability_to_manager(orbit_decrease_radius_ability, false)
	
	###
	
	
	orbit_change_rotation_ability = BaseAbility.new()
	
	orbit_change_rotation_ability.is_timebound = true
	orbit_change_rotation_ability.connect("ability_activated", self, "_on_orbit_change_orbit_activated", [], CONNECT_PERSIST)
	orbit_change_rotation_ability.icon = OrbitChangeRotPic
	
	orbit_change_rotation_ability.set_properties_to_usual_tower_based()
	orbit_change_rotation_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	orbit_change_rotation_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	orbit_change_rotation_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	orbit_change_rotation_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	orbit_change_rotation_condi_clause = orbit_change_rotation_ability.activation_conditional_clauses
	
	orbit_change_rotation_condi_clause.blacklisted_clauses.erase(BaseAbility.ActivationClauses.ROUND_ONGOING_STATE)
	
	orbit_change_rotation_ability.tower = self
	
	orbit_change_rotation_ability.display_name = "Toggle Orbit Direction"
	
	register_ability_to_manager(orbit_change_rotation_ability, false)
	
	_update_change_orbit_description()


func _can_cast_amp_up_updated(is_ready):
	amp_up_is_ready = is_ready
	
	_attempt_cast_amp_up()


func _on_main_attack_module_enemy_hit_t(enemy, damage_register_id, damage_instance, module):
	if amp_up_is_ready:
		if enemy._is_stunned:
			add_amp_up_stacks(stack_count_gain_per_main_attk_against_stunned)
		else:
			add_amp_up_stacks(stack_count_gain_per_main_attk)


func add_amp_up_stacks(arg_amount : int):
	current_stack_count += arg_amount
	
	_attempt_cast_amp_up()

func set_amp_up_stacks(arg_val : int):
	current_stack_count = arg_val
	
	_attempt_cast_amp_up()


func _attempt_cast_amp_up():
	if amp_up_is_ready and current_stack_count >= stack_count_needed_for_cast:
		_cast_amp_up()

func _cast_amp_up():
	current_stack_count = 0
	var cd = _get_cd_to_use(base_amp_up_cooldown)
	amp_up_ability.on_ability_before_cast_start(cd)
	amp_up_ability.start_time_cooldown(cd)
	
	_summon_jolt_aoe_in_orbit()
	
	amp_up_ability.on_ability_after_cast_ended(cd)


####

func _summon_jolt_aoe_in_orbit():
	var pos = Vector2(0, 0)
	var jolt_aoe = jolt_aoe_attack_module.construct_aoe(pos, pos)
	var jolt_path_follow_2D = TeslaJoltPathFollow2D_Scene.instance()
	
	jolt_path_follow_2D.add_child(jolt_aoe)
	jolt_path_follow_2D.set_tower_to_orbit(self)
	
	jolt_path_follow_2D.modulate.a = 0.7
	
	tesla_orbit_path.add_child(jolt_path_follow_2D)
	jolt_path_follow_2D.unit_offset = _get_unit_offset_for_summon_new_jolt()
	connect("on_offset_to_add", jolt_path_follow_2D, "_on_offset_to_add")
	
	multiple_trail_component.create_trail_for_node(jolt_path_follow_2D)


func _get_unit_offset_for_summon_new_jolt() -> float:
	if get_jolt_count() == 1:
		return 0.0
		
	#elif get_jolt_count() == 2:
	#	return get_opposite_unit_offset_of_only_jolt()
	else:
		var all_unit_offsets = _get_unit_offsets_of_all_jolts()
		var all_normalized_offsets = _get_unit_offsets_as_normalized(all_unit_offsets)
		
		return _get_candidate_unit_offset_for_spawn(all_normalized_offsets)


func get_jolt_count() -> int:
	return tesla_orbit_path.get_child_count()

#func get_opposite_unit_offset_of_only_jolt() -> float:
#	var unit_off = tesla_orbit_path.get_children()[0].unit_offset
#	return abs(unit_off - 0.5)


func _get_unit_offsets_of_all_jolts():
	var unit_offsets : Array = []
	for jolt in tesla_orbit_path.get_children():
		unit_offsets.append(jolt.unit_offset)
	
	return unit_offsets

func _get_unit_offsets_as_normalized(arg_unit_offsets : Array) -> Array:
	var copy = arg_unit_offsets.duplicate()
	copy.sort()
	
	return copy


func _get_candidate_unit_offset_for_spawn(arg_normalized_unit_offsets : Array):
	var left_distances_bucket : Array = []

	for i in arg_normalized_unit_offsets.size():
		var left_dist = _get_unit_distance_from_nearest_left(i, arg_normalized_unit_offsets)
		
		left_distances_bucket.append(left_dist)
	
	var highest_left_dist = _get_highest_unit_distance_from_arr(left_distances_bucket)
	
	var index_of_HLD = left_distances_bucket.find(highest_left_dist)
	
	var unit_offset_of_HLD = arg_normalized_unit_offsets[index_of_HLD]
	
	
	return unit_offset_of_HLD - (highest_left_dist / 2.0)
	


func _get_unit_distance_from_nearest_left(arg_index_of_reference : int, arg_normalized_unit_offsets : Array) -> float:
	var index_of_left = arg_index_of_reference - 1
	var dist_from_left = 0
	var modi = 0
	if index_of_left < 0:
		index_of_left = arg_normalized_unit_offsets.size() - 1
		#dist_from_left = -1
		modi = 1
	
	dist_from_left += abs(arg_normalized_unit_offsets[arg_index_of_reference] - arg_normalized_unit_offsets[index_of_left] + modi)
	return dist_from_left


func _get_highest_unit_distance_from_arr(arg_distances : Array):
	return arg_distances.max()


#

func _on_last_calculated_ap_changed():
	_update_orbit_speed()

func _update_orbit_speed():
	current_jolt_orbit_speed_per_sec = base_jolt_orbit_speed_per_sec * amp_up_ability.get_potency_to_use(last_calculated_final_ability_potency)
	


#

func _initialize_orbit_curve():
	var curve := Curve2D.new()
	for i in orbit_circle_slice:
		curve.add_point(_get_point_pos_using_current_orbit_radius_and_index(i))
	
	tesla_orbit_path.curve = curve

func _update_orbit_curve():
	var curve : Curve2D = tesla_orbit_path.curve
	for i in orbit_circle_slice:
		curve.set_point_position(i, _get_point_pos_using_current_orbit_radius_and_index(i))
	
	update() # calls draw
	
	
	_update_orbit_radius_conditional_clauses()

func _get_point_pos_using_current_orbit_radius_and_index(arg_index) -> Vector2:
	return Vector2(current_orbit_radius, 0).rotated(2 * PI * arg_index / orbit_circle_slice)


func _update_orbit_radius_conditional_clauses():
	if _get_final_range_of_self_for_orbit() <= current_orbit_radius:
		orbit_increase_activation_condi_clause.attempt_insert_clause(ORBIT_CANNOT_INCREASE_CLAUSE)
	else:
		orbit_increase_activation_condi_clause.remove_clause(ORBIT_CANNOT_INCREASE_CLAUSE)
	
	if current_orbit_radius <= orbit_radius_minimum:
		orbit_decrease_activation_condi_clause.attempt_insert_clause(ORBIT_CANNOT_DECREASE_CLAUSE)
	else:
		orbit_decrease_activation_condi_clause.remove_clause(ORBIT_CANNOT_DECREASE_CLAUSE)

func _get_final_range_of_self_for_orbit() -> float:
	if is_instance_valid(range_module):
		return range_module.last_calculated_final_range
	else:
		return float(orbit_radius_minimum)


#

func _process(delta):
	emit_signal("on_offset_to_add", current_jolt_orbit_speed_per_sec * delta * current_orbit_rotation)


func _on_round_end_t():
	set_amp_up_stacks(0)
	
	for jolt in tesla_orbit_path.get_children():
		jolt.queue_free()
	



func toggle_module_ranges():
	.toggle_module_ranges()
	
	update() # calls draw


func _draw():
	if is_showing_ranges:
		draw_circle_arc(Vector2(0, 0), current_orbit_radius, 0, 360, Color(0, 0, 1, 0.5))

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 2)


#

func _on_final_range_changed_t():
	var final_range = _get_final_range_of_self_for_orbit()
	
	if final_range < current_orbit_radius:
		_set_current_orbit_radius(final_range)
	
	_update_orbit_radius_conditional_clauses()



func _on_orbit_radius_increase_activated():
	_increase_orbit_by_amount()

func _on_orbit_radius_decrease_activated():
	_decrease_orbit_by_amount()


func _increase_orbit_by_amount(arg_val : float = orbit_incre_decre_amount_per_cast):
	var tentative_val = current_orbit_radius + arg_val
	var curr_range = _get_final_range_of_self_for_orbit()
	if tentative_val > curr_range:
		tentative_val = curr_range
	
	_set_current_orbit_radius(tentative_val)

func _decrease_orbit_by_amount(arg_val : float = orbit_incre_decre_amount_per_cast):
	var tentative_val = current_orbit_radius - arg_val
	if tentative_val < orbit_radius_minimum:
		tentative_val = orbit_radius_minimum
	
	_set_current_orbit_radius(tentative_val)


func _set_current_orbit_radius(arg_val : float):
	var old_radius = current_orbit_radius
	
	current_orbit_radius = arg_val
	
	if old_radius != current_orbit_radius:
		_update_orbit_curve()


##

func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = 10
	arg_trail.trail_color = trail_color
	arg_trail.width = 4
	


##

func _on_orbit_change_orbit_activated():
	current_orbit_rotation *= -1
	
	_update_change_orbit_description()

func _update_change_orbit_description():
	var curr_orbit_name : String
	if current_orbit_rotation == 1:
		curr_orbit_name = "clockwise"
	else:
		curr_orbit_name = "counter clockwise"
	
	var desc_copy = orbit_change_rotation_base_description.duplicate()
	desc_copy.append("Current orbit direction: %s" % curr_orbit_name)
	
	orbit_change_rotation_ability.set_descriptions(desc_copy)
