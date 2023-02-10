extends "res://TowerRelated/AbstractTower.gd"



const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Biomorph_NormalProj_Boosted = preload("res://TowerRelated/Color_Violet/BioMorph/Assets/Biomorph_NormalProj_Boosted.png")
const Biomorph_NormalProj_Unboosted = preload("res://TowerRelated/Color_Violet/BioMorph/Assets/Biomorph_NormalProj_Unboosted.png")
const Biomorph_Beam_Pic = preload("res://TowerRelated/Color_Violet/BioMorph/Assets/Biomorph_Beam.png")

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")
#const TimerForTower_Scene = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")


#

const boost_health_cost : int = 3  # make it int for simplicity's sake
const boosted_bonus_dmg_amount : float = 2.0
const boosted_bonus_dmg_dmg_type : int = DamageType.ELEMENTAL

#var boost_dmg_modifier : FlatModifier
var boost_on_hit_dmg_effect : TowerOnHitDamageAdderEffect

var boost_multiple_trail_component : MultipleTrailsForNodeComponent
const trail_color : Color = Color(217/255.0, 2/255.0, 167/255.0, 0.65)
const base_trail_length : int = 6
const base_trail_width : int = 2

var boost_health_suck_timer : Timer
var _suck_remaining : int

#

const not_enough_health_for_drain_clause : int = -10
const laser_for_drain_is_active_clause : int = -11

const drain_ability_health_cost : int = 3

var drain_ability : BaseAbility
var drain_ability_activation_clause : ConditionalClauses

#

const laser_base_dmg_amount : float = 0.35
const laser_base_dmg_scale : float = 0.25

var laser_duration : float = 30.0
var laser_timer : TimerForTower

const laser_deactivated_can_be_commanded_clause : int = -10

var _is_laser_active : bool

var laser_attack_module : WithBeamInstantDamageAttackModule

#

var _y_shift_of_attack_module : float = 20
var _y_shift_of_laser_attk_module : float = 32

var _is_boosted : bool

var non_essential_rng : RandomNumberGenerator

#

onready var laser_frame = $TowerBase/KnockUpLayer/LaserFrame

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BIOMORPH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += _y_shift_of_attack_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 550
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.base_proj_inaccuracy = 0
	attack_module.position.y -= _y_shift_of_attack_module
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	#attack_module.set_texture_as_sprite_frame(SprinklerBullet_pic)
	
	attack_module.connect("before_bullet_is_shot", self, "_on_orig_attk_module_before_bullet_is_shot", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	#
	
	
	laser_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	laser_attack_module.base_damage_scale = laser_base_dmg_scale
	laser_attack_module.base_damage = laser_base_dmg_amount / laser_attack_module.base_damage_scale
	laser_attack_module.base_damage_type = DamageType.ELEMENTAL
	laser_attack_module.base_attack_speed = 4
	laser_attack_module.base_attack_wind_up = 0
	laser_attack_module.is_main_attack = false
	laser_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	laser_attack_module.position.y -= _y_shift_of_laser_attk_module
	laser_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	laser_attack_module.on_hit_damage_scale = 0
	
	laser_attack_module.benefits_from_bonus_on_hit_damage = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Biomorph_Beam_Pic)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	laser_attack_module.beam_scene = BeamAesthetic_Scene
	laser_attack_module.beam_sprite_frames = beam_sprite_frame
	
	laser_attack_module.set_image_as_tracker_image(Biomorph_Beam_Pic)
	
	laser_attack_module.connect("on_damage_instance_constructed", self, "_on_laser_damage_instance_constructed", [], CONNECT_PERSIST)
	
	add_attack_module(laser_attack_module)
	
	
	#
	
	_construct_miscs()
	_construct_effects()
	_construct_trails_components()
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	connect("on_main_bullet_attack_module_after_bullet_is_shot", self, "_on_main_bullet_attack_module_after_bullet_is_shot_b", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_on_round_start_b", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_b", [], CONNECT_PERSIST)
	
	
	_construct_and_connect_ability()
	_update_drain_castable_based_on_player_health()
	
	_deactivate_laser()
	
	#
	
	_post_inherit_ready()


func _construct_miscs():
	boost_health_suck_timer = Timer.new()
	boost_health_suck_timer.one_shot = false
	boost_health_suck_timer.connect("timeout", self, "_on_boost_health_suck_timer_timeout", [], CONNECT_PERSIST)
	add_child(boost_health_suck_timer)
	
	laser_timer = TimerForTower.new()
	laser_timer.one_shot = true
	laser_timer.connect("timeout", self, "_on_laser_timer_timeout", [], CONNECT_PERSIST)
	laser_timer.set_tower_and_properties(self)
	laser_timer.stop_on_round_end_instead_of_pause = false
	add_child(laser_timer)

