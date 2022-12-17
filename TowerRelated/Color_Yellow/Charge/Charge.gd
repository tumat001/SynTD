extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")


const ChargeBullet_Level1 = preload("res://TowerRelated/Color_Yellow/Charge/Charge_Bullet_Level1.png")
const ChargeBullet_Level2 = preload("res://TowerRelated/Color_Yellow/Charge/Charge_Bullet_Level2.png")
const ChargeBullet_Level3 = preload("res://TowerRelated/Color_Yellow/Charge/Charge_Bullet_Level3.png")
const ChargeBullet_Level4 = preload("res://TowerRelated/Color_Yellow/Charge/Charge_Bullet_Level4.png")
const ChargeBar_0 = preload("res://TowerRelated/Color_Yellow/Charge/ChargeBar/Bar00.png")
const ChargeBar_1 = preload("res://TowerRelated/Color_Yellow/Charge/ChargeBar/Bar01.png")
const ChargeBar_2 = preload("res://TowerRelated/Color_Yellow/Charge/ChargeBar/Bar02.png")
const ChargeBar_3 = preload("res://TowerRelated/Color_Yellow/Charge/ChargeBar/Bar03.png")
const ChargeBar_4 = preload("res://TowerRelated/Color_Yellow/Charge/ChargeBar/Bar04.png")
const ChargeBar_5 = preload("res://TowerRelated/Color_Yellow/Charge/ChargeBar/Bar05.png")
const ChargeBar_6 = preload("res://TowerRelated/Color_Yellow/Charge/ChargeBar/Bar06.png")
const ChargeBar_6_Special = preload("res://TowerRelated/Color_Yellow/Charge/ChargeBar/Bar06_WithEnergy.png")

const MaxChargeParticle_Scene = preload("res://TowerRelated/Color_Yellow/Charge/MaxChargeParticle/MaxChargeParticle.tscn")

const proj_speed_level_1 : float = 300.0
const proj_speed_level_2 : float = 400.0
const proj_speed_level_3 : float = 500.0
const proj_speed_level_4 : float = 650.0

const original_max_on_hit_damage : float = 35.0
const original_max_percent_on_hit_damage : float = 20.0

const with_energy_max_on_hit_damage : float = 160.0


const original_max_energy : float = 100.0
const original_base_energy_recharge_per_sec : float = 20.0


var max_on_hit_damage : float = original_max_on_hit_damage
var max_percent_enemy_health_on_hit_damage_amount : float = original_max_percent_on_hit_damage
var max_energy : float = original_max_energy
var base_energy_recharge_per_sec : float = original_base_energy_recharge_per_sec
var _last_calculated_recharge_rate : float = 20.0

var _current_energy : float = 0.0
var _current_energy_recharge_per_sec : float = 20.0
var _current_cooldown_before_recharge : float = 0

var _current_chargebar_06 : Texture = ChargeBar_6


var bonus_on_hit_damage : OnHitDamage
var bonus_percent_on_hit_damage : OnHitDamage
var bonus_damage_as_modifier : FlatModifier
var bonus_percent_damage_as_modifier : PercentModifier

var interpreter_for_flat_on_hit : TextFragmentInterpreter

#

onready var charge_bar_sprite : Sprite = $TowerBase/KnockUpLayer/ChargeBarSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.CHARGE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	_construct_bonus_on_hit_and_modifier()
	
	var attack_module_y_shift : float = 7.0
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attack_module_y_shift
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = -20
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attack_module_y_shift
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(14, 8)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	connect("attack_module_removed", self, "_on_attack_module_removed_from_charge")
	connect("attack_module_added", self, "_on_attack_module_added_from_charge")
	
	connect("final_attack_speed_changed", self, "_calculate_recharge_per_sec")
	
	add_attack_module(attack_module)
	
	_post_inherit_ready()


