extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

const GrandProj01 = preload("res://TowerRelated/Color_Blue/Grand/Grand_Attacks/Grand_Attack_01.png")
const GrandProj02 = preload("res://TowerRelated/Color_Blue/Grand/Grand_Attacks/Grand_Attack_02.png")
const GrandProj03 = preload("res://TowerRelated/Color_Blue/Grand/Grand_Attacks/Grand_Attack_03.png")
const GrandProj04 = preload("res://TowerRelated/Color_Blue/Grand/Grand_Attacks/Grand_Attack_04.png")

var grand_attack_module : BulletAttackModule

const ap_level02 : float = 1.25
const ap_level03 : float = 1.50
const ap_level04 : float = 2.0

#const bonus_pierce_ap_level02 : int = 1
#const bonus_pierce_ap_level03 : int = 2
#const bonus_pierce_ap_level04 : int = 4

const bonus_pierce_per_025_ap : int = 1

var current_level : int = 0

#var grand_pierce_effect : TowerAttributesEffect
#var grand_pspeed_effect : TowerAttributesEffect
var pspeed_mod : FlatModifier
var pierce_mod : FlatModifier


const ap_needed_for_show_trail : float = 1.5
var _current_should_show_trail : bool

const trail_color : Color = Color(0.3, 0.4, 0.9, 1)#Color(0.4, 0.5, 1, 1)
const trail_transparency : float = 0.75
const base_trail_length : int = 10
var _current_trail_length : int = base_trail_length

const base_trail_width : int = 3
var _current_trail_width : int = base_trail_width

var multiple_trail_component : MultipleTrailsForNodeComponent


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.GRAND)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 11
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 400
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 11
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 12
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	var sp := SpriteFrames.new()
	sp.add_frame("default", GrandProj01)
	sp.add_frame("default", GrandProj02)
	sp.add_frame("default", GrandProj03)
	sp.add_frame("default", GrandProj04)
	attack_module.bullet_sprite_frames = sp
	
	grand_attack_module = attack_module
	attack_module.connect("before_bullet_is_shot", self, "_grand_before_bullet_shot", [], CONNECT_PERSIST)
	add_attack_module(attack_module)
	
	connect("final_ability_potency_changed", self, "_final_ap_changed", [], CONNECT_PERSIST)
	connect("on_main_attack_module_damage_instance_constructed", self, "_main_damage_instance_constructed", [], CONNECT_PERSIST)
	
	
	multiple_trail_component = MultipleTrailsForNodeComponent.new()
	multiple_trail_component.node_to_host_trails = self
	multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	
	attack_module.connect("after_bullet_is_shot", self, "_grand_after_bullet_shot", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	
	pierce_mod = FlatModifier.new(StoreOfTowerEffectsUUID.GRAND_PIERCE)
	pierce_mod.flat_modifier = 0
	
	var grand_pierce_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_PIERCE, pierce_mod, StoreOfTowerEffectsUUID.GRAND_PIERCE)
	
	add_tower_effect(grand_pierce_effect)
	
	
	pspeed_mod = FlatModifier.new(StoreOfTowerEffectsUUID.GRAND_PROJ_SPEED)
	pspeed_mod.flat_modifier = 0
	
	var grand_pspeed_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_PROJ_SPEED, pspeed_mod, StoreOfTowerEffectsUUID.GRAND_PROJ_SPEED)
	
	add_tower_effect(grand_pspeed_effect)
	
	_final_ap_changed()



func _final_ap_changed():
	var new_level : int = _calculate_new_level_from_change()
	
	var final_pierce_bonus : int = 0
	var extra_ap : float = last_calculated_final_ability_potency - 1
	if extra_ap > 0:
		final_pierce_bonus = round((extra_ap * 4) * bonus_pierce_per_025_ap)
	
	pierce_mod.flat_modifier = final_pierce_bonus
	
	
	if current_level != new_level:
		current_level = new_level
		
		if current_level == 4:
			#pierce_mod.flat_modifier = bonus_pierce_ap_level04
			pspeed_mod.flat_modifier = 350
			
		elif current_level == 3:
			#pierce_mod.flat_modifier = bonus_pierce_ap_level03
			pspeed_mod.flat_modifier = 150
			
		elif current_level == 2:
			#pierce_mod.flat_modifier = bonus_pierce_ap_level02
			pspeed_mod.flat_modifier = 100
			
		elif current_level == 1:
			#pierce_mod.flat_modifier = 0
			pspeed_mod.flat_modifier = 0
	
	
	for am in all_attack_modules:
		if am is BulletAttackModule:
			am.calculate_final_pierce()
			am.calculate_final_proj_speed()
	
	#
	
	_current_should_show_trail = ap_needed_for_show_trail <= last_calculated_final_ability_potency
	_current_trail_length = base_trail_length * last_calculated_final_ability_potency
	_current_trail_width = base_trail_width * last_calculated_final_ability_potency
	


func _calculate_new_level_from_change() -> int:
	if last_calculated_final_ability_potency >= ap_level04:
		return 4
	if last_calculated_final_ability_potency >= ap_level03:
		return 3
	if last_calculated_final_ability_potency >= ap_level02:
		return 2
	else:
		return 1


func _grand_before_bullet_shot(bullet):
	bullet.set_current_frame(current_level - 1)
	
	# size scale
	var scale_mag = last_calculated_final_ability_potency / 2
	bullet.scale = Vector2(scale_mag, scale_mag)
	
	bullet.destroy_self_after_zero_life_distance = false
	bullet.connect("on_current_life_distance_expire", self, "_grand_bullet_curr_distance_expired", [bullet], CONNECT_ONESHOT)


func _main_damage_instance_constructed(damage_instance, module):
	damage_instance.scale_only_damage_by(last_calculated_final_ability_potency)


#

func _grand_bullet_curr_distance_expired(bullet):
	var targets = grand_attack_module.range_module.get_targets_without_affecting_self_current_targets(1, Targeting.FAR)
	
	if targets.size() > 0:
		var enemy = targets[0]
		if is_instance_valid(enemy):
			grand_attack_module._adjust_bullet_physics_settings(bullet, enemy.global_position, bullet.global_position)
			
			bullet.current_life_distance *= 2
			bullet.set_deferred("destroy_self_after_zero_life_distance", true)
		else:
			bullet.trigger_on_death_events()
	else:
		bullet.trigger_on_death_events()

###

func _grand_after_bullet_shot(arg_bullet):
	if _current_should_show_trail:
		multiple_trail_component.create_trail_for_node(arg_bullet)

func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = _current_trail_length
	arg_trail.trail_color = trail_color
	arg_trail.width = _current_trail_width
	arg_trail.modulate.a = trail_transparency

