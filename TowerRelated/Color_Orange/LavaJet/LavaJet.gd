extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const LavaJet_Bullet_Pic = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJetBullet.png")

const LavaJet_Beam01 = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_Beam/LavaJetBeam_01.png")
const LavaJet_Beam02 = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_Beam/LavaJetBeam_02.png")
const LavaJet_Beam03 = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_Beam/LavaJetBeam_03.png")
const LavaJet_Beam04 = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_Beam/LavaJetBeam_04.png")
const LavaJet_Beam05 = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_Beam/LavaJetBeam_05.png")
const LavaJet_Beam06 = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_Beam/LavaJetBeam_06.png")
const LavaJet_Beam07 = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_Beam/LavaJetBeam_07.png")
const LavaJet_Beam08 = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_Beam/LavaJetBeam_08.png")
const LavaJet_Beam09 = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_Beam/LavaJetBeam_09.png")


const num_of_attacks_before_beam : int = 5
var _curr_num_of_attacks : int = 0

var lava_jet_beam_am : WithBeamInstantDamageAttackModule

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.LAVA_JET)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 10
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_name = "sprinkler_base_damage"
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 400
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 10
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(LavaJet_Bullet_Pic)
	
	attack_module.connect("in_attack", self, "_on_attack_of_lavajet_bullet")
	
	add_attack_module(attack_module)
	
	# Lava Beam
	
	var beam_attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	beam_attack_module.base_damage = 0
	beam_attack_module.base_damage_type = DamageType.ELEMENTAL
	beam_attack_module.base_attack_speed = 0
	beam_attack_module.base_attack_wind_up = 0
	beam_attack_module.is_main_attack = false
	beam_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	beam_attack_module.position.y -= 10
	beam_attack_module.base_on_hit_damage_internal_name = "lavajet_beam"
	beam_attack_module.on_hit_damage_scale = 1
	
	beam_attack_module.benefits_from_bonus_attack_speed = false
	beam_attack_module.benefits_from_bonus_base_damage = false
	beam_attack_module.benefits_from_bonus_on_hit_damage = false
	beam_attack_module.benefits_from_bonus_on_hit_effect = false
	
	beam_attack_module.range_module = range_module
	#attack_module.attack_sprite_scene = Tesla_Hit_Particle
	#attack_module.attack_sprite_follow_enemy = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", LavaJet_Beam01)
	beam_sprite_frame.add_frame("default", LavaJet_Beam02)
	beam_sprite_frame.add_frame("default", LavaJet_Beam03)
	beam_sprite_frame.add_frame("default", LavaJet_Beam04)
	beam_sprite_frame.add_frame("default", LavaJet_Beam05)
	beam_sprite_frame.add_frame("default", LavaJet_Beam06)
	beam_sprite_frame.add_frame("default", LavaJet_Beam07)
	beam_sprite_frame.add_frame("default", LavaJet_Beam08)
	beam_sprite_frame.add_frame("default", LavaJet_Beam09)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 45)
	
	beam_attack_module.beam_scene = BeamAesthetic_Scene
	beam_attack_module.beam_sprite_frames = beam_sprite_frame
	beam_attack_module.beam_is_timebound = true
	beam_attack_module.beam_time_visible = 0.2
	
	beam_attack_module.can_be_commanded_by_tower = false
	
	lava_jet_beam_am = beam_attack_module
	
	add_attack_module(beam_attack_module)
	
	var percent_mod : PercentModifier = PercentModifier.new("lavajet_beam")
	percent_mod.percent_amount = 50
	percent_mod.percent_based_on = PercentType.MAX
	percent_mod.flat_maximum = 125 # Max damage on enemy with 250 max health
	percent_mod.ignore_flat_limits = false
	
	var beam_on_hit_dmg : OnHitDamage = OnHitDamage.new("lavajet_beam", percent_mod, DamageType.ELEMENTAL)
	var effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(beam_on_hit_dmg, StoreOfTowerEffectsUUID.LAVA_JET_BEAM)
	effect.force_apply = true
	
	_add_on_hit_damage_adder_effect(effect, [beam_attack_module])
	
	_post_inherit_ready()


func _on_attack_of_lavajet_bullet(attk_spd_delay, enemies : Array):
	_curr_num_of_attacks += 1
	
	if _curr_num_of_attacks >= num_of_attacks_before_beam:
		_curr_num_of_attacks = 0
		lava_jet_beam_am._attack_enemies(enemies)


func _on_round_end():
	._on_round_end()
	
	_curr_num_of_attacks = 0
