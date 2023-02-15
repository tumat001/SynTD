extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")

const Biomorph_IngBeam_Pic = preload("res://TowerRelated/Color_Violet/BioMorph/IngAssets/Biomorph_Ing_Beam.png")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")

const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")



const base_laser_dmg : float = 0.25
const laser_attk_speed : float = 4.0
const laser_dmg_type = DamageType.ELEMENTAL


#const life_lost_breakpoints : Array = [
#	16,
#	12,
#	8,
#	4,
#	1,
#]
const life_lost_to_laser_count_map : Dictionary = {
	16 : 5,
	12 : 4,
	8 : 3,
	4 : 2,
	1 : 1,
}
var life_lost_breakpoints = life_lost_to_laser_count_map.keys()

#

var _effects_applied : bool

var _tower
var _current_laser_count : int

var laser_attack_module : WithBeamInstantDamageAttackModule

#

func _init().(StoreOfTowerEffectsUUID.ING_BIOMORPH):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_BiomorphBeam.png")
	#
	_update_description()
	
	_can_be_scaled_by_yel_vio = true


func _update_description():
	
	var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
	interpreter_for_flat_on_hit.display_body = false
	
	var ins_for_flat_on_hit = []
	ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, laser_dmg_type, "damage", base_laser_dmg * _current_additive_scale))
	
	interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
	
	#
	
	var current_bonus_desc = ""
	if _effects_applied:
		current_bonus_desc = " (Current laser count: %s)." % _current_laser_count
	
	
	description = ["Fire 1 to 5 lasers, depending on lives lost in the round. Each laser deals |0| every %s seconds.%s%s" % [base_laser_dmg, current_bonus_desc, str(_generate_desc_for_persisting_total_additive_scaling(true))], [interpreter_for_flat_on_hit]]

##

func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_effects_applied:
		_effects_applied = true
		
		

func _construct_laser_attk_module():
	
	laser_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	laser_attack_module.base_damage = base_laser_dmg
	laser_attack_module.base_damage_type = DamageType.ELEMENTAL
	laser_attack_module.base_attack_speed = 4
	laser_attack_module.base_attack_wind_up = 0
	laser_attack_module.is_main_attack = false
	laser_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	laser_attack_module.position.y -= _y_shift_of_laser_attk_module
	laser_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	laser_attack_module.on_hit_damage_scale = 0
	
	laser_attack_module.benefits_from_bonus_on_hit_damage = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Biomorph_Beam_Pic)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	laser_attack_module.beam_scene = BeamAesthetic_Scene
	laser_attack_module.beam_sprite_frames = beam_sprite_frame
	
	laser_attack_module.set_image_as_tracker_image(Biomorph_Beam_Pic)
	
	
	
	add_attack_module(laser_attack_module)
	
