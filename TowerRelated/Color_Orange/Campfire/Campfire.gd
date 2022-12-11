extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")

const CampfireParticle_Scene = preload("res://TowerRelated/Color_Orange/Campfire/CampfireTriggerParticle.tscn")

const HeatModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/HeatModule.gd")

const Campfire_Base_Normal_Pic = preload("res://TowerRelated/Color_Orange/Campfire/Campfire_Base.png")
const Campfire_Base_NoHealth_Pic = preload("res://TowerRelated/Color_Orange/Campfire/Campfire_Base_NoHealth.png")


var tower_detecting_range_module : TowerDetectingRangeModule

const base_rage_threshold : float = 50.0
var _current_rage : float = 0
var last_calculated_rage_threshold : float = base_rage_threshold

const rage_on_hit__base_dmg_scale : float = 1.5

var cf_attack_module : InstantDamageAttackModule

var physical_on_hit_effect : TowerOnHitDamageAdderEffect
var physical_on_hit : OnHitDamage

var campfire_base_damage : float

const initial_cooldown_after_ability_cast : float = 1.0
var initial_cd_timer : Timer

var rage_ability : BaseAbility

#

onready var campfire_wood_base_sprite = $TowerBase/KnockUpLayer/Sprite
onready var flame_anim_sprite = $TowerBase/KnockUpLayer/BaseSprites
const base_frame_rate : int = 5
const original_flame_y_pos : float = -13.0

const flame_anim_name := "Omni"

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.CAMPFIRE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	campfire_base_damage = info.base_damage
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.detection_range = info.base_range
	
	add_child(tower_detecting_range_module)
	
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.clear_all_targeting()
	
	
	var attack_module = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.can_be_commanded_by_tower = false
	
	attack_module.is_displayed_in_tracker = false
	
	cf_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	connect("final_range_changed", self, "_final_range_changed", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_entered", self, "_enemy_entered_range", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_enemy_exited_range", [], CONNECT_PERSIST)
	connect("final_attack_speed_changed", self, "_calculate_final_rage_threshold", [], CONNECT_PERSIST)
	connect("attack_module_added", self, "_on_main_attack_module_changed", [], CONNECT_PERSIST)
	connect("attack_module_removed", self, "_on_main_attack_module_changed", [], CONNECT_PERSIST)
	connect("final_base_damage_changed", self, "_final_base_damage_changed", [], CONNECT_PERSIST)
	
	connect("changed_anim_from_alive_to_dead", self, "_on_changed_anim_from_alive_to_dead", [], CONNECT_PERSIST)
	connect("changed_anim_from_dead_to_alive", self, "_on_changed_anim_from_dead_to_alive", [], CONNECT_PERSIST)
	
	_construct_on_hit_and_modifiers()
	_construct_effects()
	_construct_timer()
	
	_construct_and_connect_ability()
	
	_post_inherit_ready()


func _construct_on_hit_and_modifiers():
	var physical_on_hit_modifier = FlatModifier.new(StoreOfTowerEffectsUUID.CAMPFIRE_PHY_ON_HIT)
	
	physical_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.CAMPFIRE_PHY_ON_HIT, physical_on_hit_modifier, DamageType.PHYSICAL)


func _construct_effects():
	physical_on_hit_effect = TowerOnHitDamageAdderEffect.new(physical_on_hit, StoreOfTowerEffectsUUID.CAMPFIRE_PHY_ON_HIT)
	physical_on_hit_effect.is_countbound = true
	physical_on_hit_effect.count = 1
	physical_on_hit_effect.count_reduced_by_main_attack_only = false

func _construct_timer():
	initial_cd_timer = Timer.new()
	initial_cd_timer.one_shot = true
	
	add_child(initial_cd_timer)


func _construct_and_connect_ability():
	rage_ability = BaseAbility.new()
	
	rage_ability.is_timebound = false
	
	register_ability_to_manager(rage_ability, false)


# Giving effects and trigger

func _enemy_damage_taken(damage_report, is_lethal, enemy):
	if initial_cd_timer.time_left <= 0:
		_current_rage += damage_report.get_total_effective_damage_excluding([StoreOfTowerEffectsUUID.CAMPFIRE_PHY_ON_HIT])
		
		if _current_rage >= last_calculated_rage_threshold:
			#if heat_module == null or !last_calculated_disabled_from_attacking:
			if !last_calculated_disabled_from_attacking:
				var cd = _get_cd_to_use(initial_cooldown_after_ability_cast)
				rage_ability.on_ability_before_cast_start(cd)
				
				_update_physical_on_hit_effect()
				_give_buffs_to_towers(cd)
				_construct_particle()
				rage_ability.on_ability_after_cast_ended(cd)
				
				_current_rage = 0


