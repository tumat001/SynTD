extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const TargetingGained_Particle_Scene = preload("res://TowerRelated/Color_Red/Adept/Assets/TargetingGained_Particle/TargetingGained_Particle.tscn")

const Adept_Beam01_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam01.png")
const Adept_Beam02_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam02.png")
const Adept_Beam03_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam03.png")
const Adept_Beam04_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam04.png")
const Adept_Beam05_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam05.png")
const Adept_Beam06_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam06.png")
const Adept_Beam07_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam07.png")
const Adept_Beam08_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam08.png")
const Adept_Beam09_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam09.png")
const Adept_Beam10_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam10.png")
const Adept_Beam11_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Beam11.png")

const Adept_MiniBeam01_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam01.png")
const Adept_MiniBeam02_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam02.png")
const Adept_MiniBeam03_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam03.png")
const Adept_MiniBeam04_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam04.png")
const Adept_MiniBeam05_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam05.png")
const Adept_MiniBeam06_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam06.png")
const Adept_MiniBeam07_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam07.png")

const Adept_HitMark01_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Hit01.png")
const Adept_HitMark02_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Hit02.png")
const Adept_HitMark03_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Hit03.png")
const Adept_HitMark04_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Hit04.png")
const Adept_HitMark05_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/Adept_Hit05.png")

const base_beyond_range_threshold_ratio : float = 0.75
const color_beyond_range : Color = Color(0, 0, 1, 0.5)
const base_below_range_threshold_ratio : float = 0.40
const color_below_range : Color = Color(1, 0, 0, 0.5)

var current_beyond_range_threshold : float
var current_below_range_threshold : float

var mini_shot_attack_module : WithBeamInstantDamageAttackModule
const mini_dmg_reg_id : int = Towers.ADEPT


var slow_effect : EnemyAttributesEffect
const base_beyond_range_bonus_damage_ratio : float = 1.5
var main_shot_sprite_frames : SpriteFrames

const rounds_before_learn : int = 3
var current_round_before_learn : int = rounds_before_learn
var main_shot_range_module : RangeModule


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.ADEPT)
	
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
	range_module.position.y += 14
	
	main_shot_range_module = range_module
	
	
	# mini attack
	
	mini_shot_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	mini_shot_attack_module.on_hit_damage_scale = 0.15
	mini_shot_attack_module.base_damage_scale = 0.15
	mini_shot_attack_module.base_damage = 2.25 / mini_shot_attack_module.base_damage_scale
	mini_shot_attack_module.base_damage_type = DamageType.PHYSICAL
	mini_shot_attack_module.base_attack_speed = 0
	mini_shot_attack_module.base_attack_wind_up = 1 / 0.1
	mini_shot_attack_module.is_main_attack = true
	mini_shot_attack_module.module_id = StoreOfAttackModuleID.MAIN
	mini_shot_attack_module.position.y -= 14
	mini_shot_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	
	mini_shot_attack_module.on_hit_effect_scale = 1
	
	mini_shot_attack_module.commit_to_targets_of_windup = true
	mini_shot_attack_module.fill_empty_windup_target_slots = false
	mini_shot_attack_module.show_beam_at_windup = true
	
	mini_shot_attack_module.benefits_from_bonus_base_damage = false
	mini_shot_attack_module.benefits_from_bonus_on_hit_damage = false
	
	var mini_beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam01_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam02_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam03_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam04_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam05_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam06_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam07_Pic)
	mini_beam_sprite_frame.set_animation_loop("default", false)
	mini_beam_sprite_frame.set_animation_speed("default", 7 / 0.15)
	
	mini_shot_attack_module.beam_scene = BeamAesthetic_Scene
	mini_shot_attack_module.beam_sprite_frames = mini_beam_sprite_frame
	mini_shot_attack_module.beam_is_timebound = true
	mini_shot_attack_module.beam_time_visible = 0.15
	
	mini_shot_attack_module.can_be_commanded_by_tower = false
	
	mini_shot_attack_module.damage_register_id = mini_dmg_reg_id
	
	mini_shot_attack_module.set_image_as_tracker_image(preload("res://TowerRelated/Color_Red/Adept/Assets/MiniShot_AM_Pic.png"))
	
	add_attack_module(mini_shot_attack_module)
	
	# normal attack
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1 / 0.15 
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 14
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	attack_module.show_beam_at_windup = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Adept_Beam01_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam02_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam03_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam04_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam05_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam06_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam07_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam08_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam09_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam10_Pic)
	beam_sprite_frame.add_frame("default", Adept_Beam11_Pic)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 11 / 0.15)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.15
	
	add_attack_module(attack_module)
	
	#
	
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy_a", [], CONNECT_PERSIST)
	connect("final_range_changed", self, "_calculate_range_thresholds", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_ended_a", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	_calculate_range_thresholds()
	_construct_effects()
	_construct_hit_marker()

func _calculate_range_thresholds():
	current_beyond_range_threshold = main_attack_module.range_module.last_calculated_final_range * base_beyond_range_threshold_ratio
	current_below_range_threshold = main_attack_module.range_module.last_calculated_final_range * base_below_range_threshold_ratio
	
	update()

func _construct_effects():
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ADEPT_SLOW)
	slow_modifier.percent_amount = -30
	slow_modifier.percent_based_on = PercentType.BASE
	
	slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.ADEPT_SLOW)
	slow_effect.is_timebound = true
	slow_effect.time_in_seconds = 0.75

