extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"

const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")


const Black_Explosion_Pic_01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_01.png")
const Black_Explosion_Pic_02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_02.png")
const Black_Explosion_Pic_03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_03.png")
const Black_Explosion_Pic_04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_04.png")
const Black_Explosion_Pic_05 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_05.png")
const Black_Explosion_Pic_06 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_06.png")
const Black_Explosion_Pic_07 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_07.png")
const Black_Explosion_Pic_08 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_08.png")
const Black_Explosion_Pic_09 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_09.png")
const Black_Explosion_Pic_10 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_10.png")
const Black_Explosion_Pic_11 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_11.png")
const Black_Explosion_Pic_12 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverkillExplosion/Black_Overkill_Explosion_12.png")

const Black_OverkillExp_AttkModule_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/AMAssets/Black_OverkillExp_AttackModule_Icon.png")

const Black_Overflow_TowerBar_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/GUI/Overflow_TowerBar/Black_Overflow_TowerBar.tscn")


signal on_damage_scale_changed(curr_dmg_scale, max_dmg_scale)
signal on_effect_being_removed_b()


var overkill_ratio_damage : float
var explosion_scale : float
var can_summon_overkill_explosion_from_overkill_explosion : bool
var explosion_pierce : int

var initial_delay_before_damage_scale : float
var base_damage_scale_after_initial : float
var bonus_scale_per_second_after_delay : float
var max_scale_including_base : float

var initial_delay_dmg_scale_timer : Timer
var bonus_delay_dmg_scale_timer : Timer


var explosion_attk_module : AOEAttackModule
var _attached_tower
var _current_dmg_scale : float

func _init().(StoreOfTowerEffectsUUID.BLACK_OVERKILL_ATTKMOD_GIVER):
	pass

#

func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	if !tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt_by_tower"):
		tower.connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt_by_tower", [], CONNECT_PERSIST)
	
	if !is_instance_valid(explosion_attk_module):
		_construct_and_add_explosion_attack_module()
	
	if !is_instance_valid(initial_delay_dmg_scale_timer):
		initial_delay_dmg_scale_timer = Timer.new()
		initial_delay_dmg_scale_timer.one_shot = true
		initial_delay_dmg_scale_timer.connect("timeout", self, "_on_initial_delay_dmg_scale_timer_timeout", [], CONNECT_PERSIST)
		
		tower.get_tree().get_root().add_child(initial_delay_dmg_scale_timer)
	
	if !is_instance_valid(bonus_delay_dmg_scale_timer):
		bonus_delay_dmg_scale_timer = Timer.new()
		bonus_delay_dmg_scale_timer.one_shot = true
		bonus_delay_dmg_scale_timer.connect("timeout", self, "_on_bonus_delay_dmg_scale_timer_timeout", [], CONNECT_PERSIST)
		
		tower.get_tree().get_root().add_child(bonus_delay_dmg_scale_timer)
	
	if tower.is_round_started:
		_on_round_start()
	else:
		_on_round_end()
	
	
	if !tower.is_connected("on_round_start", self, "_on_round_start"):
		tower.connect("on_round_start", self, "_on_round_start", [], CONNECT_PERSIST)
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
		tower.connect("on_any_attack_module_enemy_hit", self, "_on_tower_any_attk_module_hit_enemy", [], CONNECT_PERSIST)
	
	var overflow_towerbar = Black_Overflow_TowerBar_Scene.instance()
	tower.add_infobar_control(overflow_towerbar)
	overflow_towerbar.set_tower_and_effect(tower, self)
	
	_reset_current_dmg_scale()

func _construct_and_add_explosion_attack_module():
	explosion_attk_module = AOEAttackModule_Scene.instance()
	explosion_attk_module.base_damage_scale = 0
	explosion_attk_module.base_damage = 0
	explosion_attk_module.base_damage_type = DamageType.PHYSICAL
	explosion_attk_module.base_attack_speed = 0
	explosion_attk_module.base_attack_wind_up = 0
	explosion_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attk_module.is_main_attack = false
	explosion_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attk_module.benefits_from_bonus_explosion_scale = true
	explosion_attk_module.benefits_from_bonus_base_damage = false
	explosion_attk_module.benefits_from_bonus_attack_speed = false
	explosion_attk_module.benefits_from_bonus_on_hit_damage = false
	explosion_attk_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Black_Explosion_Pic_01)
	sprite_frames.add_frame("default", Black_Explosion_Pic_02)
	sprite_frames.add_frame("default", Black_Explosion_Pic_03)
	sprite_frames.add_frame("default", Black_Explosion_Pic_04)
	sprite_frames.add_frame("default", Black_Explosion_Pic_05)
	sprite_frames.add_frame("default", Black_Explosion_Pic_06)
	sprite_frames.add_frame("default", Black_Explosion_Pic_07)
	sprite_frames.add_frame("default", Black_Explosion_Pic_08)
	sprite_frames.add_frame("default", Black_Explosion_Pic_09)
	sprite_frames.add_frame("default", Black_Explosion_Pic_10)
	sprite_frames.add_frame("default", Black_Explosion_Pic_11)
	sprite_frames.add_frame("default", Black_Explosion_Pic_12)
	
	
	explosion_attk_module.aoe_sprite_frames = sprite_frames
	explosion_attk_module.sprite_frames_only_play_once = true
	explosion_attk_module.pierce = explosion_pierce
	explosion_attk_module.duration = 0.25
	explosion_attk_module.damage_repeat_count = 1
	
	explosion_attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attk_module.base_aoe_scene = BaseAOE_Scene
	explosion_attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attk_module.can_be_commanded_by_tower = false
	
	explosion_attk_module.tracker_image = Black_OverkillExp_AttkModule_Icon
	
	_attached_tower.add_attack_module(explosion_attk_module)

