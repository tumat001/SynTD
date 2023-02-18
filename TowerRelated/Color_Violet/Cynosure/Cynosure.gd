extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Cynosure_MainProj = preload("res://TowerRelated/Color_Violet/Cynosure/Assets/Cynosure_MainProj.png")



const bonus_range_on_stack_threshold : float = 100.0
const stack_count_base_multiplier_on_target_changed : float = 0.75
const attk_speed_gain_per_stack : float = 5.0
const stack_count_for_range_gain : int = 15
var _current_stack_count : int

var _last_attacked_enemy

var attk_speed_modi : PercentModifier
var range_effect : TowerAttributesEffect

var _is_range_effect_active : bool = false

onready var stack_label = $TowerBase/KnockUpLayer/StackLabel
onready var cosmetic_on_stacks = $TowerBase/KnockUpLayer/CosmeticOnStacks

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.CYNOSURE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift_of_attack_module : float = 16
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.add_targeting_option(Targeting.STRONGEST)
	range_module.add_targeting_option(Targeting.WEAKEST)
	range_module.set_current_targeting(Targeting.STRONGEST)
	
	range_module.position.y += y_shift_of_attack_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 560
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.base_proj_inaccuracy = 0
	attack_module.position.y -= y_shift_of_attack_module
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Cynosure_MainProj)
	
	add_attack_module(attack_module)
	
	#
	
	connect("on_main_attack", self, "_on_main_attack_c", [], CONNECT_PERSIST)
	
	#
	
	_construct_and_add_attk_speed_effect()
	_set_stack_count(0)
	
	_post_inherit_ready()

#

func _construct_and_add_attk_speed_effect():
	attk_speed_modi = PercentModifier.new(StoreOfTowerEffectsUUID.CYNOSURE_ATTK_SPEED_EFFECT)
	attk_speed_modi.percent_amount = 0
	attk_speed_modi.percent_based_on = PercentType.BASE
	
	var attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_modi, StoreOfTowerEffectsUUID.CYNOSURE_ATTK_SPEED_EFFECT)
	attk_speed_effect.is_timebound = false
	
	add_tower_effect(attk_speed_effect)
	

#

func _on_main_attack_c(arg_attk_delay, arg_enemies, arg_module):
	if arg_enemies.size() > 0:
		if arg_enemies[0] == _last_attacked_enemy:
			_set_stack_count(_current_stack_count + 1)
		else:
			_set_stack_count(_get_stack_count_on_reduction())
		
		_last_attacked_enemy = arg_enemies[0]
		
	else:
		_set_stack_count(_get_stack_count_on_reduction())
		
	

func _get_stack_count_on_reduction():
	return _current_stack_count * (1 - (stack_count_base_multiplier_on_target_changed / last_calculated_final_ability_potency))


func _set_stack_count(arg_val : int):
	_current_stack_count = arg_val
	
	stack_label.text = "%02d" % _current_stack_count
	
	attk_speed_modi.percent_amount = _current_stack_count * attk_speed_gain_per_stack
	recalculate_final_attack_speed()
	
	
	if arg_val >= stack_count_for_range_gain:
		cosmetic_on_stacks.visible = true
		if range_effect == null:
			_construct_range_effect()
		
		add_tower_effect(range_effect)
		_is_range_effect_active = true
		
	else:
		cosmetic_on_stacks.visible = false
		
		if _is_range_effect_active:
			remove_tower_effect(range_effect)
			_is_range_effect_active = false

func _construct_range_effect():
	var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.CYNOSURE_RANGE_EFFECT)
	range_attr_mod.flat_modifier = bonus_range_on_stack_threshold
	range_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.CYNOSURE_RANGE_EFFECT)
	range_effect.is_timebound = false
	
	

