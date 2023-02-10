extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")
const ArcingBaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")


const MainAttackProj_Meteor_01 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/Meteors/Crowned_Meteor_01.png")
const MainAttackProj_Meteor_02 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/Meteors/Crowned_Meteor_02.png")
const MainAttackProj_Meteor_03 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/Meteors/Crowned_Meteor_03.png")

const MainAttackProj_Normal_01 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalProjs/Crowned_NormalProjs_01.png")
const MainAttackProj_Normal_02 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalProjs/Crowned_NormalProjs_02.png")
const MainAttackProj_Normal_03 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalProjs/Crowned_NormalProjs_03.png")

const Celestial_NormalExplosion_01 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_01.png")
const Celestial_NormalExplosion_02 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_02.png")
const Celestial_NormalExplosion_03 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_03.png")
const Celestial_NormalExplosion_04 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_04.png")
const Celestial_NormalExplosion_05 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_05.png")
const Celestial_NormalExplosion_06 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_06.png")
const Celestial_NormalExplosion_07 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_07.png")
const Celestial_NormalExplosion_08 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_08.png")
const Celestial_NormalExplosion_09 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_09.png")
const Celestial_NormalExplosion_10 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_10.png")
const Celestial_NormalExplosion_11 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_11.png")
const Celestial_NormalExplosion_12 = preload("res://TowerRelated/Color_Violet/Celestial/Assets/NormalExplosion/Crowned_NormalExplosion_12.png")

const Celestial_NormalExplosion_AMA = preload("res://TowerRelated/Color_Violet/Celestial/Assets/AMAssets/Coronal_NormalExplosion_AMA.png")
const Celestial_MeteorExplosion_AMA = preload("res://TowerRelated/Color_Violet/Celestial/Assets/AMAssets/Coronal_MeteorExplosion_AMA.png")

const Celestial_AOEDrawNode = preload("res://TowerRelated/Color_Violet/Celestial/Celestial_AOEDrawNode.gd")
const Celestial_LineDrawNode = preload("res://TowerRelated/Color_Violet/Celestial/Celestial_LineDrawNode.gd")

#

const normal_explosion_base_dmg : float = 6.0
const normal_explosion_base_dmg_scale : float = 3.0
const normal_explosion_on_hit_dmg_scale : float = 3.0
const meteor_explosion_scale_to_normal_dmg : float = 2.0
const meteor_larger_explosion_dmg_instance_dmg_multiplier : float = 0.75

const shot_count_for_meteor : int = 4
var _current_shot_count_left_for_meteor : int
var _next_shot_is_meteor : bool

var normal_explosion_attack_module : AOEAttackModule
var meteor_explosion_attack_module : AOEAttackModule

const meteor_explosion_lifetime : float = 1.1
const meteor_aoe_base_radius : float = 150.0
#const meteor_aoe_radius_per_sec_inc : float = meteor_aoe_final_radius / meteor_explosion_lifetime


#

var non_essential_rng : RandomNumberGenerator

#

const line_draw_color__main_shot := Color(217/255.0, 164/255.0, 2/255.0, 0.75)
const line_draw_color__meteor_side_main_shot := Color(217/255.0, 164/255.0, 2/255.0, 0.4)

const line_draw_color__meteor_sides_falling_shot := Color(127/255.0, 1/255.0, 146/255.0, 0.75)


const arc_shot_trail_color := Color(253/255.0, 43/255.0, 208/255.0, 0.75)
const arc_shot_non_meteor_trail_width : int = 3
const arc_shot_meteor_trail_width : int = 6

const arc_shot_non_meteor_trail_length : int = 10
const arc_shot_meteor_trail_length : int = 18

var arc_proj_multiple_trail_component : MultipleTrailsForNodeComponent

#

var meteor_ability : BaseAbility

#

var y_shift = 7

#

onready var aoe_draw_node = $AOEDrawNode
onready var line_draw_node = $LineDrawNode

