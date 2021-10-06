extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"


const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")

const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const BlackBeam_Pic01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackBeam/BlackBeam_01.png")
const BlackBeam_Pic02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackBeam/BlackBeam_02.png")
const BlackBeam_Pic03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackBeam/BlackBeam_03.png")
const BlackBeam_Pic04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackBeam/BlackBeam_04.png")
const BlackBeam_Pic05 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackBeam/BlackBeam_05.png")
const BlackBeam_Pic06 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackBeam/BlackBeam_06.png")
const BlackBeam_Pic07 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackBeam/BlackBeam_07.png")
const BlackBeam_Pic08 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackBeam/BlackBeam_08.png")
const BlackBeam_Pic09 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackBeam/BlackBeam_09.png")

const Black_AttackModule_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/AMAssets/Black_AttackModule_Icon.png")


const _stack_amount_trigger : int = 10

const _beam_cooldown : float = 0.1
const _beam_base_damage : float = 1.5


var black_beam_attack_module : WithBeamInstantDamageAttackModule
var attached_tower
var own_timer : Timer

func _init().(StoreOfTowerEffectsUUID.BLACK_BLACK_BEAM_AM):
	pass


func _make_modifications_to_tower(tower):
	attached_tower = tower
	
	if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit"):
		tower.connect("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit", [], CONNECT_PERSIST)
	
	if own_timer == null:
		own_timer = Timer.new()
		own_timer.one_shot = true
		own_timer.wait_time = 0.1
		tower.get_tree().get_root().add_child(own_timer)
	
	
	if black_beam_attack_module == null:
		_construct_beam_am()
		tower.add_attack_module(black_beam_attack_module)


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit")
	
	if own_timer != null:
		own_timer.queue_free()
		own_timer = null
	
	if black_beam_attack_module != null:
		tower.remove_attack_module(black_beam_attack_module)
		black_beam_attack_module.queue_free()
		black_beam_attack_module = null

#

func _construct_beam_am():
	black_beam_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	black_beam_attack_module.base_damage_scale = 0.3
	black_beam_attack_module.base_damage = _beam_base_damage / black_beam_attack_module.base_damage_scale
	black_beam_attack_module.base_damage_type = DamageType.PHYSICAL
	black_beam_attack_module.base_attack_speed = 0
	black_beam_attack_module.base_attack_wind_up = 1 / 0.15
	black_beam_attack_module.is_main_attack = false
	black_beam_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	black_beam_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	black_beam_attack_module.on_hit_damage_scale = 0.3
	
	black_beam_attack_module.commit_to_targets_of_windup = true
	black_beam_attack_module.fill_empty_windup_target_slots = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", BlackBeam_Pic01)
	beam_sprite_frame.add_frame("default", BlackBeam_Pic02)
	beam_sprite_frame.add_frame("default", BlackBeam_Pic03)
	beam_sprite_frame.add_frame("default", BlackBeam_Pic04)
	beam_sprite_frame.add_frame("default", BlackBeam_Pic05)
	beam_sprite_frame.add_frame("default", BlackBeam_Pic06)
	beam_sprite_frame.add_frame("default", BlackBeam_Pic07)
	beam_sprite_frame.add_frame("default", BlackBeam_Pic08)
	beam_sprite_frame.add_frame("default", BlackBeam_Pic09)
	beam_sprite_frame.set_animation_speed("default", 9 / 0.15)
	beam_sprite_frame.set_animation_loop("default", false)
	
	black_beam_attack_module.beam_scene = BeamAesthetic_Scene
	black_beam_attack_module.beam_sprite_frames = beam_sprite_frame
	black_beam_attack_module.beam_is_timebound = true
	black_beam_attack_module.beam_time_visible = 0.15
	
	black_beam_attack_module.show_beam_at_windup = true
	black_beam_attack_module.show_beam_regardless_of_state = true
	black_beam_attack_module.can_be_commanded_by_tower = false
	
	black_beam_attack_module.set_image_as_tracker_image(Black_AttackModule_Icon)


func _on_main_attk_module_enemy_hit(enemy, damage_register_id, damage_instance, module):
	if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.BLACK_CORRUPTION_STACK):
		var effect = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.BLACK_CORRUPTION_STACK]
		
		if effect._current_stack >= _stack_amount_trigger:
			call_deferred("_attempt_command_am_to_attack")

func _attempt_command_am_to_attack():
	if own_timer.time_left <= 0:
		_command_am_to_attack()
		own_timer.start(_beam_cooldown)

func _command_am_to_attack():
	if attached_tower.main_attack_module != null and attached_tower.main_attack_module.range_module != null:
		var range_module = attached_tower.main_attack_module.range_module
		
		var decided_target = range_module.get_targets_without_affecting_self_current_targets(1, Targeting.RANDOM)
		if decided_target.size() != 0:
			black_beam_attack_module.on_command_attack_enemies_and_attack_when_ready([decided_target[0]])



