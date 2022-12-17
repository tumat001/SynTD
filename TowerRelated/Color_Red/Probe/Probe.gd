extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Probe_NormalBullet_Pic = preload("res://TowerRelated/Color_Red/Probe/AttkAssets/Probe_NormalProj.png")
const Probe_PierceProj_Pic = preload("res://TowerRelated/Color_Red/Probe/AttkAssets/Probe_PierceProj.png")

const ProbePiercing_AttackModule_Icon = preload("res://TowerRelated/Color_Red/Probe/AMAssets/ProbePiercing_AttackModule_Icon.png")

const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")


const attk_speed_research_amount : float = 50.0
const attk_speed_research_duration : float = 5.0
const research_stack_trigger_amount : int = 3

const piercing_base_dmg : float = 3.0
const piercing_on_hit_dmg_ratio : float = 0.5
const piercing_pierce_amount : int = 4


var attk_speed_effect : TowerAttributesEffect

var piercing_attk_module : BulletAttackModule


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.PROBE)
	
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
	range_module.position.y += 15
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 530 #420
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 15
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 4
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Probe_NormalBullet_Pic)
	
	add_attack_module(attack_module)
	
	#
	_construct_and_add_piercing_attk_module()
	_construct_attk_speed_effect()
	
	#
	
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attk_hit_enemy_p", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	_construct_and_add_research_effect()

func _construct_and_add_piercing_attk_module():
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = piercing_base_dmg
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = piercing_pierce_amount
	attack_module.base_proj_speed = 696 #580
	#attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = piercing_on_hit_dmg_ratio
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = true
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = true
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Probe_PierceProj_Pic)
	
	attack_module.can_be_commanded_by_tower = false
	
	attack_module.set_image_as_tracker_image(ProbePiercing_AttackModule_Icon)
	
	piercing_attk_module = attack_module
	
	configure_self_to_change_direction_on_attack_module_when_commanded(piercing_attk_module)
	
	add_attack_module(attack_module)



#

func _construct_and_add_research_effect():
	var research_stack_effect = EnemyStackEffect.new(null, 1, 9999, StoreOfEnemyEffectsUUID.PROBE_RESEARCH_STACK, true, false)
	
	var tower_research_effect = TowerOnHitEffectAdderEffect.new(research_stack_effect, StoreOfTowerEffectsUUID.PROBE_RESEARCH_EFFECT_HOLDER)
	add_tower_effect(tower_research_effect)

func _construct_attk_speed_effect():
	var modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.PROBE_ATTK_SPEED_EFFECT)
	modi.percent_amount = attk_speed_research_amount
	modi.percent_based_on = PercentType.BASE
	
	attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, modi, StoreOfTowerEffectsUUID.PROBE_ATTK_SPEED_EFFECT)
	attk_speed_effect.is_timebound = true
	attk_speed_effect.time_in_seconds = attk_speed_research_duration
	attk_speed_effect.status_bar_icon = preload("res://TowerRelated/Color_Red/Probe/AttkAssets/Probe_AttkSpeed_StatusBarIcon.png")


#

func _on_main_attk_hit_enemy_p(enemy, damage_register_id, damage_instance, module):
	if is_instance_valid(enemy):
		if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.PROBE_RESEARCH_STACK):
			var effect = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.PROBE_RESEARCH_STACK]
			
			if effect._current_stack >= research_stack_trigger_amount:
				_grant_self_attk_speed()
				effect._current_stack = 0


func _grant_self_attk_speed():
	if has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.PROBE_ATTK_SPEED_EFFECT):
		if is_instance_valid(range_module):
			var targets = range_module.get_targets_without_affecting_self_current_targets(1)
			if targets.size() > 0:
				piercing_attk_module.on_command_attack_enemies_and_attack_when_ready(targets)
	
	#add_tower_effect(attk_speed_effect._shallow_duplicate())
	add_tower_effect(attk_speed_effect._get_copy_scaled_by(last_calculated_final_ability_potency))



# HeatModule

func set_heat_module(module):
	module.heat_per_attack = 2
	.set_heat_module(module)

func _construct_heat_effect():
	var base_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_attr_mod.percent_amount = 50
	base_attr_mod.percent_based_on = PercentType.BASE
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED , base_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module.benefits_from_bonus_attack_speed:
			module.calculate_all_speed_related_attributes()
	
	emit_signal("final_attack_speed_changed")

