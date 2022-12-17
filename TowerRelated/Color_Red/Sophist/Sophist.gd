extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")
const ExpandingAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/ExpandingAttackSprite.gd")
const ExpandingAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/ExpandingAttackSprite.tscn")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")

const Sophist_MainProj_Pic = preload("res://TowerRelated/Color_Red/Sophist/Assets/Sophist_MainProj.png")
#const Sophist_Crystal_Pic = preload("res://TowerRelated/Color_Red/Sophist/Assets/Sophist_CrystalProj.png")
const Sophist_CrystalAura_Pic = preload("res://TowerRelated/Color_Red/Sophist/Assets/Sophist_CrystalAuraPic.png")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")

const CrystalProj_Scene = preload("res://TowerRelated/Color_Red/Sophist/Subs/CrystalProj.tscn")

#

const crystal_group_name : String = "TOWERS_RED_SOPHIST__CRYSTALS"
var crystal_attk_module : BulletAttackModule
var crystal_pos_rng : RandomNumberGenerator
const crystal_pos_rng_min_val : int = -30
const crtstal_pos_rng_max_val : int = 30
const crystal_tower_seek_range : float = 120.0

var enchant_ability : BaseAbility
var is_enchant_ability_ready : bool

const main_attacks_to_cast_enchant : int = 10
var _current_main_attack_count : int = 0
var _current_crystal_count : int = 0

const base_attk_speed_buff_amount : float = 10.0
const attk_speed_buff_amount_per_crystal : float = 10.0
const max_attack_speed_buff_amount : float = 60.0
const attk_speed_buff_duration : float = 8.0
var _current_attk_speed_buff_amount : float
var crystal_attk_speed_effect : TowerAttributesEffect

var crystal_aura_trigger_delay_timer : TimerForTower
const crystal_aura_trigger_delay_amount : float = 1.0
var crystal_aura_attk_sprite_pool : AttackSpritePoolComponent

var interpreter_for_current_attk_speed : TextFragmentInterpreter

var crystal_proj_activate_deactivate_timer : TimerForTower


#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SOPHIST)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 27
	range_module.position.x -= 2
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 530#450
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 27
	attack_module.position.x += 2
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Sophist_MainProj_Pic)
	
	add_attack_module(attack_module)
	
	#
	
	crystal_pos_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SOPHIST_CRYSAL_POS)
	
	_construct_and_add_crsyal_attk_module()
	_construct_attk_speed_effect()
	_construct_and_register_ability()
	
	connect("on_main_attack", self, "_on_main_attack_s", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_s", [], CONNECT_PERSIST)
	
	crystal_aura_trigger_delay_timer = TimerForTower.new()
	crystal_aura_trigger_delay_timer.set_tower_and_properties(self)
	crystal_aura_trigger_delay_timer.one_shot = true
	crystal_aura_trigger_delay_timer.connect("timeout", self, "_on_crystal_aura_trigger_delay_timer_timeout", [], CONNECT_PERSIST)
	crystal_aura_trigger_delay_timer.stop_on_round_end_instead_of_pause = true
	add_child(crystal_aura_trigger_delay_timer)
	
	crystal_proj_activate_deactivate_timer = TimerForTower.new()
	crystal_proj_activate_deactivate_timer.set_tower_and_properties(self)
	crystal_proj_activate_deactivate_timer.one_shot = true
	crystal_proj_activate_deactivate_timer.connect("timeout", self, "_on_crystal_acti_deacti_timer_timeout", [], CONNECT_PERSIST)
	crystal_proj_activate_deactivate_timer.stop_on_round_end_instead_of_pause = true
	add_child(crystal_proj_activate_deactivate_timer)
	
	_initialize_interpreters_for_tower_desc()
	
	#
	
	crystal_aura_attk_sprite_pool = AttackSpritePoolComponent.new()
	crystal_aura_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	crystal_aura_attk_sprite_pool.node_to_listen_for_queue_free = self
	crystal_aura_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	crystal_aura_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_crystal_aura_particle"
	
	#
	
	_post_inherit_ready()


func _construct_and_add_crsyal_attk_module():
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = 0
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = 1
	attack_module.base_proj_speed = 600
	#attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = 1
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = false
	
	#attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = CrystalProj_Scene
	#attack_module.set_texture_as_sprite_frame(Sophist_Crystal_Pic)
	
	attack_module.can_be_commanded_by_tower = false
	
	attack_module.is_displayed_in_tracker = false
	
	crystal_attk_module = attack_module
	
	add_attack_module(attack_module)

func _construct_and_register_ability():
	enchant_ability = BaseAbility.new()
	
	enchant_ability.is_timebound = true
	
	enchant_ability.set_properties_to_usual_tower_based()
	enchant_ability.tower = self
	
	enchant_ability.connect("updated_is_ready_for_activation", self, "_can_cast_enchant_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(enchant_ability, false)


func _construct_attk_speed_effect():
	var modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.SOPHIST_CRYSTAL_ATTK_SPEED_EFFECT)
	modi.percent_amount = base_attk_speed_buff_amount
	modi.percent_based_on = PercentType.BASE
	
	crystal_attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, modi, StoreOfTowerEffectsUUID.SOPHIST_CRYSTAL_ATTK_SPEED_EFFECT)
	crystal_attk_speed_effect.is_timebound = true
	crystal_attk_speed_effect.time_in_seconds = attk_speed_buff_duration
	crystal_attk_speed_effect.status_bar_icon = preload("res://TowerRelated/Color_Red/Sophist/Assets/Sophist_CrystalBuff_StatusBarIcon.png")


#

func _can_cast_enchant_updated(arg_is_ready):
	is_enchant_ability_ready = arg_is_ready