##


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.CELESTIAL)
	
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
	range_module.position.y += y_shift
	
	#
	
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = info.base_damage_type
	proj_attack_module.base_damage_type = info.base_damage_type
	proj_attack_module.base_attack_speed = info.base_attk_speed
	proj_attack_module.base_attack_wind_up = 0
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = true
	proj_attack_module.base_pierce = info.base_pierce
	proj_attack_module.base_proj_speed = 2
	#attack_module.base_proj_life_distance = info.base_range
	proj_attack_module.module_id = StoreOfAttackModuleID.MAIN
	proj_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	
	proj_attack_module.position.y -= y_shift
	#var bullet_shape = CircleShape2D.new()
	#bullet_shape.radius = 3
	
	#proj_attack_module.bullet_shape = bullet_shape
	proj_attack_module.bullet_scene = ArcingBaseBullet_Scene
	#proj_attack_module.set_texture_as_sprite_frame(Volcano_Proj_Pic)
	
	proj_attack_module.max_height = 875
	proj_attack_module.bullet_rotation_per_second = 240
	
	proj_attack_module.connect("before_bullet_is_shot", self, "_on_before_bullet_is_shot_from_orig_main_attk_module", [], CONNECT_PERSIST)
	
	proj_attack_module.is_displayed_in_tracker = false
	
	add_attack_module(proj_attack_module)
	
	
	# PROJ EXPLOSION AOE
	
	normal_explosion_attack_module = AOEAttackModule_Scene.instance()
	normal_explosion_attack_module.base_damage_scale = normal_explosion_base_dmg_scale
	normal_explosion_attack_module.base_damage = normal_explosion_base_dmg / normal_explosion_attack_module.base_damage_scale
	normal_explosion_attack_module.base_damage_type = info.base_damage_type
	normal_explosion_attack_module.base_attack_speed = 0
	normal_explosion_attack_module.base_attack_wind_up = 0
	normal_explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	normal_explosion_attack_module.is_main_attack = false
	normal_explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	normal_explosion_attack_module.on_hit_damage_scale = normal_explosion_on_hit_dmg_scale
	
	normal_explosion_attack_module.benefits_from_bonus_explosion_scale = true
	normal_explosion_attack_module.benefits_from_bonus_base_damage = true
	normal_explosion_attack_module.benefits_from_bonus_attack_speed = false
	normal_explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	normal_explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Celestial_NormalExplosion_01)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_02)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_03)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_04)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_05)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_06)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_07)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_08)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_09)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_10)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_11)
	sprite_frames.add_frame("default", Celestial_NormalExplosion_12)
	
	normal_explosion_attack_module.aoe_sprite_frames = sprite_frames
	normal_explosion_attack_module.sprite_frames_only_play_once = true
	normal_explosion_attack_module.pierce = -1
	normal_explosion_attack_module.duration = 0.65
	normal_explosion_attack_module.damage_repeat_count = 1
	
	normal_explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	normal_explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	normal_explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	normal_explosion_attack_module.can_be_commanded_by_tower = false
	
	normal_explosion_attack_module.set_image_as_tracker_image(Celestial_NormalExplosion_AMA)
	
	add_attack_module(normal_explosion_attack_module)
	
	#
	
	meteor_explosion_attack_module = AOEAttackModule_Scene.instance()
	meteor_explosion_attack_module.base_damage = 0
	meteor_explosion_attack_module.base_damage_type = info.base_damage_type
	meteor_explosion_attack_module.base_attack_speed = 0
	meteor_explosion_attack_module.base_attack_wind_up = 0
	meteor_explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	meteor_explosion_attack_module.is_main_attack = false
	meteor_explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	meteor_explosion_attack_module.benefits_from_bonus_explosion_scale = true
	meteor_explosion_attack_module.benefits_from_bonus_base_damage = true
	meteor_explosion_attack_module.benefits_from_bonus_attack_speed = false
	meteor_explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	meteor_explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	#var meteor_sprite_frames = SpriteFrames.new()
	
	#meteor_explosion_attack_module.aoe_sprite_frames = sprite_frames
	meteor_explosion_attack_module.sprite_frames_only_play_once = false
	meteor_explosion_attack_module.pierce = -1
	meteor_explosion_attack_module.duration = meteor_explosion_lifetime
	meteor_explosion_attack_module.damage_repeat_count = 1
	
	meteor_explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	meteor_explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	meteor_explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	meteor_explosion_attack_module.can_be_commanded_by_tower = false
	
	meteor_explosion_attack_module.set_image_as_tracker_image(Celestial_MeteorExplosion_AMA)
	meteor_explosion_attack_module.connect("before_aoe_is_added_as_child", self, "_on_before_meteor_aoe_is_added_as_child", [], CONNECT_PERSIST)
	
	add_attack_module(meteor_explosion_attack_module)
	
	#
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	set_current_shot_count_left_for_meteor(shot_count_for_meteor)
	
	connect("on_main_attack_finished", self, "_on_main_attack_finished_c", [], CONNECT_PERSIST)
	
	
	arc_proj_multiple_trail_component = MultipleTrailsForNodeComponent.new()
	arc_proj_multiple_trail_component.node_to_host_trails = self
	arc_proj_multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	
	#
	
	_construct_and_register_ability()
	
	#
	
	_post_inherit_ready()