func _construct_effects():
	var dmg_modifier = FlatModifier.new(StoreOfTowerEffectsUUID.BIOMORPH_ON_HIT_DMG_BOOST)
	dmg_modifier.flat_modifier = boosted_bonus_dmg_amount
	
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.BIOMORPH_ON_HIT_DMG_BOOST, dmg_modifier, boosted_bonus_dmg_dmg_type)
	
	boost_on_hit_dmg_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.BIOMORPH_ON_HIT_DMG_BOOST)

func _construct_trails_components():
	boost_multiple_trail_component = MultipleTrailsForNodeComponent.new()
	boost_multiple_trail_component.node_to_host_trails = self
	boost_multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	boost_multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	

func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = base_trail_length
	arg_trail.trail_color = trail_color
	arg_trail.width = base_trail_width

#

func _on_orig_attk_module_before_bullet_is_shot(bullet):
	if _is_boosted:
		bullet.set_texture_as_sprite_frames(Biomorph_NormalProj_Boosted)
	else:
		bullet.set_texture_as_sprite_frames(Biomorph_NormalProj_Unboosted)

func _on_main_bullet_attack_module_after_bullet_is_shot_b(bullet, attack_module):
	if _is_boosted:
		boost_multiple_trail_component.create_trail_for_node(bullet)
	

##

func _on_round_start_b():
	if is_current_placable_in_map():
		if game_elements.health_manager.current_health > boost_health_cost:
			_is_boosted = true
			add_tower_effect(boost_on_hit_dmg_effect)
			
			_perform_health_suck_process(boost_health_cost)

func _perform_health_suck_process(arg_amount):
	_suck_remaining += arg_amount
	_suck_one_player_health()
	
	if _suck_remaining > 0:
		boost_health_suck_timer.start(0.22)

func _on_boost_health_suck_timer_timeout():
	_suck_one_player_health()

func _suck_one_player_health():
	_suck_remaining -= 1
	game_elements.health_manager.create_player_health_damage_particle__with_diff_dest_pos(global_position + Vector2(0, -_y_shift_of_attack_module), 1, game_elements.health_manager.DecreaseHealthSource.TOWER)
	
	if _suck_remaining <= 0:
		boost_health_suck_timer.stop()

func _on_round_end_b():
	if has_tower_effect_uuid_in_buff_map(boost_on_hit_dmg_effect.effect_uuid):
		_is_boosted = false
		remove_tower_effect(boost_on_hit_dmg_effect)
	

#########

func _on_player_health_changed_b(arg_val):
	_update_drain_castable_based_on_player_health()

func _update_drain_castable_based_on_player_health():
	if game_elements.health_manager.current_health > drain_ability_health_cost:
		drain_ability_activation_clause.remove_clause(not_enough_health_for_drain_clause)
	else:
		drain_ability_activation_clause.attempt_insert_clause(not_enough_health_for_drain_clause)

func _on_laser_timer_timeout():
	_deactivate_laser()


func _construct_and_connect_ability():
	drain_ability = BaseAbility.new()
	
	drain_ability.is_timebound = true
	drain_ability.connect("ability_activated", self, "_drain_ability_activated_b", [], CONNECT_PERSIST)
	drain_ability.icon = preload("res://TowerRelated/Color_Violet/BioMorph/Assets/Biomorph_AbilityIcon.png")
	
	drain_ability.set_properties_to_usual_tower_based()
	drain_ability.tower = self
	
	drain_ability.descriptions = tower_type_info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION]
	drain_ability.simple_descriptions = tower_type_info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION]
	
	drain_ability.display_name = "Drain"

	drain_ability_activation_clause = drain_ability.activation_conditional_clauses
	
	drain_ability.set_properties_to_auto_castable()
	drain_ability.auto_cast_func = "_drain_ability_activated_b"
	
	register_ability_to_manager(drain_ability)
	
	####
	
	game_elements.health_manager.connect("current_health_changed", self, "_on_player_health_changed_b", [], CONNECT_PERSIST)


func _drain_ability_activated_b():
	var cd = drain_ability._get_cd_to_use(BaseAbility.ON_ABILITY_CAST_NO_COOLDOWN)
	drain_ability.on_ability_before_cast_start(cd)
	
	drain_ability.start_time_cooldown(cd)
	_perform_health_suck_process(drain_ability_health_cost)
	
	_activate_laser()
	
	drain_ability.on_ability_after_cast_ended(cd)

func _activate_laser():
	_is_laser_active = true
	drain_ability_activation_clause.attempt_insert_clause(laser_for_drain_is_active_clause)
	
	laser_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01)
	
	laser_frame.visible = true
	laser_timer.start(laser_duration)

func _deactivate_laser():
	_is_laser_active = false
	drain_ability_activation_clause.remove_clause(laser_for_drain_is_active_clause)
	
	laser_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01)
	laser_attack_module.hide_all_beams()
	
	laser_frame.visible = false


func _on_laser_damage_instance_constructed(arg_dmg_instance, arg_attk_module):
	arg_dmg_instance.scale_only_damage_by(drain_ability.get_potency_to_use(last_calculated_final_ability_potency))

########

