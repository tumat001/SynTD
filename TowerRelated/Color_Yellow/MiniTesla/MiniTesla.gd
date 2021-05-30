extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")

const mini_tesla_pic_01 = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Bolt_01.png")
const mini_tesla_pic_02 = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Bolt_02.png")
const mini_tesla_pic_03 = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Bolt_03.png")
const mini_tesla_pic_04 = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Bolt_04.png")

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

var attack_module : WithBeamInstantDamageAttackModule

var mini_tesla_stun_effect : EnemyStunEffect

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.MINI_TESLA)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 13
	
	attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 13
	attack_module.base_on_hit_damage_internal_name = "tesla"
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", mini_tesla_pic_01)
	beam_sprite_frame.add_frame("default", mini_tesla_pic_02)
	beam_sprite_frame.add_frame("default", mini_tesla_pic_03)
	beam_sprite_frame.add_frame("default", mini_tesla_pic_04)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.2
	
	add_attack_module(attack_module)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	var enemy_final_effect : EnemyStunEffect = EnemyStunEffect.new(2, StoreOfEnemyEffectsUUID.MINI_TESLA_STUN)
	var enemy_effect : EnemyStackEffect = EnemyStackEffect.new(enemy_final_effect, 1, 5, StoreOfEnemyEffectsUUID.MINI_TESLA_STACK)
	enemy_effect.is_timebound = true
	enemy_effect.time_in_seconds = 3
	
	var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.MINI_TESLA_STACKING_STUN)
	
	mini_tesla_stun_effect = enemy_final_effect
	
	add_tower_effect(tower_effect)


# module effects

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Attacking an enemy affected by \"static's\" stun stuns the enemy (with static) for 2 seconds."
		]


func _module_turned_on(_first_time_per_round : bool):
	if !main_attack_module.is_connected("on_enemy_hit", self, "_attempt_restun"):
		main_attack_module.connect("on_enemy_hit", self, "_attempt_restun")
	
	if !is_connected("attack_module_added", self, "_attack_module_attached"):
		connect("attack_module_added", self, "_attack_module_attached")
		connect("attack_module_removed", self, "_attack_module_detached")


func _module_turned_off():
	if main_attack_module.is_connected("on_enemy_hit", self, "_attempt_restun"):
		main_attack_module.disconnect("on_enemy_hit", self, "_attempt_restun")
	
	if is_connected("attack_module_added", self, "_attack_module_attached"):
		disconnect("attack_module_added", self, "_attack_module_attached")
		disconnect("attack_module_removed", self, "_attack_module_detached")



func _attack_module_detached(attack_module : AbstractAttackModule):
	if energy_module != null:
		if attack_module.module_id == StoreOfAttackModuleID.MAIN:
			attack_module.disconnect("on_enemy_hit", self, "_attempt_restun")


func _attack_module_attached(attack_module : AbstractAttackModule):
	if attack_module == main_attack_module:
		if energy_module != null and energy_module.is_turned_on:
			attack_module.connect("on_enemy_hit", self, "_attempt_restun")
		else:
			attack_module.disconnect("on_enemy_hit", self, "_attempt_restun")

#

func _attempt_restun(enemy : AbstractEnemy, damage_reg_id : int, module):
	if enemy._stun_id_effects_map.has(StoreOfEnemyEffectsUUID.MINI_TESLA_STUN):
		enemy._add_effect(mini_tesla_stun_effect) # it gets copied anyway