#

func _construct_and_register_ability():
	meteor_ability = BaseAbility.new()
	
	meteor_ability.is_timebound = false
	
	meteor_ability.set_properties_to_usual_tower_based()
	meteor_ability.tower = self
	
	#meteor_ability.connect("updated_is_ready_for_activation", self, "_can_cast_rewind_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(meteor_ability, false)
	

#

func set_current_shot_count_left_for_meteor(arg_count):
	_current_shot_count_left_for_meteor = arg_count
	
	if _current_shot_count_left_for_meteor == 1:
		_next_shot_is_meteor = true
	elif _current_shot_count_left_for_meteor == 0:
		_current_shot_count_left_for_meteor = shot_count_for_meteor

func _on_main_attack_finished_c(arg_attk_module):
	set_current_shot_count_left_for_meteor(_current_shot_count_left_for_meteor - 1)
	

#

func _on_before_bullet_is_shot_from_orig_main_attk_module(bullet : ArcingBaseBullet):
	var cd = _get_cd_to_use(BaseAbility.ON_ABILITY_CAST_NO_COOLDOWN)
	meteor_ability.on_ability_before_cast_start(cd)
	
	meteor_ability.start_time_cooldown(cd)
	meteor_ability.on_ability_after_cast_ended(cd)
	
	#
	
	if _next_shot_is_meteor:
		var rand_num = non_essential_rng.randi_range(1, 3)
		
		if rand_num == 1:
			bullet.set_texture_as_sprite_frames(MainAttackProj_Meteor_01)
		elif rand_num == 2:
			bullet.set_texture_as_sprite_frames(MainAttackProj_Meteor_02)
		elif rand_num == 3:
			bullet.set_texture_as_sprite_frames(MainAttackProj_Meteor_03)
		
		
	else:
		var rand_num = non_essential_rng.randi_range(1, 3)
		
		if rand_num == 1:
			bullet.set_texture_as_sprite_frames(MainAttackProj_Normal_01)
		elif rand_num == 2:
			bullet.set_texture_as_sprite_frames(MainAttackProj_Normal_02)
		elif rand_num == 3:
			bullet.set_texture_as_sprite_frames(MainAttackProj_Normal_03)
	
	
	bullet.modulate.a = 0
	bullet.connect("current_life_dist_changed", self, "_on_current_life_dist_of_arc_proj_changed", [bullet, _next_shot_is_meteor])
	bullet.connect("on_final_location_reached", self, "_on_arc_proj_final_location_reached", [_next_shot_is_meteor], CONNECT_ONESHOT)
	
	_start_beam_display_for_firing(_next_shot_is_meteor)
	
	_next_shot_is_meteor = false