#

func _on_any_post_mitigation_damage_dealt_by_tower(damage_instance_report, killed, enemy, damage_register_id, module):
	if (module != explosion_attk_module or can_summon_overkill_explosion_from_overkill_explosion) and killed:
		var overkill_dmg : float = _get_overkill_damage(overkill_ratio_damage, damage_instance_report)
		
		if overkill_dmg > 0:
			var explosion = explosion_attk_module.construct_aoe(enemy.global_position, enemy.global_position)
			explosion.modulate.a = 0.6
			explosion.scale *= explosion_scale
			
			explosion.damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE].damage_as_modifier.flat_modifier = overkill_dmg
			
			_attached_tower.get_tree().get_root().add_child(explosion)

func _get_overkill_damage(arg_scale : float, damage_instance_report) -> float:
	var overkill_dmg = damage_instance_report.get_total_post_mitigated_damage() - damage_instance_report.get_total_effective_damage()
	return overkill_dmg * arg_scale

#

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt_by_tower"):
		tower.disconnect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt_by_tower")
	
	if is_instance_valid(explosion_attk_module):
		_attached_tower.remove_attack_module(explosion_attk_module)
		explosion_attk_module.queue_free()
	
	_attached_tower = null
	
	if is_instance_valid(initial_delay_dmg_scale_timer):
		initial_delay_dmg_scale_timer.queue_free()
	
	if is_instance_valid(bonus_delay_dmg_scale_timer):
		bonus_delay_dmg_scale_timer.queue_free()
	
	if tower.is_connected("on_round_start", self, "_on_round_start"):
		tower.disconnect("on_round_start", self, "_on_round_start")
		tower.disconnect("on_round_end", self, "_on_round_end")
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_on_tower_any_attk_module_hit_enemy")
	
	emit_signal("on_effect_being_removed_b")

##

func _on_round_start():
	initial_delay_dmg_scale_timer.paused = false
	bonus_delay_dmg_scale_timer.paused = false
	
	initial_delay_dmg_scale_timer.start(initial_delay_before_damage_scale)

func _on_round_end():
	initial_delay_dmg_scale_timer.stop()
	bonus_delay_dmg_scale_timer.stop()
	
	initial_delay_dmg_scale_timer.paused = true
	bonus_delay_dmg_scale_timer.paused = true
	
	_reset_current_dmg_scale()


#

func _on_initial_delay_dmg_scale_timer_timeout():
	_current_dmg_scale = base_damage_scale_after_initial
	
	bonus_delay_dmg_scale_timer.start(1)
	
	emit_signal("on_damage_scale_changed", _current_dmg_scale, max_scale_including_base)


func _on_bonus_delay_dmg_scale_timer_timeout():
	_current_dmg_scale += bonus_scale_per_second_after_delay
	var continue_bonus_scale_timer : bool = true
	
	if _current_dmg_scale >= max_scale_including_base:
		_current_dmg_scale = max_scale_including_base
		continue_bonus_scale_timer = false
	
	if continue_bonus_scale_timer:
		bonus_delay_dmg_scale_timer.start(1)
	
	emit_signal("on_damage_scale_changed", _current_dmg_scale, max_scale_including_base)

#

func _on_tower_any_attk_module_hit_enemy(enemy, damage_register_id, damage_instance, module):
	damage_instance.scale_only_damage_by(_current_dmg_scale + 1)
	
	_reset_current_dmg_scale()
	
	initial_delay_dmg_scale_timer.start(initial_delay_before_damage_scale)
	bonus_delay_dmg_scale_timer.stop()


func _reset_current_dmg_scale():
	_current_dmg_scale = 0.0
	
	emit_signal("on_damage_scale_changed", _current_dmg_scale, max_scale_including_base)

#

