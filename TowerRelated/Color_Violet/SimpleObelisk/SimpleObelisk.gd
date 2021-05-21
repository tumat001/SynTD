extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const SpawnAOEModuleModification = preload("res://TowerRelated/Modification/ModuleModification/SpawnAOEModuleModification.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const SpawnAOETemplate = preload("res://TowerRelated/Templates/SpawnAOETemplate.gd")

const SimpleObeliskBullet_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_Bullet.png")

const Explosion03_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_03.png")
const Explosion04_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_04.png")
const Explosion05_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_05.png")
const Explosion06_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_06.png")
const Explosion07_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_07.png")
const Explosion08_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_08.png")


var template : SpawnAOETemplate

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SIMPLE_OBELISK)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_name = "simple_obelisk_base_damage"
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 250
	attack_module.projectile_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 30
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 3
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(SimpleObeliskBullet_pic)
	
	
	# AOE
	
	var spawn_aoe_mod : SpawnAOEModuleModification = SpawnAOEModuleModification.new()
	spawn_aoe_mod.template = _generate_template()
	
	#
	
	attack_module.modifications = [spawn_aoe_mod]
	attack_modules_and_target_num[attack_module] = 1
	
	_post_inherit_ready()


func _generate_template():
	template = SpawnAOETemplate.new()
	
	template.aoe_scene = BaseAOE_Scene
	
	template.aoe_damage_repeat_count = 1
	template.aoe_duration = 0.5
	template.aoe_pierce = -1
	
	template.aoe_base_damage = 3
	template.aoe_base_damage_type = DamageType.ELEMENTAL
	template.aoe_base_on_hit_damage_internal_name = "simple_obelisk_explosion_base_damage"
	
	template.aoe_on_hit_damage_scale = 0.5
	template.aoe_base_on_hit_affected_by_scale = false
	
	template.aoe_sprite_frames_play_only_once = true
	template.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	template.tree = get_tree()
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Explosion03_pic)
	sprite_frames.add_frame("default", Explosion04_pic)
	sprite_frames.add_frame("default", Explosion05_pic)
	sprite_frames.add_frame("default", Explosion06_pic)
	sprite_frames.add_frame("default", Explosion07_pic)
	sprite_frames.add_frame("default", Explosion08_pic)
	
	template.aoe_sprite_frames = sprite_frames
	
	return template


# Update damage of template based on this tower's base dmg
func _emit_final_base_damage_changed():
	._emit_final_base_damage_changed()
	
	template.aoe_base_damage = main_attack_module.last_calculated_final_damage / 2


