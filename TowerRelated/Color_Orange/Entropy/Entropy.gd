extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const EntropyAttackSprite = preload("res://TowerRelated/Color_Orange/Entropy/EntropyAttkSprite/EntropyAttkSprite.tscn")

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

var first_attack_speed_effect : TowerAttributesEffect
var second_attack_speed_effect : TowerAttributesEffect

const first_attack_speed_starting_amount : int = 130
const second_attack_speed_starting_amount : int = 230

var curr_first_attack_speed_amount : int = first_attack_speed_starting_amount
var first_speed_is_gone : bool = false

var curr_second_attack_speed_amount : int = second_attack_speed_starting_amount
var second_speed_is_gone : bool = false

onready var body_sprite : AnimatedSprite = $TowerBase/KnockUpLayer/BaseSprites

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.ENTROPY)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 6
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.attack_sprite_scene = EntropyAttackSprite
	attack_module.attack_sprite_match_lifetime_to_windup = true
	attack_module.attack_sprite_show_in_windup = true
	attack_module.attack_sprite_show_in_attack = false
	
	
	_construct_effects()
	
	connect("on_main_attack_finished", self, "_on_main_attack_finished_e", [], CONNECT_PERSIST)
	attack_module.connect("before_attack_sprite_is_shown", self, "_on_attack_sprite_constructed_e", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	add_tower_effect(first_attack_speed_effect)
	add_tower_effect(second_attack_speed_effect)


func _construct_effects():
	# First
	var first_spd_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ENTROPY_FIRST_BONUS_ATTK_SPEED)
	first_spd_mod.percent_amount = 30
	first_spd_mod.percent_based_on = PercentType.BASE
	
	first_attack_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, first_spd_mod, StoreOfTowerEffectsUUID.ENTROPY_FIRST_BONUS_ATTK_SPEED)
	
	# Second
	var second_spd_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ENTROPY_SECOND_BONUS_ATTK_SPEED)
	second_spd_mod.percent_amount = 30
	second_spd_mod.percent_based_on = PercentType.BASE
	
	second_attack_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, second_spd_mod, StoreOfTowerEffectsUUID.ENTROPY_SECOND_BONUS_ATTK_SPEED)



func _on_main_attack_finished_e(module):
	curr_first_attack_speed_amount -= 1
	curr_second_attack_speed_amount -= 1
	
	if curr_first_attack_speed_amount <= 0 and !first_speed_is_gone:
		remove_tower_effect(first_attack_speed_effect)
		first_speed_is_gone = true
		body_sprite.modulate = Color(0.6, 0.6, 0.6, 1)
	
	if curr_second_attack_speed_amount <= 0 and !second_speed_is_gone:
		remove_tower_effect(second_attack_speed_effect)
		second_speed_is_gone = true
		body_sprite.modulate = Color(0.3, 0.3, 0.3, 1)


func _on_attack_sprite_constructed_e(attack_sprite):
	var modul : Color = Color(1, 1, 1, 1)
	
	if second_speed_is_gone:
		modul = Color(0.3, 0.3, 0.3, 1)
	elif first_speed_is_gone:
		modul = Color(0.6, 0.6, 0.6, 1)
	
	attack_sprite.modulate = modul



# Heat Module

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