func _on_current_life_dist_of_arc_proj_changed(arg_curr_life_dist, arg_ratio, arg_bullet, arg_is_meteor):
	if arg_ratio <= 0.45:
		arg_bullet.disconnect("current_life_dist_changed", self, "_on_current_life_dist_of_arc_proj_changed")
		_make_main_arc_proj_visible_and_show_effects(arg_bullet, arg_is_meteor)


func _make_main_arc_proj_visible_and_show_effects(arg_bullet : ArcingBaseBullet, arg_is_meteor):
	arg_bullet.modulate.a = 1
	
	arc_proj_multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_arc_proj", [arg_is_meteor], CONNECT_ONESHOT)
	arc_proj_multiple_trail_component.create_trail_for_node(arg_bullet)
	
	_start_beam_display_for_proj_falling(arg_bullet, arg_is_meteor)

func _trail_before_attached_to_arc_proj(arg_trail, node, arg_is_meteor):
	if !arg_is_meteor:
		arg_trail.max_trail_length = arc_shot_non_meteor_trail_length
		arg_trail.trail_color = arc_shot_trail_color
		arg_trail.width = arc_shot_non_meteor_trail_width
	else:
		arg_trail.max_trail_length = arc_shot_meteor_trail_length
		arg_trail.trail_color = arc_shot_trail_color
		arg_trail.width = arc_shot_meteor_trail_width
	
	#arg_trail.set_to_idle_and_available_if_node_is_not_visible = true



func _on_arc_proj_final_location_reached(arg_final_pos, arg_bullet, arg_is_meteor : bool):
	var dmg_instance = _create_normal_aoe_on_location(arg_final_pos, arg_is_meteor)
	dmg_instance = dmg_instance.get_copy_damage_only_scaled_by(1)
	dmg_instance.final_damage_multiplier = meteor_larger_explosion_dmg_instance_dmg_multiplier
	
	if arg_is_meteor:
		_create_meteor_aoe_on_location(arg_final_pos, dmg_instance)

##

func _create_normal_aoe_on_location(arg_pos, arg_is_meteor):
	var explosion = normal_explosion_attack_module.construct_aoe(arg_pos, arg_pos)
	if arg_is_meteor:
		explosion.damage_instance.scale_only_damage_by(meteor_explosion_scale_to_normal_dmg)
	
	explosion.scale *= 2.0
	explosion.modulate.a = 0.75
	normal_explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)
	
	return explosion.damage_instance

func _create_meteor_aoe_on_location(arg_pos, dmg_instance_to_use):
	var ap_to_use = meteor_ability.get_potency_to_use(last_calculated_final_ability_potency)
	var final_radius = ap_to_use * meteor_aoe_base_radius
	
	
	var explosion = meteor_explosion_attack_module.construct_aoe(arg_pos, arg_pos)
	explosion.damage_instance = dmg_instance_to_use
	meteor_explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)
	
	
	var draw_params = aoe_draw_node.DrawParams.new()
	draw_params.center_pos = arg_pos
	draw_params.current_radius = 1
	draw_params.radius_per_sec = final_radius / meteor_explosion_lifetime #meteor_aoe_radius_per_sec_inc
	draw_params.fill_color = Color(162/255.0, 2/255.0, 187/255.0, 0.2)
	
	draw_params.outline_color = Color(70/255.0, 1/255.0, 81/255.0, 0.4)
	draw_params.outline_width = 3
	
	draw_params.lifetime_of_draw = meteor_explosion_lifetime + 0.2
	draw_params.lifetime_to_start_transparency = meteor_explosion_lifetime - 0.3
	
	aoe_draw_node.add_draw_param(draw_params)

