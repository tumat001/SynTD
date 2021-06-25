extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const Wave_Bullet_Pic = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/Wave_Bullet01.png")
const Wave_AbilityBullet_Pic = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/Wave_AbilityBullet01.png")
const Wave_AbilityIcon = preload("res://TowerRelated/Color_Blue/Wave/Ability/Wave_AbilityIcon.png")

const Wave_Explosion_01 = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/Wave_AbilityExplosion01.png")
const Wave_Explosion_02 = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/Wave_AbilityExplosion02.png")
const Wave_Explosion_03 = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/Wave_AbilityExplosion03.png")
const Wave_Explosion_04 = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/Wave_AbilityExplosion04.png")
const Wave_Explosion_05 = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/Wave_AbilityExplosion05.png")
const Wave_Explosion_06 = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/Wave_AbilityExplosion06.png")
const Wave_Explosion_07 = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/Wave_AbilityExplosion07.png")

const WaveColumnProj_Scene = preload("res://TowerRelated/Color_Blue/Wave/Wave_Attacks/WaveColumn.tscn")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

signal effect_modifier_changed()

const base_damage_amount_modifier : float = 2.0
const debuff_damage_amount_per_cast : float = 0.5
var current_debuff_damage : float = 0.0

const base_debuff_duration : float = 30.0
var current_debuff_duration : float = base_debuff_duration
var current_debuffs_time_arr : Array = []

const no_enemy_in_range_clause : int = -10
const base_column_count : int = 8
var current_column_count : int = base_column_count

const base_ability_cooldown : float = 6.0

const max_angle_of_fire : float = 15.0
var current_column_angles_of_fire : Array = []

var wave_dmg_effect : TowerOnHitDamageAdderEffect
var wave_dmg_modifier : FlatModifier

var ability_attack_module : BulletAttackModule
var tidal_wave_ability : BaseAbility
var tidal_ability_activation_clause : ConditionalClauses

var explosion_attack_module : AOEAttackModule

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.WAVE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 475
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.burst_amount = 2
	attack_module.burst_attack_speed = 8
	attack_module.has_burst = true
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Wave_Bullet_Pic)
	
	add_attack_module(attack_module)
	
	
	# ability attack module
	
	ability_attack_module = BulletAttackModule_Scene.instance()
	ability_attack_module.base_damage = 0
	ability_attack_module.base_damage_type = DamageType.ELEMENTAL
	ability_attack_module.base_attack_speed = 0
	ability_attack_module.base_attack_wind_up = 0
	ability_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	ability_attack_module.is_main_attack = true
	ability_attack_module.base_pierce = 2
	ability_attack_module.base_proj_speed = 625
	ability_attack_module.base_proj_life_distance = info.base_range
	ability_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	ability_attack_module.on_hit_damage_scale = 2
	
	ability_attack_module.benefits_from_bonus_base_damage = false
	ability_attack_module.benefits_from_bonus_on_hit_effect = false
	ability_attack_module.benefits_from_bonus_on_hit_damage = false
	ability_attack_module.benefits_from_bonus_attack_speed = false
	ability_attack_module.benefits_from_bonus_pierce = false
	
	var ability_bullet_shape = RectangleShape2D.new()
	ability_bullet_shape.extents = Vector2(7, 5)
	
	ability_attack_module.bullet_shape = bullet_shape
	ability_attack_module.bullet_scene = WaveColumnProj_Scene
	ability_attack_module.set_texture_as_sprite_frame(Wave_AbilityBullet_Pic)
	
	ability_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(ability_attack_module)
	
	# ability explosion
	
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = 1.25
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
	sprite_frames.add_frame("default", Wave_Explosion_01)
	sprite_frames.add_frame("default", Wave_Explosion_02)
	sprite_frames.add_frame("default", Wave_Explosion_03)
	sprite_frames.add_frame("default", Wave_Explosion_04)
	sprite_frames.add_frame("default", Wave_Explosion_05)
	sprite_frames.add_frame("default", Wave_Explosion_06)
	sprite_frames.add_frame("default", Wave_Explosion_07)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 2
	explosion_attack_module.duration = 0.3
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(explosion_attack_module)
	
	# others
	
	connect("final_ability_cd_changed", self, "_on_acd_changed_w", [], CONNECT_PERSIST)
	connect("final_ability_potency_changed", self, "_on_ap_changed_w", [], CONNECT_PERSIST)
	
	connect("on_range_module_enemy_entered" , self, "_on_range_module_enemy_entered_w", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited" , self, "_on_range_module_enemy_exited_w", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	_construct_effects()
	
	add_tower_effect(wave_dmg_effect)
	# force add
	ability_attack_module.on_hit_damage_adder_effects[wave_dmg_effect.effect_uuid] = wave_dmg_effect
	
	
	_construct_and_connect_ability()
	
	_on_acd_changed_w()
	_on_ap_changed_w()



func _construct_effects():
	wave_dmg_modifier = FlatModifier.new(StoreOfTowerEffectsUUID.WAVE_ON_HIT_DMG)
	wave_dmg_modifier.flat_modifier = base_damage_amount_modifier
	
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.WAVE_ON_HIT_DMG, wave_dmg_modifier, DamageType.ELEMENTAL)
	
	wave_dmg_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.WAVE_ON_HIT_DMG)


# cd and ap related

func _on_acd_changed_w():
	current_debuff_duration = _get_cd_to_use(base_debuff_duration)


