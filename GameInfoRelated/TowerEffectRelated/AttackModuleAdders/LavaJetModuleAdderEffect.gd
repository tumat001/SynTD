extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

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

const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")

const Ingredient_pic = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_LavaJetBeam.png")

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

var lava_jet_beam_am : WithBeamInstantDamageAttackModule
const num_of_attacks_before_beam : int = 5
var _curr_num_of_attacks : int = 0


func _init().(StoreOfTowerEffectsUUID.LAVA_JET_BEAM):
	effect_icon = Ingredient_pic
	description = "Shoots a lava beam at the current enemy every 5th main attack. The beam deals 40% of the enemy's max health damage as elemental damage, up to a limit."



func _make_modifications_to_tower(tower : AbstractTower):
	_construct_lava_jet_module()
	
	tower.add_attack_module(lava_jet_beam_am)
	tower.connect("on_main_attack", self, "_on_main_tower_attack")
	tower.connect("on_round_end", self, "_on_round_end")


func _construct_lava_jet_module():
	var beam_attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	beam_attack_module.base_damage = 0
	beam_attack_module.base_damage_type = DamageType.ELEMENTAL
	beam_attack_module.base_attack_speed = 0
	beam_attack_module.base_attack_wind_up = 0
	beam_attack_module.is_main_attack = false
	beam_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	beam_attack_module.position.y -= 0
	beam_attack_module.base_on_hit_damage_internal_name = "lavajet_beam"
	beam_attack_module.on_hit_damage_scale = 1
	
	beam_attack_module.benefits_from_bonus_attack_speed = false
	beam_attack_module.benefits_from_bonus_base_damage = false
	beam_attack_module.benefits_from_bonus_on_hit_damage = false
	beam_attack_module.benefits_from_bonus_on_hit_effect = false
	
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
	
	var percent_mod : PercentModifier = PercentModifier.new("lavajet_beam_ing")
	percent_mod.percent_amount = 40
	percent_mod.percent_based_on = PercentType.MAX
	percent_mod.flat_maximum = 100 # Max damage on enemy with 250 max health
	percent_mod.ignore_flat_limits = false
	
	var beam_on_hit_dmg : OnHitDamage = OnHitDamage.new("lavajet_beam_ing", percent_mod, DamageType.ELEMENTAL)
	var effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(beam_on_hit_dmg, StoreOfTowerEffectsUUID.ING_LAVA_JET)
	effect.force_apply = true
	
	beam_attack_module.on_hit_damage_adder_effects[effect.effect_uuid] = effect


func _on_main_tower_attack(attack_delay, enemies, module):
	_curr_num_of_attacks += 1
	
	if _curr_num_of_attacks >= num_of_attacks_before_beam:
		_curr_num_of_attacks = 0
		lava_jet_beam_am._attack_enemies(enemies)


func _on_round_end():
	_curr_num_of_attacks = 0



func _undo_modifications_to_tower(tower : AbstractTower):
	tower.disconnect("on_main_attack", self, "_on_main_tower_attack")
	tower.disconnect("on_round_end", self, "_on_round_end")
	
	if lava_jet_beam_am != null:
		tower.remove_attack_module(lava_jet_beam_am)
		lava_jet_beam_am.queue_free()