func _on_before_meteor_aoe_is_added_as_child(aoe):
	var shape = CircleShape2D.new()
	shape.radius = 1
	aoe.aoe_shape_to_set_on_ready = shape
	
	var ap_to_use = meteor_ability.get_potency_to_use(last_calculated_final_ability_potency)
	var final_radius = ap_to_use * meteor_aoe_base_radius
	
	aoe.coll_shape_circle_inc_per_sec = final_radius / meteor_explosion_lifetime #meteor_aoe_radius_per_sec_inc

##

func _start_beam_display_for_firing(arg_is_meteor):
	var main_line_draw_param := Celestial_LineDrawNode.LineDrawParams.new()
	main_line_draw_param.source_pos = global_position + Vector2(0, -y_shift)
	main_line_draw_param.dest_pos = main_line_draw_param.source_pos + Vector2(0, -160)
	main_line_draw_param.total_line_length = 80
	
	main_line_draw_param.line_length_per_sec = 160 * 2
	main_line_draw_param.color = line_draw_color__main_shot
	main_line_draw_param.width = 5
	
	line_draw_node.add_line_draw_param(main_line_draw_param)
	
	if arg_is_meteor:
		var left_line_draw_param := Celestial_LineDrawNode.LineDrawParams.new()
		left_line_draw_param.source_pos = global_position + Vector2(0, -y_shift)
		left_line_draw_param.dest_pos = left_line_draw_param.source_pos + Vector2(-20, -90)
		left_line_draw_param.total_line_length = 60
		
		left_line_draw_param.line_length_per_sec = 90 * 2
		left_line_draw_param.color = line_draw_color__main_shot
		left_line_draw_param.width = 4
		
		left_line_draw_param.delta_delay_before_show = 0.15
		
		line_draw_node.add_line_draw_param(left_line_draw_param)
		
		#
		
		
		var right_line_draw_param := Celestial_LineDrawNode.LineDrawParams.new()
		right_line_draw_param.source_pos = global_position + Vector2(0, -y_shift)
		right_line_draw_param.dest_pos = right_line_draw_param.source_pos + Vector2(20, -90)
		right_line_draw_param.total_line_length = 60
		
		right_line_draw_param.line_length_per_sec = 90 * 2
		right_line_draw_param.color = line_draw_color__main_shot
		right_line_draw_param.width = 4
		
		right_line_draw_param.delta_delay_before_show = 0.30
		
		line_draw_node.add_line_draw_param(right_line_draw_param)
		

func _start_beam_display_for_proj_falling(arg_bullet : ArcingBaseBullet, arg_is_meteor):
	var bullet_pos = arg_bullet.global_position
	
	if arg_is_meteor:
		var delay = 0
		for i in 7:
			delay += 0.12
			
			_generate_random_draw_param_for_proj_falling_meteor(bullet_pos, arg_bullet.final_location, delay)

func _generate_random_draw_param_for_proj_falling_meteor(arg_pos : Vector2, arg_bullet_dest_pos : Vector2, arg_delay_to_use):
	var angle_to_final_pos = arg_pos.angle_to_point(arg_bullet_dest_pos)
	var angle_to_use = angle_to_final_pos + non_essential_rng.randf_range(-PI/4, PI/4)
	
	var length_to_use = non_essential_rng.randf_range(350, 450)
	
	var line_draw_param := Celestial_LineDrawNode.LineDrawParams.new()
	line_draw_param.source_pos = arg_pos + Vector2(-30, 0).rotated(angle_to_use)
	line_draw_param.dest_pos = line_draw_param.source_pos + Vector2(-length_to_use, 0).rotated(angle_to_use)
	line_draw_param.total_line_length = 140
	
	line_draw_param.line_length_per_sec = length_to_use * 1.75
	line_draw_param.color = line_draw_color__meteor_sides_falling_shot
	line_draw_param.width = 3
	
	line_draw_param.delta_delay_before_show = arg_delay_to_use
	
	line_draw_node.add_line_draw_param(line_draw_param)
	
	







