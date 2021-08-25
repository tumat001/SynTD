extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const TimeMachine_WindUpParticle_Scene = preload("res://TowerRelated/Color_Blue/TimeMachine/TimeMachine_Attks/TimeMachine_WindUpParticle.tscn")

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
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1
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
	
	
	connect("on_main_post_mitigation_damage_dealt" , self, "_on_main_post_mitigated_dmg_dealt", [], CONNECT_PERSIST)
	
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

func _on_main_post_mitigated_dmg_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.TIME_MACHINE_TIME_DUST):
		var effect = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.TIME_MACHINE_TIME_DUST]
		effect._current_stack -= 1
		if effect._current_stack <= 0:
			enemy._remove_effect(time_dust_effect)
		
		_time_dust_stack_consumed()
	
	if !killed and rewind_ability_is_ready:
		var final_potency = rewind_ability.get_potency_to_use(last_calculated_final_ability_potency)
		var final_shift = final_potency * base_position_shift
		
		enemy.shift_position(final_shift)
		
		rewind_ability.start_time_cooldown(_get_cd_to_use(base_rewind_cooldown))
		enemy._add_effect(time_dust_effect._get_copy_scaled_by(1))


func _time_dust_stack_consumed():
	if is_energy_module_on:
		ability_manager._decrease_time_cooldown_of_all_abilities(time_dust_energy_module_cd_time_decrease)
		
	else:
		rewind_ability.time_decreased(time_dust_cd_time_decrease)


# module effects

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Consuming a stack of Time Dust instead reduces all abilities’s cooldown by 2.5 seconds.",
			"Turning this on while in round also sets Rewind's current cooldown to 0.",
		]


func _module_turned_on(_first_time_per_round : bool):
	is_energy_module_on = true
	
	if is_round_started:
		rewind_ability.time_decreased(rewind_ability._time_current_cooldown)


func _module_turned_off():
	is_energy_module_on = false
