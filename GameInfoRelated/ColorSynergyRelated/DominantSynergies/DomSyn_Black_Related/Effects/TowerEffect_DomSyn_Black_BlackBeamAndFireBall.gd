extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"


const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")

const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")


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

const Black_Fireball_Pic01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackFireBall/BlackFireBall_01.png")
const Black_Fireball_Pic02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackFireBall/BlackFireBall_02.png")
const Black_Fireball_Pic03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackFireBall/BlackFireBall_03.png")
const Black_Fireball_Pic04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackFireBall/BlackFireBall_04.png")
const Black_Fireball_Pic05 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackFireBall/BlackFireBall_05.png")
const Black_Fireball_Pic06 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/BlackFireBall/BlackFireBall_06.png")

const Black_AttackModule_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/AMAssets/Black_AttackModule_Icon.png")
const Black_Fireball_AM_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/AMAssets/Black_Fireball_AttackModule_Icon.png")

var beam_cooldown : float
var beam_base_damage : float
var beam_applies_on_hit_effects : bool
var beam_bonus_base_dmg_scale : float
var beam_bonus_on_hit_dmg_scale : float

var fireball_enabled : bool
var fireball_base_damage : float
var fireball_pierce : int
var fireball_proj_speed : float
var fireball_bonus_base_dmg_scale : float
var fireball_bonus_on_hit_dmg_scale : float
var fireball_black_beam_count_for_summon : int

var black_beam_attack_module : WithBeamInstantDamageAttackModule
var black_fireball_attack_module : BulletAttackModule

var attached_tower
var own_timer : Timer


var _black_beam_count_until_fireball : int


func _init().(StoreOfTowerEffectsUUID.BLACK_BLACK_BEAM_AM):
	pass

func _make_modifications_to_tower(tower):
	attached_tower = tower
	
	if !tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
	
	if !is_instance_valid(own_timer):
		own_timer = Timer.new()
		own_timer.one_shot = true
		own_timer.wait_time = 0.1
		tower.get_tree().get_root().add_child(own_timer)
	
	
	if !is_instance_valid(black_beam_attack_module):
		_construct_beam_am()
		tower.add_attack_module(black_beam_attack_module)
	
	if fireball_enabled:
		_construct_fireball_am()
		tower.add_attack_module(black_fireball_attack_module)
		
		if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit__with_fireball"):
			tower.connect("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit__with_fireball", [], CONNECT_PERSIST)
		
	else:
		if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit__no_fireball"):
			tower.connect("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit__no_fireball", [], CONNECT_PERSIST)
	
	
	
	_reset_black_beam_count_for_fireball()

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit__no_fireball"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit__no_fireball")
	
	if tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit__with_fireball"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_main_attk_module_enemy_hit__with_fireball")
	
	
	if tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.disconnect("on_round_end", self, "_on_round_end")
	
	
	if is_instance_valid(own_timer):
		own_timer.queue_free()
		own_timer = null
	
	if is_instance_valid(black_beam_attack_module):
		tower.remove_attack_module(black_beam_attack_module)
		black_beam_attack_module.queue_free()
		black_beam_attack_module = null
	
	if is_instance_valid(black_fireball_attack_module):
		tower.remove_attack_module(black_fireball_attack_module)
		black_fireball_attack_module.queue_free()
		black_fireball_attack_module = null

#

func _construct_beam_am():
	black_beam_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	black_beam_attack_module.base_damage_scale = beam_bonus_base_dmg_scale
	black_beam_attack_module.base_damage = beam_base_damage / black_beam_attack_module.base_damage_scale
	black_beam_attack_module.base_damage_type = DamageType.PHYSICAL
	black_beam_attack_module.base_attack_speed = 0
	black_beam_attack_module.base_attack_wind_up = 1 / 0.15
	black_beam_attack_module.is_main_attack = false
	black_beam_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	black_beam_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	black_beam_attack_module.on_hit_damage_scale = beam_bonus_on_hit_dmg_scale
	
	black_beam_attack_module.commit_to_targets_of_windup = true
	black_beam_attack_module.fill_empty_windup_target_slots = false
	
	black_beam_attack_module.benefits_from_bonus_on_hit_effect = beam_applies_on_hit_effects
	
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