func _construct_hit_marker():
	if main_shot_sprite_frames == null:
		main_shot_sprite_frames = SpriteFrames.new()
		main_shot_sprite_frames.add_frame("default", Adept_HitMark01_Pic)
		main_shot_sprite_frames.add_frame("default", Adept_HitMark02_Pic)
		main_shot_sprite_frames.add_frame("default", Adept_HitMark03_Pic)
		main_shot_sprite_frames.add_frame("default", Adept_HitMark04_Pic)
		main_shot_sprite_frames.add_frame("default", Adept_HitMark05_Pic)
		main_shot_sprite_frames.set_animation_loop("default", false)

#

func _on_main_attack_hit_enemy_a(enemy, damage_register_id, damage_instance, am : AbstractAttackModule):
	if damage_register_id != mini_dmg_reg_id and am != mini_shot_attack_module:
		var distance = global_position.distance_to(enemy.global_position)
		
		if distance < current_below_range_threshold:
			call_deferred("_attempt_do_secondary_attack_at_another_enemy")
		elif distance > current_beyond_range_threshold:
			_boost_beyond_attack(damage_instance, enemy.global_position)
		
		
	elif damage_register_id == mini_dmg_reg_id and am == mini_shot_attack_module:
		var damage_ratio = last_calculated_final_ability_potency
		damage_instance.scale_only_damage_by(damage_ratio)


# below
func _attempt_do_secondary_attack_at_another_enemy():
	var enemies = main_attack_module.range_module.get_targets(2)
	if enemies.size() == 2:
		mini_shot_attack_module.on_command_attack_enemies_and_attack_when_ready([enemies[1]], 1)

# above
func _boost_beyond_attack(damage_instance, pos):
	var damage_ratio = base_beyond_range_bonus_damage_ratio * last_calculated_final_ability_potency
	
	damage_instance.scale_only_damage_by(damage_ratio)
	damage_instance.on_hit_effects[StoreOfEnemyEffectsUUID.ADEPT_SLOW] = slow_effect._get_copy_scaled_by(1)
	
	var atk_sprite : AttackSprite = AttackSprite_Scene.instance()
	atk_sprite.frames = main_shot_sprite_frames
	atk_sprite.frame = 0
	atk_sprite.has_lifetime = true
	atk_sprite.lifetime = 0.2
	atk_sprite.frames_based_on_lifetime = true
	atk_sprite.position = pos
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(atk_sprite)

#

func toggle_module_ranges():
	.toggle_module_ranges()
	
	update()


func _draw():
	if is_showing_ranges:
		draw_circle_arc(Vector2(0, 0), current_beyond_range_threshold, 0, 360, color_beyond_range)
		draw_circle_arc(Vector2(0, 0), current_below_range_threshold, 0, 360, color_below_range)


func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 2)

#

func _on_round_ended_a():
	if is_current_placable_in_map():
		current_round_before_learn -= 1
		
		if current_round_before_learn <= 0:
			disconnect("on_round_end", self, "_on_round_ended_a")
			main_shot_range_module.add_targeting_option(Targeting.CLOSE)
			main_shot_range_module.add_targeting_option(Targeting.FAR)
			
			var particle = TargetingGained_Particle_Scene.instance()
			CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
			particle.lifetime = 1.25
			particle.lifetime_to_start_transparency = 0.5
			particle.position = global_position
			particle.position.y -= 10
			
			CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)


# Heat Module

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

