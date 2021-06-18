extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

const SpikeGroundProj = preload("res://TowerRelated/Color_Green/Spike/Spike_GroundProj/Spike_GroundProj.tscn")


const bonus_damage_percent_threshold : float = 0.25
const bonus_damage : float = 2.0
var bonus_damage_instance : DamageInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SPIKE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.add_targeting_option(Targeting.EXECUTE)
	range_module.set_current_targeting(Targeting.EXECUTE)
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 6
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.attack_sprite_scene = SpikeGroundProj
	attack_module.attack_sprite_match_lifetime_to_windup = false
	attack_module.attack_sprite_show_in_windup = true
	attack_module.attack_sprite_show_in_attack = false
	
#	attack_module.connect("before_attack_sprite_is_shown", self, "_on_attack_sprite_constructed_s", [], CONNECT_PERSIST)
	connect("on_main_attack_module_enemy_hit", self, "_on_enemy_hit_s", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	_construct_bonus_damage_instance()
	
	_post_inherit_ready()


func _construct_bonus_damage_instance():
	var mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE)
	mod.flat_modifier = bonus_damage
	
	var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE, mod, DamageType.PHYSICAL)
	
	bonus_damage_instance = DamageInstance.new()
	bonus_damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE] = on_hit
	


func _on_enemy_hit_s(enemy, damage_register_id, damage_instance, module):
	if enemy._last_calculated_max_health != 0:
		var ratio_health = enemy.current_health / enemy._last_calculated_max_health
		
		if ratio_health < bonus_damage_percent_threshold:
			call_deferred("_deal_bonus_damage", enemy)


func _deal_bonus_damage(enemy):
	if enemy != null:
		enemy.hit_by_damage_instance(bonus_damage_instance)
