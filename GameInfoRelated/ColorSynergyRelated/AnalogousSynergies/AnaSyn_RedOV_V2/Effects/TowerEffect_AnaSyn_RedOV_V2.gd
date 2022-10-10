extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const TowerDamageInstanceScaleBoostEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerDamageInstanceScaleBoostEffect.gd")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const BeamAestheticPool = preload("res://MiscRelated/PoolRelated/Implementations/BeamAestheticPool.gd")

const RedOV_DmgBoostEffect01_StatBarIcon_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/RedOV_DmgBoostEffect_StatusBarIcon.png")
const RedOV_DmgBoostEffect02_StatBarIcon_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/RedOV_DmgBoostEffect02_StatusBarIcon.png")
const RedOV_BuffBeam01 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/BeamBuff/RedOV_BeamBuff_01.png")
const RedOV_BuffBeam02 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/BeamBuff/RedOV_BeamBuff_02.png")
const RedOV_BuffBeam03 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/BeamBuff/RedOV_BeamBuff_03.png")
const RedOV_BuffBeam04 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/BeamBuff/RedOV_BeamBuff_04.png")
const RedOV_BuffBeam05 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/BeamBuff/RedOV_BeamBuff_05.png")
const RedOV_BuffBeam06 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/BeamBuff/RedOV_BeamBuff_06.png")
const RedOV_BuffBeam07 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/BeamBuff/RedOV_BeamBuff_07.png")
const RedOV_BuffBeam08 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/BeamBuff/RedOV_BeamBuff_08.png")
const RedOV_BuffBeam09 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Assets/BeamBuff/RedOV_BeamBuff_09.png")

const RedOV_EmpoweredParticle = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Subs/RedOV_EmpoweredParticle.gd")
const RedOV_EmpoweredParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Subs/RedOV_EmpoweredParticle.tscn")


var base_dmg_scale_boost_amount : float 
var empowered_bonus_dmg_scale_boost_amount : float
var _is_empowered : bool

var main_attacks_for_dmg_amp_trigger : int
var _current_main_attack_count_for_dmg_amp_trigger : int

var dmg_amp_trigger_before_empower : int
var _current_dmg_amp_trigger_count : int

var buff_duration : float

var attached_tower
var tower_detecting_range_module : TowerDetectingRangeModule

var empower_particle_effect : RedOV_EmpoweredParticle
var red_buff_beam_aesthetic_pool : BeamAestheticPool
var red_buff_beam_sprite_frames : SpriteFrames
const _red_buff_beam_time_visible : float = 0.25

#

func _init().(StoreOfTowerEffectsUUID.RED_OV_V2_GIVER_EFFECT):
	pass



func _make_modifications_to_tower(tower):
	attached_tower = tower
	
	if tower_detecting_range_module == null:
		_construct_tower_detecting_range_module()
	
	if red_buff_beam_aesthetic_pool == null:
		_construct_red_buff_beam_aesthetic_pool()
	
	if !tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
		tower.connect("on_main_attack", self, "_on_tower_main_attack", [], CONNECT_PERSIST | CONNECT_DEFERRED)

func _construct_tower_detecting_range_module():
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.mirror_tower_range_module_range_changes(attached_tower)
	attached_tower.add_child(tower_detecting_range_module)

func _construct_red_buff_beam_aesthetic_pool():
	red_buff_beam_sprite_frames = SpriteFrames.new()
	red_buff_beam_sprite_frames.add_frame("default", RedOV_BuffBeam01)
	red_buff_beam_sprite_frames.add_frame("default", RedOV_BuffBeam02)
	red_buff_beam_sprite_frames.add_frame("default", RedOV_BuffBeam03)
	red_buff_beam_sprite_frames.add_frame("default", RedOV_BuffBeam04)
	red_buff_beam_sprite_frames.add_frame("default", RedOV_BuffBeam05)
	red_buff_beam_sprite_frames.add_frame("default", RedOV_BuffBeam06)
	red_buff_beam_sprite_frames.add_frame("default", RedOV_BuffBeam07)
	red_buff_beam_sprite_frames.add_frame("default", RedOV_BuffBeam08)
	red_buff_beam_sprite_frames.add_frame("default", RedOV_BuffBeam09)
	
	red_buff_beam_aesthetic_pool = BeamAestheticPool.new()
	red_buff_beam_aesthetic_pool.node_to_parent = attached_tower.get_tree().get_root()
	red_buff_beam_aesthetic_pool.node_to_listen_for_queue_free = attached_tower
	red_buff_beam_aesthetic_pool.source_of_create_resource = self
	red_buff_beam_aesthetic_pool.func_name_for_create_resource = "_create_buff_beam"


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.disconnect("on_round_end", self, "_on_round_end")
		tower.disconnect("on_main_attack", self, "_on_tower_main_attack")
	
	if is_instance_valid(tower_detecting_range_module):
		tower_detecting_range_module.queue_free()
	
	if is_instance_valid(empower_particle_effect):
		empower_particle_effect.queue_free()
		empower_particle_effect = null
	
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_OV_V2_DMG_AMP_EFFECT)
	if effect != null:
		tower.remove_tower_effect(effect)
	
	var emp_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_OV_V2_DMG_AMP_EMP_BONUS_EFFECT)
	if emp_effect != null:
		tower.remove_tower_effect(emp_effect)


