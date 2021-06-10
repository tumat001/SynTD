extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

const Coal_Proj01 = preload("res://TowerRelated/Color_Orange/CoalLauncher/Coal_Proj/Coal_Proj01.png")
const Coal_Proj02 = preload("res://TowerRelated/Color_Orange/CoalLauncher/Coal_Proj/Coal_Proj02.png")

var coal_attack_module : BulletAttackModule
var burn_effect_ids_to_inc : Array = [
	StoreOfEnemyEffectsUUID.ING_EMBER_BURN,
	StoreOfEnemyEffectsUUID.EMBER_BURN,
	
	StoreOfEnemyEffectsUUID._704_FIRE_BURN,
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.COAL_LAUNCHER)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 4
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_name = "coal_launcher_base_damage"
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 540
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 4
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 4)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Coal_Proj01)
	
	attack_module.connect("before_bullet_is_shot", self, "_modify_bullet", [], CONNECT_PERSIST)
	attack_module.connect("on_enemy_hit", self, "_on_coal_hit_enemy", [], CONNECT_PERSIST)
	coal_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	
	_post_inherit_ready()


func _modify_bullet(bullet : BaseBullet):
	var rng := StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	var rand_num = rng.randi_range(1, 2)
	
	if rand_num == 1:
		bullet.set_texture_as_sprite_frames(Coal_Proj01)
	elif rand_num == 2:
		bullet.set_texture_as_sprite_frames(Coal_Proj02)


func _on_coal_hit_enemy(enemy : AbstractEnemy, damage_reg_id, module):
	for eff_id in enemy._dmg_over_time_id_effects_map.keys():
		if burn_effect_ids_to_inc.has(eff_id):
			enemy._dmg_over_time_id_effects_map[eff_id].time_in_seconds += 1.5

