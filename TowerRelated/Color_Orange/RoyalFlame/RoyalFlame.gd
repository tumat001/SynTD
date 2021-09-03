extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const RoyalFlame_Proj01 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_Proj/RoyalFlame_Proj01.png")
const RoyalFlame_Proj02 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_Proj/RoyalFlame_Proj02.png")
const RoyalFlame_Proj03 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_Proj/RoyalFlame_Proj03.png")
const RoyalFlame_Proj04 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_Proj/RoyalFlame_Proj04.png")
const RoyalFlame_Proj05 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_Proj/RoyalFlame_Proj05.png")
const RoyalFlame_Proj06 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_Proj/RoyalFlame_Proj06.png")

const RoyalFlame_ExtinguishBeam01 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_ExtinguishBeam/RoyalFlame_ExtinguishBeam01.png")
const RoyalFlame_ExtinguishBeam02 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_ExtinguishBeam/RoyalFlame_ExtinguishBeam02.png")
const RoyalFlame_ExtinguishBeam03 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_ExtinguishBeam/RoyalFlame_ExtinguishBeam03.png")
const RoyalFlame_ExtinguishBeam04 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_ExtinguishBeam/RoyalFlame_ExtinguishBeam04.png")
const RoyalFlame_ExtinguishBeam05 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_ExtinguishBeam/RoyalFlame_ExtinguishBeam05.png")
const RoyalFlame_ExtinguishBeam06 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_ExtinguishBeam/RoyalFlame_ExtinguishBeam06.png")
const RoyalFlame_ExtinguishBeam07 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_ExtinguishBeam/RoyalFlame_ExtinguishBeam07.png")
const RoyalFlame_ExtinguishBeam08 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_ExtinguishBeam/RoyalFlame_ExtinguishBeam08.png")

const RoyalFlame_SteamBurst01 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_SteamBurst/RoyalFlame_SteamBurst01.png")
const RoyalFlame_SteamBurst02 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_SteamBurst/RoyalFlame_SteamBurst02.png")
const RoyalFlame_SteamBurst03 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_SteamBurst/RoyalFlame_SteamBurst03.png")
const RoyalFlame_SteamBurst04 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_SteamBurst/RoyalFlame_SteamBurst04.png")
const RoyalFlame_SteamBurst05 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_SteamBurst/RoyalFlame_SteamBurst05.png")
const RoyalFlame_SteamBurst06 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_SteamBurst/RoyalFlame_SteamBurst06.png")
const RoyalFlame_SteamBurst07 = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_SteamBurst/RoyalFlame_SteamBurst07.png")

const RoyalFlame_AbilityIcon = preload("res://TowerRelated/Color_Orange/RoyalFlame/Ability/RoyalFlame_AbilityIcon.png")
const RoyalFlame_StatusIcon = preload("res://TowerRelated/Color_Orange/RoyalFlame/Ability/RoyalFlame_StatusIcon.png")

const EnemyDmgOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyDmgOverTimeEffect.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")



var burn_damage_modifier : FlatModifier
const burn_base_damage_ratio : float = 0.25

var burn_enemy_effect : EnemyDmgOverTimeEffect

var steam_burst_ability : BaseAbility
const base_ability_cooldown : float = 25.0

var extinguish_range_module : RangeModule
var extinguish_attack_module : WithBeamInstantDamageAttackModule

var explosion_attack_module : AOEAttackModule
var burst_missing_health_ratio : float = 0.4
var burst_missing_health_limit : float = 300

