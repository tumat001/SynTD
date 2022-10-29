extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

const ImpaleGroundProj_Scene = preload("res://TowerRelated/Color_Green/Impale/Impale_GroundProj/Impale_GroundProj.tscn")
const ImpaleGroundProj = preload("res://TowerRelated/Color_Green/Impale/Impale_GroundProj/Impale_GroundProj.gd")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")


var impale_attack_module : InstantDamageAttackModule
const bonus_damage_scale : float = 3.0
const bonus_damage_scale_on_normal_enemies : float = 2.0

const bonus_damage_percent_threshold : float = 0.75

const impale_retract_damage_dmg_reg_id : int = -10

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.IMPALE)
	
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
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.add_targeting_option(Targeting.EXECUTE)
	range_module.set_current_targeting(Targeting.EXECUTE)
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.attack_sprite_scene = ImpaleGroundProj_Scene
	attack_module.attack_sprite_show_in_windup = false
	attack_module.attack_sprite_show_in_attack = true
	
	attack_module.connect("on_enemy_hit", self, "_on_enemy_implale_hit", [], CONNECT_PERSIST)
	
	impale_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	var enemy_effect : EnemyStunEffect = EnemyStunEffect.new(2.2, StoreOfEnemyEffectsUUID.IMPALE_STUN)
	var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.IMPALE_STUN)
	
	add_tower_effect(tower_effect, [impale_attack_module], false, false)



func _on_enemy_implale_hit(enemy, damage_register_id, damage_instance, module):
	if damage_register_id != impale_retract_damage_dmg_reg_id:
		var impale_proj : ImpaleGroundProj = ImpaleGroundProj_Scene.instance()
		
		impale_proj.enemy = enemy
		impale_proj.connect("spike_retracted", self, "_on_impale_rectract")
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(impale_proj)

func _on_impale_rectract(enemy):
	if is_instance_valid(enemy):
		var dmg_instance = impale_attack_module.construct_damage_instance()
		dmg_instance.on_hit_effects.erase(StoreOfEnemyEffectsUUID.IMPALE_STUN)
		
		if _check_if_within_threshold(enemy):
			dmg_instance.scale_only_damage_by(bonus_damage_scale)
		
		if enemy.is_enemy_type_normal():
			dmg_instance.scale_only_damage_by(bonus_damage_scale_on_normal_enemies)
		
		enemy.hit_by_instant_damage(dmg_instance, impale_retract_damage_dmg_reg_id, impale_attack_module)



func _check_if_within_threshold(enemy):
	if enemy._last_calculated_max_health != 0:
		var ratio_health = enemy.current_health / enemy._last_calculated_max_health
		
		return ratio_health < bonus_damage_percent_threshold
	
	return false
