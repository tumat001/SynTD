extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const ShockerBall = preload("res://TowerRelated/Color_Red/Shocker/Shocker_Ball/ShockerBall.gd")
const ShockerBall_Scene = preload("res://TowerRelated/Color_Red/Shocker/Shocker_Ball/ShockerBall.tscn")

const ShockBolt_01 = preload("res://TowerRelated/Color_Red/Shocker/Shocker_Ball/Shocker_Ball_Bolt01.png")
const ShockBolt_02 = preload("res://TowerRelated/Color_Red/Shocker/Shocker_Ball/Shocker_Ball_Bolt02.png")
const ShockBolt_03 = preload("res://TowerRelated/Color_Red/Shocker/Shocker_Ball/Shocker_Ball_Bolt03.png")
const ShockBolt_04 = preload("res://TowerRelated/Color_Red/Shocker/Shocker_Ball/Shocker_Ball_Bolt04.png")
const ShockBolt_05 = preload("res://TowerRelated/Color_Red/Shocker/Shocker_Ball/Shocker_Ball_Bolt05.png")

#
const shock_flat_dmg : float = 1.25
const shock_base_damage_and_on_hit_ratio : float = 0.40

const shock_ball_range : float = 100.0
const no_shock_ball_clause : int = AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01

const shock_ball_inactive_duration_queue_free : float = 5.0

const shock_ball_number_of_shock_per_interval : int = 15
const shock_ball_number_of_shock_time_interval : float = 1.0
var _current_shock_ball_number_of_shocks : int = 0
var _shock_ball_number_of_shock_timer : Timer

#
onready var ball_display_sprite : Sprite = $TowerBase/KnockUpLayer/BallDisplay

var shock_attack_module : WithBeamInstantDamageAttackModule
var shock_range_module : RangeModule

var ball_launcher_attack_module : BulletAttackModule

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SHOCKER)
	
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
	range_module.position.y += 24
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 275#210
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 24
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = ShockerBall_Scene
	
	attack_module.connect("before_bullet_is_shot", self, "_on_shock_ball_launched", [], CONNECT_PERSIST)
	
	ball_launcher_attack_module = attack_module
	
	attack_module.is_displayed_in_tracker = false
	
	add_attack_module(attack_module)
	
	
	# shock attack
	
	shock_range_module = RangeModule_Scene.instance()
	shock_range_module.base_range_radius = shock_ball_range
	shock_range_module.set_range_shape(CircleShape2D.new())
	shock_range_module.clear_all_targeting()
	shock_range_module.add_targeting_option(Targeting.CLOSE)
	shock_range_module.set_current_targeting(Targeting.CLOSE)
	
	shock_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	shock_attack_module.base_damage_scale = shock_base_damage_and_on_hit_ratio
	shock_attack_module.base_damage = shock_flat_dmg / shock_attack_module.base_damage_scale
	shock_attack_module.base_damage_type = DamageType.ELEMENTAL
	shock_attack_module.base_attack_speed = 0
	shock_attack_module.base_attack_wind_up = 0
	shock_attack_module.is_main_attack = false
	shock_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	shock_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.SHOCKER_SHOCK_BALL_MAIN_DAMAGE
	
	shock_attack_module.on_hit_damage_scale = shock_base_damage_and_on_hit_ratio
	shock_attack_module.on_hit_effect_scale = 1
	
	shock_attack_module.benefits_from_bonus_on_hit_effect = false
	shock_attack_module.benefits_from_bonus_attack_speed = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", ShockBolt_01)
	beam_sprite_frame.add_frame("default", ShockBolt_02)
	beam_sprite_frame.add_frame("default", ShockBolt_03)
	beam_sprite_frame.add_frame("default", ShockBolt_04)
	beam_sprite_frame.add_frame("default", ShockBolt_05)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 5 / 0.15)
	
	shock_attack_module.beam_scene = BeamAesthetic_Scene
	shock_attack_module.beam_sprite_frames = beam_sprite_frame
	shock_attack_module.beam_is_timebound = true
	shock_attack_module.beam_time_visible = 0.15
	
	shock_attack_module.range_module = shock_range_module
	shock_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(shock_attack_module)
	#
	
	_shock_ball_number_of_shock_timer = Timer.new()
	_shock_ball_number_of_shock_timer.one_shot = true
	_shock_ball_number_of_shock_timer.connect("timeout", self, "_on_shock_ball_number_of_shock_timer_timeout", [], CONNECT_PERSIST)
	add_child(_shock_ball_number_of_shock_timer)
	
	connect("on_round_end", self, "_on_round_end_s", [], CONNECT_PERSIST)
	
	#
	_post_inherit_ready()


# before ball is launched
func _on_shock_ball_launched(ball : ShockerBall):
	ball.connect("on_enemy_stucked_to_exiting", self, "_on_shock_ball_enemy_tree_exiting", [ball], CONNECT_ONESHOT)
	ball.connect("on_current_life_distance_expire", self, "_on_shock_ball_life_distance_expired", [ball], CONNECT_ONESHOT)
	ball.connect("on_enemy_hit", self, "_on_shock_ball_enemy_hit")
	ball.connect("on_position_changed", self, "_on_shock_ball_pos_changed")
	ball.connect("tree_exiting", self, "_on_ball_tree_exiting", [ball], CONNECT_ONESHOT)
	ball.rotation_per_second = 0
	
	ball_launcher_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(no_shock_ball_clause)
	ball_display_sprite.visible = false
	ball.base_time_before_queue_free = shock_ball_inactive_duration_queue_free

func _on_shock_ball_enemy_tree_exiting(enemy, ball):
	ball.queue_free()
	ball_launcher_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(no_shock_ball_clause)
	ball_display_sprite.visible = true

func _on_shock_ball_life_distance_expired(ball):
	ball.queue_free()
	ball_launcher_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(no_shock_ball_clause)
	ball_display_sprite.visible = true

func _on_ball_tree_exiting(ball):
	ball.queue_free()
	ball_launcher_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(no_shock_ball_clause)
	ball_display_sprite.visible = true


func _on_shock_ball_pos_changed(new_pos : Vector2):
	shock_attack_module.global_position = new_pos


func _on_shock_ball_enemy_hit(enemy):
	var enemies = shock_range_module.get_targets(2)
	
	for cand_enemy in enemies:
		if cand_enemy != enemy and is_instance_valid(cand_enemy):
			if _current_shock_ball_number_of_shocks < shock_ball_number_of_shock_per_interval:
				_add_current_shock_ball_number_of_shocks()
				_shock_to_attack_enemy(cand_enemy)
				break


func _shock_to_attack_enemy(enemy):
	shock_attack_module._attack_enemies([enemy])

########

func _add_current_shock_ball_number_of_shocks(arg_num : int = 1):
	_current_shock_ball_number_of_shocks += arg_num
	
	if _shock_ball_number_of_shock_timer.time_left == 0:
		_shock_ball_number_of_shock_timer.start(shock_ball_number_of_shock_time_interval)


func _on_shock_ball_number_of_shock_timer_timeout():
	_reset__current_shock_ball_number_of_shocks()

func _reset__current_shock_ball_number_of_shocks():
	_current_shock_ball_number_of_shocks = 0

func _on_round_end_s():
	_reset__current_shock_ball_number_of_shocks()



#

func set_heat_module(module):
	module.heat_per_attack = 8
	.set_heat_module(module)

func _construct_heat_effect():
	var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_dmg_attr_mod.flat_modifier = 1.5
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module.benefits_from_bonus_base_damage:
			module.calculate_final_base_damage()
	
	emit_signal("final_base_damage_changed")