func _construct_bonus_on_hit_and_modifier():
	bonus_damage_as_modifier = FlatModifier.new(StoreOfTowerEffectsUUID.CHARGE_BONUS_ON_HIT)
	bonus_on_hit_damage = OnHitDamage.new(StoreOfTowerEffectsUUID.CHARGE_BONUS_ON_HIT, bonus_damage_as_modifier, DamageType.PHYSICAL)
	
	bonus_percent_damage_as_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.CHARGE_BONUS_PERCENT_ON_HIT)
	bonus_percent_damage_as_modifier.percent_based_on = PercentType.MAX
	bonus_percent_on_hit_damage = OnHitDamage.new(StoreOfTowerEffectsUUID.CHARGE_BONUS_PERCENT_ON_HIT, bonus_percent_damage_as_modifier, DamageType.PHYSICAL)


# Module adding/removing

func _on_attack_module_removed_from_charge(attack_module : AbstractAttackModule):
	if is_instance_valid(attack_module) and attack_module == main_attack_module:
		if attack_module.has_signal("in_attack"):
			attack_module.disconnect("in_attack", self, "_main_module_in_attack")
			attack_module.disconnect("before_bullet_is_shot", self, "_modify_bullet_before_shooting")


func _on_attack_module_added_from_charge(attack_module : AbstractAttackModule):
	if is_instance_valid(attack_module) and attack_module == main_attack_module:
		attack_module.connect("in_attack", self, "_main_module_in_attack")
		attack_module.connect("before_bullet_is_shot", self, "_modify_bullet_before_shooting")


# Cooldown related

func _main_module_in_attack(attack_delay, enemies):
	_current_cooldown_before_recharge = attack_delay
	
	charge_bar_sprite.texture = ChargeBar_0


func _process(delta):
	if is_round_started and current_placable is InMapAreaPlacable:
		if _current_cooldown_before_recharge <= 0:
			if _current_energy < max_energy:
				
				_current_energy += _last_calculated_recharge_rate * delta
				
				if _current_energy > max_energy:
					_current_energy = max_energy
				
				
				if _current_energy >= max_energy:
					charge_bar_sprite.texture = _current_chargebar_06
				elif _current_energy > max_energy * 5 / 6:
					charge_bar_sprite.texture = ChargeBar_5
				elif _current_energy > max_energy * 4 / 6:
					charge_bar_sprite.texture = ChargeBar_4
				elif _current_energy > max_energy * 3 / 6:
					charge_bar_sprite.texture = ChargeBar_3
				elif _current_energy > max_energy * 2 / 6:
					charge_bar_sprite.texture = ChargeBar_2
				elif _current_energy > max_energy * 1 / 6:
					charge_bar_sprite.texture = ChargeBar_1
				else:
					charge_bar_sprite.texture = ChargeBar_0
				
			
		else:
			_current_cooldown_before_recharge -= delta


func _on_round_start():
	._on_round_start()
	
	_current_energy = max_energy / 2
	_current_cooldown_before_recharge = 0


func _on_round_end():
	._on_round_end()
	
	_current_energy = 0


# Stats calculation related

func _calculate_recharge_per_sec():
	_last_calculated_recharge_rate = base_energy_recharge_per_sec * (main_attack_module.last_calculated_final_attk_speed / main_attack_module.base_attack_speed)

func _calculate_level_of_charge() -> int: # from 1 - 4
	return int(ceil(((_current_energy * 3) / max_energy))) + 1

func _get_bullet_sprite_to_use(level_of_charge) -> Texture:
	if level_of_charge == 1:
		return ChargeBullet_Level1
	elif level_of_charge == 2:
		return ChargeBullet_Level2
	elif level_of_charge == 3:
		return ChargeBullet_Level3
	else:
		return ChargeBullet_Level4

func _get_proj_speed_to_use(level_of_charge) -> float:
	if level_of_charge == 1:
		return proj_speed_level_1
	elif level_of_charge == 2:
		return proj_speed_level_2
	elif level_of_charge == 3:
		return proj_speed_level_3
	else:
		return proj_speed_level_4