func _update_physical_on_hit_effect():
	if is_instance_valid(main_attack_module):
		physical_on_hit.damage_as_modifier.flat_modifier = (main_attack_module.last_calculated_final_damage * rage_on_hit__base_dmg_scale) * last_calculated_final_ability_potency
		physical_on_hit_effect.on_hit_damage = physical_on_hit.duplicate()


func _give_buffs_to_towers(cooldown):
	_campfire_attack_equivalent()
	for tower in tower_detecting_range_module.get_all_in_map_towers_in_range():
		tower.add_tower_effect(physical_on_hit_effect._shallow_duplicate())
	
	initial_cd_timer.start(cooldown)


func _construct_particle():
	var particle = CampfireParticle_Scene.instance()
	add_child(particle)


# Trigger

func _calculate_final_rage_threshold():
	var total_atk_speed = main_attack_module.last_calculated_final_attk_speed
	
	last_calculated_rage_threshold = _get_cd_to_use(base_rage_threshold / total_atk_speed)
	
	_match_fire_fps_to_attack_speed(total_atk_speed)


# Module related

func _on_main_attack_module_changed(attack_module):
	_calculate_final_rage_threshold()
	_final_base_damage_changed()


# Aesthetics

func _match_fire_fps_to_attack_speed(total_atk_speed):
	flame_anim_sprite.frames.set_animation_speed(flame_anim_name, 5 * total_atk_speed)

func _match_fire_size_to_base_dmg(total_base_dmg):
	flame_anim_sprite.scale = Vector2(1, 1) # original scale
	flame_anim_sprite.scale *= 1 + ((total_base_dmg - campfire_base_damage) / 5)
	
	var sprite_height : float = flame_anim_sprite.frames.get_frame(flame_anim_name, 0).get_size().y
	var height_change = ((flame_anim_sprite.scale.y * sprite_height) - sprite_height) / 2
	
	flame_anim_sprite.position.y = original_flame_y_pos # original height
	flame_anim_sprite.position.y -= height_change


func _final_base_damage_changed():
	_match_fire_size_to_base_dmg(main_attack_module.last_calculated_final_damage)


# range related

func _enemy_entered_range(enemy, module, range_module):
	if is_current_placable_in_map():
		if !enemy.is_connected("on_post_mitigated_damage_taken", self, "_enemy_damage_taken"):
			enemy.connect("on_post_mitigated_damage_taken", self, "_enemy_damage_taken")


func _enemy_exited_range(enemy, module, range_module):
	if is_current_placable_in_map():
		if enemy.is_connected("on_post_mitigated_damage_taken", self, "_enemy_damage_taken"):
			enemy.disconnect("on_post_mitigated_damage_taken", self, "_enemy_damage_taken")



func _final_range_changed():
	tower_detecting_range_module.detection_range = range_module.last_calculated_final_range


func toggle_module_ranges():
	.toggle_module_ranges()
	
	if is_showing_ranges:
		if current_placable is InMapAreaPlacable:
			_on_tower_show_range()
	else:
		_on_tower_hide_range()


func _on_tower_show_range():
	tower_detecting_range_module.glow_all_towers_in_range()

func _on_tower_hide_range():
	tower_detecting_range_module.unglow_all_towers_in_range()


# On round end

func _on_round_end():
	._on_round_end()
	
	_current_rage = 0
	
	if is_instance_valid(initial_cd_timer):
		initial_cd_timer.wait_time = 0.1
		initial_cd_timer.start()


#

func _on_changed_anim_from_alive_to_dead():
	campfire_wood_base_sprite.texture = Campfire_Base_NoHealth_Pic
	flame_anim_sprite.visible = false

func _on_changed_anim_from_dead_to_alive():
	campfire_wood_base_sprite.texture = Campfire_Base_Normal_Pic
	flame_anim_sprite.visible = true

# Heat Module


func set_heat_module(module : HeatModule):
	module.heat_per_attack = 2
	.set_heat_module(module)

func _construct_heat_effect():
	var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_dmg_attr_mod.flat_modifier = 1.25
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module.benefits_from_bonus_base_damage:
			module.calculate_final_base_damage()
	
	emit_signal("final_base_damage_changed")


func _campfire_attack_equivalent():
	if heat_module != null:
		# The param is unused, so..
		heat_module._on_tower_attack_finished("")
