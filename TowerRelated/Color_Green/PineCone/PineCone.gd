extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Pinecone_Proj = preload("res://TowerRelated/Color_Green/PineCone/Attks/PineCone_MainProj.png")
const Pinecone_SmallProj = preload("res://TowerRelated/Color_Green/PineCone/Attks/PineCone_SmallerProj.png")

const PineconeFrags_AttackModule_Icon = preload("res://TowerRelated/Color_Green/PineCone/AMAssets/PineconeFrags_AttackModule_Icon.png")

var burst_attack_module : BulletAttackModule
var base_angles_of_fire : Array = [
	30,
	0,
	-30
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.PINECONE)
	
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
	range_module.position.y += 8
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 360#300
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 8
	
	attack_module.benefits_from_bonus_pierce = true
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(8, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	var sp = SpriteFrames.new()
	sp.add_frame("default", Pinecone_Proj)
	attack_module.bullet_sprite_frames = sp
	
#	connect("attack_module_added", self, "_attack_module_added_on_self", [], CONNECT_PERSIST)
#	connect("attack_module_removed", self, "_attack_module_removed_on_self", [], CONNECT_PERSIST)
	connect("on_main_attack_module_enemy_hit", self, "_bullet_burst", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	
	# SPAWNED fragments
	
	burst_attack_module = BulletAttackModule_Scene.instance()
	burst_attack_module.base_damage = 1
	burst_attack_module.base_damage_type = DamageType.PHYSICAL
	burst_attack_module.base_attack_speed = 0
	burst_attack_module.base_attack_wind_up = 0
	burst_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	burst_attack_module.is_main_attack = false
	burst_attack_module.base_pierce = 1
	burst_attack_module.base_proj_speed = 200
	burst_attack_module.base_proj_life_distance = 45
	burst_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	burst_attack_module.benefits_from_bonus_on_hit_effect = false
	burst_attack_module.benefits_from_bonus_attack_speed = false
	burst_attack_module.benefits_from_bonus_base_damage = false
	burst_attack_module.benefits_from_bonus_on_hit_damage = false
	burst_attack_module.benefits_from_bonus_pierce = true
	
	var burst_bullet_shape = RectangleShape2D.new()
	burst_bullet_shape.extents = Vector2(5, 3)
	
	burst_attack_module.bullet_shape = burst_bullet_shape
	burst_attack_module.bullet_scene = BaseBullet_Scene
	
	var burst_sp = SpriteFrames.new()
	burst_sp.add_frame("default", Pinecone_SmallProj)
	burst_attack_module.bullet_sprite_frames = burst_sp
	
	burst_attack_module.can_be_commanded_by_tower = false
	
	burst_attack_module.set_image_as_tracker_image(PineconeFrags_AttackModule_Icon)
	
	add_attack_module(burst_attack_module)
	
	_post_inherit_ready()



func _bullet_burst(enemy, damage_reg_id, damage_instance, module):
	var spawn_pos : Vector2 = enemy.global_position
	
	for dir in base_angles_of_fire:
		var bullet : BaseBullet = burst_attack_module.construct_bullet(spawn_pos)
		bullet.life_distance = 55
		bullet.enemies_ignored.append(enemy)
		bullet.global_position = spawn_pos
		
		var initial_angle = bullet.direction_as_relative_location.angle()
		var final_angle = initial_angle + dir
		
		bullet.direction_as_relative_location = bullet.direction_as_relative_location.rotated(deg2rad(final_angle))
		bullet.rotation_degrees = rad2deg(bullet.direction_as_relative_location.angle())
		
		burst_attack_module.set_up_bullet__add_child_and_emit_signals(bullet)

