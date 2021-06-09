extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")

const BurstProj_01 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj01.png")
const BurstProj_02 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj02.png")
const BurstProj_03 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj03.png")
const BurstProj_04 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj04.png")
const BurstProj_05 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj05.png")
const BurstProj_06 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj06.png")


var burst_attack_module : BulletAttackModule
var directions : Array = [
	Vector2(0.5, -sqrt(3)/2),
	Vector2(1, 0), # L
	Vector2(0.5, sqrt(3)/2),
	Vector2(-0.5, sqrt(3)/2),
	Vector2(-1, 0), # R
	Vector2(-0.5, -sqrt(3)/2)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.FLAMEBURST)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_name = "flameburst_damage"
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 375
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(8, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	var sp = SpriteFrames.new()
	sp.add_frame("default", BurstProj_01)
	sp.add_frame("default", BurstProj_02)
	sp.add_frame("default", BurstProj_03)
	sp.add_frame("default", BurstProj_04)
	sp.add_frame("default", BurstProj_05)
	sp.add_frame("default", BurstProj_06)
	attack_module.bullet_sprite_frames = sp
	
	connect("attack_module_added", self, "_attack_module_added_on_self", [], CONNECT_PERSIST)
	connect("attack_module_removed", self, "_attack_module_removed_on_self", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	
	# SPAWNED flames
	
	burst_attack_module = BulletAttackModule_Scene.instance()
	burst_attack_module.base_damage = 2
	burst_attack_module.base_damage_type = DamageType.ELEMENTAL
	burst_attack_module.base_attack_speed = 0
	burst_attack_module.base_attack_wind_up = 0
	burst_attack_module.base_on_hit_damage_internal_name = "flameburst_mini_damage"
	burst_attack_module.is_main_attack = false
	burst_attack_module.base_pierce = 1
	burst_attack_module.base_proj_speed = 200
	burst_attack_module.base_proj_life_distance = 30
	burst_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	burst_attack_module.benefits_from_bonus_on_hit_effect = false
	burst_attack_module.benefits_from_bonus_attack_speed = false
	burst_attack_module.on_hit_damage_scale = 0.5
	burst_attack_module.base_damage_scale = 0.5
	
	var burst_bullet_shape = RectangleShape2D.new()
	burst_bullet_shape.extents = Vector2(5, 3)
	
	burst_attack_module.bullet_shape = burst_bullet_shape
	burst_attack_module.bullet_scene = BaseBullet_Scene
	
	var burst_sp = SpriteFrames.new()
	burst_sp.add_frame("default", BurstProj_01)
	burst_sp.add_frame("default", BurstProj_02)
	burst_sp.add_frame("default", BurstProj_03)
	burst_sp.add_frame("default", BurstProj_04)
	burst_sp.add_frame("default", BurstProj_05)
	burst_sp.add_frame("default", BurstProj_06)
	burst_attack_module.bullet_sprite_frames = burst_sp
	
	burst_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(burst_attack_module)
	
	_post_inherit_ready()


func _attack_module_added_on_self(module : AbstractAttackModule):
	if module.module_id == StoreOfAttackModuleID.MAIN:
		if !module.is_connected("on_enemy_hit", self, "_bullet_burst"):
			module.connect("on_enemy_hit", self, "_bullet_burst", [], CONNECT_PERSIST)

func _attack_module_removed_from_self(module : AbstractAttackModule):
	if module.module_id == StoreOfAttackModuleID.MAIN:
		if module.is_connected("on_enemy_hit", self, "_bullet_burst"):
			module.disconnect("on_enemy_hit", self, "_bullet_burst")



func _bullet_burst(enemy, damage_reg_id, module):
	var spawn_pos : Vector2 = enemy.global_position
	
	for dir in directions:
		var bullet : BaseBullet = burst_attack_module.construct_bullet(spawn_pos + dir)
		bullet.life_distance = 30 + (main_attack_module.range_module.last_calculated_final_range - main_attack_module.range_module.base_range_radius)
		bullet.enemies_ignored.append(enemy)
		bullet.direction_as_relative_location = dir
		bullet.rotation_degrees = rad2deg(spawn_pos.angle_to_point(spawn_pos - dir))
		bullet.global_position = spawn_pos
		bullet.scale *= 0.75
		
		get_tree().get_root().call_deferred("add_child", bullet)

