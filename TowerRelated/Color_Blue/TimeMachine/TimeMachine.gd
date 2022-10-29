extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const TimeMachine_WindUpParticle_Scene = preload("res://TowerRelated/Color_Blue/TimeMachine/TimeMachine_Attks/TimeMachine_WindUpParticle.tscn")
const TimePortal_Pic = preload("res://TowerRelated/Color_Blue/TimeMachine/TimeMachine_Attks/TimeMachine_TimePortal_Sprite.png")

const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")

const TimeMachine_TimeDust_StatusIcon = preload("res://TowerRelated/Color_Blue/TimeMachine/TimeMachine_Attks/TimeMachine_TimeDust_EnemyIcon.png")


const base_position_shift : float = -65.0
const base_rewind_cooldown : float = 15.0
var rewind_ability : BaseAbility
var rewind_ability_is_ready : bool = false

const time_dust_cd_time_decrease : float = 2.0
const time_dust_energy_module_cd_time_decrease : float = 2.5

var time_dust_effect : EnemyStackEffect

var is_energy_module_on : bool


var time_portal_attack_module : AOEAttackModule
const time_portal_duration : float = 8.0
const time_portal_rewind_scale : float = 2.0

const rewind_effectiveness_on_boss_with_energy : float = 0.33


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.TIME_MACHINE)
	
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
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1.5
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	
	attack_module.attack_sprite_show_in_windup = true
	attack_module.attack_sprite_show_in_attack = false
	attack_module.attack_sprite_follow_enemy = true
	attack_module.attack_sprite_match_lifetime_to_windup = true
	attack_module.attack_sprite_scene = TimeMachine_WindUpParticle_Scene
	
	add_attack_module(attack_module)
	
	#
	
	time_portal_attack_module = AOEAttackModule_Scene.instance()
	time_portal_attack_module.base_damage = 0
	time_portal_attack_module.base_damage_type = DamageType.ELEMENTAL
	time_portal_attack_module.base_attack_speed = 0
	time_portal_attack_module.base_attack_wind_up = 0
	time_portal_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	time_portal_attack_module.is_main_attack = false
	time_portal_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	time_portal_attack_module.benefits_from_bonus_explosion_scale = true
	time_portal_attack_module.benefits_from_bonus_base_damage = false
	time_portal_attack_module.benefits_from_bonus_attack_speed = false
	time_portal_attack_module.benefits_from_bonus_on_hit_damage = false
	time_portal_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", TimePortal_Pic)
	
	time_portal_attack_module.aoe_sprite_frames = sprite_frames
	time_portal_attack_module.sprite_frames_only_play_once = true
	time_portal_attack_module.pierce = -1
	time_portal_attack_module.duration = time_portal_duration
	time_portal_attack_module.damage_repeat_count = 1
	
	time_portal_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	time_portal_attack_module.base_aoe_scene = BaseAOE_Scene
	time_portal_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	time_portal_attack_module.can_be_commanded_by_tower = false
	
	time_portal_attack_module.is_displayed_in_tracker = false
	
	add_attack_module(time_portal_attack_module)
	
	#
	
	connect("on_main_post_mitigation_damage_dealt" , self, "_on_main_post_mitigated_dmg_dealt_t", [], CONNECT_PERSIST)
	
	_construct_and_register_ability()
	_construct_effect()
	
	_post_inherit_ready()


