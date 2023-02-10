extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Bounded_Proj_Normal_Pic = preload("res://TowerRelated/Color_Violet/Bounded/Assets/Proj/Bounded_MainProj_DarkBlue.png")
const Bounded_Proj_Glowing_Pic = preload("res://TowerRelated/Color_Violet/Bounded/Assets/Proj/Bounded_MainProj_LightBlue.png")

const Bounded_Omni_Normal = preload("res://TowerRelated/Color_Violet/Bounded/Bounded_Omni.png")
const Bounded_Omni_Unbounded = preload("res://TowerRelated/Color_Violet/Bounded/Bounded_Omni_Unbounded.png")

#const SummonBeam_Pic = preload("res://TowerRelated/Color_Violet/Bounded/Assets/SummonBeam/Bounded_SummonBeam.png")
#const BeamStretchAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
#const BeamStretchAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")


const ValTransition = preload("res://MiscRelated/ValTransitionRelated/ValTransition.gd")


signal lifetime_as_clone_end__by_any_means()


#

# these vals must be set before _ready() is called
var is_a_clone : bool 
var clone_basis  # the creator
var current_clone_duration : float

#

var is_unbounded : bool setget set_is_unbounded

var original_main_attk_module : BulletAttackModule

#

var val_transition_for_chains_mod_a : ValTransition
var is_transitioning_val_chains_mod_a : bool

#var summon_beam : BeamStretchAesthetic

#

const summon_beam_color := Color(56/255.0, 1/255.0, 111/255.0, 0.6)
var is_drawing_beam : bool

var val_transition_for_beam_length : ValTransition
var target_pos : Vector2
var source_pos : Vector2

#

var unbound_ability : BaseAbility
const unbound_base_cooldown : float = 18.0
const unbound_base_clone_duration : float = 12.0

const unbound_is_clone_active_activation_clause : int = -10

var unbound_ability_is_ready : bool

#

var _atomic_placable
var _atomic_cd

#

onready var chains_left = $TowerBase/KnockUpLayer/ChainsLeft
onready var chains_right = $TowerBase/KnockUpLayer/ChainsRight

onready var beam_draw_layer = $TowerBase/KnockUpLayer/BeamDrawLayer

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BOUNDED)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift_of_attack_module : float = 9
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += y_shift_of_attack_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 520
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.base_proj_inaccuracy = 12
	attack_module.position.y -= y_shift_of_attack_module
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(6, 6)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	original_main_attk_module = attack_module
	
	add_attack_module(attack_module)
	
	#
	
	original_main_attk_module.connect("before_bullet_is_shot", self, "_on_before_bullet_is_shot__original_attk_module", [], CONNECT_PERSIST)
	
	val_transition_for_chains_mod_a = ValTransition.new()
	
	#
	
	if !is_a_clone:
		_construct_abilities()
		_connect_ability_relevant_signals()
		
		#set_is_unbounded(false)
		
		val_transition_for_beam_length = ValTransition.new()
		
		beam_draw_layer.color = summon_beam_color
		beam_draw_layer.width = 5
		
		connect("global_position_changed", self, "_on_global_position_changed_b", [], CONNECT_PERSIST)
		
	else:
		
		set_contribute_to_synergy_color_count(false)
		#contributing_to_synergy_clauses.attempt_insert_clause(ContributingToSynergyClauses.BOUNDED_CLONE)
		tower_limit_slots_taken = 0
		is_a_summoned_tower = true
		
		can_be_sold_conditonal_clauses.attempt_insert_clause(CanBeSoldClauses.VIO_TOWER__BOUNDED_CLONE)
		can_be_used_as_ingredient_conditonal_clauses.attempt_insert_clause(CanAbsorbIngredientClauses.CAN_NOT_ABSORB_INGREDIENT_GENERIC_TAG)
		set_tower_base_modulate(TowerModulateIds.BOUNDED_CLONE, Color(1, 1, 1, 0.8))
		
		set_base_gold_cost(0)
		_configure_self_to_match_clone_basis_relevant_properties()
		
		#set_is_unbounded(true)
		chains_left.visible = false
		chains_right.visible = false
	
	#
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	if !is_a_clone:
		set_is_unbounded(false)
	else:
		set_is_unbounded(true)


func _on_before_bullet_is_shot__original_attk_module(bullet):
	if is_unbounded:
		bullet.set_texture_as_sprite_frames(Bounded_Proj_Glowing_Pic)
	else:
		bullet.set_texture_as_sprite_frames(Bounded_Proj_Normal_Pic)

#

func set_is_unbounded(arg_val):
	is_unbounded = arg_val
	
	var is_done_with_transition = false
	
	var texture_to_use : Texture
	if is_unbounded:
		texture_to_use = Bounded_Omni_Unbounded
		is_done_with_transition = val_transition_for_chains_mod_a.configure_self(chains_left.modulate.a, chains_left.modulate.a, 0, ValTransition.VALUE_UNSET, -2, ValTransition.ValueIncrementMode.LINEAR)
	else:
		texture_to_use = Bounded_Omni_Normal
		is_done_with_transition = val_transition_for_chains_mod_a.configure_self(chains_left.modulate.a, chains_left.modulate.a, 1, ValTransition.VALUE_UNSET, 2, ValTransition.ValueIncrementMode.LINEAR)
	
	tower_base_sprites.frames.set_frame(AnimFaceDirComponent.dir_omni_name, 0, texture_to_use)
	#anim_face_dir_component.set_animation_sprite_animation_using_anim_name(tower_base_sprites, AnimFaceDirComponent.dir_omni_name)
	_change_animation_to_face_angle(0)  # param does not matter
	
	#chains_left.visible = !arg_val
	#chains_right.visible = !arg_val
	
	if !is_done_with_transition:
		is_transitioning_val_chains_mod_a = true
	