func _construct_fireball_am():
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage_scale = fireball_bonus_base_dmg_scale
	attack_module.base_damage = fireball_base_damage / fireball_bonus_base_dmg_scale
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = fireball_pierce
	attack_module.base_proj_speed = fireball_proj_speed
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = fireball_bonus_on_hit_dmg_scale
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = true
	attack_module.benefits_from_bonus_on_hit_damage = true
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = false
	attack_module.benefits_from_bonus_proj_speed = false
	
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(15, 11)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Black_Fireball_Pic02)
	var sp = SpriteFrames.new()
	sp.add_frame("default", Black_Fireball_Pic01)
	sp.add_frame("default", Black_Fireball_Pic02)
	sp.add_frame("default", Black_Fireball_Pic03)
	sp.add_frame("default", Black_Fireball_Pic04)
	sp.add_frame("default", Black_Fireball_Pic05)
	sp.add_frame("default", Black_Fireball_Pic06)
	sp.set_animation_speed("default", 6 / 1)
	sp.set_animation_loop("default", true)
	attack_module.bullet_sprite_frames = sp
	
	
	attack_module.can_be_commanded_by_tower = false
	
	attack_module.set_image_as_tracker_image(Black_Fireball_AM_Icon)
	
	black_fireball_attack_module = attack_module


func _on_main_attk_module_enemy_hit__no_fireball(enemy, damage_register_id, damage_instance, module):
	call_deferred("_attempt_command_am_to_attack__no_fireball")

func _attempt_command_am_to_attack__no_fireball():
	if own_timer.time_left <= 0:
		_command_black_beam_am_to_attack__no_fireball()
		own_timer.start(beam_cooldown)

func _command_black_beam_am_to_attack__no_fireball():
	if is_instance_valid(attached_tower.main_attack_module) and is_instance_valid(attached_tower.main_attack_module.range_module):
		var range_module = attached_tower.main_attack_module.range_module
		
		var decided_target = range_module.get_targets_without_affecting_self_current_targets(1, Targeting.RANDOM)
		if decided_target.size() != 0:
			black_beam_attack_module.on_command_attack_enemies_and_attack_when_ready([decided_target[0]])

#


func _on_main_attk_module_enemy_hit__with_fireball(enemy, damage_register_id, damage_instance, module):
	call_deferred("_attempt_command_am_to_attack__with_fireball")

func _attempt_command_am_to_attack__with_fireball():
	if own_timer.time_left <= 0:
		_command_black_beam_am_to_attack__with_fireball()
		own_timer.start(beam_cooldown)

func _command_black_beam_am_to_attack__with_fireball():
	_black_beam_count_until_fireball -= 1
	
	if _black_beam_count_until_fireball > 0:
		if is_instance_valid(attached_tower.main_attack_module) and is_instance_valid(attached_tower.main_attack_module.range_module):
			var range_module = attached_tower.main_attack_module.range_module
			
			var decided_target = range_module.get_targets_without_affecting_self_current_targets(1, Targeting.RANDOM)
			if decided_target.size() != 0:
				black_beam_attack_module.on_command_attack_enemies_and_attack_when_ready([decided_target[0]])
	else:
		_command_black_fireball_am_to_attack()
		_reset_black_beam_count_for_fireball()


func _command_black_fireball_am_to_attack():
	if is_instance_valid(attached_tower.main_attack_module) and is_instance_valid(attached_tower.main_attack_module.range_module):
		var range_module = attached_tower.main_attack_module.range_module
		
		var decided_target = range_module.get_targets_without_affecting_self_current_targets(1, Targeting.RANDOM)
		if decided_target.size() != 0:
			black_fireball_attack_module.on_command_attack_enemies_and_attack_when_ready([decided_target[0]])


#

func _on_round_end():
	_reset_black_beam_count_for_fireball()

func _reset_black_beam_count_for_fireball():
	_black_beam_count_until_fireball = fireball_black_beam_count_for_summon