func _on_main_attack_s(attk_speed_delay, enemies, module):
	_current_main_attack_count += 1
	
	if _current_main_attack_count >= main_attacks_to_cast_enchant and enemies.size() > 0:
		_attempt_cast_enchant(enemies[0])


func _attempt_cast_enchant(arg_enemy):
	if is_enchant_ability_ready:
		_cast_enchant(arg_enemy)

func _cast_enchant(arg_enemy):
	if is_instance_valid(arg_enemy):
		_current_main_attack_count = 0
		set_crystal_count_amount(_current_crystal_count + 1)
		
		var pos = get_randomized_pos_based_on_arg_pos(arg_enemy.global_position)
		var crystal = crystal_attk_module.construct_bullet(pos)
		crystal.add_to_group(crystal_group_name)
		crystal.connect("on_current_life_distance_expire", self, "_on_crystal_life_distance_expired", [crystal], CONNECT_ONESHOT)
		
		crystal.can_hit_enemy(false)
		#crystal.rotation_per_second = 270
		crystal.destroy_self_after_zero_life_distance = false
		crystal_attk_module.set_up_bullet__add_child_and_emit_signals(crystal)
		crystal_aura_trigger_delay_timer.start(crystal_aura_trigger_delay_amount)


func set_crystal_count_amount(arg_amount):
	_current_crystal_count = arg_amount
	_current_attk_speed_buff_amount = base_attk_speed_buff_amount + ((_current_crystal_count - 1) * attk_speed_buff_amount_per_crystal)
	if _current_attk_speed_buff_amount > max_attack_speed_buff_amount:
		_current_attk_speed_buff_amount = max_attack_speed_buff_amount
	elif _current_attk_speed_buff_amount < base_attk_speed_buff_amount:
		_current_attk_speed_buff_amount = base_attk_speed_buff_amount
	
	_update_tower_descriptions()

func get_randomized_pos_based_on_arg_pos(arg_pos):
	return arg_pos + Vector2(crystal_pos_rng.randi_range(crystal_pos_rng_min_val, crtstal_pos_rng_max_val), crystal_pos_rng.randi_range(crystal_pos_rng_min_val, crtstal_pos_rng_max_val))

func _on_crystal_life_distance_expired(arg_crystal):
	arg_crystal.speed = 0

#

func _on_crystal_aura_trigger_delay_timer_timeout():
	var candidate_towers = _get_all_towers_in_range_of_crystals()
	
	for tower in candidate_towers:
		var copy_of_effect : TowerAttributesEffect = crystal_attk_speed_effect._get_copy_scaled_by(1)
		copy_of_effect.attribute_as_modifier.percent_amount = _current_attk_speed_buff_amount
		
		tower.add_tower_effect(copy_of_effect)
	
	_activate_all_crystals()

func _get_all_towers_in_range_of_crystals() -> Array:
	var candidate_towers : Array = []
	var all_towers_in_map = tower_manager.get_all_in_map_towers()
	
	for crystal in get_tree().get_nodes_in_group(crystal_group_name):
		var towers_in_range_of_crystal = Targeting.get_targets__based_on_range_from_center_as_circle(all_towers_in_map, Targeting.CLOSE, all_towers_in_map.size(), crystal.global_position, crystal_tower_seek_range, Targeting.TargetingRangeState.IN_RANGE, true)
		for tower in towers_in_range_of_crystal:
			if !candidate_towers.has(tower) and tower.tower_id != Towers.SOPHIST:
				candidate_towers.append(tower)
		
		_display_crystal_circle_sprite_on_location(crystal.global_position)
	
	return candidate_towers

func _display_crystal_circle_sprite_on_location(arg_pos):
	var particle = crystal_aura_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	particle.position = arg_pos
	particle.visible = true
	particle.lifetime = 0.25
	particle.scale = Vector2(1, 1)
	
	CommonAttackSpriteTemplater.configure_scale_and_expansion_of_expanding_attk_sprite(particle, 10, crystal_tower_seek_range)

func _create_crystal_aura_particle():
	var particle = ExpandingAttackSprite_Scene.instance()
	particle.texture_to_use = Sophist_CrystalAura_Pic
	particle.modulate.a = 0.5
	particle.queue_free_at_end_of_lifetime = false
	
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS
	
	return particle

#

func _on_round_end_s():
	_current_main_attack_count = 0
	set_crystal_count_amount(0)


func _initialize_interpreters_for_tower_desc():
	interpreter_for_current_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_current_attk_speed.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_current_attk_speed.display_body = false
	
	var ins_for_current_attk_speed = []
	ins_for_current_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", _current_attk_speed_buff_amount, true))
	
	interpreter_for_current_attk_speed.array_of_instructions = ins_for_current_attk_speed
	
	#
	
	var desc = ["Current buff: |0|", [interpreter_for_current_attk_speed]]
	
	#
	
	tower_type_info.tower_simple_descriptions.append("")
	tower_type_info.tower_simple_descriptions.append(desc)
	tower_type_info.tower_descriptions.append("")
	tower_type_info.tower_descriptions.append(desc)
	

func _update_tower_descriptions():
	interpreter_for_current_attk_speed.array_of_instructions[0].num_val = _current_attk_speed_buff_amount


##


func _activate_all_crystals():
	for crystal in get_tree().get_nodes_in_group(crystal_group_name):
		crystal.show_as_active()
	
	crystal_proj_activate_deactivate_timer.start(attk_speed_buff_duration)

func _on_crystal_acti_deacti_timer_timeout():
	_deactivate_all_crystals()

func _deactivate_all_crystals():
	for crystal in get_tree().get_nodes_in_group(crystal_group_name):
		crystal.show_as_unactive()



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


