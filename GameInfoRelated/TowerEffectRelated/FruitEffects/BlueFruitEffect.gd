extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"

const IceExplosion_01 = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruit_Blue_Assets/FruitBlue_Explosion01.png")
const IceExplosion_02 = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruit_Blue_Assets/FruitBlue_Explosion02.png")
const IceExplosion_03 = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruit_Blue_Assets/FruitBlue_Explosion03.png")
const IceExplosion_04 = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruit_Blue_Assets/FruitBlue_Explosion04.png")
const IceExplosion_05 = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruit_Blue_Assets/FruitBlue_Explosion05.png")
const IceExplosion_06 = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruit_Blue_Assets/FruitBlue_Explosion06.png")
const IceExplosion_07 = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruit_Blue_Assets/FruitBlue_Explosion07.png")

const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")

var explosion_attack_module : AOEAttackModule
var tree

func _init().(StoreOfTowerEffectsUUID.ING_BLUE_FRUIT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_BlueFruit.png")
	description = "Tower's main attacks create an icy explosion that slows down up to 3 enemies by 22.5% for 2 seconds."


# make mod

func _make_modifications_to_tower(tower):
	tree = tower.get_tree()
	
	if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_module_enemy_hit"):
		_construct_attack_module()
		tower.add_attack_module(explosion_attack_module)
		tower.connect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_module_enemy_hit", [], CONNECT_PERSIST)


func _construct_attack_module():
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = 0
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	explosion_attack_module.on_hit_damage_scale = 0
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", IceExplosion_01)
	sprite_frames.add_frame("default", IceExplosion_02)
	sprite_frames.add_frame("default", IceExplosion_03)
	sprite_frames.add_frame("default", IceExplosion_04)
	sprite_frames.add_frame("default", IceExplosion_05)
	sprite_frames.add_frame("default", IceExplosion_06)
	sprite_frames.add_frame("default", IceExplosion_07)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 3
	explosion_attack_module.duration = 0.4
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	
	# effect
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_BLUE_FRUIT)
	slow_modifier.percent_amount = -22.5
	slow_modifier.percent_based_on = PercentType.MAX
	
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.ING_BLUE_FRUIT_SLOW)
	enemy_attr_eff.is_timebound = true
	enemy_attr_eff.time_in_seconds = 2
	
	var tower_eff : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_attr_eff, StoreOfTowerEffectsUUID.ING_BLUE_FRUIT)
	tower_eff.force_apply = true
	
	
	explosion_attack_module.on_hit_effects[StoreOfTowerEffectsUUID.ING_BLUE_FRUIT] = tower_eff


# signal

func _on_tower_main_attack_module_enemy_hit(enemy, damage_register_id, damage_instance, module):
	var explo_instance = explosion_attack_module.construct_aoe(enemy.global_position, enemy.global_position)
	
	tree.get_root().add_child(explo_instance)



# undo

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_module_enemy_hit"):
		tower.remove_attack_module(explosion_attack_module)
		explosion_attack_module.queue_free()
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_module_enemy_hit", [], CONNECT_PERSIST)

