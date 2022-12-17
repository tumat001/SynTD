extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")
const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

const Wyvern_NormalProj = preload("res://TowerRelated/Color_Red/Wyvern/Assets/Wyvern_NormalProj.png")
const Wyvern_SuperProj = preload("res://TowerRelated/Color_Red/Wyvern/Assets/Wyvern_EmpProj.png")
const Wyvern_MarkPic = preload("res://TowerRelated/Color_Red/Wyvern/Assets/Wyvern_LockOnPic.png")
const Wyvern_EmpProj_AMI = preload("res://TowerRelated/Color_Red/Wyvern/Assets/AMI/Wyvern_EmpProj_AMI.png")

signal on_current_fury_changed(new_fury_val)


var fury_ability : BaseAbility
var fury_ability_activation_clause : ConditionalClauses
var can_cast_fury_ability : bool
const fury_base_cooldown : float = 18.0
const fury_initial_cooldown : float = 10.0
const no_enemies_in_range_clause : int = -10
const fury_is_active_clause : int = -11

var _is_in_fury : bool

const fury_base_dmg_ratio : float = 3.5
const fury_on_hit_dmg_ratio : float = 4.5
const fury_final_dmg_multiplier_against_bosses : float = 0.75

var _attk_module_disabled_by_fury_clause : AbstractAttackModule

const not_in_fury_condi_clause : int = -11
var empowered_proj_attk_module : BulletAttackModule

var _current_fury_locked_on_target
var mark_indicator

const fury_bonus_attk_speed_amount_base_amount : float = 100.0
var fury_attk_speed_effect : TowerAttributesEffect
  

const trail_color : Color = Color(217/255.0, 0, 0, 0.75)
const base_trail_length : int = 14
var _current_trail_length : int = base_trail_length

const base_trail_width : int = 4
var _current_trail_width : int = base_trail_width

var trail_for_emp_proj_component : MultipleTrailsForNodeComponent

const beam_to_target_color : Color = Color(1, 0, 0, 0.75)
const beam_to_target_width : int = 2
#var _should_show_beam : bool

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.WYVERN)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift_of_attk_module : float = 10.0
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += y_shift_of_attk_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 740 #670
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= y_shift_of_attk_module
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 4)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Wyvern_NormalProj)
	
	add_attack_module(attack_module)
	
	_construct_empowered_proj_attk_module(y_shift_of_attk_module, info)
	_construct_mark_indicator()
	_construct_fury_ability()
	_construct_attk_speed_effect()
	
	
	trail_for_emp_proj_component = MultipleTrailsForNodeComponent.new()
	trail_for_emp_proj_component.node_to_host_trails = self
	trail_for_emp_proj_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	trail_for_emp_proj_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	
	
	#
	
	connect("on_round_end", self, "_on_round_end_w", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_entered", self, "_on_enemies_entered_range_module", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_on_enemies_exited_range_module", [], CONNECT_PERSIST)
	
	connect("on_tower_no_health", self, "_on_tower_no_health_w", [], CONNECT_PERSIST)
	
	_post_inherit_ready()

#

func _construct_empowered_proj_attk_module(y_shift_of_attk_module, info):
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = 0
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 800 #770
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = fury_on_hit_dmg_ratio
	attack_module.position.y -= y_shift_of_attk_module
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 4)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Wyvern_SuperProj)
	
	attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(not_in_fury_condi_clause)
	attack_module.set_image_as_tracker_image(Wyvern_EmpProj_AMI)
	
	configure_self_to_change_direction_on_attack_module_when_commanded(attack_module)
	
	add_attack_module(attack_module)
	
	empowered_proj_attk_module = attack_module
	
	empowered_proj_attk_module.connect("on_damage_instance_constructed", self, "_on_dmg_instance_constructed__of_emp_proj", [], CONNECT_PERSIST)
	empowered_proj_attk_module.connect("before_bullet_is_shot", self, "_before_bullet_is_shot__of_emp_proj", [], CONNECT_PERSIST)
	empowered_proj_attk_module.connect("on_enemy_hit", self, "_on_emp_attk_module_bullet_hit_enemy", [], CONNECT_PERSIST)

func _on_dmg_instance_constructed__of_emp_proj(arg_dmg_instance, arg_module):
	arg_dmg_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE].damage_as_modifier.flat_modifier = get_last_calculated_base_damage_of_main_attk_module() * fury_base_dmg_ratio