func _construct_and_register_ability():
	rewind_ability = BaseAbility.new()
	
	rewind_ability.is_timebound = true
	
	rewind_ability.set_properties_to_usual_tower_based()
	rewind_ability.tower = self
	
	rewind_ability.connect("updated_is_ready_for_activation", self, "_can_cast_rewind_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(rewind_ability, false)
	

func _can_cast_rewind_updated(is_ready):
	rewind_ability_is_ready = is_ready

func _construct_effect():
	time_dust_effect = EnemyStackEffect.new(null, 0, 99999, StoreOfEnemyEffectsUUID.TIME_MACHINE_TIME_DUST)
	time_dust_effect.is_timebound = true
	time_dust_effect.time_in_seconds = 10
	time_dust_effect._current_stack = 3
	time_dust_effect.status_bar_icon = TimeMachine_TimeDust_StatusIcon
	


# attk

func _on_main_post_mitigated_dmg_dealt_t(damage_instance_report, killed, enemy, damage_register_id, module):
	if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.TIME_MACHINE_TIME_DUST):
		var effect = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.TIME_MACHINE_TIME_DUST]
		effect._current_stack -= 1
		if effect._current_stack <= 0:
			enemy._remove_effect(time_dust_effect)
		
		_time_dust_stack_consumed()
	
	if !killed and rewind_ability_is_ready:
		if !enemy.is_enemy_type_boss() or (enemy.is_enemy_type_boss() and is_energy_module_on):
			var shift_scale : float = 1
			
			if enemy.is_enemy_type_boss():
				shift_scale = rewind_effectiveness_on_boss_with_energy
			
			var cd = _get_cd_to_use(base_rewind_cooldown)
			rewind_ability.on_ability_before_cast_start(cd)
			
			_shift_enemy_position_t(enemy, shift_scale)
			rewind_ability.start_time_cooldown(cd)
			enemy._add_effect(time_dust_effect._get_copy_scaled_by(1))
			
			_enemy_shifted_by_main_attack(enemy, enemy.global_position)
			
			rewind_ability.on_ability_after_cast_ended(cd)


func _time_dust_stack_consumed():
	if is_energy_module_on:
		ability_manager._decrease_time_cooldown_of_all_abilities(time_dust_energy_module_cd_time_decrease)
	else:
		rewind_ability.time_decreased(time_dust_cd_time_decrease)



func _shift_enemy_position_t(enemy, shift_scale : float = 1):
	var final_potency = rewind_ability.get_potency_to_use(last_calculated_final_ability_potency)
	var final_shift = final_potency * base_position_shift * shift_scale
	
	enemy.shift_offset(final_shift)



# module effects

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Consuming a stack of Time Dust instead reduces all abilities’s cooldown by %s seconds." % [str(time_dust_energy_module_cd_time_decrease)],
			"Boss enemies are now affected by teleportation at %s effectiveness." % [str(rewind_effectiveness_on_boss_with_energy * 100) + "%"],
			"",
			"A time portal is opened beneath the rewinded enemy for %s seconds. Enemies that enter the time portal for the first time are teleported backwards at %s effectiveness." % [str(time_portal_duration), str(time_portal_rewind_scale * 100) + "%"],
		]


func _module_turned_on(_first_time_per_round : bool):
	is_energy_module_on = true

func _module_turned_off():
	is_energy_module_on = false


# time portal related

func _enemy_shifted_by_main_attack(enemy, enemy_curr_position):
	if is_energy_module_on and is_instance_valid(enemy):
		var time_portal = time_portal_attack_module.construct_aoe(enemy_curr_position, enemy_curr_position)
		time_portal.enemies_to_ignore.append(enemy)
		#time_portal.rotation_deg_per_sec = 360 / time_portal_duration
		time_portal.connect("before_enemy_hit_aoe", self, "_time_portal_hit_enemy", [time_portal])
		time_portal.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
		
		get_tree().get_root().add_child(time_portal)


func _time_portal_hit_enemy(enemy, aoe):
	if is_instance_valid(enemy):
		if !enemy.is_enemy_type_boss():
			_shift_enemy_position_t(enemy, time_portal_rewind_scale)
			aoe.enemies_to_ignore.append(enemy)
		elif is_energy_module_on and enemy.is_enemy_type_boss():
			_shift_enemy_position_t(enemy, time_portal_rewind_scale * rewind_effectiveness_on_boss_with_energy)
			aoe.enemies_to_ignore.append(enemy)