var burning_enemies_group_id = "RoyalFlameBurnGroupId" #unused thus far

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.ROYAL_FLAME)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 9
	
	
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
	attack_module.position.y -= 9
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	var sp = SpriteFrames.new()
	sp.add_frame("default", RoyalFlame_Proj01)
	sp.add_frame("default", RoyalFlame_Proj02)
	sp.add_frame("default", RoyalFlame_Proj03)
	sp.add_frame("default", RoyalFlame_Proj04)
	sp.add_frame("default", RoyalFlame_Proj05)
	sp.add_frame("default", RoyalFlame_Proj06)
	attack_module.bullet_sprite_frames = sp
	
	connect("final_base_damage_changed", self, "_final_damage_changed", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	connect("attack_module_added", self, "_main_am_added")
	
	
	# Extinguish attack module
	
	extinguish_range_module = RangeModule_Scene.instance()
	extinguish_range_module.base_range_radius = 600
	extinguish_range_module.set_range_shape(CircleShape2D.new())
	extinguish_range_module.can_display_range = false
	extinguish_range_module.position.y += 9
	
	extinguish_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	extinguish_attack_module.base_damage = 0
	extinguish_attack_module.base_damage_type = DamageType.ELEMENTAL
	extinguish_attack_module.base_attack_speed = 0
	extinguish_attack_module.base_attack_wind_up = 0
	extinguish_attack_module.is_main_attack = false
	extinguish_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	extinguish_attack_module.position.y -= 9
	extinguish_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	extinguish_attack_module.on_hit_damage_scale = 0
	
	extinguish_attack_module.benefits_from_bonus_base_damage = false
	extinguish_attack_module.benefits_from_bonus_attack_speed = false
	extinguish_attack_module.benefits_from_bonus_on_hit_damage = false
	extinguish_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", RoyalFlame_ExtinguishBeam01)
	beam_sprite_frame.add_frame("default", RoyalFlame_ExtinguishBeam02)
	beam_sprite_frame.add_frame("default", RoyalFlame_ExtinguishBeam03)
	beam_sprite_frame.add_frame("default", RoyalFlame_ExtinguishBeam04)
	beam_sprite_frame.add_frame("default", RoyalFlame_ExtinguishBeam05)
	beam_sprite_frame.add_frame("default", RoyalFlame_ExtinguishBeam06)
	beam_sprite_frame.add_frame("default", RoyalFlame_ExtinguishBeam07)
	beam_sprite_frame.add_frame("default", RoyalFlame_ExtinguishBeam08)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 60)
	
	extinguish_attack_module.beam_scene = BeamAesthetic_Scene
	extinguish_attack_module.beam_sprite_frames = beam_sprite_frame
	extinguish_attack_module.beam_is_timebound = true
	extinguish_attack_module.beam_time_visible = 0.15
	extinguish_attack_module.show_beam_at_windup = false
	extinguish_attack_module.show_beam_regardless_of_state = true
	
	extinguish_attack_module.use_self_range_module = true
	extinguish_attack_module.range_module = extinguish_range_module
	
	extinguish_attack_module.can_be_commanded_by_tower = false
	
	extinguish_attack_module.connect("beam_connected_to_enemy", self, "_extinguish_beam_created", [], CONNECT_PERSIST)
	
	add_attack_module(extinguish_attack_module)
	
	
	# Steam burst / explosion
	
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = 0
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", RoyalFlame_SteamBurst01)
	sprite_frames.add_frame("default", RoyalFlame_SteamBurst02)
	sprite_frames.add_frame("default", RoyalFlame_SteamBurst03)
	sprite_frames.add_frame("default", RoyalFlame_SteamBurst04)
	sprite_frames.add_frame("default", RoyalFlame_SteamBurst05)
	sprite_frames.add_frame("default", RoyalFlame_SteamBurst06)
	sprite_frames.add_frame("default", RoyalFlame_SteamBurst07)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = -1
	explosion_attack_module.duration = 0.4
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(explosion_attack_module)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	burn_damage_modifier = FlatModifier.new(StoreOfTowerEffectsUUID.ROYAL_FLAME_BURN)
	burn_damage_modifier.flat_modifier = main_attack_module.base_damage * burn_base_damage_ratio
	
	var burn_on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ROYAL_FLAME_BURN, burn_damage_modifier, DamageType.ELEMENTAL)
	var burn_dmg_instance = DamageInstance.new()
	burn_dmg_instance.on_hit_damages[burn_on_hit.internal_id] = burn_on_hit
	
	burn_enemy_effect = EnemyDmgOverTimeEffect.new(burn_dmg_instance, StoreOfEnemyEffectsUUID.ROYAL_FLAME_BURN, 0.5)
	burn_enemy_effect.is_timebound = true
	burn_enemy_effect.time_in_seconds = 10
	burn_enemy_effect.status_bar_icon = RoyalFlame_StatusIcon
	burn_enemy_effect.effect_source_ref = self
	
	var tower_effect = TowerOnHitEffectAdderEffect.new(burn_enemy_effect, StoreOfTowerEffectsUUID.ROYAL_FLAME_BURN)
	
	add_tower_effect(tower_effect)
	
	_construct_and_connect_ability()


