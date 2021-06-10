extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

const Tesla_Bolt_01 = preload("res://TowerRelated/Color_Violet/Tesla/Tesla_Bolt_01.png")
const Tesla_Bolt_02 = preload("res://TowerRelated/Color_Violet/Tesla/Tesla_Bolt_02.png")
const Tesla_Bolt_03 = preload("res://TowerRelated/Color_Violet/Tesla/Tesla_Bolt_03.png")

const Tesla_Hit_Particle = preload("res://TowerRelated/Color_Violet/Tesla/TeslaHitParticle.tscn")


var tesla_main_attack_module : AbstractAttackModule

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.TESLA)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 30
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 30
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.attack_sprite_scene = Tesla_Hit_Particle
	attack_module.attack_sprite_follow_enemy = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Tesla_Bolt_01)
	beam_sprite_frame.add_frame("default", Tesla_Bolt_02)
	beam_sprite_frame.add_frame("default", Tesla_Bolt_03)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.2
	
	add_attack_module(attack_module)
	
	tesla_main_attack_module = attack_module
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	var enemy_effect : EnemyStunEffect = EnemyStunEffect.new(0.3, StoreOfEnemyEffectsUUID.TESLA_STUN)
	var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.TESLA_STUN)
	
	add_tower_effect(tower_effect)


# energy module related

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Tesla's main attack now attacks up to 3 enemies."
		]


func _module_turned_on(_first_time_per_round : bool):
	main_attack_module.number_of_unique_targets = 3
	
	if !is_connected("attack_module_added", self, "_attack_module_attached"):
		connect("attack_module_added", self, "_attack_module_attached")
		connect("attack_module_removed", self, "_attack_module_detached")


func _module_turned_off():
	main_attack_module.number_of_unique_targets = 1
	
	if is_connected("attack_module_added", self, "_attack_module_attached"):
		disconnect("attack_module_added", self, "_attack_module_attached")
		disconnect("attack_module_removed", self, "_attack_module_detached")



func _attack_module_detached(attack_module : AbstractAttackModule):
	if energy_module != null:
		if attack_module == tesla_main_attack_module:
			tesla_main_attack_module.number_of_unique_targets = 1

func _attack_module_attached(attack_module : AbstractAttackModule):
	if attack_module == main_attack_module:
		if energy_module != null and energy_module.is_turned_on:
			main_attack_module.number_of_unique_targets = 3
		else:
			main_attack_module.number_of_unique_targets = 1