func _before_bullet_is_shot__of_emp_proj(arg_bullet):
	trail_for_emp_proj_component.create_trail_for_node(arg_bullet)
	arg_bullet.life_distance = empowered_proj_attk_module.global_position.distance_to(_current_fury_locked_on_target.global_position) + BulletAttackModule.get_life_distance_bonus_allowance()

func _on_emp_attk_module_bullet_hit_enemy(enemy, damage_register_id, damage_instance, arg_module):
	if enemy.is_enemy_type_boss():
		damage_instance.final_damage_multiplier *= fury_final_dmg_multiplier_against_bosses


func _construct_fury_ability():
	fury_ability = BaseAbility.new()
	
	fury_ability.is_timebound = true
	
	fury_ability.set_properties_to_usual_tower_based()
	fury_ability.tower = self
	
	fury_ability.connect("updated_is_ready_for_activation", self, "_can_cast_fury_changed", [], CONNECT_PERSIST)
	register_ability_to_manager(fury_ability, false)
	
	fury_ability.start_time_cooldown(_get_cd_to_use(fury_initial_cooldown))


func _construct_mark_indicator():
	mark_indicator = AttackSprite_Scene.instance()
	mark_indicator.visible = false
	
	mark_indicator.frames = SpriteFrames.new()
	mark_indicator.frames.add_frame("default", Wyvern_MarkPic)
	
	mark_indicator.has_lifetime = false
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(mark_indicator)


func _construct_attk_speed_effect():
	var modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.WYVERN_SELF_ATTK_SPEED_EFFECT)
	modi.percent_amount = fury_bonus_attk_speed_amount_base_amount
	modi.percent_based_on = PercentType.BASE
	
	fury_attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, modi, StoreOfTowerEffectsUUID.WYVERN_SELF_ATTK_SPEED_EFFECT)
	fury_attk_speed_effect.is_timebound = false
	fury_attk_speed_effect.is_roundbound = true
	fury_attk_speed_effect.round_count = 1
	fury_attk_speed_effect.status_bar_icon = preload("res://TowerRelated/Color_Red/Wyvern/Assets/Wyvern_AttkSpeed_StatusBarIcon.png")


#

func _can_cast_fury_changed(arg_val):
	can_cast_fury_ability = arg_val
	_attempt_cast_fury()


func _on_enemies_entered_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		fury_ability.activation_conditional_clauses.remove_clause(no_enemies_in_range_clause)
		
		if !enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives", [], CONNECT_DEFERRED)

func _on_enemy_killed_with_no_more_revives(damage_instance_report, arg_enemy):
	_on_enemies_exited_range_module(arg_enemy, null, range_module)


func _on_enemies_exited_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		if range_module.get_enemy_in_range_count() == 0:
			fury_ability.activation_conditional_clauses.attempt_insert_clause(no_enemies_in_range_clause)
		
		if enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.disconnect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives")



func _attempt_cast_fury():
	if can_cast_fury_ability:
		_cast_fury()

func _cast_fury():
	var target = _get_candidate_target()
	
	if is_instance_valid(target):
		_set_fury_mode(true)
		_current_fury_locked_on_target = target
		
		_disable_current_main_attk_module()
		_lock_onto_target_as_fury_target(target)
		
		add_tower_effect(fury_attk_speed_effect._get_copy_scaled_by(fury_ability.get_potency_to_use(last_calculated_final_ability_potency)))
		if !empowered_proj_attk_module.is_connected("ready_to_attack", self, "_on_emp_proj_ready_to_attack"):
			empowered_proj_attk_module.connect("ready_to_attack", self, "_on_emp_proj_ready_to_attack")
		empowered_proj_attk_module.on_command_attack_enemies([target])
		
		
		fury_ability.activation_conditional_clauses.attempt_insert_clause(fury_is_active_clause)
		
		call_deferred("_set_marker_visible_status", true)

func _set_marker_visible_status(arg_visible):
	mark_indicator.visible = arg_visible
	#_should_show_beam = arg_visible
	
	if !arg_visible:
		update()

func _get_candidate_target():
	if is_instance_valid(range_module):
		var candidates = range_module.get_targets_without_affecting_self_current_targets(1, Targeting.HEALTHIEST, false)
		if candidates.size() > 0:
			return candidates[0]
	
	return null

#

func _set_fury_mode(arg_is_on : bool):
	_is_in_fury = arg_is_on