func _construct_and_connect_ability():
	steam_burst_ability = BaseAbility.new()
	
	steam_burst_ability.is_timebound = true
	steam_burst_ability.connect("ability_activated", self, "_royal_flame_ability_activated", [], CONNECT_PERSIST)
	steam_burst_ability.icon = RoyalFlame_AbilityIcon
	
	steam_burst_ability.set_properties_to_usual_tower_based()
	steam_burst_ability.tower = self
	
	steam_burst_ability.descriptions = [
		"Extinguishes the 3 closest enemies burned by Royal Flame. Extinguishing enemies creates a steam explosion that deals 40% of the extinguished enemy's missing health as elemental damage, up to a limit.",
		"The explosion benefits only from explosion size buffs, damage mitigation pierce buffs, and ability related buffs.",
		"Cooldown: 25 s"
	]
	steam_burst_ability.display_name = "Steam Burst"
	
	register_ability_to_manager(steam_burst_ability)


# Burn damage update

func _main_am_added(attack_module):
	if attack_module.module_id == StoreOfAttackModuleID.MAIN:
		_final_damage_changed()

func _main_am_removed(attack_module):
	if attack_module.module_id == StoreOfAttackModuleID.MAIN:
		_final_damage_changed()


func _final_damage_changed():
	if main_attack_module != null:
		burn_damage_modifier.flat_modifier = main_attack_module.last_calculated_final_damage * burn_base_damage_ratio


# Ability activated related

func _royal_flame_ability_activated():
	steam_burst_ability.start_time_cooldown(_get_cd_to_use(base_ability_cooldown))
	
	var bucket : Array = []
	var targets_sorted_close : Array = Targeting.enemies_to_target(extinguish_range_module.enemies_in_range, Targeting.CLOSE, extinguish_range_module.enemies_in_range.size(), extinguish_range_module.global_position)
	for enemy in targets_sorted_close:
		if enemy._dmg_over_time_id_effects_map.has(StoreOfEnemyEffectsUUID.ROYAL_FLAME_BURN):
			bucket.append(enemy)
			
			if bucket.size() >= 3:
				break
	
	extinguish_attack_module._attack_enemies(bucket)


func _extinguish_beam_created(beam, enemy):
	beam.connect("time_visible_is_over", self, "_extinguish_on_enemy_beam_hit", [enemy], CONNECT_ONESHOT)


# Explosion related

func _extinguish_on_enemy_beam_hit(enemy):
	if enemy != null:
		var missing_health = enemy._last_calculated_max_health - enemy.current_health
		var damage = missing_health * burst_missing_health_ratio
		
		if damage > burst_missing_health_limit:
			damage = burst_missing_health_limit
		
		damage *= steam_burst_ability.get_potency_to_use(last_calculated_final_ability_potency)
		
		
		var dmg_as_modifier : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE)
		dmg_as_modifier.flat_modifier = damage
		
		var dmg_as_on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE, dmg_as_modifier, DamageType.ELEMENTAL)
		
		
		var steam_explosion = explosion_attack_module.construct_aoe(enemy.global_position, enemy.global_position)
		steam_explosion.damage_instance.on_hit_damages[dmg_as_on_hit.internal_id] = dmg_as_on_hit
		
		get_tree().get_root().add_child(steam_explosion)
		
		
		# extinguish
		
		enemy._remove_effect(burn_enemy_effect)


# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 1
	.set_heat_module(module)

func _construct_heat_effect():
	var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_dmg_attr_mod.flat_modifier = 3
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module != null:
			if module.benefits_from_bonus_base_damage:
				module.calculate_final_base_damage()
	
	emit_signal("final_base_damage_changed")
