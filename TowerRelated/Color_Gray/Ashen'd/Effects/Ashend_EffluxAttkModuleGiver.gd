extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const Ashend_ExplosionPic_01 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ExplosionAttk/Ashend_ExplosionAttk_01.png")
const Ashend_ExplosionPic_02 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ExplosionAttk/Ashend_ExplosionAttk_02.png")
const Ashend_ExplosionPic_03 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ExplosionAttk/Ashend_ExplosionAttk_03.png")
const Ashend_ExplosionPic_04 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ExplosionAttk/Ashend_ExplosionAttk_04.png")
const Ashend_ExplosionPic_05 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ExplosionAttk/Ashend_ExplosionAttk_05.png")
const Ashend_ExplosionPic_06 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ExplosionAttk/Ashend_ExplosionAttk_06.png")

const Efflux_StatusBarIcon = preload("res://TowerRelated/Color_Gray/Ashen'd/StatusBarIcons/Efflux_StatusBarIcon.png")


var explosion_dmg_ratio_from_main : float
var explosion_pierce : int

var explosion_attk_module : AOEAttackModule
var _attached_tower

var buff_duration_timer : Timer
var _is_buff_active : bool


#

func _init().(StoreOfTowerEffectsUUID.ASHEND_EFFLUX_EXPLOSION_AM_GIVER):
	pass


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	if explosion_attk_module == null:
		_construct_and_add_explosion_attack_module()
	
	if buff_duration_timer == null:
		buff_duration_timer = Timer.new()
		buff_duration_timer.one_shot = true
		buff_duration_timer.connect("timeout", self, "_on_buff_timer_timeout", [], CONNECT_PERSIST)
		_attached_tower.add_child(buff_duration_timer)
	
	if !_attached_tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy"):
		_attached_tower.connect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy", [], CONNECT_PERSIST)
		_attached_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
		_attached_tower.connect("on_round_start", self, "_on_round_start", [], CONNECT_PERSIST)



func _construct_and_add_explosion_attack_module():
	explosion_attk_module = AOEAttackModule_Scene.instance()
	explosion_attk_module.base_damage_scale = 0
	explosion_attk_module.base_damage = 0
	explosion_attk_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attk_module.base_attack_speed = 0
	explosion_attk_module.base_attack_wind_up = 0
	explosion_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attk_module.is_main_attack = false
	explosion_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attk_module.base_explosion_scale = 2.0
	
	explosion_attk_module.benefits_from_bonus_explosion_scale = true
	explosion_attk_module.benefits_from_bonus_base_damage = false
	explosion_attk_module.benefits_from_bonus_attack_speed = false
	explosion_attk_module.benefits_from_bonus_on_hit_damage = false
	explosion_attk_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Ashend_ExplosionPic_01)
	sprite_frames.add_frame("default", Ashend_ExplosionPic_02)
	sprite_frames.add_frame("default", Ashend_ExplosionPic_03)
	sprite_frames.add_frame("default", Ashend_ExplosionPic_04)
	sprite_frames.add_frame("default", Ashend_ExplosionPic_05)
	sprite_frames.add_frame("default", Ashend_ExplosionPic_06)
	
	explosion_attk_module.aoe_sprite_frames = sprite_frames
	explosion_attk_module.sprite_frames_only_play_once = true
	explosion_attk_module.pierce = explosion_pierce
	explosion_attk_module.duration = 0.25
	explosion_attk_module.damage_repeat_count = 1
	
	explosion_attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attk_module.base_aoe_scene = BaseAOE_Scene
	explosion_attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attk_module.can_be_commanded_by_tower = false
	
	explosion_attk_module.tracker_image = Ashend_ExplosionPic_04
	
	_attached_tower.add_attack_module(explosion_attk_module)



func _on_tower_main_attack_hit_enemy(enemy, damage_register_id, damage_instance, module):
	if _is_buff_active and is_instance_valid(enemy) and enemy.has_effect_uuid(StoreOfEnemyEffectsUUID.ASHEND_BURN_EFFECT):
		var dmg_instance_copy = damage_instance.get_copy_scaled_by(1)
		dmg_instance_copy.scale_only_damage_by(explosion_dmg_ratio_from_main)
		dmg_instance_copy.on_hit_effects.clear()
		
		var pos = enemy.global_position
		var explosion = explosion_attk_module.construct_aoe(pos, pos)
		explosion.damage_instance = dmg_instance_copy
		
		_attached_tower.get_tree().get_root().call_deferred("add_child", explosion)



#

func _on_round_end():
	buff_duration_timer.paused = true

func _on_round_start():
	buff_duration_timer.paused = false


#

func on_buff_refreshed(arg_duration_of_refresh):
	buff_duration_timer.start(arg_duration_of_refresh)
	_is_buff_active = true
	
	_attached_tower.status_bar.add_status_icon(effect_uuid, Efflux_StatusBarIcon)


func _on_buff_timer_timeout():
	_is_buff_active = false
	_attached_tower.status_bar.remove_status_icon(effect_uuid)



#

func _undo_modifications_to_tower(tower):
	if is_instance_valid(buff_duration_timer):
		buff_duration_timer.queue_free()
	
	if _attached_tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy"):
		_attached_tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy")
		_attached_tower.disconnect("on_round_end", self, "_on_round_end")
		_attached_tower.disconnect("on_round_start", self, "_on_round_start")
	
	if is_instance_valid(explosion_attk_module):
		_attached_tower.remove_attack_module(explosion_attk_module)
		explosion_attk_module.queue_free()
	
	
	_is_buff_active = false
	_attached_tower.status_bar.remove_status_icon(effect_uuid)
	
	
	_attached_tower = null

