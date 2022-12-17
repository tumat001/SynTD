extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")

const ExpandingAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/ExpandingAttackSprite.gd")
const ExpandingAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/ExpandingAttackSprite.tscn")

const ExecuteParticle_Scene = preload("res://TowerRelated/Color_Red/HexTribute/ExecuteParticle/Hextribute_ExecuteParticle.tscn")

const Hex_Attk01 = preload("res://TowerRelated/Color_Red/HexTribute/HexTribute_Attks/HexTributeAttk_01.png")
const Hex_Attk02 = preload("res://TowerRelated/Color_Red/HexTribute/HexTribute_Attks/HexTributeAttk_02.png")
const Hex_Attk03 = preload("res://TowerRelated/Color_Red/HexTribute/HexTribute_Attks/HexTributeAttk_03.png")
const Hex_Attk04 = preload("res://TowerRelated/Color_Red/HexTribute/HexTribute_Attks/HexTributeAttk_04.png")
const Hex_Attk05 = preload("res://TowerRelated/Color_Red/HexTribute/HexTribute_Attks/HexTributeAttk_05.png")


const hex_for_damage_bonus : int = 2
const hex_for_armor_reduction : int = 4
const hex_for_toughness_reduction : int = 6
const hex_for_effect_vulnerablility : int = 8
const hex_for_hex_per_attk_buff : int = 10
const hex_for_exeucte_normal : int = 20
const hex_for_execute_elite : int = 80

const hex_bonus_damage_amount : float = 1.5
const hex_armor_reduction_ratio : float = 25.0
const hex_toughness_reduction_ratio : float = 25.0
const hex_effect_vulnerability_ratio : float = 75.0


const base_hex_per_attack : int = 1
const base_empowered_hex_per_attack : int = 4
const extra_hex_per_attack_per_ability_pot_interval : int = 1
const extra_hex_ability_pot_interval : float = 0.5

var current_hex_per_attack : int = base_hex_per_attack

var hextribute_hex_stack_effect : TowerOnHitEffectAdderEffect
var hextribute_bonus_on_hit_damage : OnHitDamage
var hextribute_armor_reduction_effect : EnemyAttributesEffect
var hextribute_toughness_reduction_effect : EnemyAttributesEffect
var hextribute_effect_vul_effect : EnemyAttributesEffect

var hex_attk_sprite_frames : SpriteFrames
onready var hextribute_crest : Sprite = $TowerBase/KnockUpLayer/Crest


var original_attack_module
var execute_attack_module : InstantDamageAttackModule

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.HEXTRIBUTE)
	
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
	range_module.add_targeting_option(Targeting.HEALTHIEST)
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 6
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	add_attack_module(attack_module)
	
	connect("on_any_attack_module_enemy_hit", self, "_on_any_attack_hit_enemy_h", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_h", [], CONNECT_PERSIST)
	
	hextribute_crest.visible = false
	original_attack_module = attack_module
	
	hextribute_crest.use_parent_material = false
	
	#
	
	execute_attack_module = InstantDamageAttackModule_Scene.instance()
	execute_attack_module.base_damage = 0
	execute_attack_module.base_damage_type = info.base_damage_type
	execute_attack_module.base_attack_speed = info.base_attk_speed
	execute_attack_module.base_attack_wind_up = 0
	execute_attack_module.is_main_attack = false
	execute_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	execute_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	execute_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	#execute_attack_module.benefits_from_any_effect = false
	execute_attack_module.can_be_commanded_by_tower = false
	
	execute_attack_module.set_image_as_tracker_image(preload("res://TowerRelated/Color_Red/HexTribute/ExecuteParticle/Assets/Hextribute_ExecuteParticle_08.png"))
	
	
	add_attack_module(execute_attack_module)
	
	
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	_construct_effects()
	_construct_others()
	
	add_tower_effect(hextribute_hex_stack_effect)


func _construct_effects():
	var enemy_hextribute_hex_stack = EnemyStackEffect.new(null, 1, 9999, StoreOfEnemyEffectsUUID.HEXTRIBUTE_HEX_STACK, false, false)
	enemy_hextribute_hex_stack.is_timebound = false
	
	hextribute_hex_stack_effect = TowerOnHitEffectAdderEffect.new(enemy_hextribute_hex_stack, StoreOfTowerEffectsUUID.HEXTRIBUTE_HEX_STACK)
	
	var dmg_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEXTRIBUTE_BONUS_DMG)
	dmg_modi.flat_modifier = hex_bonus_damage_amount
	hextribute_bonus_on_hit_damage = OnHitDamage.new(StoreOfTowerEffectsUUID.HEXTRIBUTE_BONUS_DMG, dmg_modi, DamageType.ELEMENTAL)
	
	var armor_red_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.HEXTRIBUTE_ARMOR_REDUCTION)
	armor_red_modi.percent_amount = hex_armor_reduction_ratio
	armor_red_modi.percent_based_on = PercentType.BASE
	hextribute_armor_reduction_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_ARMOR, armor_red_modi, StoreOfEnemyEffectsUUID.HEXTRIBUTE_ARMOR_REDUCTION)
	
	var tou_red_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.HEXTRIBUTE_TOUGHNESS_REDUCTION)
	tou_red_modi.percent_amount = hex_toughness_reduction_ratio
	tou_red_modi.percent_based_on = PercentType.BASE
	hextribute_toughness_reduction_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_TOUGHNESS, tou_red_modi, StoreOfEnemyEffectsUUID.HEXTRIBUTE_TOUGHNESS_REDUCTION)
	
	var effect_vul_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.HEXTRIBUTE_EFFECT_VULNERABLE)
	effect_vul_modi.percent_amount = hex_effect_vulnerability_ratio
	effect_vul_modi.percent_based_on = PercentType.BASE
	hextribute_effect_vul_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_EFFECT_VULNERABILITY, effect_vul_modi, StoreOfEnemyEffectsUUID.HEXTRIBUTE_EFFECT_VULNERABLE)
	hextribute_effect_vul_effect.respect_scale = false

