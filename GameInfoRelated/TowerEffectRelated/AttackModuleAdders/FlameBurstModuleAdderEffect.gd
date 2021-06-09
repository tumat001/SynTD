extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"

const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")

const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const BurstProj_01 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj01.png")
const BurstProj_02 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj02.png")
const BurstProj_03 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj03.png")
const BurstProj_04 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj04.png")
const BurstProj_05 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj05.png")
const BurstProj_06 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj06.png")

var burst_attack_module : BulletAttackModule
var directions : Array = [
	Vector2(1, 1),
	Vector2(1, -1),
	Vector2(-1, 1),
	Vector2(-1, -1),
]
var tree

func _init().(StoreOfTowerEffectsUUID.ING_FLAMEBURST):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_FlameburtBurst.png")
	description = "This tower's main attacks on hit causes 4 flamelets to be spewed from enemies hit. The flamelets deal 1 elemental damage, and benefit from base damage buffs and on hit damages at 50% efficiency."


func _construct_burst_module():
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


func _make_modifications_to_tower(tower):
	_construct_burst_module()
	tower.add_attack_module(burst_attack_module)
	
	tree = tower.get_tree()
	
	for module in tower.all_attack_modules:
		if module.module_id == StoreOfAttackModuleID.MAIN:
			if !module.is_connected("on_enemy_hit", self, "_bullet_burst"):
				module.connect("on_enemy_hit", self, "_bullet_burst", [], CONNECT_PERSIST)
	
	if !tower.is_connected("attack_module_added", self, "_on_tower_attack_module_added"):
		tower.connect("attack_module_added", self, "_on_tower_attack_module_added")
		tower.connect("attack_module_removed", self, "_on_tower_attack_module_removed")


func _undo_modifications_to_tower(tower):
	if burst_attack_module != null:
		tower.remove_attack_module(burst_attack_module)
		burst_attack_module.queue_free()
	
	for module in tower.all_attack_modules:
		if module.module_id == StoreOfAttackModuleID.MAIN:
			if module.is_connected("on_enemy_hit", self, "_bullet_burst"):
				module.disconnect("on_enemy_hit", self, "_bullet_burst")
	
	if tower.is_connected("attack_module_added", self, "_on_tower_attack_module_added"):
		tower.disconnect("attack_module_added", self, "_on_tower_attack_module_added")
		tower.disconnect("attack_module_removed", self, "_on_tower_attack_module_removed")
	

# hit

func _bullet_burst(enemy, damage_reg_id, module):
	var spawn_pos : Vector2 = enemy.global_position
	
	for dir in directions:
		var bullet : BaseBullet = burst_attack_module.construct_bullet(spawn_pos + dir)
		bullet.life_distance = 30
		bullet.enemies_ignored.append(enemy)
		bullet.direction_as_relative_location = dir
		bullet.rotation_degrees = rad2deg(spawn_pos.angle_to_point(spawn_pos - dir))
		bullet.global_position = spawn_pos
		bullet.scale *= 0.75
		
		tree.get_root().call_deferred("add_child", bullet)


# connect

func _on_tower_attack_module_added(module):
	if module.module_id == StoreOfAttackModuleID.MAIN:
		if !module.is_connected("on_enemy_hit", self, "_bullet_burst"):
			module.connect("on_enemy_hit", self, "_bullet_burst", [], CONNECT_PERSIST)


func _on_tower_attack_module_removed(module):
	if module.module_id == StoreOfAttackModuleID.MAIN:
		if module.is_connected("on_enemy_hit", self, "_bullet_burst"):
			module.disconnect("on_enemy_hit", self, "_bullet_burst")
