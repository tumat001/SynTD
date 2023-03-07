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

const Biomorph_HeartSourcePic_Normal = preload("res://TowerRelated/Color_Violet/BioMorph/IngAssets/Biomorph_HeartBeamSource.png")
const Biomorph_HeartSourcePic_Emp = preload("res://TowerRelated/Color_Violet/BioMorph/IngAssets/Biomorph_HeartBeamSource_Empowered.png")



const base_laser_dmg : float = 0.25
const laser_attk_speed : float = 4.0
const laser_dmg_type = DamageType.ELEMENTAL


const life_lost_breakpoints : Array = [
	16,
	12,
	8,
	4,
	1,
]
const life_lost_to_laser_count_map : Dictionary = {
	16 : 5,
	12 : 4,
	8 : 3,
	4 : 2,
	1 : 1,
}
const highest_life_breakpoint_val : int = life_lost_breakpoints[0]
#var life_lost_breakpoints = life_lost_to_laser_count_map.keys()

#

var _effects_applied : bool

var _tower
var _current_laser_count : int = 0
var _current_lives_lost_in_round : float


const no_life_lost_clause_id : int = -10
var laser_attack_module : WithBeamInstantDamageAttackModule

var _dmg_scale : float = 1

#

var heart_sprite : Sprite

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
	ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, laser_dmg_type, "damage", base_laser_dmg * _current_additive_scale * _dmg_scale))
	
	interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
	
	#
	
	var current_bonus_desc = ""
	if _effects_applied:
		current_bonus_desc = " (Current laser count: %s)." % _current_laser_count
	
	
	description = ["Fire 1 to 5 lasers, depending on lives lost in the round. Each laser deals |0| every %s seconds.%s%s" % [base_laser_dmg, current_bonus_desc, str(_generate_desc_for_persisting_total_additive_scaling(true))], [interpreter_for_flat_on_hit]]
	
	emit_signal("description_updated")

##

func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_effects_applied:
		_effects_applied = true
		
		
		_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_DEFERRED | CONNECT_PERSIST)
		_tower.game_elements.health_manager.connect("health_decreased_by", self, "_on_player_health_decreased_by", [], CONNECT_PERSIST)
		
		_construct_heart_sprite()
		_construct_laser_attk_module()
		
		_update_description()


func _undo_modifications_to_tower(tower):
	
	if _effects_applied:
		if is_instance_valid(laser_attack_module):
			tower.remove_attack_module(laser_attack_module)
			laser_attack_module.queue_free()
			laser_attack_module = null
		
		_tower.disconnect("on_round_end", self, "_on_round_end")
		_tower.game_elements.health_manager.disconnect("health_decreased_by", self, "_on_player_health_decreased_by")
		


func _construct_heart_sprite():
	heart_sprite = Sprite.new()


func _construct_laser_attk_module():
	
	laser_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	laser_attack_module.base_damage = base_laser_dmg
	laser_attack_module.base_damage_type = DamageType.ELEMENTAL
	laser_attack_module.base_attack_speed = 4
	laser_attack_module.base_attack_wind_up = 0
	laser_attack_module.is_main_attack = false
	laser_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	laser_attack_module.position.y -= _tower.last_calc_vec_shift_from_pos_zero_to_top_left.y
	laser_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	laser_attack_module.on_hit_damage_scale = 0
	
	laser_attack_module.benefits_from_bonus_on_hit_damage = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Biomorph_IngBeam_Pic)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	laser_attack_module.beam_scene = BeamAesthetic_Scene
	laser_attack_module.beam_sprite_frames = beam_sprite_frame
	
	laser_attack_module.set_image_as_tracker_image(effect_icon)
	
	laser_attack_module.add_child(heart_sprite)
	laser_attack_module.connect("on_damage_instance_constructed", self, "_on_laser_damage_instance_constructed")
	
	laser_attack_module.number_of_unique_targets = 1
	
	
	set_num_of_lives_lost_this_round(0)
	
	_tower.add_attack_module(laser_attack_module)
	

#

func set_num_of_lives_lost_this_round(arg_val):
	_current_lives_lost_in_round = arg_val
	
	if _current_lives_lost_in_round > 0:
		
		for life_loss_breakpoint in life_lost_breakpoints:
			if _current_lives_lost_in_round > life_loss_breakpoint:
				
				set_num_of_laser_count(life_lost_to_laser_count_map[life_loss_breakpoint])
				
				if life_loss_breakpoint == highest_life_breakpoint_val:
					heart_sprite.texture = Biomorph_HeartSourcePic_Emp
				else:
					heart_sprite.texture = Biomorph_HeartSourcePic_Normal
				
				break
		
		heart_sprite.visible = true
		laser_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(no_life_lost_clause_id)
	else:
		
		heart_sprite.visible = false
		laser_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(no_life_lost_clause_id)
		laser_attack_module.hide_all_beams()
		
		set_num_of_laser_count(0)


func set_num_of_laser_count(arg_val):
	var is_diff = _current_laser_count != arg_val
	
	_current_laser_count = arg_val
	
	if is_diff:
		if is_instance_valid(laser_attack_module):
			laser_attack_module.number_of_unique_targets = arg_val
			
			_update_description()

#

func _on_round_end():
	set_num_of_lives_lost_this_round(0)
	

func _on_player_health_decreased_by(arg_decrease):
	set_num_of_lives_lost_this_round(_current_lives_lost_in_round + arg_decrease)
	


func _on_laser_damage_instance_constructed(arg_dmg_instance, arg_attk_module):
	arg_dmg_instance.scale_only_damage_by(_dmg_scale)


#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	_dmg_scale = _current_additive_scale
	_current_additive_scale = 1
	