func _disable_current_main_attk_module():
	if !is_instance_valid(_attk_module_disabled_by_fury_clause):
		_attk_module_disabled_by_fury_clause = main_attack_module
		_attk_module_disabled_by_fury_clause.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.WYVERN_DISABLE)

func _reenable_disabled_attk_module():
	if is_instance_valid(_attk_module_disabled_by_fury_clause):
		_attk_module_disabled_by_fury_clause.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.WYVERN_DISABLE)
		_attk_module_disabled_by_fury_clause = null

#

func _lock_onto_target_as_fury_target(arg_target):
	_current_fury_locked_on_target = arg_target
	
	if !arg_target.is_connected("cancel_all_lockons", self, "_on_target_cancel_lock_ons"):
		arg_target.connect("cancel_all_lockons", self, "_on_target_cancel_lock_ons")
	
	if !arg_target.is_connected("on_killed_by_damage", self, "_on_target_killed"):
		arg_target.connect("on_killed_by_damage", self, "_on_target_killed")

func _on_target_killed(damage_instance_report, arg_enemy):
	_end_fury_mode()

func _on_target_cancel_lock_ons():
	_end_fury_mode()


func _end_fury_mode():
	_set_fury_mode(false)
	
	if is_instance_valid(_current_fury_locked_on_target):
		if _current_fury_locked_on_target.is_connected("cancel_all_lockons", self, "_on_target_cancel_lock_ons"):
			_current_fury_locked_on_target.disconnect("cancel_all_lockons", self, "_on_target_cancel_lock_ons")
		
		if _current_fury_locked_on_target.is_connected("on_killed_by_damage", self, "_on_target_killed"):
			_current_fury_locked_on_target.disconnect("on_killed_by_damage", self, "_on_target_killed")
	
	_current_fury_locked_on_target = null
	call_deferred("_set_marker_visible_status", false)
	
	#
	var attk_speed_effect = get_tower_effect(StoreOfTowerEffectsUUID.WYVERN_SELF_ATTK_SPEED_EFFECT)
	if attk_speed_effect != null:
		remove_tower_effect(attk_speed_effect)
	
	if fury_ability.activation_conditional_clauses.has_clause(fury_is_active_clause):
		var cd = _get_cd_to_use(fury_base_cooldown)
		fury_ability.on_ability_before_cast_start(cd)
		fury_ability.start_time_cooldown(cd)
		fury_ability.on_ability_after_cast_ended(cd)
		fury_ability.activation_conditional_clauses.remove_clause(fury_is_active_clause)
	
	_reenable_disabled_attk_module()

#

func _on_emp_proj_ready_to_attack():
	if !_is_in_fury or !is_instance_valid(_current_fury_locked_on_target):
		if empowered_proj_attk_module.is_connected("ready_to_attack", self, "_on_emp_proj_ready_to_attack"):
			empowered_proj_attk_module.disconnect("ready_to_attack", self, "_on_emp_proj_ready_to_attack")
	else:
		empowered_proj_attk_module.on_command_attack_enemies([_current_fury_locked_on_target])

#

func _on_round_end_w():
	_end_fury_mode()

#

func _process(delta):
	if is_instance_valid(_current_fury_locked_on_target):
		mark_indicator.global_position = _current_fury_locked_on_target.global_position
		update()

func _draw():
	if is_instance_valid(_current_fury_locked_on_target) and !is_dead_for_the_round:
		draw_line(empowered_proj_attk_module.global_position - global_position, _current_fury_locked_on_target.global_position - global_position, beam_to_target_color, beam_to_target_width)


#

func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = _current_trail_length
	arg_trail.trail_color = trail_color
	arg_trail.width = _current_trail_width

#

func queue_free():
	if is_instance_valid(mark_indicator) and !mark_indicator.is_queued_for_deletion():
		mark_indicator.queue_free()
	
	.queue_free()

#

func _on_tower_no_health_w():
	_set_marker_visible_status(false)

# HeatModule

func set_heat_module(module):
	module.heat_per_attack = 1
	.set_heat_module(module)

func _construct_heat_effect():
	var base_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_attr_mod.percent_amount = 50
	base_attr_mod.percent_based_on = PercentType.BASE
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED , base_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module.benefits_from_bonus_attack_speed:
			module.calculate_all_speed_related_attributes()
	
	emit_signal("final_attack_speed_changed")