func _construct_others():
	hex_attk_sprite_frames = SpriteFrames.new()
	
	hex_attk_sprite_frames.add_frame("default", Hex_Attk01)
	hex_attk_sprite_frames.add_frame("default", Hex_Attk02)
	hex_attk_sprite_frames.add_frame("default", Hex_Attk03)
	hex_attk_sprite_frames.add_frame("default", Hex_Attk04)
	hex_attk_sprite_frames.add_frame("default", Hex_Attk05)


#

func _on_any_attack_hit_enemy_h(enemy, damage_register_id, damage_instance, module):
	if module.benefits_from_bonus_on_hit_effect:
		var stack_amount : int = 0
		
		if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.HEXTRIBUTE_HEX_STACK):
			var effect : EnemyStackEffect = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.HEXTRIBUTE_HEX_STACK]
			stack_amount = effect._current_stack
			
			if stack_amount >= hex_for_damage_bonus - 1:
				damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.HEXTRIBUTE_BONUS_DMG] = hextribute_bonus_on_hit_damage
				
			if stack_amount >= hex_for_armor_reduction - 1:
				damage_instance.on_hit_effects[StoreOfEnemyEffectsUUID.HEXTRIBUTE_ARMOR_REDUCTION] = hextribute_armor_reduction_effect
				
			if stack_amount >= hex_for_toughness_reduction - 1:
				damage_instance.on_hit_effects[StoreOfEnemyEffectsUUID.HEXTRIBUTE_TOUGHNESS_REDUCTION] = hextribute_toughness_reduction_effect
				
			if stack_amount >= hex_for_effect_vulnerablility - 1:
				damage_instance.on_hit_effects[StoreOfEnemyEffectsUUID.HEXTRIBUTE_EFFECT_VULNERABLE] = hextribute_effect_vul_effect
				
			if stack_amount >= hex_for_hex_per_attk_buff - 1:
				current_hex_per_attack = _get_empowered_hex_per_attack_amount()
				hextribute_crest.visible = true
				_update_stack_amount_of_hex_effect()
			
			if stack_amount >= hex_for_exeucte_normal - 1 and enemy.is_enemy_type_normal():
				call_deferred("_attempt_execute_normal_enemy", enemy)
			
			if stack_amount >= hex_for_execute_elite - 1 and !enemy.is_enemy_type_boss():
				call_deferred("_attempt_execute_elite_enemy", enemy)
		
		call_deferred("_create_attk_sprite", enemy.global_position, stack_amount)

func _get_empowered_hex_per_attack_amount() -> int:
	var extra_hex = floor(get_bonus_ability_potency() / extra_hex_ability_pot_interval) * extra_hex_per_attack_per_ability_pot_interval
	
	return base_empowered_hex_per_attack + extra_hex

func _create_attk_sprite(pos, stack_amount):
	var attk_sprite : ExpandingAttackSprite = ExpandingAttackSprite_Scene.instance()
	
	attk_sprite.has_lifetime = true
	attk_sprite.lifetime = 0.15
	attk_sprite.scale *= 0.5
	attk_sprite.scale_of_scale = 1.12
	attk_sprite.offset.y = -0.5
	attk_sprite.offset.x = -0.5
	
	attk_sprite.frames = hex_attk_sprite_frames
	
	var frame_to_use : int = 0
	if stack_amount >= hex_for_effect_vulnerablility - 1:
		frame_to_use = 4
	elif stack_amount >= hex_for_toughness_reduction - 1:
		frame_to_use = 3
	elif stack_amount >= hex_for_armor_reduction - 1:
		frame_to_use = 2
	elif stack_amount >= hex_for_damage_bonus - 1:
		frame_to_use = 1
	
	attk_sprite.playing = false
	
	attk_sprite.position = pos
	attk_sprite.frame = frame_to_use
	attk_sprite.reset_frame_to_start = false
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(attk_sprite)


func _attempt_execute_elite_enemy(enemy):
	if is_instance_valid(enemy) and !enemy.is_queued_for_deletion():
		enemy.execute_self_by(StoreOfTowerEffectsUUID.HEXTRIBUTE_EXECUTE, execute_attack_module)
		_executed_enemy_by_hexes(enemy)
		
		

func _attempt_execute_normal_enemy(enemy):
	if is_instance_valid(enemy) and !enemy.is_queued_for_deletion():
		enemy.execute_self_by(StoreOfTowerEffectsUUID.HEXTRIBUTE_EXECUTE, execute_attack_module)
		_executed_enemy_by_hexes(enemy)

func _executed_enemy_by_hexes(arg_enemy):
	var particle = ExecuteParticle_Scene.instance()
	particle.global_position = arg_enemy.global_position
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)


func _update_stack_amount_of_hex_effect():
	hextribute_hex_stack_effect.enemy_base_effect.num_of_stacks_per_apply = current_hex_per_attack

#

func _on_round_end_h():
	current_hex_per_attack = base_hex_per_attack
	_update_stack_amount_of_hex_effect()
	hextribute_crest.visible = false



# HeatModule

func set_heat_module(module):
	module.heat_per_attack = 1
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

