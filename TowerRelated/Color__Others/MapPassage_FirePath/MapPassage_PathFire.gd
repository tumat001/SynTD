extends "res://TowerRelated/AbstractTower.gd"

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")


var fire_path__aoe_module : AOEAttackModule
var water_path__aoe_module : AOEAttackModule


func _init():
	is_tower_hidden = true
	

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.MAP_PASSAGE__FIRE_PATH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	tower_limit_slots_taken = 0
	
	#
	
	fire_path__aoe_module = AOEAttackModule_Scene.instance()
	fire_path__aoe_module.base_damage = 0
	fire_path__aoe_module.base_damage_type = DamageType.PHYSICAL
	fire_path__aoe_module.base_attack_speed = 0
	fire_path__aoe_module.base_attack_wind_up = 0
	fire_path__aoe_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	fire_path__aoe_module.is_main_attack = false
	fire_path__aoe_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	fire_path__aoe_module.benefits_from_bonus_explosion_scale = false
	fire_path__aoe_module.benefits_from_bonus_base_damage = false
	fire_path__aoe_module.benefits_from_bonus_attack_speed = false
	fire_path__aoe_module.benefits_from_bonus_on_hit_damage = false
	fire_path__aoe_module.benefits_from_bonus_on_hit_effect = false
	fire_path__aoe_module.benefits_from_ingredient_effect = false
	
	fire_path__aoe_module.pierce = -1
	fire_path__aoe_module.duration = 1
	fire_path__aoe_module.is_decrease_duration = false
	fire_path__aoe_module.damage_repeat_count = 1
	
	fire_path__aoe_module.aoe_default_coll_shape = BaseAOEDefaultShapes.RECTANGLE
	fire_path__aoe_module.base_aoe_scene = BaseAOE_Scene
	fire_path__aoe_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	fire_path__aoe_module.can_be_commanded_by_tower = false
	
	
	fire_path__aoe_module.kill_all_created_aoe_at_round_end = false
	fire_path__aoe_module.is_displayed_in_tracker = false
	
	add_attack_module(fire_path__aoe_module)
	
	########
	
	
	water_path__aoe_module = AOEAttackModule_Scene.instance()
	water_path__aoe_module.base_damage = 0
	water_path__aoe_module.base_damage_type = DamageType.PHYSICAL
	water_path__aoe_module.base_attack_speed = 0
	water_path__aoe_module.base_attack_wind_up = 0
	water_path__aoe_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	water_path__aoe_module.is_main_attack = false
	water_path__aoe_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	water_path__aoe_module.benefits_from_bonus_explosion_scale = false
	water_path__aoe_module.benefits_from_bonus_base_damage = false
	water_path__aoe_module.benefits_from_bonus_attack_speed = false
	water_path__aoe_module.benefits_from_bonus_on_hit_damage = false
	water_path__aoe_module.benefits_from_bonus_on_hit_effect = false
	water_path__aoe_module.benefits_from_ingredient_effect = false
	
	water_path__aoe_module.pierce = -1
	water_path__aoe_module.duration = 1
	water_path__aoe_module.is_decrease_duration = false
	water_path__aoe_module.damage_repeat_count = 1
	
	water_path__aoe_module.aoe_default_coll_shape = BaseAOEDefaultShapes.RECTANGLE
	water_path__aoe_module.base_aoe_scene = BaseAOE_Scene
	water_path__aoe_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	water_path__aoe_module.can_be_commanded_by_tower = false
	
	
	water_path__aoe_module.kill_all_created_aoe_at_round_end = false
	water_path__aoe_module.is_displayed_in_tracker = false
	
	add_attack_module(water_path__aoe_module)
	
	
	#
	
	_post_inherit_ready()

func configure_fire_dmg_using_on_hit(on_hit_dmg : OnHitDamage):
	var dmg_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.MAP_PASSAGE__FIRE_PATH_DMG)
	
	_force_add_on_hit_damage_adder_effect_to_module(dmg_effect, fire_path__aoe_module)



func create_fire_path_aoe_at_pos(arg_pos : Vector2, arg_aoe_extents : Vector2):
	var aoe = fire_path__aoe_module.construct_aoe(arg_pos, arg_pos)
	#aoe.connect("tree_entered", self, "_on_aoe_entered_tree", [aoe, arg_aoe_extents], CONNECT_ONESHOT)
	var shape = RectangleShape2D.new()
	shape.extents = arg_aoe_extents
	aoe.aoe_shape_to_set_on_ready = shape
	
	fire_path__aoe_module.set_up_aoe__add_child_and_emit_signals(aoe)
	return aoe

#func _on_aoe_entered_tree(aoe, arg_aoe_extents):
#
#
#	aoe.set_coll_shape(shape)

func create_water_path_aoe_at_pos(arg_pos : Vector2, arg_aoe_extents : Vector2):
	var aoe = water_path__aoe_module.construct_aoe(arg_pos, arg_pos)
	#aoe.connect("tree_entered", self, "_on_aoe_entered_tree", [aoe, arg_aoe_extents], CONNECT_ONESHOT)
	var shape = RectangleShape2D.new()
	shape.extents = arg_aoe_extents
	aoe.aoe_shape_to_set_on_ready = shape
	
	water_path__aoe_module.set_up_aoe__add_child_and_emit_signals(aoe)
	return aoe