func _on_ap_changed_w():
	current_column_count = int(ceil(float(base_column_count) * tidal_wave_ability.get_potency_to_use(last_calculated_final_ability_potency)))
	
	current_column_angles_of_fire.clear()
	var twice_angle_of_fire = max_angle_of_fire * 2
	for i in current_column_count:
		var f_col_count : float = current_column_count
		var f_i : float = i
		
		current_column_angles_of_fire.append((twice_angle_of_fire * (f_i / (f_col_count - 1))) - max_angle_of_fire)


# enemy entered/exited range

func _on_range_module_enemy_entered_w(enemy, attk_module, range_module : RangeModule):
	if attk_module == main_attack_module:
		tidal_ability_activation_clause.remove_clause(no_enemy_in_range_clause)

func _on_range_module_enemy_exited_w(enemy, attk_module, range_module : RangeModule):
	if attk_module == main_attack_module:
		if main_attack_module.range_module.enemies_in_range.size() == 0:
			tidal_ability_activation_clause.attempt_insert_clause(no_enemy_in_range_clause)


# ability related

func _construct_and_connect_ability():
	tidal_wave_ability = BaseAbility.new()
	
	tidal_wave_ability.is_timebound = true
	tidal_wave_ability.connect("ability_activated", self, "_ability_activated_w", [], CONNECT_PERSIST)
	tidal_wave_ability.icon = Wave_AbilityIcon
	
	tidal_wave_ability.set_properties_to_usual_tower_based()
	tidal_wave_ability.tower = self
	
	tidal_wave_ability.descriptions = [
		"Wave sprays 8 columns of water in a cone facing its current target.",
		"Each column deals twice of Wave's passive on hit damage to all enemies hit.",
		"Each column explodes when reaching its max distance, or when hitting 2 enemies. Each explosion deals 1.25 elemental damage to 2 enemies.",
		"Activating Tidal Wave reduces the passive on hit damage by 0.5 for 30 seconds. This effect stacks, but does not refresh other stacks.",
		"Cooldown : 6 s",
		"",
		"Tidal wave's columns and explosions do not benefit from bonus base damage, on hit damages and on hit effects.",
		"Ability cdr also reduces the duration of stack's on hit damage debuff.",
		"Ability potency increases number of columns, but does not increase damage of the columns and explosions."
	]
	tidal_wave_ability.display_name = "Tidal Wave"
	
	tidal_wave_ability.activation_conditional_clauses.attempt_insert_clause(no_enemy_in_range_clause)
	tidal_ability_activation_clause = tidal_wave_ability.activation_conditional_clauses
	
	register_ability_to_manager(tidal_wave_ability)


func _ability_activated_w():
	var curr_target : Node2D = null
	if range_module != null:
		var targets = range_module.get_targets(1)
		if targets.size() != 0:
			curr_target = targets[0]
	
	if curr_target != null:
		for col_i in current_column_count:
			var bullet = ability_attack_module.construct_bullet(curr_target.global_position)
			
			var initial_angle = bullet.direction_as_relative_location.angle()
			var final_angle = initial_angle + current_column_angles_of_fire[col_i]
			
			bullet.direction_as_relative_location = bullet.direction_as_relative_location.rotated(deg2rad(final_angle))
			bullet.rotation_degrees = rad2deg(bullet.direction_as_relative_location.angle())
			
			call_deferred("_add_bullet_to_tree", bullet)
		
		_apply_debuff_stack()
		
		tidal_wave_ability.start_time_cooldown(_get_cd_to_use(base_ability_cooldown))


func _add_bullet_to_tree(bullet):
	get_tree().get_root().add_child(bullet)
	bullet.connect("tree_exiting" , self, "_on_column_death", [bullet], CONNECT_ONESHOT)


# explosion trigger

func _on_column_death(bullet):
	var bullet_position = bullet.global_position
	
	var explosion = explosion_attack_module.construct_aoe(bullet_position, bullet_position)
	explosion.global_position = bullet_position
	
	get_tree().get_root().add_child(explosion)


# do damage debuff next

func _apply_debuff_stack():
	current_debuffs_time_arr.push_front(current_debuff_duration)
	
	current_debuff_damage += debuff_damage_amount_per_cast
	var final_mod = base_damage_amount_modifier - current_debuff_damage
	if final_mod < 0:
		final_mod = 0
	elif final_mod > base_damage_amount_modifier:
		final_mod = base_damage_amount_modifier
	wave_dmg_modifier.flat_modifier = final_mod
	call_deferred("emit_signal", "effect_modifier_changed")


func _process(delta):
	if is_current_placable_in_map() and is_round_started:
		for i in current_debuffs_time_arr.size():
			var final_d = current_debuffs_time_arr[i] - delta
			if final_d < 0:
				final_d = 0
			current_debuffs_time_arr[i] = final_d
		
		while current_debuffs_time_arr.has(0):
			_remove_debuff_stack()


func _remove_debuff_stack():
	current_debuffs_time_arr.erase(0)
	
	current_debuff_damage -= debuff_damage_amount_per_cast
	var final_mod = base_damage_amount_modifier - current_debuff_damage
	if final_mod < 0:
		final_mod = 0
	elif final_mod > base_damage_amount_modifier:
		final_mod = base_damage_amount_modifier
	wave_dmg_modifier.flat_modifier = final_mod
	call_deferred("emit_signal", "effect_modifier_changed")