func _update_on_hit_damage_to_use():
	bonus_damage_as_modifier.flat_modifier = (_current_energy / max_energy) * max_on_hit_damage * last_calculated_final_ability_potency
	bonus_on_hit_damage.damage_as_modifier = bonus_damage_as_modifier
	
	bonus_percent_damage_as_modifier.percent_amount = (_current_energy / max_energy) * max_percent_enemy_health_on_hit_damage_amount * last_calculated_final_ability_potency
	bonus_percent_on_hit_damage.damage_as_modifier = bonus_percent_damage_as_modifier


# Bullet modification

func _modify_bullet_before_shooting(bullet : BaseBullet):
	var level_of_charge = _calculate_level_of_charge()
	
	if bullet.get_sprite_frames() == null:
		var s_frames = SpriteFrames.new()
		s_frames.add_frame("default", _get_bullet_sprite_to_use(level_of_charge))
		bullet.set_sprite_frames(s_frames)
	
	if bullet.speed == -20: # it was set to -20 (look at up)
		bullet.speed = _get_proj_speed_to_use(level_of_charge)
	
	_update_on_hit_damage_to_use()
	bullet.damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.CHARGE_BONUS_ON_HIT] = bonus_on_hit_damage
	bullet.damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.CHARGE_BONUS_PERCENT_ON_HIT] = bonus_percent_on_hit_damage
	
	_current_energy = 0
	
	if level_of_charge == 4: # 4 is max
		bullet.connect("hit_an_enemy", self, "_on_bullet_hit_enemy")


func _on_bullet_hit_enemy(arg_bullet, arg_enemy):
	var max_charge_particle = MaxChargeParticle_Scene.instance()
	max_charge_particle.position = arg_enemy.global_position
	max_charge_particle.scale *= 1.5
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(max_charge_particle)


# Module related

func set_energy_module(module):
	.set_energy_module(module)
	
	if interpreter_for_flat_on_hit == null:
		_construct_interpreter_for_energy_module()
	
	if module != null:
		module.module_effect_descriptions = [
			["Max base flat on hit damage is increased to |0|. Charge's flat portion of its passive becomes pure damage instead. Also recharges faster.", [interpreter_for_flat_on_hit]]
		]


func _module_turned_on(_first_time_per_round : bool):
	max_on_hit_damage = with_energy_max_on_hit_damage
	base_energy_recharge_per_sec = 50.0
	_current_chargebar_06 = ChargeBar_6_Special
	
	if charge_bar_sprite != null:
		charge_bar_sprite.texture = _current_chargebar_06
	
	bonus_on_hit_damage.damage_type = DamageType.PURE
	#bonus_percent_on_hit_damage.damage_type = DamageType.PURE
	
	_calculate_recharge_per_sec()


func _module_turned_off():
	max_on_hit_damage = original_max_on_hit_damage
	base_energy_recharge_per_sec = original_base_energy_recharge_per_sec
	_current_chargebar_06 = ChargeBar_6
	
	if charge_bar_sprite != null:
		charge_bar_sprite.texture = _current_chargebar_06
	
	bonus_on_hit_damage.damage_type = DamageType.PHYSICAL
	#bonus_percent_on_hit_damage.damage_type = DamageType.PHYSICAL
	
	_calculate_recharge_per_sec()



func _construct_interpreter_for_energy_module():
	# INS START
	interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
	interpreter_for_flat_on_hit.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_flat_on_hit.display_body = false
	
	var ins_for_flat_on_hit = []
	ins_for_flat_on_hit.append(NumericalTextFragment.new(with_energy_max_on_hit_damage, false, DamageType.PHYSICAL))
	
	
	interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
	


# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 3
	.set_heat_module(module)

func _construct_heat_effect():
	var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	attr_mod.flat_modifier = 0.5
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	_calculate_final_ability_potency()


