# NOTE, Ingredient version of chaos has its own
# stats, found in TowerChaosTakeoverEffect.



extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const ChaosOrb_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_Orb.png")
const ChaosDiamond_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_Diamond.png")

const ChaosBolt01_pic = preload("res://TowerRelated/Color_Violet/Chaos/ChaosBolt_01.png")
const ChaosBolt02_pic = preload("res://TowerRelated/Color_Violet/Chaos/ChaosBolt_02.png")
const ChaosBolt03_pic = preload("res://TowerRelated/Color_Violet/Chaos/ChaosBolt_03.png")

const ChaosSword = preload("res://TowerRelated/Color_Violet/Chaos/ChaosSwordParticle.tscn")


const damage_accumulated_trigger : float = 75.0
var damage_accumulated : float = 0
var sword_attack_module : InstantDamageAttackModule


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.CHAOS)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	
	# Orb's range module
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.all_targeting_options = [Targeting.RANDOM, Targeting.FIRST, Targeting.LAST]
	range_module.set_range_shape(CircleShape2D.new())
	
	
	# Orb related
	var orb_attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	orb_attack_module.base_damage = info.base_damage
	orb_attack_module.base_damage_type = info.base_damage_type
	orb_attack_module.base_attack_speed = info.base_attk_speed
	orb_attack_module.base_attack_wind_up = 0
	orb_attack_module.base_on_hit_damage_internal_name = "chaos_orb_damage"
	orb_attack_module.is_main_attack = true
	orb_attack_module.base_pierce = info.base_pierce
	orb_attack_module.base_proj_speed = 550
	orb_attack_module.projectile_life_distance = info.base_range
	orb_attack_module.module_id = StoreOfAttackModuleID.MAIN
	orb_attack_module.position.y -= 22
	orb_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	orb_attack_module.benefits_from_bonus_attack_speed = false
	orb_attack_module.benefits_from_bonus_base_damage = true
	orb_attack_module.benefits_from_bonus_on_hit_damage = false
	orb_attack_module.benefits_from_bonus_on_hit_effect = false
	orb_attack_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	orb_attack_module.bullet_shape = bullet_shape
	orb_attack_module.bullet_scene = BaseBullet_Scene
	orb_attack_module.set_texture_as_sprite_frame(ChaosOrb_pic)
	
	orb_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated")
	
	attack_modules_and_target_num[orb_attack_module] = 1
	
	
	# Diamond related
	var dia_range_module = RangeModule_Scene.instance()
	dia_range_module.base_range_radius = info.base_range
	dia_range_module.all_targeting_options = [Targeting.RANDOM]
	dia_range_module.set_range_shape(CircleShape2D.new())
	dia_range_module.position.y += 22
	dia_range_module.can_display_range = false
	
	var diamond_attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	diamond_attack_module.base_damage = 4
	diamond_attack_module.base_damage_type = DamageType.PHYSICAL
	diamond_attack_module.base_attack_speed = 0.85
	diamond_attack_module.base_attack_wind_up = 2
	diamond_attack_module.base_on_hit_damage_internal_name = "chaos_dia_damage"
	diamond_attack_module.is_main_attack = false
	diamond_attack_module.base_pierce = 3
	diamond_attack_module.base_proj_speed = 400
	diamond_attack_module.projectile_life_distance = info.base_range
	diamond_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	diamond_attack_module.position.y -= 22
	diamond_attack_module.on_hit_damage_scale = 1
	diamond_attack_module.on_hit_effect_scale = 2
	diamond_attack_module.benefits_from_bonus_attack_speed = false
	diamond_attack_module.benefits_from_bonus_base_damage = true
	diamond_attack_module.benefits_from_bonus_on_hit_damage = true
	diamond_attack_module.benefits_from_bonus_on_hit_effect = true
	
	diamond_attack_module.use_self_range_module = true
	diamond_attack_module.range_module = dia_range_module
	
	var diamond_shape = RectangleShape2D.new()
	diamond_shape.extents = Vector2(11, 7)
	
	diamond_attack_module.bullet_shape = diamond_shape
	diamond_attack_module.bullet_scene = BaseBullet_Scene
	diamond_attack_module.set_texture_as_sprite_frame(ChaosDiamond_pic)
	
	diamond_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated")
	
	attack_modules_and_target_num[diamond_attack_module] = 1
	
	
	# Bolt related
	var bolt_range_module = RangeModule_Scene.instance()
	bolt_range_module.base_range_radius = info.base_range
	bolt_range_module.all_targeting_options = [Targeting.RANDOM]
	bolt_range_module.set_range_shape(CircleShape2D.new())
	bolt_range_module.position.y += 22
	bolt_range_module.can_display_range = false
	
	var bolt_attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	bolt_attack_module.base_damage = 1
	bolt_attack_module.base_damage_type = DamageType.ELEMENTAL
	bolt_attack_module.base_attack_speed = 1.3
	bolt_attack_module.base_attack_wind_up = 0
	bolt_attack_module.is_main_attack = false
	bolt_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	bolt_attack_module.position.y -= 22
	bolt_attack_module.base_on_hit_damage_internal_name = "chaos_bolt"
	bolt_attack_module.base_damage_scale = 1.5
	bolt_attack_module.benefits_from_bonus_attack_speed = true
	bolt_attack_module.benefits_from_bonus_base_damage = true
	bolt_attack_module.benefits_from_bonus_on_hit_damage = false
	bolt_attack_module.benefits_from_bonus_on_hit_effect = false
	
	bolt_attack_module.use_self_range_module = true
	bolt_attack_module.range_module = bolt_range_module
	
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", ChaosBolt01_pic)
	beam_sprite_frame.add_frame("default", ChaosBolt02_pic)
	beam_sprite_frame.add_frame("default", ChaosBolt03_pic)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	bolt_attack_module.beam_scene = BeamAesthetic_Scene
	bolt_attack_module.beam_sprite_frames = beam_sprite_frame
	bolt_attack_module.beam_is_timebound = true
	bolt_attack_module.beam_time_visible = 0.15
	
	bolt_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated")
	
	attack_modules_and_target_num[bolt_attack_module] = 1
	
	
	# Sword related
	
	sword_attack_module = InstantDamageAttackModule_Scene.instance()
	sword_attack_module.base_damage = 9
	sword_attack_module.base_damage_type = DamageType.PHYSICAL
	sword_attack_module.base_attack_speed = 0
	sword_attack_module.base_attack_wind_up = 0
	sword_attack_module.is_main_attack = false
	sword_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	sword_attack_module.base_on_hit_damage_internal_name = "chaos_sword"
	sword_attack_module.on_hit_damage_scale = 1
	sword_attack_module.range_module = range_module
	sword_attack_module.base_damage_scale = 5
	sword_attack_module.benefits_from_bonus_attack_speed = false
	sword_attack_module.benefits_from_bonus_base_damage = true
	sword_attack_module.benefits_from_bonus_on_hit_damage = false
	sword_attack_module.benefits_from_bonus_on_hit_effect = false
	
	sword_attack_module.connect("in_attack", self, "_show_attack_sprite_on_attack")
	
	attack_modules_and_target_num[sword_attack_module] = 1
	sword_attack_module.can_be_commanded_by_tower = false
	
	_post_inherit_ready()


# Sword related

func _on_round_end():
	._on_round_end()
	
	damage_accumulated = 0


func _add_damage_accumulated(damage : float, damage_type : int, killed_enemy : bool, enemy, damage_register_id : int, module):
	damage_accumulated += damage
	_check_damage_accumulated()

func _check_damage_accumulated():
	if damage_accumulated >= damage_accumulated_trigger:
		var success = sword_attack_module.attempt_find_then_attack_enemies(1)
		if success:
			damage_accumulated = 0

# Showing sword related

func _construct_attack_sprite_on_attack():
	return ChaosSword.instance()


func _show_attack_sprite_on_attack(_attk_speed_delay, enemies : Array):
	for enemy in enemies:
		if enemy != null:
			var sword = _construct_attack_sprite_on_attack()
			sword.global_position = enemies[0].global_position
			get_tree().get_root().add_child(sword)
			sword.playing = true