#

func _on_round_end():
	_current_dmg_amp_trigger_count = 0
	_current_main_attack_count_for_dmg_amp_trigger = 0
	_is_empowered = false
	if is_instance_valid(empower_particle_effect):
		empower_particle_effect.queue_free()
		empower_particle_effect = null

func _on_tower_main_attack(attk_speed_delay, enemies, module):
	_current_main_attack_count_for_dmg_amp_trigger += 1
	if _current_main_attack_count_for_dmg_amp_trigger >= main_attacks_for_dmg_amp_trigger:
		_buff_towers_nearby()
		
		_current_main_attack_count_for_dmg_amp_trigger = 0
		_current_dmg_amp_trigger_count += 1
		if _current_dmg_amp_trigger_count >= dmg_amp_trigger_before_empower and !_is_empowered:
			_empower_curr_dmg_buff_effect_amount()

func _buff_towers_nearby():
	for tower in tower_detecting_range_module.get_all_in_map_towers_in_range():
		var dmg_scale_effect = _construct_new_base_dmg_scale_effect()
		tower.add_tower_effect(dmg_scale_effect)
		
		if _is_empowered:
			var emp_dmg_scale_effect = _construct_new_emp_bonus_dmg_scale_effect()
			tower.add_tower_effect(emp_dmg_scale_effect)
		
		
		var beam = red_buff_beam_aesthetic_pool.get_or_create_resource_from_pool()
		beam.frame = 0
		beam.time_visible = _red_buff_beam_time_visible
		beam.position = attached_tower.global_position
		beam.update_destination_position(tower.global_position)
		beam.visible = true

func _construct_new_base_dmg_scale_effect() -> TowerDamageInstanceScaleBoostEffect:
	var effect = TowerDamageInstanceScaleBoostEffect.new(TowerDamageInstanceScaleBoostEffect.DmgInstanceTypesToBoost.ANY, TowerDamageInstanceScaleBoostEffect.DmgInstanceBoostType.BASE_AND_ON_HIT_DMG_ONLY, base_dmg_scale_boost_amount, StoreOfTowerEffectsUUID.RED_OV_V2_DMG_AMP_EFFECT)
	effect.time_in_seconds = buff_duration
	effect.is_timebound = true
	effect.status_bar_icon = RedOV_DmgBoostEffect01_StatBarIcon_Pic
	
	return effect

func _construct_new_emp_bonus_dmg_scale_effect() -> TowerDamageInstanceScaleBoostEffect:
	var effect = TowerDamageInstanceScaleBoostEffect.new(TowerDamageInstanceScaleBoostEffect.DmgInstanceTypesToBoost.ANY, TowerDamageInstanceScaleBoostEffect.DmgInstanceBoostType.BASE_AND_ON_HIT_DMG_ONLY, empowered_bonus_dmg_scale_boost_amount, StoreOfTowerEffectsUUID.RED_OV_V2_DMG_AMP_EMP_BONUS_EFFECT)
	effect.time_in_seconds = buff_duration
	effect.is_timebound = true
	effect.status_bar_icon = RedOV_DmgBoostEffect02_StatBarIcon_Pic
	
	return effect


func _empower_curr_dmg_buff_effect_amount():
	_is_empowered = true
	
	if !is_instance_valid(empower_particle_effect):
		empower_particle_effect = RedOV_EmpoweredParticle_Scene.instance()
		empower_particle_effect.tower = attached_tower
		attached_tower.get_tree().get_root().add_child(empower_particle_effect)

#

func _create_buff_beam():
	var beam = BeamAesthetic_Scene.instance()
	beam.modulate.a = 0.75
	beam.set_sprite_frames(red_buff_beam_sprite_frames)
	
	beam.frame = 0
	beam.time_visible = _red_buff_beam_time_visible
	beam.is_timebound = true
	beam.queue_free_if_time_over = false
	beam.play_only_once(true)
	beam.set_frame_rate_based_on_lifetime()
	
	attached_tower.get_tree().get_root().add_child(beam)
	
	return beam
