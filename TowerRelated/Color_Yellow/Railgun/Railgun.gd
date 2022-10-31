extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BulletRectEdgeBounceComponent = preload("res://TowerRelated/CommonBehaviorRelated/BulletRectEdgeBounceComponent.gd")
const BulletRectEdgeBounceComponentPool = preload("res://MiscRelated/PoolRelated/Implementations/BulletRectEdgeBounceComponentPool.gd")

const RailgunBullet_pic = preload("res://TowerRelated/Color_Yellow/Railgun/Railgun_Bullet.png")


var railgun_attack_module : BulletAttackModule
var info : TowerTypeInformation

var is_energy_module_on : bool = false
var bullet_rect_edge_bounce_compo_pool : BulletRectEdgeBounceComponentPool


func _ready():
	info = Towers.get_tower_info(Towers.RAILGUN)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var attack_module_y_shift : float = 5.0
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attack_module_y_shift
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 660 #600
	attack_module.base_proj_life_distance = info.base_range
	attack_module.base_proj_life_distance_scale = 3
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attack_module_y_shift
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(12, 6)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(RailgunBullet_pic)
	
	railgun_attack_module = attack_module
	add_attack_module(attack_module)
	
	
	_construct_bounce_edge_compo_pool()
	connect("on_main_bullet_attack_module_after_bullet_is_shot", self, "_on_main_bullet_attack_module_after_bullet_is_shot_r", [], CONNECT_PERSIST)
	
	_post_inherit_ready()

#

func _on_main_bullet_attack_module_after_bullet_is_shot_r(bullet, attack_module):
	var bounce_compo : BulletRectEdgeBounceComponent = bullet_rect_edge_bounce_compo_pool.get_or_create_resource_from_pool()
	
	bounce_compo.bullet = bullet



# Energy module

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Railgun's base pierce is increased to 77. Bullets travel 5 times further.",
			"On hit damages and effects are 300% effective.",
			"",
			"Railgun's main attack also punches a hole in enemies, making bullets pierce through them at twice the effectiveness. This effect stacks."
		]


func _module_turned_on(_first_time_per_round : bool):
	railgun_attack_module.base_pierce = 77
	railgun_attack_module.on_hit_damage_scale = 3
	railgun_attack_module.on_hit_effect_scale = 3
	railgun_attack_module.base_proj_life_distance_scale = 15
	
	railgun_attack_module.calculate_final_pierce()
	
	is_energy_module_on = true
	
	if !is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attack_module_enemy_hit_r"):
		connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_module_enemy_hit_r", [], CONNECT_PERSIST)


func _module_turned_off():
	railgun_attack_module.base_pierce = info.base_pierce
	railgun_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	railgun_attack_module.on_hit_effect_scale = 1
	railgun_attack_module.base_proj_life_distance_scale = 2
	
	railgun_attack_module.calculate_final_pierce()
	
	is_energy_module_on = false
	
	if is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attack_module_enemy_hit_r"):
		disconnect("on_main_attack_module_enemy_hit", self, "_on_main_attack_module_enemy_hit_r")

#

func _on_main_attack_module_enemy_hit_r(enemy, damage_register_id, damage_instance, module):
	if is_energy_module_on:
		call_deferred("_punch_hole_at_enemy", enemy)

func _punch_hole_at_enemy(enemy):
	if is_instance_valid(enemy):
		enemy.pierce_consumed_per_hit /= 2
		print(enemy.pierce_consumed_per_hit)

#

func _construct_bounce_edge_compo_pool():
	bullet_rect_edge_bounce_compo_pool = BulletRectEdgeBounceComponentPool.new()
	bullet_rect_edge_bounce_compo_pool.node_to_parent = CommsForBetweenScenes.current_game_elements__other_node_hoster
	bullet_rect_edge_bounce_compo_pool.source_of_create_resource = self
	bullet_rect_edge_bounce_compo_pool.func_name_for_create_resource = "_create_bullet_bounce_component"

func _create_bullet_bounce_component():
	var bounce_component = BulletRectEdgeBounceComponent.new()
	bounce_component.set_bounds_based_on_game_elements(game_elements)
	
	return bounce_component