func _configure_self_to_match_clone_basis_relevant_properties():
	for ing_effect in clone_basis.ingredients_absorbed.values():
		var ing_effect_copy = ing_effect.get_copy__deep_or_shallow()
		
		if ing_effect_copy != null:
			absorb_ingredient(ing_effect_copy, 0, false)


################

func _construct_abilities():
	unbound_ability = BaseAbility.new()
	
	unbound_ability.is_timebound = true
	
	unbound_ability.set_properties_to_usual_tower_based()
	unbound_ability.tower = self
	
	unbound_ability.connect("updated_is_ready_for_activation", self, "_can_cast_unbound_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(unbound_ability, false)

func _can_cast_unbound_updated(arg_val):
	unbound_ability_is_ready = arg_val


func _connect_ability_relevant_signals():
	connect("on_main_post_mitigation_damage_dealt", self, "_on_main_post_mitigated_dmg_dealt", [], CONNECT_PERSIST)


func _on_main_post_mitigated_dmg_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	if !killed and unbound_ability_is_ready and !is_drawing_beam:
		var placable_to_create_clone = _get_candidate_placable_for_clone(enemy.global_position)
		
		if placable_to_create_clone != null:
			var cd = _get_cd_to_use(unbound_base_cooldown)
			unbound_ability.on_ability_before_cast_start(cd)
			
			_start_create_clone_at_placable(placable_to_create_clone, cd)
			
			unbound_ability.activation_conditional_clauses.attempt_insert_clause(unbound_is_clone_active_activation_clause)
			
			#
			
			set_is_unbounded(true)

func _get_candidate_placable_for_clone(arg_enemy_pos : Vector2):
	var map_manager_var = game_elements.map_manager
	var placables = map_manager_var.get_all_placables_in_range(arg_enemy_pos, get_last_calculated_range_of_main_attk_module(), map_manager_var.PlacableState.UNOCCUPIED)
	
	if placables.size() > 0:
		return placables[0]
	else:
		return null

func _start_create_clone_at_placable(arg_placable, arg_cd):
	_atomic_placable = arg_placable
	_atomic_cd = arg_cd
	
	
	target_pos = arg_placable.global_position
	source_pos = global_position
	
	var target_beam_length = source_pos.distance_to(target_pos)
	val_transition_for_beam_length.configure_self(0, 0, target_beam_length, 0.45, ValTransition.VALUE_UNSET, ValTransition.ValueIncrementMode.LINEAR)
	
	is_drawing_beam = true


func _create_clone_at_placable(arg_placable, arg_cd):
	var clone = tower_inventory_bench.create_tower(Towers.BOUNDED, arg_placable)
	
	clone.is_a_clone = true
	clone.clone_basis = self
	clone.current_clone_duration = unbound_base_clone_duration * unbound_ability.get_potency_to_use(last_calculated_final_ability_potency)
	
	clone.connect("lifetime_as_clone_end__by_any_means", self, "_on_clone_lifetime_as_clone_end__by_any_means", [clone, arg_cd], CONNECT_ONESHOT)
	clone.connect("global_position_changed", self, "_on_clone_global_position_changed_b", [], CONNECT_PERSIST)
	
	#tower_inventory_bench.add_tower_to_scene(clone, false)
	tower_inventory_bench.call_deferred("add_tower_to_scene", clone, false)


#

func _on_clone_lifetime_as_clone_end__by_any_means(arg_clone, arg_cd):
	#arg_clone.can_be_sold_conditonal_clauses.remove_clause(CanBeSoldClauses.VIO_TOWER__BOUNDED_CLONE)
	arg_clone.force_sell_tower()
	
	unbound_ability.start_time_cooldown(arg_cd)
	unbound_ability.on_ability_after_cast_ended(arg_cd)
	
	unbound_ability.activation_conditional_clauses.remove_clause(unbound_is_clone_active_activation_clause)
	
	set_is_unbounded(false)
	
	#beam_draw_layer.show_beam = false
	#_update_beam_draw_layer()
	_break_showing_beam()

####


func _process(delta):
	if is_a_clone and is_round_started:
		current_clone_duration -= delta
		if current_clone_duration <= 0:
			emit_signal("lifetime_as_clone_end__by_any_means")
	
	if is_transitioning_val_chains_mod_a:
		var reached_target = val_transition_for_chains_mod_a.delta_pass(delta)
		if reached_target:
			is_transitioning_val_chains_mod_a = false
		
		var curr_val = val_transition_for_chains_mod_a.get_current_val()
		chains_left.modulate.a = curr_val
		chains_right.modulate.a = curr_val
	
	if is_drawing_beam:
		var reached_target = val_transition_for_beam_length.delta_pass(delta)
		if reached_target:
			_create_clone_at_placable(_atomic_placable, _atomic_cd)
			is_drawing_beam = false
		
		beam_draw_layer.show_beam = true
		_update_beam_draw_layer()

func _update_beam_draw_layer():
	var final_dist = val_transition_for_beam_length.get_current_val()
	var final_pos = source_pos.move_toward(target_pos, final_dist)
	
	#draw_line(source_pos, final_pos, summon_beam_color, 5)
	beam_draw_layer.source_pos = source_pos
	beam_draw_layer.dest_pos = final_pos
	beam_draw_layer.update_draw()

####

func _on_global_position_changed_b(arg_old_pos, arg_new_pos):
	_break_showing_beam()

func _on_clone_global_position_changed_b(arg_old_pos, arg_new_pos):
	_break_showing_beam()


func _break_showing_beam():
	beam_draw_layer.show_beam = false
	_update_beam_draw_layer()
	
	is_drawing_beam = false


