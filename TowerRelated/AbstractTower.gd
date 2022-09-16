extends Area2D

const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const BaseAreaTowerPlacable = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/BaseAreaTowerPlacable.gd")
const TowerBenchSlot = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/TowerBenchSlot.gd")
const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")
const AbstractAttackModule = preload("res://TowerRelated/Modules/AbstractAttackModule.gd")
const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")
const LifeBar = preload("res://EnemyRelated/Infobar/LifeBar/LifeBar.gd")
const TowerHeatModuleBar = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/TowerHeatBar/TowerHeatModuleBar.gd")
const TowerHeatModuleBar_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/TowerHeatBar/TowerHeatModuleBar.tscn")

const TowerBaseEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const TowerResetEffects = preload("res://GameInfoRelated/TowerEffectRelated/TowerResetEffects.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")
const TowerChaosTakeoverEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerChaosTakeoverEffect.gd")
const BaseTowerAttackModuleAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd")
const TowerFullSellbackEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerFullSellbackEffect.gd")
const _704EmblemPointsEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/704EmblemPointsEffect.gd")
const BaseTowerModifyingEffect = preload("res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd")
const TowerMarkEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerMarkEffect.gd")
const TowerIngredientColorCompatibilityEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerIngredientColorCompatibilityEffect.gd")
const TowerIngredientColorAcceptabilityEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerIngredientColorAcceptabilityEffect.gd")
const TowerPriorityTargetEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerPriorityTargetEffect.gd")
const TowerStunEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerStunEffect.gd")
const TowerKnockUpEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerKnockUpEffect.gd")
const TowerEffectShieldEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerEffectShieldEffect.gd")
const TowerInvulnerabilityEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerInvulnerabilityEffect.gd")

const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")
const BaseTowerDetectingBullet = preload("res://EnemyRelated/TowerInteractingRelated/Spawnables/BaseTowerDetectingBullet.gd")

const CombinationEffect = preload("res://GameInfoRelated/CombinationRelated/CombinationEffect.gd")

const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")

const StoreOfTowerEffectsUUID = preload("res://GameInfoRelated/TowerEffectRelated/StoreOfTowerEffectsUUID.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const ingredient_decline_pic = preload("res://GameHUDRelated/BottomPanel/IngredientMode_CannotCombine.png")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const AnimFaceDirComponent = preload("res://MiscRelated/CommonComponents/AnimFaceDirComponent.gd")
const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const AbsorbIngParticle_Scene = preload("res://TowerRelated/CommonTowerParticles/AbsorbRelated/AbsorbIngParticle.tscn")

signal tower_being_dragged(tower_self)
signal tower_dropped_from_dragged(tower_self) # use when listening for player input. Note: does not take into account the swapping of towers
signal on_attempt_drop_tower_on_placable(tower_self, arg_placable, arg_move_success) # 3rd arg is if there is enough tower slots to put the tower
signal on_tower_transfered_to_placable(tower_self, arg_placable)

signal tower_toggle_show_info
signal on_tower_toggle_showing_range(is_showing_ranges)
signal tower_in_queue_free
signal update_active_synergy
signal tower_being_sold(sellback_gold)
signal tower_give_gold(gold, gold_source_as_int)
signal tower_being_absorbed_as_ingredient(tower_self)

signal tower_selected_in_selection_mode(tower_self)

#
signal tower_not_in_active_map # tower benched
signal tower_active_in_map
#signal tower_can_contribute_to_synergy_changed(is_contributing_to_synergy_val)

signal attack_module_added(attack_module)
signal attack_module_removed(attack_module)

signal final_base_damage_changed
signal final_attack_speed_changed
signal final_range_changed
signal ingredients_absorbed_changed
signal ingredients_limit_changed(new_limit)
signal self_ingredient_changed(arg_old_ing, arg_new_ing)
signal tower_colors_changed
signal targeting_changed # by main module's range module
signal targeting_options_modified
signal final_ability_potency_changed
signal final_ability_cd_changed

signal on_ingredient_absorbed(arg_ingredient) # should be used to detect if this tower has absorbed an ing, and not what ings are active
signal on_sellback_value_changed(new_value)

signal on_max_health_changed(new_max)
signal on_current_health_changed(new_curr)
signal on_tower_no_health()


signal on_main_attack_in_attack_windup(wind_up_time, enemies, module)
signal on_main_attack_finished(module)
signal on_main_attack(attk_speed_delay, enemies, module)
signal on_any_attack_in_attack_windup(wind_up_time, enemies)
signal on_any_attack_finished(module)
signal on_any_attack(attk_speed_delay, enemies, module)

signal on_main_attack_module_commanded_to_attack_enemies_or_poses(arg_enemies_or_poses, module)


# on any damage instance constructed
signal on_damage_instance_constructed(damage_instance, module)
signal on_main_attack_module_damage_instance_constructed(damage_instance, module)

signal on_main_attack_module_enemy_hit(enemy, damage_register_id, damage_instance, module)
signal on_any_attack_module_enemy_hit(enemy, damage_register_id, damage_instance, module)

signal on_any_bullet_attack_module_before_bullet_is_shot(bullet, attack_module)
signal on_main_bullet_attack_module_before_bullet_is_shot(bullet, attack_module)

signal on_any_bullet_attack_module_after_bullet_is_shot(bullet, attack_module)
signal on_main_bullet_attack_module_after_bullet_is_shot(bullet, attack_module)

signal on_any_bullet_attack_module_bullet_reached_zero_pierce(bullet, module)
signal on_main_bullet_attack_module_bullet_reached_zero_pierce(bullet, module)


signal on_any_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module)
signal on_main_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module)


# on any range module
signal on_range_module_enemy_entered(enemy, module, range_module)
signal on_range_module_enemy_exited(enemy, module, range_module)

signal on_any_range_module_current_enemy_exited(enemy, module, range_module)
signal on_any_range_module_current_enemies_acquired(module, range_module)


signal on_round_end
#signal on_round_end__set_up_from_manager_aware(arg_is_startup_from_tower_manager)
signal on_round_end__before_any_round_end_reverts() # used to check if tower had this effect (before being cleared), and if the tower is dead before the round ending (look at round end func to see what gets reverted)
signal on_round_start

signal register_ability(ability, add_to_panel)

signal on_tower_ability_before_cast_start(cooldown, ability)
signal on_tower_ability_after_cast_end(cooldown, ability)


signal global_position_changed(old_pos, new_pos)

signal on_effect_added(effect)
signal on_effect_removed(effect)
signal before_effect_is_removed(effect)

signal on_taken_damage_from_enemy(arg_enemy, arg_dmg_amount)

#

signal on_is_contributing_to_synergy_color_count_changed(new_val)

#

signal on_per_round_total_damage_changed(per_round_total_dmg)

# Clause related

signal on_last_calculated_disabled_from_attacking_changed(arg_new_val)

#
signal on_heat_module_overheat()
signal on_heat_module_overheat_cooldown()


# syn signals

signal energy_module_attached
signal energy_module_detached

signal heat_module_should_be_displayed_changed

#

# the sprite shown indicating that the tower will be placed there
var tower_highlight_sprite : Texture
var tower_image_icon_atlas_texture : AtlasTexture


var tower_id : int
var tower_type_info : TowerTypeInformation

enum DisabledFromAttackingSourceClauses {
	
	HEAT_MODULE = 1,
	TOWER_NO_HEALTH = 2,
	TOWER_BEING_DRAGGED = 3,
	TOWER_IN_BENCH = 4,
	
	IS_STUNNED = 10,
	
	#
	
	L_ASSAUT_PURSUE_ACTIVE = 1000
	
	DOM_SYN__RED__DOMINANCE_SUPPLEMENT = 1001
	DOM_SYN__RED__COMPLEMENTARY_SUPPLEMENT = 1002
	DOM_SYN__RED__HOLOGRAPHIC_TOWERS = 1003
	DOM_SYN__RED__HEALING_SYMBOLS = 1004
	
	PROPEL_DURING_PLOW = 1005
}

enum UntargetabilityClauses {
	GENERIC_IS_UNTARGETABLE_CLAUSE = 0,
	
	TOWER_NO_HEALTH = 1,
	IS_INVISIBLE = 2,
	
	#
	
	L_ASSAUT_PURSUE_ACTIVE = 1000
	PROPEL_DURING_PLOW = 1001
	
}

enum ContributingToSynergyClauses {
	NOT_IN_MAP = 1,
	IN_QUEUE_FREE = 2,
	GENERIC_DOES_NOT_CONTRIBUTE = 3,
	
	DOM_SYN__RED__DOMINANCE_SUPPLEMENT = 1000,
	DOM_SYN__RED__COMPLEMENTARY_SUPPLEMENT = 1001,
}

###

var hovering_over_placable : BaseAreaTowerPlacable
var current_placable : BaseAreaTowerPlacable

var is_being_dragged : bool = false
var is_in_ingredient_mode : bool = false
var is_being_hovered_by_mouse : bool = false

var _is_in_select_tower_prompt : bool = false

var is_showing_ranges : bool

var contributing_to_synergy_clauses : ConditionalClauses
var last_calculated_is_contributing_to_synergy : bool


#####

var collision_shape

var current_power_level_used : int

var all_attack_modules : Array = []
var main_attack_module : AbstractAttackModule
var range_module : RangeModule


var disabled_from_attacking_clauses : ConditionalClauses
var last_calculated_disabled_from_attacking : bool = false

var untargetability_clauses : ConditionalClauses
var last_calculated_is_untargetable : bool = false

# Tower buffs related

var _all_uuid_tower_buffs_map : Dictionary = {}


# Mov to placable related

enum CanBePlacedInMapClauses {
	GENERIC_CANNOT_BE_PLACED_IN_MAP = 0
}
var can_be_placed_in_map_conditional_clause : ConditionalClauses
var last_calculated_can_be_placed_in_map : bool


enum CanBePlacedInBenchClauses {
	GENERIC_CANNOT_BE_PLACED_IN_BENCH = 0
}
var can_be_placed_in_bench_conditional_clause : ConditionalClauses
var last_calculated_can_be_placed_in_bench : bool

# Ingredient related

var ingredients_absorbed : Dictionary = {} # Map of tower_id (ingredient source) to ingredient_effect
var ingredient_of_self : IngredientEffect setget set_self_ingredient_effect
var originally_has_ingredient : bool # used by combination manager
var ingredient_compatible_colors : Array = []

var _ingredient_id_limit_modifier_map : Dictionary
var last_calculated_ingredient_limit : int

var _ingredient_compatible_color_effects : Dictionary = {}
var _ingredient_acceptability_color_effects : Dictionary = {}


enum CanAbsorbIngredientClauses {
	CAN_NOT_ABSORB_INGREDIENT_GENERIC_TAG = 0,
	
	
}
var can_absorb_ingredient_conditonal_clauses : ConditionalClauses
var last_calculated_can_absorb_ingredient : bool


enum CanBeUsedAsIngredientClauses {
	CANNOT_BE_USED_AS_ING_GENERIC_TAG = 0,
	DOM_SYN_RED__HOLOGRAPHIC_TOWERS = 1
}
var can_be_used_as_ingredient_conditonal_clauses : ConditionalClauses
var last_calculated_can_be_used_as_ingredient : bool


# Color related

var _tower_colors : Array = []

# Synergy related

var can_contribute_to_synergy_color_count : bool = true setget set_contribute_to_synergy_color_count# tower can still gain benefits of synergy, but does not contribute to syngergy progress

# Gold related

var _base_gold_cost : int setget set_base_gold_cost
var _ingredients_tower_id_base_gold_costs_map : Dictionary = {}
var _is_full_sellback : bool = false
var last_calculated_sellback_value : int

# Sell related

enum CanBeSoldClauses {
	IS_NOT_SELLABLE_GENERIC_TAG = 0, # used for anything that does not need to be checked for.
	
	DOM_SYN_RED__PACT_HOLOGRAPHIC_TOWERS = 1,
	
	END_OF_GAME = 100,
	
	TUTORIAL_DISABLED_CLAUSE = 10000
}

var can_be_sold_conditonal_clauses : ConditionalClauses
var last_calculated_can_be_sold : bool


# Is bought or summoned/others

var is_tower_bought : bool # true if the tower is bought from the shop. false if summoned, etc.

# Round related

var is_round_started : bool = false setget _set_round_started


# Ability Power related

var base_ability_potency : float = 1
var _flat_base_ability_potency_effects : Dictionary = {}
var _percent_base_ability_potency_effects : Dictionary = {}
var last_calculated_final_ability_potency : float

var base_flat_ability_cdr : float = 0
var _flat_base_ability_cdr_effects : Dictionary = {}
var last_calculated_final_flat_ability_cdr : float

var base_percent_ability_cdr : float = 0
var _percent_base_ability_cdr_effects : Dictionary = {}
var last_calculated_final_percent_ability_cdr : float

# Vamp related

var _flat_omnivamp_effects : Dictionary = {}
var last_calculated_flat_omnivamp : float = 0

var _percent_damage_omnivamp_effects : Dictionary = {}
var last_calculated_percent_damage_omnivamp : float = 0

# Effect vul related

var base_enemy_effect_vulnerability : float = 1
var _flat_enemy_effect_vulnerability_id_effect_map : Dictionary = {}
var _percent_enemy_effect_vulnerability_id_effect_map : Dictionary = {}
var last_calculated_enemy_final_effect_vulnerability : float

# Invul related
var invulnerability_id_effect_map : Dictionary = {}
var last_calculated_is_invulnerable : bool = false
const invulnerable_sprite_layer_self_modulate : Color = Color(1.5, 1.5, 1, 1)
const normal_sprite_layer_self_modulate : Color = Color(1, 1, 1, 1)

# Other effects

var _stun_id_effect_map : Dictionary = {}
var last_calculated_is_stunned : bool

var effect_shield_effect_map : Dictionary = {}
var last_calculated_has_effect_shield_against_towers : bool
var last_calculated_has_effect_shield_against_enemies : bool


# Combination Related

var all_combinations_id_to_effect_id_map : Dictionary = {}


# Modulate related

enum TowerModulateIds {
	TOWER_DETECTING_RANGE_MODULE = 10
	
	PROPEL_INVIS = 100
}

var all_id_to_tower_base_modulate : Dictionary = {}
var last_calculated_tower_base_modulate : Color

# Clickalbe related

enum TowerDraggableClauseIds{
	END_OF_GAME = 100
	
	TUTORIAL_DISABLED = 1000
}
var tower_is_draggable_clauses : ConditionalClauses
var last_calculated_tower_is_draggable : bool

# Other stats

var base_health : float = 10
var flat_base_health_id_effect_map : Dictionary = {}
var percent_base_health_id_effect_map : Dictionary = {}
var last_calculated_max_health : float
var current_health : float

var is_dead_for_the_round : bool = false

var tower_limit_slots_taken : int = 1
var is_a_summoned_tower : bool = false

var last_calculated_has_commandable_attack_modules : bool

var all_tower_abiltiies : Array

var anim_face_dir_component : AnimFaceDirComponent

# tracker

var old_global_position : Vector2

# Damage tracker

var in_round_total_damage_dealt : float# setget ,get_in_round_total_damage_dealt
var in_round_pure_damage_dealt : float
var in_round_elemental_damage_dealt : float
var in_round_physical_damage_dealt : float

#var displayable_in_damage_stats_panel : bool = true #

# compatibility stuffs
var distance_to_exit : float = 0 # this is here for Targeting purposes
#var last_calculated_invisibility_status : bool = false # this is here for Targeting purposes
#var is_reviving : bool = false


# knock up related
# makes use of knockuplayer.position
var _knock_up_current_acceleration : float
var _knock_up_current_acceleration_deceleration : float

# managers

var tower_manager
var tower_inventory_bench
var input_prompt_manager
var ability_manager
var synergy_manager
var game_elements


# anim related

var _anim_face__custom_anim_names_to_use
var _anim_face__custom_dir_name_to_primary_rad_angle_map
var _anim_face__custom_initial_dir_hierarchy

# particle related

const ing_tier_to_amount_of_particles_map : Dictionary = {
	1 : 3,
	2 : 3,
	3 : 3,
	4 : 4,
	5 : 5,
	6 : 6
}
var absorb_ing_particle_pool_component : AttackSpritePoolComponent


# SYN RELATED ---------------------------- #
# Yellow
var energy_module setget set_energy_module

# Orange
var heat_module setget set_heat_module
var base_heat_effect : TowerBaseEffect

var tower_heat_module_bar : TowerHeatModuleBar


# -- node related
onready var info_bar_layer = $InfoBarLayer
onready var life_bar = $InfoBarLayer/InfoBar/VBoxContainer/LifeBar
onready var status_bar = $InfoBarLayer/InfoBar/VBoxContainer/TowerStatusBar
onready var info_bar = $InfoBarLayer/InfoBar

onready var tower_base_sprites : AnimatedSprite = $TowerBase/KnockUpLayer/BaseSprites #$TowerBase/BaseSprites
onready var tower_base = $TowerBase
onready var knock_up_layer = $TowerBase/KnockUpLayer

onready var info_bar_vbox_container = $InfoBarLayer/InfoBar/VBoxContainer

onready var cannot_apply_pic = $DoesNotApplyPic


# Initialization -------------------------- #


func _initialize_stats_from_tower_info(arg_tower_info):
	originally_has_ingredient = (arg_tower_info.ingredient_effect != null)
	
	base_ability_potency = arg_tower_info.base_ability_potency
	base_percent_ability_cdr = arg_tower_info.base_percent_cdr


func _init():
	untargetability_clauses = ConditionalClauses.new()
	untargetability_clauses.connect("clause_inserted", self, "_untargetability_clause_added_or_removed", [], CONNECT_PERSIST)
	untargetability_clauses.connect("clause_removed", self, "_untargetability_clause_added_or_removed", [], CONNECT_PERSIST)
	
	disabled_from_attacking_clauses = ConditionalClauses.new()
	disabled_from_attacking_clauses.connect("clause_inserted", self, "_disabled_from_attacking_clause_added_or_removed", [], CONNECT_PERSIST)
	disabled_from_attacking_clauses.connect("clause_removed", self, "_disabled_from_attacking_clause_added_or_removed", [], CONNECT_PERSIST)
	
	contributing_to_synergy_clauses = ConditionalClauses.new()
	contributing_to_synergy_clauses.connect("clause_inserted", self, "_contributing_to_synergy_clause_added_or_removed", [], CONNECT_PERSIST)
	contributing_to_synergy_clauses.connect("clause_removed", self, "_contributing_to_synergy_clause_added_or_removed", [], CONNECT_PERSIST)
	
	can_be_sold_conditonal_clauses = ConditionalClauses.new()
	can_be_sold_conditonal_clauses.connect("clause_inserted", self, "_on_sell_clause_added_or_removed", [], CONNECT_PERSIST)
	can_be_sold_conditonal_clauses.connect("clause_removed", self, "_on_sell_clause_added_or_removed", [], CONNECT_PERSIST)
	
	can_absorb_ingredient_conditonal_clauses = ConditionalClauses.new()
	can_absorb_ingredient_conditonal_clauses.connect("clause_inserted", self, "_on_can_absorb_ing_clause_added_or_removed", [], CONNECT_PERSIST)
	can_absorb_ingredient_conditonal_clauses.connect("clause_removed", self, "_on_can_absorb_ing_clause_added_or_removed", [], CONNECT_PERSIST)
	
	can_be_used_as_ingredient_conditonal_clauses = ConditionalClauses.new()
	can_be_used_as_ingredient_conditonal_clauses.connect("clause_inserted", self, "_on_can_be_used_as_ing_clause_added_or_removed", [], CONNECT_PERSIST)
	can_be_used_as_ingredient_conditonal_clauses.connect("clause_removed", self, "_on_can_be_used_as_ing_clause_added_or_removed", [], CONNECT_PERSIST)
	
	can_be_placed_in_map_conditional_clause = ConditionalClauses.new()
	can_be_placed_in_map_conditional_clause.connect("clause_inserted", self, "_on_can_move_to_in_map_clause_added_or_removed", [], CONNECT_PERSIST)
	can_be_placed_in_map_conditional_clause.connect("clause_removed", self, "_on_can_move_to_in_map_clause_added_or_removed", [], CONNECT_PERSIST)
	
	can_be_placed_in_bench_conditional_clause = ConditionalClauses.new()
	can_be_placed_in_bench_conditional_clause.connect("clause_inserted", self, "_on_can_move_to_bench_clause_added_or_removed", [], CONNECT_PERSIST)
	can_be_placed_in_bench_conditional_clause.connect("clause_removed", self, "_on_can_move_to_bench_clause_added_or_removed", [], CONNECT_PERSIST)
	
	tower_is_draggable_clauses = ConditionalClauses.new()
	tower_is_draggable_clauses.connect("clause_inserted", self, "_on_tower_is_draggable_clause_ins_or_rem", [], CONNECT_PERSIST)
	tower_is_draggable_clauses.connect("clause_removed", self, "_on_tower_is_draggable_clause_ins_or_rem", [], CONNECT_PERSIST)
	
	_update_last_calculated_contributing_to_synergy()
	_update_last_calculated_disabled_from_attacking()
	_update_untargetability_state()
	_update_last_calculated_can_be_sold()
	_update_last_calculated_can_absorb_ing()
	_update_last_calculated_can_be_used_as_ing()
	_update_last_calculated_can_be_placed_in_map()
	_update_last_calculated_can_be_placed_in_bench()
	_update_last_calculate_tower_is_draggable()
	
	##
	
	anim_face_dir_component = AnimFaceDirComponent.new()


func _ready():
	$IngredientDeclinePic.visible = false
	cannot_apply_pic.visible = false
	_end_drag(true)
	
	connect("on_current_health_changed", life_bar, "set_current_health_value", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	connect("on_max_health_changed", life_bar, "set_max_value", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	for child in knock_up_layer.get_children():
		child.use_parent_material = true
	tower_base.material = ShaderMaterial.new()
	

func _post_inherit_ready():
	_update_ingredient_compatible_colors()
	
	if range_module != null:
		if range_module.get_parent() == null:
			add_child(range_module)
		
		range_module.update_range() 
	
	_calculate_final_ability_potency()
	_calculate_final_flat_ability_cdr()
	_calculate_final_percent_ability_cdr()
	_calculate_max_health()
	_calculate_enemy_effect_vulnerability()
	
	_calculate_final_flat_omnivamp()
	_calculate_final_percent_damage_omnivamp()
	
	_set_health(last_calculated_max_health)
	
	_update_last_calculated_disabled_from_attacking()
	
	var _self_size = get_current_anim_size()
	#info_bar_layer.position.y -= round((_self_size.y) + 4)
	#info_bar_layer.position.x -= round(life_bar.get_bar_fill_foreground_size().x / 3)
	info_bar_layer.position.y -= round((_self_size.y) + 15)
	info_bar_layer.position.x -= round(life_bar.get_bar_fill_foreground_size().x / 4)
	info_bar.rect_size.x = life_bar.rect_size.x
	life_bar.update_first_time()
	
	connect("on_any_post_mitigation_damage_dealt", self, "_on_tower_any_post_mitigation_damage_dealt", [], CONNECT_PERSIST)
	
	#initialize_atlas_texture()
	
	_calculate_sellback_value()
	
	
	##
	
	var sprite_frames_of_base : SpriteFrames = tower_base_sprites.frames
	if sprite_frames_of_base.animations.size() >= 2:
		anim_face_dir_component.initialize_with_sprite_frame_to_monitor(sprite_frames_of_base, tower_base_sprites,_anim_face__custom_anim_names_to_use, _anim_face__custom_dir_name_to_primary_rad_angle_map, _anim_face__custom_initial_dir_hierarchy)
		anim_face_dir_component.set_animated_sprite_animation_to_default(tower_base_sprites)
		#connect("on_main_attack", self, "_on_main_attack__for_face_direction_updates", [], CONNECT_PERSIST)
		connect("on_main_attack_module_commanded_to_attack_enemies_or_poses", self, "_on_main_attk_module__commanded_to_attack_enemies_or_poses", [], CONNECT_PERSIST)


func get_current_anim_size() -> Vector2:
	return tower_base_sprites.frames.get_frame(tower_base_sprites.animation, tower_base_sprites.frame).get_size()



func _emit_final_range_changed():
	call_deferred("emit_signal", "final_range_changed")

func _emit_final_base_damage_changed():
	call_deferred("emit_signal", "final_base_damage_changed")

func _emit_final_attack_speed_changed():
	call_deferred("emit_signal", "final_attack_speed_changed")

func _emit_ingredients_absorbed_changed():
	call_deferred("emit_signal", "ingredients_absorbed_changed")

func _emit_targeting_changed():
	call_deferred("emit_signal", "targeting_changed")

func _emit_targeting_options_modified():
	call_deferred("emit_signal", "targeting_options_modified")

func _emit_final_ability_potency_changed():
	call_deferred("emit_signal", "final_ability_potency_changed")

func _emit_final_ability_cd_changed():
	call_deferred("emit_signal", "final_ability_cd_changed")

func _emit_max_health_changed():
	#life_bar.max_value = last_calculated_max_health
	emit_signal("on_max_health_changed", last_calculated_max_health)

func _emit_current_health_changed():
	#life_bar.current_health_value = current_health
	emit_signal("on_current_health_changed", current_health)

func _emit_tower_no_health():
	emit_signal("on_tower_no_health")

# Adding Attack modules related

func add_attack_module(attack_module : AbstractAttackModule, benefit_from_existing_tower_buffs : bool = true):
	if !attack_module.is_connected("in_attack_end", self, "_emit_on_any_attack_finished"):
		attack_module.connect("in_attack_end", self, "_emit_on_any_attack_finished", [attack_module], CONNECT_PERSIST)
		attack_module.connect("in_attack", self, "_emit_on_any_attack", [attack_module], CONNECT_PERSIST)
		attack_module.connect("on_damage_instance_constructed", self, "_emit_on_damage_instance_constructed", [], CONNECT_PERSIST)
		attack_module.connect("on_enemy_hit" , self, "_emit_on_any_attack_module_enemy_hit", [], CONNECT_PERSIST)
		attack_module.connect("on_post_mitigation_damage_dealt", self, "_emit_on_any_post_mitigation_damage_dealt", [], CONNECT_PERSIST)
		attack_module.connect("in_attack_windup", self, "_emit_on_any_attack_in_windup", [attack_module], CONNECT_PERSIST)
		
		if attack_module is BulletAttackModule:
			attack_module.connect("before_bullet_is_shot", self, "_emit_on_any_bullet_attack_module_before_bullet_is_shot", [attack_module], CONNECT_PERSIST)
			attack_module.connect("after_bullet_is_shot", self, "_emit_on_any_bullet_attack_module_after_bullet_is_shot", [attack_module], CONNECT_PERSIST)
			attack_module.connect("bullet_on_zero_pierce", self, "_emit_on_any_bullet_attack_module_on_bullet_zero_pierce", [attack_module], CONNECT_PERSIST)
	
	
	if attack_module.get_parent() == null:
		add_child(attack_module)
		attack_module.parent_tower = self
	
	if attack_module.range_module == null and range_module != null:
		attack_module.range_module = range_module
	
	if attack_module.range_module != null:
		if !attack_module.range_module.is_connected("enemy_entered_range", self, "_emit_on_range_module_enemy_entered"):
			attack_module.range_module.connect("enemy_entered_range", self, "_emit_on_range_module_enemy_entered", [attack_module, attack_module.range_module], CONNECT_PERSIST)
			attack_module.range_module.connect("enemy_left_range" , self, "_emit_on_range_module_enemy_exited", [attack_module, attack_module.range_module], CONNECT_PERSIST)
			attack_module.range_module.connect("current_enemy_left_range", self, "_emit_on_any_range_module_current_enemy_exited", [attack_module, attack_module.range_module], CONNECT_PERSIST)
			attack_module.range_module.connect("current_enemies_acquired", self, "_emit_on_any_range_module_current_enemies_acquired", [attack_module, attack_module.range_module], CONNECT_PERSIST)
		
		attack_module.range_module.update_range()
	
	#if main_attack_module == null and attack_module.module_id == StoreOfAttackModuleID.MAIN:
	if attack_module.module_id == StoreOfAttackModuleID.MAIN:
		# Pre-existing attack module
		if main_attack_module != null:
			if range_module != null and range_module.is_connected("final_range_changed", self, "_emit_final_range_changed"):
				range_module.disconnect("final_range_changed", self, "_emit_final_range_changed")
				range_module.disconnect("targeting_changed", self, "_emit_targeting_changed")
				range_module.disconnect("targeting_options_modified", self, "_emit_targeting_options_modified")
		
		main_attack_module = attack_module
		
		if !main_attack_module.is_connected("in_attack_end", self, "_emit_on_main_attack_finished"):
			main_attack_module.connect("in_attack_end", self, "_emit_on_main_attack_finished", [main_attack_module], CONNECT_PERSIST)
			main_attack_module.connect("in_attack", self, "_emit_on_main_attack", [main_attack_module], CONNECT_PERSIST)
			main_attack_module.connect("on_enemy_hit" , self, "_emit_on_main_attack_module_enemy_hit", [], CONNECT_PERSIST)
			main_attack_module.connect("on_damage_instance_constructed", self, "_emit_on_main_attack_module_damage_instance_constructed", [], CONNECT_PERSIST)
			main_attack_module.connect("on_post_mitigation_damage_dealt", self, "_emit_on_main_post_mitigation_damage_dealt", [], CONNECT_PERSIST)
			main_attack_module.connect("in_attack_windup", self, "_emit_on_main_attack_in_windup", [main_attack_module], CONNECT_PERSIST)
			main_attack_module.connect("on_commanded_to_attack_enemies_or_poses", self, "_emit_on_main_attack_module_commanded_to_attack_enemies_or_poses", [main_attack_module], CONNECT_PERSIST)
			
			if main_attack_module is BulletAttackModule:
				main_attack_module.connect("before_bullet_is_shot", self, "_emit_on_main_bullet_attack_module_before_bullet_is_shot", [attack_module], CONNECT_PERSIST)
				main_attack_module.connect("after_bullet_is_shot", self, "_emit_on_main_bullet_attack_module_after_bullet_is_shot", [attack_module], CONNECT_PERSIST)
				main_attack_module.connect("bullet_on_zero_pierce", self, "_emit_on_main_bullet_attack_module_on_bullet_zero_pierce", [attack_module], CONNECT_PERSIST)
		
		if range_module == null and main_attack_module.range_module != null:
			range_module = main_attack_module.range_module
		
		if range_module != null:
			if range_module.get_parent() == null:
				add_child(range_module)
			
			if !range_module.is_connected("final_range_changed", self, "_emit_final_range_changed"):
				range_module.connect("final_range_changed", self, "_emit_final_range_changed", [], CONNECT_PERSIST)
				range_module.connect("targeting_changed", self, "_emit_targeting_changed", [], CONNECT_PERSIST)
				range_module.connect("targeting_options_modified", self, "_emit_targeting_options_modified", [], CONNECT_PERSIST)
			
			range_module.update_range()
		
		# update
		_emit_final_base_damage_changed()
		_emit_final_attack_speed_changed()
		
	
	if benefit_from_existing_tower_buffs:
		for tower_effect in _all_uuid_tower_buffs_map.values():
			add_tower_effect(tower_effect, [attack_module], false, false)
	
	all_attack_modules.append(attack_module)
	
	_on_attack_module_added_or_removed()
	emit_signal("attack_module_added", attack_module)


func remove_attack_module(attack_module_to_remove : AbstractAttackModule):
	# any
	if attack_module_to_remove.is_connected("in_attack_end", self, "_emit_on_any_attack_finished"):
		attack_module_to_remove.disconnect("in_attack_end", self, "_emit_on_any_attack_finished")
		attack_module_to_remove.disconnect("in_attack", self, "_emit_on_any_attack")
		attack_module_to_remove.disconnect("on_damage_instance_constructed", self, "_emit_on_damage_instance_constructed")
		attack_module_to_remove.disconnect("on_enemy_hit", self, "_emit_on_any_attack_module_enemy_hit")
		attack_module_to_remove.disconnect("on_post_mitigation_damage_dealt", self, "_emit_on_any_post_mitigation_damage_dealt")
		attack_module_to_remove.disconnect("in_attack_windup", self, "_emit_on_any_attack_in_windup")
		
		if attack_module_to_remove is BulletAttackModule:
			attack_module_to_remove.disconnect("before_bullet_is_shot", self, "_emit_on_any_bullet_attack_module_before_bullet_is_shot")
			attack_module_to_remove.disconnect("after_bullet_is_shot", self, "_emit_on_any_bullet_attack_module_after_bullet_is_shot")
			attack_module_to_remove.disconnect("bullet_on_zero_pierce", self, "_emit_on_any_bullet_attack_module_on_bullet_zero_pierce")
	
	# main
	if attack_module_to_remove.is_connected("in_attack_end", self, "_emit_on_main_attack_finished"):
		attack_module_to_remove.disconnect("in_attack_end", self, "_emit_on_main_attack_finished")
		attack_module_to_remove.disconnect("in_attack", self, "_emit_on_main_attack")
		attack_module_to_remove.disconnect("on_enemy_hit", self, "_emit_on_main_attack_module_enemy_hit")
		attack_module_to_remove.disconnect("on_damage_instance_constructed", self, "_emit_on_main_attack_module_damage_instance_constructed")
		attack_module_to_remove.disconnect("on_post_mitigation_damage_dealt", self, "_emit_on_main_post_mitigation_damage_dealt")
		attack_module_to_remove.disconnect("in_attack_windup", self, "_emit_on_main_attack_in_windup")
		attack_module_to_remove.disconnect("on_commanded_to_attack_enemies_or_poses", self, "_emit_on_main_attack_module_commanded_to_attack_enemies_or_poses")
		
		if attack_module_to_remove is BulletAttackModule:
			attack_module_to_remove.disconnect("before_bullet_is_shot", self, "_emit_on_main_bullet_attack_module_before_bullet_is_shot")
			attack_module_to_remove.disconnect("after_bullet_is_shot", self, "_emit_on_main_bullet_attack_module_after_bullet_is_shot")
			attack_module_to_remove.disconnect("bullet_on_zero_pierce", self, "_emit_on_main_bullet_attack_module_on_bullet_zero_pierce")
	
	for tower_effect in _all_uuid_tower_buffs_map.values():
		remove_tower_effect(tower_effect, [attack_module_to_remove], false, false)
	
	if range_module != null:
		if range_module.attack_modules_using_this.has(attack_module_to_remove) and range_module.attack_modules_using_this.size() == 1:
			if attack_module_to_remove.range_module == range_module:
				range_module.disconnect("final_range_changed", self, "_emit_final_range_changed")
				range_module.disconnect("targeting_changed", self, "_emit_targeting_changed")
				range_module.disconnect("targeting_options_modified", self, "_emit_targeting_options_modified")
	
	if attack_module_to_remove.range_module != null:
		if attack_module_to_remove.range_module.attack_modules_using_this.has(attack_module_to_remove) and attack_module_to_remove.range_module.attack_modules_using_this.size() == 1:
			if attack_module_to_remove.range_module.is_connected("enemy_entered_range", self, "_emit_on_range_module_enemy_entered"):
				attack_module_to_remove.range_module.disconnect("enemy_entered_range", self, "_emit_on_range_module_enemy_entered")
				attack_module_to_remove.range_module.disconnect("enemy_left_range" , self, "_emit_on_range_module_enemy_exited")
				attack_module_to_remove.range_module.disconnect("current_enemy_left_range", self, "_emit_on_any_range_module_current_enemy_exited")
				attack_module_to_remove.range_module.disconnect("current_enemies_acquired", self, "_emit_on_any_range_module_current_enemies_acquired")
	
	if attack_module_to_remove.get_parent() == self:
		attack_module_to_remove.parent_tower = null
	
	all_attack_modules.erase(attack_module_to_remove)
	
	if main_attack_module == attack_module_to_remove:
		#for module in all_attack_modules:
		for module_index in range(all_attack_modules.size() - 1, -1, -1):
			var module = all_attack_modules[module_index]
			if module.module_id == StoreOfAttackModuleID.MAIN:
				main_attack_module = module
				
				if main_attack_module != null:
					if !main_attack_module.range_module.is_connected("final_range_changed", self, "_emit_final_range_changed"):
						main_attack_module.range_module.connect("final_range_changed", self, "_emit_final_range_changed", [], CONNECT_PERSIST)
						main_attack_module.range_module.connect("targeting_changed", self, "_emit_targeting_changed", [], CONNECT_PERSIST)
						main_attack_module.range_module.connect("targeting_options_modified", self, "_emit_targeting_options_modified", [], CONNECT_PERSIST)
						main_attack_module.range_module.update_range()
				
				break
	
	_on_attack_module_added_or_removed()
	emit_signal("attack_module_removed", attack_module_to_remove)


# Does not track attack modules's changes tho, only changes when module is added or removed
func _on_attack_module_added_or_removed():
	for module in all_attack_modules:
		if module.last_calculated_can_be_commanded_by_tower:
			last_calculated_has_commandable_attack_modules = true
			return
	
	last_calculated_has_commandable_attack_modules = false


# Module signals related

func _emit_on_any_attack_finished(module):
	call_deferred("emit_signal", "on_any_attack_finished", module)

func _emit_on_any_attack(attack_delay, enemies_or_poses, module):
	emit_signal("on_any_attack", attack_delay, enemies_or_poses, module)

func _emit_on_any_attack_in_windup(windup_time, arg_poses, module):
	emit_signal("on_any_attack_in_attack_windup", windup_time, arg_poses, module)



func _emit_on_main_attack_finished(module):
	call_deferred("emit_signal", "on_main_attack_finished", module)

func _emit_on_main_attack(attack_delay, enemies_or_poses, module):
	emit_signal("on_main_attack", attack_delay, enemies_or_poses, module)

func _emit_on_main_attack_in_windup(windup_time, arg_poses, module):
	emit_signal("on_main_attack_in_attack_windup", windup_time, arg_poses, module)

func _emit_on_main_attack_module_commanded_to_attack_enemies_or_poses(arg_enemies_or_poses, module):
	emit_signal("on_main_attack_module_commanded_to_attack_enemies_or_poses", arg_enemies_or_poses, module)


func _emit_on_damage_instance_constructed(damage_instance, module):
	emit_signal("on_damage_instance_constructed", damage_instance, module)
	_decrease_count_of_countbounded(module)

func _emit_on_main_attack_module_damage_instance_constructed(damage_instance, module):
	emit_signal("on_main_attack_module_damage_instance_constructed", damage_instance, module)

func _emit_on_main_attack_module_enemy_hit(enemy, damage_register_id, damage_instance, module):
	emit_signal("on_main_attack_module_enemy_hit", enemy, damage_register_id, damage_instance, module)

func _emit_on_any_attack_module_enemy_hit(enemy, damage_register_id, damage_instance, module):
	emit_signal("on_any_attack_module_enemy_hit", enemy, damage_register_id, damage_instance, module)


func _emit_on_any_bullet_attack_module_before_bullet_is_shot(bullet, module):
	emit_signal("on_any_bullet_attack_module_before_bullet_is_shot", bullet, module)

func _emit_on_main_bullet_attack_module_before_bullet_is_shot(bullet, module):
	emit_signal("on_main_bullet_attack_module_before_bullet_is_shot", bullet, module)


func _emit_on_any_bullet_attack_module_after_bullet_is_shot(bullet, module):
	emit_signal("on_any_bullet_attack_module_after_bullet_is_shot", bullet, module)

func _emit_on_main_bullet_attack_module_after_bullet_is_shot(bullet, module):
	emit_signal("on_main_bullet_attack_module_after_bullet_is_shot", bullet, module)


func _emit_on_any_bullet_attack_module_on_bullet_zero_pierce(bullet, module):
	emit_signal("on_any_bullet_attack_module_bullet_reached_zero_pierce", bullet, module)

func _emit_on_main_bullet_attack_module_on_bullet_zero_pierce(bullet, module):
	emit_signal("on_main_bullet_attack_module_bullet_reached_zero_pierce", bullet, module)



func _emit_on_any_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	emit_signal("on_any_post_mitigation_damage_dealt", damage_instance_report, killed, enemy, damage_register_id, module)

func _emit_on_main_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	emit_signal("on_main_post_mitigation_damage_dealt", damage_instance_report, killed, enemy, damage_register_id, module)


func _emit_on_range_module_enemy_entered(enemy, module, range_module):
	emit_signal("on_range_module_enemy_entered", enemy, module, range_module)

func _emit_on_range_module_enemy_exited(enemy, module, range_module):
	emit_signal("on_range_module_enemy_exited", enemy, module, range_module)

func _emit_on_any_range_module_current_enemy_exited(enemy, module, range_module):
	emit_signal("on_any_range_module_current_enemy_exited" , enemy, module, range_module)

func _emit_on_any_range_module_current_enemies_acquired(module, range_module):
	emit_signal("on_any_range_module_current_enemies_acquired" , module, range_module)


func _emit_on_tower_ability_before_cast_start(cooldown, ability):
	emit_signal("on_tower_ability_before_cast_start", cooldown, ability)

func _emit_on_tower_ability_after_cast_end(cooldown, ability):
	emit_signal("on_tower_ability_after_cast_end", cooldown, ability)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !last_calculated_disabled_from_attacking:
		for attack_module in all_attack_modules:
			if attack_module == null:
				continue
			
			attack_module.time_passed(delta)
			
			if attack_module.last_calculated_can_be_commanded_by_tower and attack_module.is_ready_to_attack():
				# If module itself does has a range_module
				if attack_module.range_module != null:
					attack_module.attempt_find_then_attack_enemies()
				else:
					var targets = range_module.get_targets(attack_module.number_of_unique_targets)
					attack_module.on_command_attack_enemies(targets)
	
	#Drag related
	if is_being_dragged:
		var mouse_pos = get_global_mouse_position()
		position.x = mouse_pos.x
		position.y = mouse_pos.y
	
	
	# timebounded
	_decrease_time_of_timebounded(delta)


# Round start/end

func _set_round_started(arg_is_round_started : bool):
	is_round_started = arg_is_round_started
	
	if !is_round_started: # Round ended
		_on_round_end()
	else:
		_on_round_start()


func _on_round_end():
	emit_signal("on_round_end__before_any_round_end_reverts")
	
	_set_health(last_calculated_max_health)
	
	for module in all_attack_modules:
		module.on_round_end()
		
		if module.range_module != null:
			module.range_module.clear_all_detected_enemies()
	
	_remove_all_timebound_and_countbound_and_roundbound_effects()
	
	anim_face_dir_component.set_animated_sprite_animation_to_default(tower_base_sprites)
	
	emit_signal("on_round_end")


func _on_round_start():
	_set_health(last_calculated_max_health)
	
	# dmg tracker related
	in_round_elemental_damage_dealt = 0
	in_round_physical_damage_dealt = 0
	in_round_pure_damage_dealt = 0
	in_round_total_damage_dealt = 0
	
	for module in all_attack_modules:
		module.reset_damage_track_in_round()
	
	emit_signal("on_per_round_total_damage_changed", in_round_total_damage_dealt)
	
	emit_signal("on_round_start")


# Recieving buffs/debuff related

func add_tower_effect(tower_base_effect : TowerBaseEffect, 
		target_modules : Array = all_attack_modules, 
		register_to_buff_map : bool = true, 
		include_non_module_effects : bool = true, 
		ing_effect : IngredientEffect = null):
	
	if tower_base_effect.is_from_enemy:
		# right now, only TowerAttrEffect is supported by this
		tower_base_effect = tower_base_effect._get_copy_scaled_by(last_calculated_enemy_final_effect_vulnerability)
	#
	
	var modules_to_remove_from_target : Array = []
	for module in target_modules:
		if (!module.benefits_from_ingredient_effect and tower_base_effect.is_ingredient_effect) or !module.benefits_from_any_effect:
			modules_to_remove_from_target.append(module)
	
	for module in modules_to_remove_from_target:
		target_modules.erase(module)
	
	#
	
	if tower_base_effect.is_from_enemy:
		if last_calculated_has_effect_shield_against_enemies:
			_remove_count_from_single_effect_shield_effect(1, true, false)
			return null
	else:
		if last_calculated_has_effect_shield_against_towers and tower_base_effect.ignore_effect_shield_effect:
			_remove_count_from_single_effect_shield_effect()
			return null
	
	
	if include_non_module_effects and register_to_buff_map and tower_base_effect.should_map_in_all_effects_map:
		_all_uuid_tower_buffs_map[tower_base_effect.effect_uuid] = tower_base_effect
	
	if tower_base_effect.status_bar_icon != null:
		status_bar.add_status_icon(tower_base_effect.effect_uuid, tower_base_effect.status_bar_icon)
	
	
	if tower_base_effect is TowerAttributesEffect:
		if tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
			_add_attack_speed_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
			_add_base_damage_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
			_add_range_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
			_add_pierce_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
			_add_proj_speed_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_EXPLOSION_SCALE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE:
			_add_explosion_scale_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ARMOR_PIERCE:
			_add_armor_pierce_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_TOUGHNESS_PIERCE:
			_add_toughness_pierce_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RESISTANCE_PIERCE:
			_add_resistance_pierce_effect(tower_base_effect, target_modules)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ABILITY_POTENCY or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_ABILITY_POTENCY:
			if include_non_module_effects:
				_add_ability_potency_effect(tower_base_effect)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ABILITY_CDR or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_ABILITY_CDR:
			if include_non_module_effects:
				_add_ability_cdr_effect(tower_base_effect)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_OMNIVAMP:
			if include_non_module_effects:
				_add_flat_omnivamp_effect(tower_base_effect)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_DAMAGE_OMNIVAMP:
			if include_non_module_effects:
				_add_percent_omnivamp_effect(tower_base_effect)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_HEALTH:
			if include_non_module_effects:
				_add_flat_base_health_effect(tower_base_effect)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_HEALTH:
			if include_non_module_effects:
				_add_percent_base_health_effect(tower_base_effect)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ENEMY_EFFECT_VULNERABILITY:
			if include_non_module_effects:
				_add_flat_enemy_effect_vulnerability_effect(tower_base_effect)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_ENEMY_EFFECT_VULNERABILITY:
			if include_non_module_effects:
				_add_percent_enemy_effect_vulnerability_effect(tower_base_effect)
			
		
	elif tower_base_effect is TowerOnHitDamageAdderEffect:
		_add_on_hit_damage_adder_effect(tower_base_effect, target_modules)
		
	elif tower_base_effect is TowerOnHitEffectAdderEffect:
		tower_base_effect.set_source(self)
		_add_on_hit_effect_adder_effect(tower_base_effect, target_modules)
		
	elif tower_base_effect is TowerChaosTakeoverEffect:
		if include_non_module_effects:
			_add_chaos_takeover_effect(tower_base_effect)
		
	elif tower_base_effect is BaseTowerAttackModuleAdderEffect:
		if include_non_module_effects:
			_add_attack_module_from_effect(tower_base_effect)
		
	elif tower_base_effect is TowerFullSellbackEffect:
		if include_non_module_effects:
			_set_full_sellback(true)
		
	elif tower_base_effect is _704EmblemPointsEffect:
		if include_non_module_effects:
			_special_case_tower_effect_added(tower_base_effect)
			remove_ingredient(ing_effect)
		
	elif tower_base_effect is BaseTowerModifyingEffect:
		if include_non_module_effects:
			_add_tower_modifying_effect(tower_base_effect)
		
		
	elif tower_base_effect is TowerMarkEffect:
		pass
		
	elif tower_base_effect is TowerIngredientColorCompatibilityEffect:
		if include_non_module_effects: 
			add_ingredient_compatibility_color_effect(tower_base_effect)
		
	elif tower_base_effect is TowerIngredientColorAcceptabilityEffect:
		if include_non_module_effects:
			add_ingredient_color_acceptability_effect(tower_base_effect)
		
		
	elif tower_base_effect is TowerPriorityTargetEffect:
		_add_priority_target_effect(tower_base_effect, target_modules)
		
		
	elif tower_base_effect is TowerStunEffect:
		if include_non_module_effects:
			_add_stun_effect(tower_base_effect)
		
	elif tower_base_effect is TowerKnockUpEffect:
		if include_non_module_effects:
			knock_up_from_effect(tower_base_effect)
		
	elif tower_base_effect is TowerEffectShieldEffect:
		if include_non_module_effects:
			_add_effect_shield_effect(tower_base_effect)
		
	elif tower_base_effect is TowerInvulnerabilityEffect:
		if include_non_module_effects:
			_add_invulnerability_effect(tower_base_effect)
		
		
	elif tower_base_effect is TowerResetEffects:
		if include_non_module_effects:
			_clear_ingredients_by_effect_reset()
			
			if main_attack_module != null:
				main_attack_module.reset_attack_timers()
		
	
	emit_signal("on_effect_added", tower_base_effect)
	
	if ing_effect != null and ing_effect.discard_after_absorb:
		remove_tower_effect(ing_effect.tower_base_effect)


func remove_tower_effect(tower_base_effect : TowerBaseEffect, 
		target_modules : Array = all_attack_modules, erase_from_buff_map : bool = true, include_non_module_effects : bool = true):
			
	emit_signal("before_effect_is_removed", tower_base_effect)
	
	if include_non_module_effects and erase_from_buff_map:
		_all_uuid_tower_buffs_map.erase(tower_base_effect.effect_uuid)
	
	if tower_base_effect.status_bar_icon != null:
		status_bar.remove_status_icon(tower_base_effect.effect_uuid)
	
	
	if tower_base_effect is TowerAttributesEffect:
		if tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
			_remove_attack_speed_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
			_remove_base_damage_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
			_remove_range_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
			_remove_pierce_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
			_remove_proj_speed_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_EXPLOSION_SCALE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE:
			_remove_explosion_scale_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ARMOR_PIERCE:
			_remove_armor_pierce_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_TOUGHNESS_PIERCE:
			_remove_toughness_pierce_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RESISTANCE_PIERCE:
			_remove_resistance_pierce_effect(tower_base_effect.effect_uuid, target_modules)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ABILITY_POTENCY or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_ABILITY_POTENCY:
			if include_non_module_effects:
				_remove_ability_potency_effect(tower_base_effect.effect_uuid)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ABILITY_CDR:
			if include_non_module_effects:
				_remove_flat_ability_cdr_effect(tower_base_effect.effect_uuid)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_ABILITY_CDR:
			if include_non_module_effects:
				_remove_percent_ability_cdr_effect(tower_base_effect.effect_uuid)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_OMNIVAMP:
			if include_non_module_effects:
				_remove_flat_omnivamp_effect(tower_base_effect.effect_uuid)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_DAMAGE_OMNIVAMP:
			if include_non_module_effects:
				_remove_percent_omnivamp_effect(tower_base_effect.effect_uuid)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_HEALTH:
			if include_non_module_effects:
				_remove_flat_base_health_effect_preserve_percent(tower_base_effect.effect_uuid)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_HEALTH:
			if include_non_module_effects:
				_remove_percent_base_health_effect_preserve_percent(tower_base_effect.effect_uuid)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ENEMY_EFFECT_VULNERABILITY:
			if include_non_module_effects:
				_remove_flat_enemy_effect_vulnerability_effect(tower_base_effect)
			
		elif tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_ENEMY_EFFECT_VULNERABILITY:
			if include_non_module_effects:
				_remove_percent_enemy_effect_vulnerability_effect(tower_base_effect)
			
		
	elif tower_base_effect is TowerOnHitDamageAdderEffect:
		_remove_on_hit_damage_adder_effect(tower_base_effect.effect_uuid, target_modules)
		
	elif tower_base_effect is TowerOnHitEffectAdderEffect:
		_remove_on_hit_effect_adder_effect(tower_base_effect.effect_uuid, target_modules)
		
	elif tower_base_effect is BaseTowerAttackModuleAdderEffect:
		if include_non_module_effects:
			_remove_attack_module_from_effect(tower_base_effect)
		
	elif tower_base_effect is TowerChaosTakeoverEffect:
		if include_non_module_effects:
			_remove_chaos_takeover_effect(tower_base_effect)
		
	elif tower_base_effect is TowerFullSellbackEffect:
		if include_non_module_effects:
			_set_full_sellback(false)
		
	elif tower_base_effect is BaseTowerModifyingEffect:
		if include_non_module_effects:
			_remove_tower_modifying_effect(tower_base_effect)
		
	elif tower_base_effect is TowerMarkEffect:
		pass
		
	elif tower_base_effect is TowerIngredientColorCompatibilityEffect:
		if include_non_module_effects:
			remove_ingredient_compatibility_color_effect(tower_base_effect.effect_uuid)
		
	elif tower_base_effect is TowerIngredientColorAcceptabilityEffect:
		if include_non_module_effects:
			remove_ingredient_color_acceptability_effect(tower_base_effect.effect_uuid)
		
		
	elif tower_base_effect is TowerPriorityTargetEffect:
		_remove_priority_target_effect(tower_base_effect, target_modules)
		
	elif tower_base_effect is TowerStunEffect:
		if include_non_module_effects:
			_remove_stun_effect(tower_base_effect)
		
	elif tower_base_effect is TowerEffectShieldEffect:
		if include_non_module_effects:
			_remove_effect_shield_effect(tower_base_effect)
		
	elif tower_base_effect is TowerInvulnerabilityEffect:
		if include_non_module_effects:
			_remove_invulnerability_effect(tower_base_effect)
		
	
	emit_signal("on_effect_removed", tower_base_effect)


func _add_attack_speed_effect(tower_attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_attack_speed or tower_attr_effect.force_apply:
			if tower_attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
				module.percent_attack_speed_effects[tower_attr_effect.effect_uuid] = tower_attr_effect
			elif tower_attr_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED:
				module.flat_attack_speed_effects[tower_attr_effect.effect_uuid] = tower_attr_effect
			
			module.calculate_all_speed_related_attributes()
			
			if module == main_attack_module:
				_emit_final_attack_speed_changed()
			
			if tower_attr_effect.is_countbound:
				module._all_countbound_effects[tower_attr_effect.effect_uuid] = tower_attr_effect


func _remove_attack_speed_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		module.percent_attack_speed_effects.erase(attr_effect_uuid)
		module.flat_attack_speed_effects.erase(attr_effect_uuid)
		module.calculate_all_speed_related_attributes()
		
		if module == main_attack_module:
			_emit_final_attack_speed_changed()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


func _add_base_damage_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_base_damage or attr_effect.force_apply:
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
				module.percent_base_damage_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS:
				module.flat_base_damage_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_base_damage()
			
			if module == main_attack_module:
				_emit_final_base_damage_changed()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect


func _remove_base_damage_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		module.percent_base_damage_effects.erase(attr_effect_uuid)
		module.flat_base_damage_effects.erase(attr_effect_uuid)
		
		module.calculate_final_base_damage()
		
		if module == main_attack_module:
			_emit_final_base_damage_changed()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


func _add_on_hit_damage_adder_effect(on_hit_adder : TowerOnHitDamageAdderEffect, target_modules : Array):
	for module in target_modules:
		if module.benefits_from_bonus_on_hit_damage or on_hit_adder.force_apply:
			_force_add_on_hit_damage_adder_effect_to_module(on_hit_adder, module)


func _force_add_on_hit_damage_adder_effect_to_module(on_hit_adder : TowerOnHitDamageAdderEffect, module):
	module.on_hit_damage_adder_effects[on_hit_adder.effect_uuid] = on_hit_adder
	
	if on_hit_adder.is_countbound:
		module._all_countbound_effects[on_hit_adder.effect_uuid] = on_hit_adder
	
	module._listen_for_values_change_on_on_hit_dmg_effect(on_hit_adder)
	module._update_last_calculated_on_hit_damages()



func _remove_on_hit_damage_adder_effect(on_hit_adder_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module.on_hit_damage_adder_effects.has(on_hit_adder_uuid):
			var on_hit_adder = module.on_hit_damage_adder_effects[on_hit_adder_uuid]
			module.on_hit_damage_adder_effects.erase(on_hit_adder_uuid)
			
			if module._all_countbound_effects.has(on_hit_adder_uuid):
				module._all_countbound_effects.erase(on_hit_adder_uuid)
			
			module._unlisten_for_values_change_on_on_hit_dmg_effect(on_hit_adder)
			module._update_last_calculated_on_hit_damages()


func _add_range_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
#	if range_module != null:
#		if range_module.benefits_from_bonus_range or attr_effect.force_apply:
#			if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE:
#				range_module.flat_range_effects[attr_effect.effect_uuid] = attr_effect
#			elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
#				range_module.percent_range_effects[attr_effect.effect_uuid] = attr_effect
#
#			range_module.update_range()
#			_emit_final_range_changed()
#
	for module in target_modules:
		if module.range_module != null:
			if module.parent_tower == self and (module.range_module.benefits_from_bonus_range or attr_effect.force_apply):
				if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE:
					module.range_module.flat_range_effects[attr_effect.effect_uuid] = attr_effect
				elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
					module.range_module.percent_range_effects[attr_effect.effect_uuid] = attr_effect
				
				module.range_module.update_range()
				
				if module == main_attack_module:
					_emit_final_range_changed()
				
				if attr_effect.is_countbound:
					module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect



func _remove_range_effect(attr_effect_uuid : int, target_modules : Array):
	var modules_to_remove_effect : Array = []
	for module in target_modules:
		if module.range_module != null:
			var to_remove : bool = true
			
			for using_modules in module.range_module.attack_modules_using_this:
				if !target_modules.has(using_modules) and all_attack_modules.has(using_modules):
					to_remove = false
					break
			
			if to_remove:
				modules_to_remove_effect.append(module)
	
	
	for module in modules_to_remove_effect:
		if module.parent_tower == self:
			module.range_module.flat_range_effects.erase(attr_effect_uuid)
			module.range_module.percent_range_effects.erase(attr_effect_uuid)
			
			module.range_module.update_range()
			
			if module._all_countbound_effects.has(attr_effect_uuid):
				module._all_countbound_effects.erase(attr_effect_uuid)

	
#	for module in target_modules:
#		if module.range_module != null and range_module.attack_modules_using_this.size() == 1 and range_module.attack_modules_using_this.has(module):
#
#			module.range_module.flat_range_effects.erase(attr_effect_uuid)
#			module.range_module.percent_range_effects.erase(attr_effect_uuid)
#
#			module.range_module.update_range()
#
#			if module._all_countbound_effects.has(attr_effect_uuid):
#				module._all_countbound_effects.erase(attr_effect_uuid)



func _add_pierce_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule and (module.benefits_from_bonus_pierce or attr_effect.force_apply):
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
				module.percent_pierce_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE:
				module.flat_pierce_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_pierce()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect



func _remove_pierce_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule:
			module.percent_pierce_effects.erase(attr_effect_uuid)
			module.flat_pierce_effects.erase(attr_effect_uuid)
			module.calculate_final_pierce()
			
			if module._all_countbound_effects.has(attr_effect_uuid):
				module._all_countbound_effects.erase(attr_effect_uuid)



func _add_proj_speed_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule and (module.benefits_from_bonus_proj_speed or attr_effect.force_apply):
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
				module.percent_proj_speed_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED:
				module.flat_proj_speed_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_proj_speed()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect


func _remove_proj_speed_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule:
			module.percent_proj_speed_effects.erase(attr_effect_uuid)
			module.flat_proj_speed_effects.erase(attr_effect_uuid)
			
			module.calculate_final_proj_speed()
			
			if module._all_countbound_effects.has(attr_effect_uuid):
				module._all_countbound_effects.erase(attr_effect_uuid)


func _add_explosion_scale_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module is AOEAttackModule and (module.benefits_from_bonus_explosion_scale or attr_effect.force_apply):
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE:
				module.percent_explosion_scale_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_EXPLOSION_SCALE:
				module.flat_explosion_scale_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_explosion_scale()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect


func _remove_explosion_scale_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module is AOEAttackModule:
			module.percent_explosion_scale_effects.erase(attr_effect_uuid)
			module.flat_explosion_scale_effects.erase(attr_effect_uuid)
			
			module.calculate_final_explosion_scale()
			
			if module._all_countbound_effects.has(attr_effect_uuid):
				module._all_countbound_effects.erase(attr_effect_uuid)


func _add_on_hit_effect_adder_effect(effect_adder : TowerOnHitEffectAdderEffect, target_modules : Array):
	for module in target_modules:
		if module.benefits_from_bonus_on_hit_effect or effect_adder.force_apply:
			_force_add_on_hit_effect_adder_effect_to_module(effect_adder, module)

func _force_add_on_hit_effect_adder_effect_to_module(effect_adder : TowerOnHitEffectAdderEffect, module):
	module.on_hit_effects[effect_adder.effect_uuid] = effect_adder

	if effect_adder.is_countbound:
		module._all_countbound_effects[effect_adder.effect_uuid] = effect_adder



func _remove_on_hit_effect_adder_effect(effect_adder_uuid : int, target_modules : Array):
	for module in target_modules:
		module.on_hit_effects.erase(effect_adder_uuid)
		
		if module._all_countbound_effects.has(effect_adder_uuid):
			module._all_countbound_effects.erase(effect_adder_uuid)



func _add_chaos_takeover_effect(takeover_effect : TowerChaosTakeoverEffect):
	takeover_effect.takeover(self)

func _remove_chaos_takeover_effect(takeover_effect : TowerChaosTakeoverEffect):
	takeover_effect.untakeover(self)


func _add_attack_module_from_effect(module_effect : BaseTowerAttackModuleAdderEffect):
	module_effect._make_modifications_to_tower(self)

func _remove_attack_module_from_effect(module_effect : BaseTowerAttackModuleAdderEffect):
	module_effect._undo_modifications_to_tower(self)


func _set_full_sellback(full_sellback : bool):
	_is_full_sellback = full_sellback
	
	_calculate_sellback_value()


func _add_armor_pierce_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_armor_pierce or attr_effect.force_apply:
			if attr_effect.attribute_type == TowerAttributesEffect.FLAT_ARMOR_PIERCE:
				module.flat_base_armor_pierce_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_armor_pierce()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect

func _remove_armor_pierce_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		module.flat_base_armor_pierce_effects.erase(attr_effect_uuid)
		
		module.calculate_final_armor_pierce()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


func _add_toughness_pierce_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_toughness_pierce or attr_effect.force_apply:
			if attr_effect.attribute_type == TowerAttributesEffect.FLAT_TOUGHNESS_PIERCE:
				module.flat_base_toughness_pierce_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_toughness_pierce()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect

func _remove_toughness_pierce_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		module.flat_base_toughness_pierce_effects.erase(attr_effect_uuid)
		
		module.calculate_final_toughness_pierce()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


func _add_resistance_pierce_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_resistance_pierce or attr_effect.force_apply:
			if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RESISTANCE_PIERCE:
				module.flat_base_resistance_pierce_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_resistance_pierce()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect

func _remove_resistance_pierce_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		module.flat_base_resistance_pierce_effects.erase(attr_effect_uuid)
		
		module.calculate_final_resistance_pierce()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


func _add_ability_potency_effect(attr_effect : TowerAttributesEffect):
	if attr_effect.attribute_type == TowerAttributesEffect.FLAT_ABILITY_POTENCY:
		_flat_base_ability_potency_effects[attr_effect.effect_uuid] = attr_effect
	elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_ABILITY_POTENCY:
		_percent_base_ability_potency_effects[attr_effect.effect_uuid] = attr_effect
	
	_calculate_final_ability_potency()


func _remove_ability_potency_effect(attr_effect_uuid : int):
	_flat_base_ability_potency_effects.erase(attr_effect_uuid)
	_percent_base_ability_potency_effects.erase(attr_effect_uuid)
	
	_calculate_final_ability_potency()


func _add_ability_cdr_effect(attr_effect : TowerAttributesEffect):
	if attr_effect.attribute_type == TowerAttributesEffect.FLAT_ABILITY_CDR:
		_flat_base_ability_cdr_effects[attr_effect.effect_uuid] = attr_effect
		_calculate_final_flat_ability_cdr()
	elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_ABILITY_CDR:
		_percent_base_ability_cdr_effects[attr_effect.effect_uuid] = attr_effect
		_calculate_final_percent_ability_cdr()
	
	_emit_final_ability_cd_changed()

func _remove_flat_ability_cdr_effect(attr_effect_uuid : int):
	_flat_base_ability_cdr_effects.erase(attr_effect_uuid)
	_calculate_final_flat_ability_cdr()
	_emit_final_ability_cd_changed()

func _remove_percent_ability_cdr_effect(attr_effect_uuid : int):
	_percent_base_ability_cdr_effects.erase(attr_effect_uuid)
	_calculate_final_percent_ability_cdr()
	_emit_final_ability_cd_changed()


func _add_flat_omnivamp_effect(attr_effect : TowerAttributesEffect):
	_flat_omnivamp_effects[attr_effect.effect_uuid] = attr_effect
	_calculate_final_flat_omnivamp()

func _add_percent_omnivamp_effect(attr_effect : TowerAttributesEffect):
	_percent_damage_omnivamp_effects[attr_effect.effect_uuid] = attr_effect
	_calculate_final_percent_damage_omnivamp()

func _remove_flat_omnivamp_effect(attr_effect_uuid : int):
	_flat_omnivamp_effects.erase(attr_effect_uuid)
	_calculate_final_flat_omnivamp()

func _remove_percent_omnivamp_effect(attr_effect_uuid : int):
	_percent_damage_omnivamp_effects.erase(attr_effect_uuid)
	_calculate_final_percent_damage_omnivamp()


func _add_flat_enemy_effect_vulnerability_effect(attr_effect : TowerAttributesEffect):
	_flat_enemy_effect_vulnerability_id_effect_map[attr_effect.effect_uuid] = attr_effect
	_calculate_enemy_effect_vulnerability()

func _add_percent_enemy_effect_vulnerability_effect(attr_effect : TowerAttributesEffect):
	_percent_enemy_effect_vulnerability_id_effect_map[attr_effect.effect_uuid] = attr_effect
	_calculate_enemy_effect_vulnerability()

func _remove_flat_enemy_effect_vulnerability_effect(attr_effect : TowerAttributesEffect):
	_flat_enemy_effect_vulnerability_id_effect_map.erase(attr_effect.effect_uuid)
	_calculate_enemy_effect_vulnerability()

func _remove_percent_enemy_effect_vulnerability_effect(attr_effect : TowerAttributesEffect):
	_percent_enemy_effect_vulnerability_id_effect_map.erase(attr_effect.effect_uuid)
	_calculate_enemy_effect_vulnerability()


func _add_priority_target_effect(effect : TowerPriorityTargetEffect, target_modules):
	for module in target_modules:
		if module.range_module != null:
			module.range_module.add_priority_target_effect(effect)

func _remove_priority_target_effect(effect : TowerPriorityTargetEffect, target_modules):
	for module in target_modules:
		if module.range_module != null:
			module.range_module.remove_priority_target_effect(effect)


func _add_stun_effect(effect : TowerStunEffect):
	_stun_id_effect_map[effect.effect_uuid] = effect
	last_calculated_is_stunned = true
	disabled_from_attacking_clauses.attempt_insert_clause(DisabledFromAttackingSourceClauses.IS_STUNNED)
	_disable_modules(AbstractAttackModule.Disabled_ClauseId.IS_STUNNED)


func _remove_stun_effect(effect : TowerStunEffect):
	_stun_id_effect_map.erase(effect.effect_uuid)
	last_calculated_is_stunned = _stun_id_effect_map.size() > 0
	
	if last_calculated_is_stunned:
		disabled_from_attacking_clauses.attempt_insert_clause(DisabledFromAttackingSourceClauses.IS_STUNNED)
		_disable_modules(AbstractAttackModule.Disabled_ClauseId.IS_STUNNED)
	else:
		disabled_from_attacking_clauses.remove_clause(DisabledFromAttackingSourceClauses.IS_STUNNED)
		_enable_modules(AbstractAttackModule.Disabled_ClauseId.IS_STUNNED)


func knock_up_from_effect(effect : TowerKnockUpEffect):
	if effect.time_in_seconds != 0:
		_knock_up_current_acceleration += effect.knock_up_y_acceleration
		_knock_up_current_acceleration_deceleration += 2 * (_knock_up_current_acceleration / effect.time_in_seconds)
	
	add_tower_effect(effect.generate_stun_effect_from_self())




func _add_tower_modifying_effect(tower_mod : BaseTowerModifyingEffect):
	tower_mod._make_modifications_to_tower(self)

func _remove_tower_modifying_effect(tower_mod : BaseTowerModifyingEffect):
	tower_mod._undo_modifications_to_tower(self)


# adding heal effects

func _add_flat_base_health_effect(effect : TowerAttributesEffect, with_heal : bool = true):
	flat_base_health_id_effect_map[effect.effect_uuid] = effect
	var old_max_health = last_calculated_max_health
	_calculate_max_health()
	
	if with_heal:
		var heal = last_calculated_max_health - old_max_health
		if heal > 0:
			heal_by_amount(heal)

func _add_percent_base_health_effect(effect : TowerAttributesEffect, with_heal : bool = true):
	percent_base_health_id_effect_map[effect.effect_uuid] = effect
	var old_max_health = last_calculated_max_health
	_calculate_max_health()
	
	if with_heal:
		var heal = last_calculated_max_health - old_max_health
		if heal > 0:
			heal_by_amount(heal)

func _remove_flat_base_health_effect_preserve_percent(effect_uuid : int):
	if flat_base_health_id_effect_map.has(effect_uuid):
		var flat_mod : FlatModifier = flat_base_health_id_effect_map[effect_uuid].attribute_as_modifier
		var flat_remove = flat_mod.flat_modifier
		
		var old_max = last_calculated_max_health
		var old_curr_health = current_health
		flat_base_health_id_effect_map.erase(effect_uuid)
		_calculate_max_health()
		var new_max = last_calculated_max_health
		
		_set_health(preserve_percent(old_max, new_max, old_curr_health))


func _remove_percent_base_health_effect_preserve_percent(effect_uuid : int):
	if percent_base_health_id_effect_map.has(effect_uuid):
		var percent_mod : PercentModifier = percent_base_health_id_effect_map[effect_uuid].attribute_as_modifier
		
		var old_max = last_calculated_max_health
		var old_curr_health = current_health
		percent_base_health_id_effect_map.erase(effect_uuid)
		_calculate_max_health()
		var new_max = last_calculated_max_health
		
		_set_health(preserve_percent(old_max, new_max, old_curr_health))


static func preserve_percent(old_max : float, new_max : float, current : float) -> float:
	var old_ratio = current / old_max
	return new_max * old_ratio




# special case effects

func _special_case_tower_effect_added(effect : TowerBaseEffect):
	pass


# has tower effects

func has_tower_effect_uuid_in_buff_map(effect_uuid : int) -> bool:
	return _all_uuid_tower_buffs_map.has(effect_uuid)

func has_tower_effect_type_in_buff_map(tower_effect : TowerBaseEffect):
	for effect in _all_uuid_tower_buffs_map:
		if tower_effect.get_script() == effect.get_script():
			return true
	
	return false

func get_tower_effect(effect_uuid : int) -> TowerBaseEffect:
	if _all_uuid_tower_buffs_map.has(effect_uuid):
		return _all_uuid_tower_buffs_map[effect_uuid]
	else:
		return null


# Decreasing timebounds related

func _decrease_time_of_timebounded(delta):
	for effect_uuid in _all_uuid_tower_buffs_map.keys():
		var effect : TowerBaseEffect = _all_uuid_tower_buffs_map[effect_uuid]
		
		if effect.is_timebound:
			effect.time_in_seconds -= delta
			
			if effect.time_in_seconds <= 0:
				remove_tower_effect(effect)


func _remove_all_timebound_effects():
	for effect_uuid in _all_uuid_tower_buffs_map.keys():
		var effect : TowerBaseEffect = _all_uuid_tower_buffs_map[effect_uuid]
		
		if effect.is_timebound:
			remove_tower_effect(effect)


# Decreasing count of countbounded

func _decrease_count_of_countbounded(module : AbstractAttackModule):
	for effect_uuid in module._all_countbound_effects.keys():
		var effect : TowerBaseEffect = module._all_countbound_effects[effect_uuid]
		
		if effect.is_countbound:
			if effect.count_reduced_by_main_attack_only and module.module_id != StoreOfAttackModuleID.MAIN:
				continue
			
			effect.count -= 1
			
			if effect.count <= 0:
				remove_tower_effect(effect)


func _remove_all_countbound_effects():
	for effect_uuid in _all_uuid_tower_buffs_map.keys():
		var effect : TowerBaseEffect = _all_uuid_tower_buffs_map[effect_uuid]

		if effect.is_countbound:
			remove_tower_effect(effect)


func _remove_all_timebound_and_countbound_and_roundbound_effects():
	var effects_to_remove : Array = []
	
	for effect_uuid in _all_uuid_tower_buffs_map.keys():
		var effect : TowerBaseEffect = _all_uuid_tower_buffs_map[effect_uuid]
		
		if effect.is_countbound or effect.is_timebound:
			effects_to_remove.append(effect)
		elif effect.is_roundbound:
			effect.round_count -= 1
			if effect.round_count <= 0:
				effects_to_remove.append(effect)
	
	for effect in effects_to_remove:
		remove_tower_effect(effect)


# Ingredient Related

func absorb_ingredient(ingredient_effect : IngredientEffect, ingredient_gold_base_cost : int):
	if ingredient_effect != null:
		if ingredient_effect.tower_base_effect._can_be_scaled_by_yel_vio:
			ingredient_effect.tower_base_effect._consume_current_additive_scaling_for_actual_scaling_in_stats()
		
		ingredients_absorbed[ingredient_effect.tower_id] = ingredient_effect
		_ingredients_tower_id_base_gold_costs_map[ingredient_effect.tower_id] = ingredient_gold_base_cost
		add_tower_effect(ingredient_effect.tower_base_effect, all_attack_modules, true, true, ingredient_effect)
		
		_emit_ingredients_absorbed_changed()
		_calculate_sellback_value()
		
		emit_signal("on_ingredient_absorbed", ingredient_effect)
		_display_absorbed_ingredient_effects(Towers.get_tower_tier_from_tower_id(ingredient_effect.tower_id))


func remove_ingredient(ingredient_effect : IngredientEffect, refund_gold : bool = false):
	if ingredient_effect != null:
		remove_tower_effect(ingredients_absorbed[ingredient_effect.tower_id].tower_base_effect)
		
		if refund_gold:
			var gold_cost = _ingredients_tower_id_base_gold_costs_map[ingredient_effect.tower_id]
			if gold_cost > 1:
				gold_cost -= 1
			
			emit_signal("tower_give_gold", gold_cost, GoldManager.IncreaseGoldSource.TOWER_EFFECT_RESET)
		
		_ingredients_tower_id_base_gold_costs_map.erase(ingredient_effect.tower_id)
		ingredients_absorbed.erase(ingredient_effect.tower_id)
		
		_emit_ingredients_absorbed_changed()
		_calculate_sellback_value()


func clear_ingredients():
	for ingredient_tower_id in ingredients_absorbed:
		remove_tower_effect(ingredients_absorbed[ingredient_tower_id].tower_base_effect)
	
	ingredients_absorbed.clear()
	_emit_ingredients_absorbed_changed()
	_ingredients_tower_id_base_gold_costs_map.clear()
	
	_calculate_sellback_value()

func _clear_ingredients_by_effect_reset():
	for ingredient_tower_id in ingredients_absorbed.keys():
		remove_tower_effect(ingredients_absorbed[ingredient_tower_id].tower_base_effect)
	
	ingredients_absorbed.clear()
	emit_signal("tower_give_gold", _calculate_sellback_of_ingredients(), GoldManager.IncreaseGoldSource.TOWER_EFFECT_RESET)
	_ingredients_tower_id_base_gold_costs_map.clear()
	
	_calculate_sellback_value()


func _remove_latest_ingredient_by_effect():
	if ingredients_absorbed.size() != 0:
		var latest_effect = ingredients_absorbed.values()[ingredients_absorbed.size() - 1]
		remove_ingredient(latest_effect, true)
		
		_calculate_sellback_value()



# can absorb ing

func _on_can_absorb_ing_clause_added_or_removed(arg_clause_id):
	_update_last_calculated_can_absorb_ing()

func _update_last_calculated_can_absorb_ing():
	last_calculated_can_absorb_ingredient = can_absorb_ingredient_conditonal_clauses.is_passed


func _can_accept_ingredient(ingredient_effect : IngredientEffect, tower_selected) -> bool:
	if ingredient_effect != null:
		if !last_calculated_can_absorb_ingredient:
			return false
		
		if !tower_selected.last_calculated_can_be_used_as_ingredient:
			return false
		
		
		if ingredients_absorbed.size() >= last_calculated_ingredient_limit and !ingredient_effect.ignore_ingredient_limit:
			return false
		
		if all_combinations_id_to_effect_id_map.has(ingredient_effect.tower_id):
			return false
		
		if ingredients_absorbed.has(ingredient_effect.tower_id):
			return false
		
		if tower_selected.tower_id == 2000:
			return true
		
		return _can_accept_ingredient_color(tower_selected)
	
	return false

func _can_accept_ingredient_color(tower_selected) -> bool:
	for color in tower_selected.ingredient_compatible_colors:
		if _tower_colors.has(color):
			return true
	
	#if _tower_colors.has(TowerColors.BLACK):
	#	return true
	
	var final_verdict : bool = false
	for effect in _ingredient_acceptability_color_effects.values():
		for color in tower_selected.ingredient_compatible_colors:
			if effect.color_list.has(color):
				final_verdict = (effect.acceptability_type == TowerIngredientColorAcceptabilityEffect.AcceptabilityType.WHITELIST)
				break
	
	
	return final_verdict

func get_amount_of_ingredients_absorbed() -> int:
	return ingredients_absorbed.size()



func show_acceptability_with_ingredient(ingredient_effect : IngredientEffect, tower_selected):
	if tower_selected != self:
		var can_accept = _can_accept_ingredient(ingredient_effect, tower_selected)
		
		$IngredientDeclinePic.visible = !can_accept

func hide_acceptability_with_ingredient():
	$IngredientDeclinePic.visible = false


func add_ingredient_color_acceptability_effect(effect : TowerIngredientColorAcceptabilityEffect):
	_ingredient_acceptability_color_effects[effect.effect_uuid] = effect

func remove_ingredient_color_acceptability_effect(effect_uuid : int):
	_ingredient_acceptability_color_effects.erase(effect_uuid)


# can be used as ing

func _on_can_be_used_as_ing_clause_added_or_removed(arg_clause_id):
	_update_last_calculated_can_be_used_as_ing()

func _update_last_calculated_can_be_used_as_ing():
	last_calculated_can_be_used_as_ingredient = can_be_used_as_ingredient_conditonal_clauses.is_passed


# own ing related

func set_self_ingredient_effect(arg_ing_effect : IngredientEffect):
	var old_ing = ingredient_of_self
	ingredient_of_self = arg_ing_effect
	emit_signal("self_ingredient_changed", old_ing, ingredient_of_self)


# Ingredient limit related

func _tower_manager_ing_cap_set(cap_id, cap_amount):
	set_ingredient_limit_modifier(cap_id, cap_amount)

func _tower_manager_ing_cap_removed(cap_id):
	remove_ingredient_limit_modifier(cap_id)


func set_ingredient_limit_modifier(modifier_id : int, limit_modifier : int):
	_ingredient_id_limit_modifier_map[modifier_id] = limit_modifier
	_set_active_ingredient_limit(_calculate_final_ingredient_limit())

func remove_ingredient_limit_modifier(modifier_id : int):
	_ingredient_id_limit_modifier_map.erase(modifier_id)
	_set_active_ingredient_limit(_calculate_final_ingredient_limit())


func _calculate_final_ingredient_limit() -> int:
	var final_limit : int = 0
	
	for limit_modifier in _ingredient_id_limit_modifier_map.values():
		final_limit += limit_modifier
	
	if final_limit < 0:
		final_limit = 0
	
	return final_limit


func _set_active_ingredient_limit(new_limit : int):
	
	if last_calculated_ingredient_limit != new_limit:
		var old_ing_limit = last_calculated_ingredient_limit #
		last_calculated_ingredient_limit = new_limit #
		
		if old_ing_limit > new_limit:
			
			var ing_effects = ingredients_absorbed.values()
			for i in range(new_limit, ingredients_absorbed.size()):
				remove_tower_effect(ing_effects[i].tower_base_effect)
			
			
		elif old_ing_limit < new_limit:
			
			var ing_effects = ingredients_absorbed.values()
			for i in range(old_ing_limit, new_limit):
				if ing_effects.size() > i:
					add_tower_effect(ing_effects[i].tower_base_effect)
				else:
					break
		
		#last_calculated_ingredient_limit = new_limit
		emit_signal("ingredients_limit_changed", new_limit)


# ing compatible color related

func _update_ingredient_compatible_colors():
	ingredient_compatible_colors.clear()
	
	for color in _tower_colors:
		if color == TowerColors.RED:
			ingredient_compatible_colors.append(TowerColors.RED)
			ingredient_compatible_colors.append(TowerColors.ORANGE)
			ingredient_compatible_colors.append(TowerColors.VIOLET)
			
		elif color == TowerColors.ORANGE:
			ingredient_compatible_colors.append(TowerColors.ORANGE)
			ingredient_compatible_colors.append(TowerColors.RED)
			ingredient_compatible_colors.append(TowerColors.YELLOW)
			
		elif color == TowerColors.YELLOW:
			ingredient_compatible_colors.append(TowerColors.YELLOW)
			ingredient_compatible_colors.append(TowerColors.ORANGE)
			ingredient_compatible_colors.append(TowerColors.GREEN)
			
		elif color == TowerColors.GREEN:
			ingredient_compatible_colors.append(TowerColors.GREEN)
			ingredient_compatible_colors.append(TowerColors.BLUE)
			ingredient_compatible_colors.append(TowerColors.YELLOW)
			
		elif color == TowerColors.BLUE:
			ingredient_compatible_colors.append(TowerColors.BLUE)
			ingredient_compatible_colors.append(TowerColors.GREEN)
			ingredient_compatible_colors.append(TowerColors.VIOLET)
			
		elif color == TowerColors.VIOLET:
			ingredient_compatible_colors.append(TowerColors.VIOLET)
			ingredient_compatible_colors.append(TowerColors.RED)
			ingredient_compatible_colors.append(TowerColors.BLUE)
			
		elif color == TowerColors.GRAY:
			ingredient_compatible_colors.append(TowerColors.GRAY)
			
		elif color == TowerColors.BLACK:
			ingredient_compatible_colors.append(TowerColors.BLACK)
	
	
	for effect in _ingredient_compatible_color_effects.values():
		effect.modify_ing_color_compatibility_list(ingredient_compatible_colors)



func add_ingredient_compatibility_color_effect(effect : TowerIngredientColorCompatibilityEffect):
	_ingredient_compatible_color_effects[effect.effect_uuid] = effect
	_update_ingredient_compatible_colors()

func remove_ingredient_compatibility_color_effect(effect_uuid : int):
	_ingredient_compatible_color_effects.erase(effect_uuid)
	_update_ingredient_compatible_colors()


# Tower Colors Related

func add_color_to_tower(color : int):
	#if !_tower_colors.has(color):
	_tower_colors.append(color)
	
	#call_deferred("emit_signal", "update_active_synergy")
	#call_deferred("emit_signal", "tower_colors_changed")
	_update_ingredient_compatible_colors()
	
	emit_signal("tower_colors_changed")
	emit_signal("update_active_synergy")

func remove_color_from_tower(color : int):
	#if _tower_colors.has(color):
	_tower_colors.erase(color)
	
	# original order of things: update then colors changed
	call_deferred("emit_signal", "update_active_synergy")
	call_deferred("emit_signal", "tower_colors_changed")
	_update_ingredient_compatible_colors()

func remove_all_colors_from_tower(emit_change_signals : bool = true):
	_tower_colors.clear()
	
	if emit_change_signals:
		call_deferred("emit_signal", "tower_colors_changed")
		call_deferred("emit_signal", "update_active_synergy")
	_update_ingredient_compatible_colors()


# Abiliy reg and cdr related

func register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	if all_tower_abiltiies != null:
		all_tower_abiltiies.append(ability)
	
	emit_signal("register_ability", ability, add_to_panel)
	
	ability.connect("on_ability_before_cast_start", self, "_emit_on_tower_ability_before_cast_start", [ability], CONNECT_PERSIST)
	ability.connect("on_ability_after_cast_end", self, "_emit_on_tower_ability_after_cast_end", [ability], CONNECT_PERSIST)


func _get_cd_to_use(base_cd : float) -> float:
	var final_cd : float = base_cd
	
	final_cd *= (100 - last_calculated_final_percent_ability_cdr) / 100
	final_cd -= last_calculated_final_flat_ability_cdr
	
	if final_cd < 0:
		final_cd = 0
	
	return final_cd


# Recalculation

func recalculate_final_base_damage():
	for module in all_attack_modules:
		module.calculate_final_base_damage()
		
		if module == main_attack_module:
			_emit_final_base_damage_changed()

func recalculate_range():
	var updated_range_modules : Array = []
	
	for module in all_attack_modules:
		if module.range_module != null and !updated_range_modules.has(module.range_module):
			module.range_module.update_range()
			updated_range_modules.append(module.range_module)


# Stats related (Changes to any of these func names must
# be done to the func names in TowerStatsTextFragment class

func get_last_calculated_base_damage_of_main_attk_module() -> float:
	if main_attack_module != null:
		return main_attack_module.last_calculated_final_damage
	else:
		return 0.0

func get_base_base_damage_of_main_attk_module() -> float:
	if main_attack_module != null:
		return main_attack_module.base_damage
	else:
		return 0.0

func get_bonus_base_damage_of_main_attk_module() -> float:
	if main_attack_module != null:
		return main_attack_module.last_calculated_final_damage - main_attack_module.base_damage
	else:
		return 0.0


func get_last_calculated_attack_speed_of_main_attk_module() -> float:
	if main_attack_module != null:
		return main_attack_module.last_calculated_final_attk_speed
	else:
		return 0.0

func get_base_attack_speed_of_main_attk_module() -> float:
	if main_attack_module != null:
		return main_attack_module.base_attack_speed
	else:
		return 0.0

func get_bonus_attack_speed_of_main_attk_module() -> float:
	if main_attack_module != null:
		return main_attack_module.last_calculated_final_attk_speed - main_attack_module.base_attack_speed
	else:
		return 0.0


func get_last_calculated_range_of_main_attk_module() -> float:
	if main_attack_module != null:
		return main_attack_module.range_module.last_calculated_final_range
	else:
		return 0.0

func get_base_range_of_main_attk_module() -> float:
	if main_attack_module != null:
		return main_attack_module.range_module.base_range_radius
	else:
		return 0.0

func get_bonus_range_of_main_attk_module() -> float:
	if main_attack_module != null:
		return main_attack_module.range_module.last_calculated_final_range - main_attack_module.range_module.base_range_radius
	else:
		return 0.0


func get_last_calculated_ability_potency() -> float:
	return last_calculated_final_ability_potency

func get_base_ability_potency() -> float:
	return base_ability_potency

func get_bonus_ability_potency() -> float:
	return last_calculated_final_ability_potency - base_ability_potency


func get_last_calculated_percent_cdr() -> float:
	return last_calculated_final_percent_ability_cdr

func get_base_percent_cdr() -> float:
	return base_percent_ability_cdr

func get_bonus_percent_cdr() -> float:
	return last_calculated_final_percent_ability_cdr - base_percent_ability_cdr


func get_last_calculated_bullet_pierce() -> float:
	if main_attack_module != null and main_attack_module is BulletAttackModule:
		return main_attack_module.last_calculated_final_pierce
	else:
		return 0.0

func get_base_bullet_pierce() -> float:
	if main_attack_module != null and main_attack_module is BulletAttackModule:
		return main_attack_module.base_pierce
	else:
		return 0.0

func get_bonus_bullet_pierce() -> float:
	if main_attack_module != null and main_attack_module is BulletAttackModule:
		return main_attack_module.last_calculated_final_pierce - main_attack_module.base_pierce
	else:
		return 0.0




func get_last_calculated_total_flat_on_hit_damages() -> float:
	if main_attack_module != null:
		return main_attack_module.last_calculated_total_flat_on_hit_damage
	else:
		return 0.0

func get_last_calculated_flat_elemental_on_hit_damages() -> float:
	if main_attack_module != null:
		return main_attack_module.last_calculated_flat_elemental_on_hit_damage
	else:
		return 0.0

func get_last_calculated_flat_physical_on_hit_damages() -> float:
	if main_attack_module != null:
		return main_attack_module.last_calculated_flat_physical_on_hit_damage
	else:
		return 0.0

func get_last_calculated_flat_pure_on_hit_damages() -> float:
	if main_attack_module != null:
		return main_attack_module.last_calculated_flat_pure_on_hit_damage
	else:
		return 0.0



func get_all_on_hits_have_same_damage_type() -> bool:
	if main_attack_module != null:
		return main_attack_module.all_on_hits_have_same_damage_type
	else:
		return false

func get_damage_type_of_all_on_hits() -> int:
	if main_attack_module != null:
		return main_attack_module.damage_type_of_all_on_hits
	else:
		return -1


# Ability calculation related

func _calculate_final_ability_potency():
	var final_ap = base_ability_potency
	
	#if benefits_from_bonus_base_damage:
	var totals_bucket : Array = []
	
	for effect in _percent_base_ability_potency_effects.values():
		if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
			final_ap += effect.attribute_as_modifier.get_modification_to_value(base_ability_potency)
		else:
			totals_bucket.append(effect)
	
	for effect in _flat_base_ability_potency_effects.values():
		final_ap += effect.attribute_as_modifier.get_modification_to_value(base_ability_potency)
	
	var final_base_ap = final_ap
	for effect in totals_bucket:
		final_base_ap += effect.attribute_as_modifier.get_modification_to_value(final_base_ap)
	final_ap = final_base_ap
	
	last_calculated_final_ability_potency = final_ap
	_emit_final_ability_potency_changed()
	return last_calculated_final_ability_potency


func _calculate_final_flat_ability_cdr():
	var final_cdr = base_flat_ability_cdr
	
	for effect in _flat_base_ability_potency_effects.values():
		final_cdr += effect.attribute_as_modifier.get_modification_to_value(base_flat_ability_cdr)
	
	last_calculated_final_flat_ability_cdr = final_cdr
	return last_calculated_final_flat_ability_cdr


func _calculate_final_percent_ability_cdr():
	var final_percent_cdr = base_percent_ability_cdr
	
	for effect in _percent_base_ability_cdr_effects.values():
		# Intentionally does not use "get_modification_to"
		final_percent_cdr = _get_add_cdr_to_total_cdr(effect.attribute_as_modifier.percent_amount, final_percent_cdr)
	
	if final_percent_cdr > 95:
		final_percent_cdr = 95
	
	last_calculated_final_percent_ability_cdr = final_percent_cdr
	return last_calculated_final_percent_ability_cdr

func _get_add_cdr_to_total_cdr(arg_cdr, arg_total_cdr) -> float:
	var missing = 100 - arg_total_cdr
	
	return arg_total_cdr + (arg_cdr * (1 - ((100 - missing) / 100)))



# Vamp calculations

func _calculate_final_flat_omnivamp():
	var final_flat_vamp : float = 0
	
	for effect in _flat_omnivamp_effects.values():
		final_flat_vamp += effect.attribute_as_modifier.get_modification_to_value(final_flat_vamp)
	
	last_calculated_flat_omnivamp = final_flat_vamp
	return final_flat_vamp

func _calculate_final_percent_damage_omnivamp():
	var final_vamp : float = 0
	
	for effect in _percent_damage_omnivamp_effects.values():
		# Intentionally does not use "get_modification_to"
		final_vamp += effect.attribute_as_modifier.percent_amount
	
	last_calculated_percent_damage_omnivamp = final_vamp
	return final_vamp

# effect vul calcs

func _calculate_enemy_effect_vulnerability() -> float:
	#All percent modifiers here are to BASE values only
	var final_enemy_effect_vul = base_enemy_effect_vulnerability
	for effect in _percent_enemy_effect_vulnerability_id_effect_map.values():
		final_enemy_effect_vul += effect.attribute_as_modifier.get_modification_to_value(base_enemy_effect_vulnerability)
	
	for effect in _flat_enemy_effect_vulnerability_id_effect_map.values():
		final_enemy_effect_vul += effect.attribute_as_modifier.flat_modifier
	
	last_calculated_enemy_final_effect_vulnerability = final_enemy_effect_vul
	return final_enemy_effect_vul



# Invulnerability related

func _add_invulnerability_effect(effect : TowerInvulnerabilityEffect):
	invulnerability_id_effect_map[effect.effect_uuid] = effect
	calculate_invulnerability_status()

func _remove_invulnerability_effect(effect : TowerInvulnerabilityEffect):
	invulnerability_id_effect_map.erase(effect.effect_uuid)
	calculate_invulnerability_status()

func _remove_count_from_single_invulnerability_effect(arg_count_reduction : int = 1):
	var count_reduc_remaining : int = arg_count_reduction
	var effects_to_remove : Array = []
	
	for effect in invulnerability_id_effect_map.values():
		if effect.is_countbound:
			var original_count = effect.count
			
			effect.count -= count_reduc_remaining
			count_reduc_remaining -= original_count
			
			if effect.count <= 0:
				count_reduc_remaining -= effect.count
				effects_to_remove.append(effect)
			
			if count_reduc_remaining < 0:
				break
	
	for effect in effects_to_remove:
		remove_tower_effect(effect)


func calculate_invulnerability_status():
	last_calculated_is_invulnerable = invulnerability_id_effect_map.size() > 0
	
	
#	if last_calculated_is_invulnerable:
#		sprite_layer.modulate = invulnerable_sprite_layer_self_modulate
#	else:
#		sprite_layer.modulate = normal_sprite_layer_self_modulate
#



# Inputs related

func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT:
			_toggle_show_tower_info()
		elif event.pressed and event.button_index == BUTTON_LEFT:
			if _is_in_select_tower_prompt:
				_self_is_selected_in_selection_mode()
				
			elif !(is_round_started and current_placable is InMapAreaPlacable) and last_calculated_tower_is_draggable:
				_start_drag()
		elif !event.pressed and event.button_index == BUTTON_LEFT:
			if is_being_dragged:
				_end_drag()


# Tower selection related

func enter_selection_mode(prompter, arg_prompt_tower_checker_predicate_name : String):
	_is_in_select_tower_prompt = true
	if prompter.has_method(arg_prompt_tower_checker_predicate_name):
		var passed_predicate = prompter.call(arg_prompt_tower_checker_predicate_name, self)
		
		if !passed_predicate:
			cannot_apply_pic.visible = true
		else:
			cannot_apply_pic.visible = false

func exit_selection_mode():
	_is_in_select_tower_prompt = false
	
	if cannot_apply_pic != null:
		cannot_apply_pic.visible = false


func _self_is_selected_in_selection_mode():
	emit_signal("tower_selected_in_selection_mode", self)


# Show Ranges of modules and Tower Info

func toggle_module_ranges():
	var range_modules_showing : Array = []
	
	if range_module != null:
		range_module.toggle_show_range()
		range_modules_showing.append(range_module)
	
	for attack_module in all_attack_modules:
		if attack_module != null:
			if attack_module.range_module != null and attack_module.use_self_range_module and (attack_module.range_module.can_display_range or attack_module.range_module.can_display_circle_arc):
				if !range_modules_showing.has(attack_module.range_module):
					attack_module.range_module.toggle_show_range()
					range_modules_showing.append(range_module)
	
	
	range_modules_showing.clear()
	is_showing_ranges = !is_showing_ranges
	
	emit_signal("on_tower_toggle_showing_range", is_showing_ranges)


func _toggle_show_tower_info():
	emit_signal("tower_toggle_show_info", self)


# Disable Modules for whatever reason

func _disable_modules(disable_clause_id : int):
	for module in all_attack_modules:
		module.disable_module(disable_clause_id)

func _enable_modules(disable_clause_id_to_remove : int):
	for module in all_attack_modules:
		module.enable_module(disable_clause_id_to_remove)


# Movement Drag and Drop things related

func _start_drag():
	$PlacableDetector/DetectorShape.set_deferred("disabled", false)
	$PlacableDetector.monitoring = true
	is_being_dragged = true
	
	set_disabled_from_attacking_clause(DisabledFromAttackingSourceClauses.TOWER_BEING_DRAGGED)
	
	_disable_modules(AbstractAttackModule.Disabled_ClauseId.IS_IN_DRAG)
	z_index = ZIndexStore.TOWERS_BEING_DRAGGED
	
	emit_signal("tower_being_dragged", self)


func _end_drag(arg_is_from_ready : bool = false):
	z_index = ZIndexStore.TOWERS
	if !is_queued_for_deletion():
		var cannot_drop_to_placable = !tower_manager.can_place_tower_based_on_limit_and_curr_placement(self)
		#var intent_placable = hovering_over_placable
		var intent_placable = _get_placable_to_use_for_move(arg_is_from_ready)
		var move_success = transfer_to_placable(intent_placable, false, cannot_drop_to_placable)
		
		emit_signal("on_attempt_drop_tower_on_placable", self, intent_placable, move_success)
	
	erase_disabled_from_attacking_clause(DisabledFromAttackingSourceClauses.TOWER_BEING_DRAGGED)
	emit_signal("tower_dropped_from_dragged", self)
	

func _get_placable_to_use_for_move(arg_is_from_ready : bool = false) -> BaseAreaTowerPlacable:
	var drag_mode = game_elements.game_settings_manager.tower_drag_mode
	
	if arg_is_from_ready:
		return hovering_over_placable
	
	if drag_mode == game_elements.game_settings_manager.TowerDragMode.EXACT:
		return hovering_over_placable
	elif drag_mode == game_elements.game_settings_manager.TowerDragMode.SNAP_TO_NEARBY_IN_MAP_PLACABLE:
		if hovering_over_placable != null:
			return hovering_over_placable
		else:
			var nearby_placables = game_elements.map_manager.get_all_placables_in_range_from_mouse(game_elements.game_settings_manager.tower_drag_mode_search_radius)
			if nearby_placables.size() > 0:
				return nearby_placables[0]
	
	return null



func transfer_to_placable(new_area_placable: BaseAreaTowerPlacable, do_not_update : bool = false, always_snap_back_to_orignal_pos : bool = false, ignore_is_round_started : bool = false, ignore_ing_mode : bool = false):
	if !last_calculated_can_be_placed_in_map and new_area_placable is InMapAreaPlacable:
		if !is_in_ingredient_mode or ignore_ing_mode:
			new_area_placable = null
	
	if !last_calculated_can_be_placed_in_bench and new_area_placable is TowerBenchSlot:
		if !is_in_ingredient_mode or ignore_ing_mode:
			new_area_placable = null
	
	if new_area_placable != null and !new_area_placable.last_calculated_can_be_occupied__ignoring_has_tower_clause:
		new_area_placable = null
	
	var should_update_active_synergy : bool
	if new_area_placable != null and !do_not_update:
		if (current_placable != null and current_placable.get_placable_type_name() != new_area_placable.get_placable_type_name()):
			should_update_active_synergy = true
		elif current_placable == null and new_area_placable is InMapAreaPlacable:
			should_update_active_synergy = true
	
	# The "old" one
	if current_placable != null:
		if current_placable.tower_occupying == self:
			current_placable.tower_occupying = null
	
	var transferred_tower : bool = false
	# ing related and swapping
	if new_area_placable != null and new_area_placable.tower_occupying != null:
		if !is_in_ingredient_mode or ignore_ing_mode:
			# swapping related
			if (!(is_round_started and new_area_placable is InMapAreaPlacable) or ignore_is_round_started) and tower_manager.if_towers_can_swap_based_on_tower_slot_limit_and_map_placement(self, new_area_placable.tower_occupying):
				
				new_area_placable.tower_occupying.transfer_to_placable(current_placable, true, false, true, ignore_ing_mode)
				transferred_tower = true
			else:
				new_area_placable = null # return tower to original location
			
		else:
			var target_tower = new_area_placable.tower_occupying
			
			if target_tower._can_accept_ingredient(ingredient_of_self, self):
				_give_self_ingredient_buff_to(target_tower)
				return
			else:
				new_area_placable = null # return tower to original location
	
	if new_area_placable is InMapAreaPlacable and always_snap_back_to_orignal_pos and !transferred_tower:
		new_area_placable = null
	
	# The "new" one
	if new_area_placable != null:
		current_placable = new_area_placable
		$ClickableArea/ClickableShape.shape = current_placable.get_area_shape()
	
	current_placable.tower_occupying = self
	$PlacableDetector/DetectorShape.set_deferred("disabled", true)
	$PlacableDetector.monitoring = false
	is_being_dragged = false
	
	if current_placable != null:
		var pos = current_placable.get_tower_center_position()
		position.x = pos.x
		position.y = pos.y
		
		if current_placable is TowerBenchSlot:
			set_disabled_from_attacking_clause(DisabledFromAttackingSourceClauses.TOWER_IN_BENCH)
			
			_disable_modules(AbstractAttackModule.Disabled_ClauseId.IS_IN_DRAG)
			#is_contributing_to_synergy = false
			
			contributing_to_synergy_clauses.attempt_insert_clause(ContributingToSynergyClauses.NOT_IN_MAP)
			#emit_signal("tower_not_in_active_map")
			
			# Update Synergy
			if should_update_active_synergy:
				emit_signal("update_active_synergy")
			
		elif current_placable is InMapAreaPlacable:
			erase_disabled_from_attacking_clause(DisabledFromAttackingSourceClauses.TOWER_IN_BENCH)
			
			_enable_modules(AbstractAttackModule.Disabled_ClauseId.IS_IN_DRAG)
			#is_contributing_to_synergy = true
			
			contributing_to_synergy_clauses.remove_clause(ContributingToSynergyClauses.NOT_IN_MAP)
			#emit_signal("tower_active_in_map")
			
			# Update Synergy
			if should_update_active_synergy:
				emit_signal("update_active_synergy")
	
	emit_signal("on_tower_transfered_to_placable", self, current_placable)
	
	return new_area_placable != null

func _on_PlacableDetector_area_entered(area):
	if area is BaseAreaTowerPlacable:
		hovering_over_placable = area
		
		if is_being_dragged:
			hovering_over_placable.set_tower_highlight_sprite(tower_highlight_sprite)

func _on_PlacableDetector_area_exited(area):
	if area is BaseAreaTowerPlacable:
		area.set_tower_highlight_sprite(null)
		if hovering_over_placable == area:
			hovering_over_placable = null


# Mov to in map related

func _on_can_move_to_in_map_clause_added_or_removed(arg_clause_id):
	_update_last_calculated_can_be_placed_in_map()

func _update_last_calculated_can_be_placed_in_map():
	last_calculated_can_be_placed_in_map = can_be_placed_in_map_conditional_clause.is_passed


func _on_can_move_to_bench_clause_added_or_removed(arg_clause_id):
	_update_last_calculated_can_be_placed_in_bench()

func _update_last_calculated_can_be_placed_in_bench():
	last_calculated_can_be_placed_in_bench = can_be_placed_in_bench_conditional_clause.is_passed

#

func _on_tower_is_draggable_clause_ins_or_rem(arg_clause_id):
	_update_last_calculate_tower_is_draggable()

func _update_last_calculate_tower_is_draggable():
	last_calculated_tower_is_draggable = tower_is_draggable_clauses.is_passed



# Ingredient drag and drop related

func _set_is_in_ingredient_mode(mode : bool):
	is_in_ingredient_mode = mode
	
	if mode == false:
		$IngredientDeclinePic.visible = false

func _give_self_ingredient_buff_to(absorber):
	absorber.absorb_ingredient(ingredient_of_self, _calculate_sellback_value())
	
	emit_signal("tower_being_absorbed_as_ingredient", self)
	queue_free()


# Sell related

func _on_sell_clause_added_or_removed(arg_clause_id):
	_update_last_calculated_can_be_sold()

func _update_last_calculated_can_be_sold():
	last_calculated_can_be_sold = can_be_sold_conditonal_clauses.is_passed



func sell_tower():
	if last_calculated_can_be_sold:
		call_deferred("emit_signal", "tower_being_sold", last_calculated_sellback_value)
		queue_free()



func set_base_gold_cost(arg_val):
	_base_gold_cost = arg_val
	
	_calculate_sellback_value()

func _calculate_sellback_value() -> int:
	var sellback = _base_gold_cost
	
	sellback += _calculate_sellback_of_ingredients()
	
	last_calculated_sellback_value = sellback
	call_deferred("emit_signal", "on_sellback_value_changed", last_calculated_sellback_value)
	
	return sellback

func _calculate_sellback_of_ingredients() -> int:
	var sellback = 0
	
	for cost in _ingredients_tower_id_base_gold_costs_map.values():
		if cost > 1 and !_is_full_sellback:
			cost -= 1
		
		sellback += cost
	
	return sellback


# Modulate related

#func set_tower_sprite_modulate(color : Color):
#	$TowerBase.modulate = color


func set_tower_base_modulate(arg_id : int, arg_mod : Color):
	all_id_to_tower_base_modulate[arg_id] = arg_mod
	
	_update_tower_base_current_modulate()

func remove_tower_base_modulate(arg_id : int):
	all_id_to_tower_base_modulate.erase(arg_id)
	
	_update_tower_base_current_modulate()


func _update_tower_base_current_modulate():
	_calculate_tower_base_modulate()
	
	tower_base.modulate = last_calculated_tower_base_modulate


func _calculate_tower_base_modulate():
	var lowest_mod_a : float = 1.0
	var total_r : float
	var total_g : float
	var total_b : float
	
	for mod in all_id_to_tower_base_modulate.values():
		if mod.a < lowest_mod_a:
			lowest_mod_a = mod.a
		
		total_r += mod.r
		total_g += mod.g
		total_b += mod.b
	
	var total_mod_count : int = all_id_to_tower_base_modulate.size()
	
	if total_mod_count == 0:
		last_calculated_tower_base_modulate = Color(1, 1, 1, 1)
	else:
		last_calculated_tower_base_modulate = Color(total_r / total_mod_count, total_g / total_mod_count, total_b / total_mod_count, lowest_mod_a)





# Combination related

func add_combination_effect(combi_effect : CombinationEffect):
	if !all_combinations_id_to_effect_id_map.has(combi_effect.combination_id):
		
		all_combinations_id_to_effect_id_map[combi_effect.combination_id] = combi_effect.ingredient_effect.tower_base_effect.effect_uuid
		
		if (has_tower_effect_uuid_in_buff_map(combi_effect.ingredient_effect.tower_base_effect.effect_uuid)):
			remove_ingredient(combi_effect.ingredient_effect)
		
		add_tower_effect(combi_effect.ingredient_effect.tower_base_effect, all_attack_modules, true, true, combi_effect.ingredient_effect)
		#add_tower_effect(combi_effect.ingredient_effect.tower_base_effect, all_attack_modules, true, true, null)


func remove_combination_effect_id(combi_effect_id : int):
	if all_combinations_id_to_effect_id_map.has(combi_effect_id):
		
		var effect_id : int = all_combinations_id_to_effect_id_map[combi_effect_id]
		all_combinations_id_to_effect_id_map.erase(combi_effect_id)
		
		var effect = get_tower_effect(effect_id)
		if effect != null:
			remove_tower_effect(effect)
		


# Disabled from attacking clauses

func set_disabled_from_attacking_clause(id : int):
	disabled_from_attacking_clauses.attempt_insert_clause(id)

func erase_disabled_from_attacking_clause(id : int):
	disabled_from_attacking_clauses.remove_clause(id)

func _disabled_from_attacking_clause_added_or_removed(id):
	_update_last_calculated_disabled_from_attacking()


func _update_last_calculated_disabled_from_attacking():
	last_calculated_disabled_from_attacking = !disabled_from_attacking_clauses.is_passed_clauses()
	emit_signal("on_last_calculated_disabled_from_attacking_changed", last_calculated_disabled_from_attacking)

# Untargetability Clauses

func set_untargetability_clause(id : int):
	untargetability_clauses.attempt_insert_clause(id)

func erase_untargetability_clause(id : int):
	untargetability_clauses.remove_clause(id)

func _untargetability_clause_added_or_removed(id):
	_update_untargetability_state()


func _update_untargetability_state():
	last_calculated_is_untargetable = !untargetability_clauses.is_passed

func is_untargetable_only_from_invisibility():
	return untargetability_clauses.has_clause(UntargetabilityClauses.IS_INVISIBLE) and untargetability_clauses._clauses.size() == 1

# Contributing to synergy Clauses

func add_contributing_to_synergy_clause(id : int):
	contributing_to_synergy_clauses.attempt_insert_clause(id)

func erase_contributing_to_synergy_clause(id : int):
	contributing_to_synergy_clauses.remove_clause(id)


func _contributing_to_synergy_clause_added_or_removed(id):
	_update_last_calculated_contributing_to_synergy()

func _update_last_calculated_contributing_to_synergy():
	last_calculated_is_contributing_to_synergy = contributing_to_synergy_clauses.is_passed
	#emit_signal("tower_can_contribute_to_synergy_changed", last_calculated_is_contributing_to_synergy)
	if last_calculated_is_contributing_to_synergy:
		emit_signal("tower_active_in_map")
	else:
		emit_signal("tower_not_in_active_map")

# Tracking of towers related

func is_current_placable_in_map() -> bool:
	return current_placable is InMapAreaPlacable

func _on_ClickableArea_mouse_entered():
	is_being_hovered_by_mouse = true

func _on_ClickableArea_mouse_exited():
	is_being_hovered_by_mouse = false


func queue_free():
	#is_contributing_to_synergy = false
	contributing_to_synergy_clauses.attempt_insert_clause(ContributingToSynergyClauses.IN_QUEUE_FREE)
	current_placable.tower_occupying = null
	
	# ORDER CHANGED FROM bottom to top (see commented code)
	.queue_free()
	for module in all_attack_modules:
		module.queue_free()
	
	emit_signal("tower_in_queue_free", self) # synergy updated from tower manager
	
	
	#.queue_free()


func _physics_process(delta):
	if global_position != old_global_position:
		emit_signal("global_position_changed", old_global_position, global_position)
		
	old_global_position = global_position
	
	_phy_knock_up_process(delta)


func _phy_knock_up_process(delta):
	if _knock_up_current_acceleration != 0:
		knock_up_layer.position.y -= _knock_up_current_acceleration * delta
		_knock_up_current_acceleration -= _knock_up_current_acceleration_deceleration * delta
		
		if knock_up_layer.position.y >= 0:
			_knock_up_current_acceleration = 0
			_knock_up_current_acceleration_deceleration = 0
			knock_up_layer.position.y = 0


# Synergy related

func set_contribute_to_synergy_color_count(arg_val):
	can_contribute_to_synergy_color_count = arg_val
	
	emit_signal("on_is_contributing_to_synergy_color_count_changed", arg_val)
	#emit_signal()


# Detecting tower interacting stuffs

func _on_AbstractTower_body_entered(body):
	if is_current_placable_in_map():
		if body is BaseTowerDetectingBullet:
			body.hit_by_tower(self)
			body.decrease_pierce(1)
			
		elif body is BaseBullet:
			body.hit_by_tower(self)



# Health related

func _calculate_max_health() -> float:
	var max_health = base_health
	for effect in percent_base_health_id_effect_map.values():
		max_health += effect.attribute_as_modifier.get_modification_to_value(base_health)
	
	for effect in flat_base_health_id_effect_map.values():
		max_health += effect.attribute_as_modifier.flat_modifier
	
	last_calculated_max_health = max_health
	_emit_max_health_changed()
	if current_health > last_calculated_max_health:
		current_health = last_calculated_max_health
		_emit_current_health_changed()
	
	return max_health


func take_damage(damage_mod, enemy_source = null):
	var amount : float = _get_amount_from_arg(damage_mod)
	
	if last_calculated_is_invulnerable:
		_remove_count_from_single_invulnerability_effect()
		amount = 0
	
	if amount > 0:
		_set_health(current_health - amount)
	
	if enemy_source != null and amount > 0:
		emit_signal("on_taken_damage_from_enemy", enemy_source, amount)

func _get_amount_from_arg(val):
	var amount : float = 0
	
	if typeof(val) == TYPE_REAL:
		amount = val
	elif val is FlatModifier:
		amount = val.flat_modifier
	elif val is PercentModifier:
		if val.percent_based_on == PercentType.MAX:
			amount = val.get_modification_to_value(last_calculated_max_health)
		elif val.percent_based_on == PercentType.BASE:
			amount = val.get_modification_to_value(base_health)
		elif val.percent_based_on == PercentType.CURRENT:
			amount = val.get_modification_to_value(current_health)
		elif val.percent_based_on == PercentType.MISSING:
			amount = val.get_modification_to_value(last_calculated_max_health - current_health)
	
	return amount


func _set_health(val : float):
	current_health = val
	
	if current_health <= 0:
		current_health = 0
		set_disabled_from_attacking_clause(DisabledFromAttackingSourceClauses.TOWER_NO_HEALTH)
		set_untargetability_clause(UntargetabilityClauses.TOWER_NO_HEALTH)
		
		is_dead_for_the_round = true
		
		life_bar.visible = true
		_emit_tower_no_health()
		
	else:
		if current_health > last_calculated_max_health:
			current_health = last_calculated_max_health
		
		erase_disabled_from_attacking_clause(DisabledFromAttackingSourceClauses.TOWER_NO_HEALTH)
		erase_untargetability_clause(UntargetabilityClauses.TOWER_NO_HEALTH)
		
		is_dead_for_the_round = false
		
		life_bar.visible = current_health < last_calculated_max_health
		#life_bar.visible = true
	
	_emit_current_health_changed()


# heal arg can be float, or modi
func heal_by_amount(heal, revive_tower_if_dead : bool = false):
	if !is_dead_for_the_round or revive_tower_if_dead:
		var amount : float = _get_amount_from_arg(heal)
		
		if amount > 0:
			_set_health(current_health + amount)



func _heal_by_omnivamp_stat(dmg_type_damage_map : Dictionary):
	if last_calculated_flat_omnivamp != 0 or last_calculated_percent_damage_omnivamp != 0:
		var total_dmg = 0
		for dmg in dmg_type_damage_map.values():
			total_dmg += dmg
		
		var final_heal : float = 0
		
		final_heal += last_calculated_flat_omnivamp
		final_heal += (last_calculated_percent_damage_omnivamp / 100) * total_dmg
		
		heal_by_amount(final_heal)

# health queries

func has_full_health() -> bool:
	return is_equal_approx(last_calculated_max_health, current_health)

# Effect shield related

func _add_effect_shield_effect(effect : TowerEffectShieldEffect):
	effect_shield_effect_map[effect.effect_uuid] = effect
	calculate_final_has_effect_shield()

func _remove_effect_shield_effect(effect : TowerEffectShieldEffect):
	effect_shield_effect_map.erase(effect.effect_uuid)
	calculate_final_has_effect_shield()

func _remove_count_from_single_effect_shield_effect(arg_count_reduction : int = 1, reduce_shields_against_enemies : bool = false, reduce_shields_against_towers : bool = true):
	var count_reduc_remaining : int = arg_count_reduction
	var effects_to_remove : Array = []
	
	for effect in effect_shield_effect_map.values():
		if effect.is_countbound:
			if (effect.blocks_tower_effects and reduce_shields_against_towers) or (effect.blocks_enemy_effects and reduce_shields_against_enemies):
				var original_count = effect.count
				
				effect.count -= count_reduc_remaining
				count_reduc_remaining -= original_count
				
				if effect.count <= 0:
					count_reduc_remaining -= effect.count
					effects_to_remove.append(effect)
				
				if count_reduc_remaining <= 0:
					break
	
	for effect in effects_to_remove:
		remove_tower_effect(effect)


func calculate_final_has_effect_shield():
	last_calculated_has_effect_shield_against_enemies = false
	last_calculated_has_effect_shield_against_towers = false
	
	for effect in effect_shield_effect_map.values():
		if effect.blocks_tower_effects:
			last_calculated_has_effect_shield_against_towers = true
		elif effect.blocks_enemy_effects:
			last_calculated_has_effect_shield_against_enemies = true


# Damage tracking related

func _on_post_mitigated_dmg_dealt_from_effect(damage_instance_report, is_lethal, enemy, effect):
	_on_tower_any_post_mitigation_damage_dealt(damage_instance_report, is_lethal, enemy, -1, null)


func _on_tower_any_post_mitigation_damage_dealt(damage_instance_report, _killed, _enemy, _damage_register_id, _module):
	var dmg_type_damage_map : Dictionary = damage_instance_report.get_total_effective_damages_by_type()
	
	_heal_by_omnivamp_stat(dmg_type_damage_map)
	
	for dmg_type in dmg_type_damage_map.keys():
		var dmg = dmg_type_damage_map[dmg_type]
		if dmg_type == DamageType.ELEMENTAL:
			in_round_elemental_damage_dealt += dmg
			if _module != null:
				_module.in_round_elemental_damage_dealt += dmg
			
		elif dmg_type == DamageType.PHYSICAL:
			in_round_physical_damage_dealt += dmg
			if _module != null:
				_module.in_round_physical_damage_dealt += dmg
			
		elif dmg_type == DamageType.PURE:
			in_round_pure_damage_dealt += dmg
			if _module != null:
				_module.in_round_pure_damage_dealt += dmg
			
		
		in_round_total_damage_dealt += dmg
		if _module != null:
			_module.in_round_total_damage_dealt += dmg
	
	
	emit_signal("on_per_round_total_damage_changed", in_round_total_damage_dealt)


# Tower Infobar related

func add_infobar_control(control : Control, index = info_bar_vbox_container.get_child_count()):
	info_bar_vbox_container.add_child(control)
	
	info_bar_vbox_container.move_child(control, index)


# Direcion related

func is_enemy_facing_self(arg_enemy, arg_half_fov_angle : float = 90.0): # fov values range from 0 to 180, 180 always returns true.
	var angle = rad2deg(_get_rotation_to_meet_angle_fov(arg_enemy.global_position, global_position, arg_enemy.current_rad_angle_of_movement, deg2rad(180)))
	
	if angle > 0:
		return angle <= arg_half_fov_angle
	else:
		return angle <= -arg_half_fov_angle


func _get_rotation_to_meet_angle_fov(arg_bullet_pos, arg_enemy_pos, arg_current_angle, arg_max_rot_per_sec) -> float:
	var angle_to_enemy = arg_bullet_pos.angle_to_point(arg_enemy_pos)
	
	var steer_angle : float = 0
	
	angle_to_enemy = _conv_angle_to_positive_val(angle_to_enemy)
	arg_current_angle = _conv_angle_to_positive_val(arg_current_angle)
	
	
	var rotation_per_sec = arg_max_rot_per_sec
	
	if angle_to_enemy > arg_current_angle:
		if abs(arg_current_angle - angle_to_enemy) > PI:
			steer_angle = rotation_per_sec * 1
		else:
			steer_angle = rotation_per_sec * -1
		
	elif angle_to_enemy <= arg_current_angle:
		
		if abs(arg_current_angle - angle_to_enemy) > PI:
			steer_angle = rotation_per_sec * -1
		else:
			steer_angle = rotation_per_sec * 1
		
	
	if steer_angle > abs(angle_to_enemy - arg_current_angle):
		steer_angle = abs(angle_to_enemy - arg_current_angle)
		
	elif steer_angle > -abs(angle_to_enemy - arg_current_angle):
		steer_angle = PI - abs(angle_to_enemy - arg_current_angle)
		
	elif steer_angle < -abs(angle_to_enemy - arg_current_angle):
		steer_angle = abs(angle_to_enemy - arg_current_angle) - PI
		
	
	return steer_angle

#func is_enemy_facing_self(arg_enemy, arg_angle_deviation : float = 90.0):
#	var angle = rad2deg(_get_shortest_angle_to_point(arg_enemy.global_position, arg_enemy)) 
#
#	print(angle)
#	print("----------")
#
#	return angle <= arg_angle_deviation

#func _get_shortest_angle_to_point(arg_enemy_pos, arg_enemy) -> float:
#	var angle_of_enemy_to_self = arg_enemy_pos.angle_to_point(global_position)
#
#	angle_of_enemy_to_self = _conv_angle_to_positive_val(angle_of_enemy_to_self)
#	var curr_angle_of_enemy = _conv_angle_to_positive_val(arg_enemy.current_rad_angle_of_movement)
#
#	if angle_of_enemy_to_self > curr_angle_of_enemy:
#		var diff = angle_of_enemy_to_self - curr_angle_of_enemy
#
#		if abs(curr_angle_of_enemy - angle_of_enemy_to_self) >= PI:
#			#steer_angle = delta * rotation_per_sec * 1
#			#return abs(PI - abs(curr_angle_of_enemy - angle_of_enemy_to_self))
#			return abs(curr_angle_of_enemy - angle_of_enemy_to_self)
#		else:
#			#steer_angle = delta * rotation_per_sec * -1
#			return abs(curr_angle_of_enemy - angle_of_enemy_to_self)
#			#return abs(PI - abs(curr_angle_of_enemy - angle_of_enemy_to_self))
#
#	elif angle_of_enemy_to_self <= curr_angle_of_enemy:
#		var diff = curr_angle_of_enemy - angle_of_enemy_to_self
#
#		if abs(curr_angle_of_enemy - angle_of_enemy_to_self) >= PI:
#			#steer_angle = delta * rotation_per_sec * -1
#			return abs(PI - abs(curr_angle_of_enemy - angle_of_enemy_to_self))
#		else:
#			#steer_angle = delta * rotation_per_sec * 1
#			return abs(curr_angle_of_enemy - angle_of_enemy_to_self)
#
#	else:
#		return PI * 2
#


func _conv_angle_to_positive_val(arg_angle):
	if arg_angle < 0:
		return (2*PI) + arg_angle
	else:
		if arg_angle < 2 * PI:
			return arg_angle
		else:
			return arg_angle - (2 * PI)


######### TOWER animations related

#func _on_main_attack__for_face_direction_updates(attk_speed_delay, enemies, module):
#	if enemies.size() > 0:
#		_change_animation_to_face_position(enemies[0].global_position)

func _on_main_attk_module__commanded_to_attack_enemies_or_poses(arg_enemies_or_poses, module):
	if arg_enemies_or_poses.size() > 0:
		var ent = arg_enemies_or_poses[0]
		if ent is Vector2:
			_change_animation_to_face_position(ent)
		else:
			_change_animation_to_face_position(ent.global_position)


func _change_animation_to_face_position(arg_position, pos_basis = global_position):
	var angle = pos_basis.angle_to_point(arg_position)
	_change_animation_to_face_angle(angle)

func _change_animation_to_face_angle(arg_angle):
	var anim_name = anim_face_dir_component.get_anim_name_to_use_based_on_angle(arg_angle)
	anim_face_dir_component.set_animation_sprite_animation_using_anim_name(tower_base_sprites, anim_name)



####### Particle related

func _display_absorbed_ingredient_effects(arg_tier_of_ing : int): 
	if absorb_ing_particle_pool_component == null:
		_initialize_absorb_ing_particle_pool_component()
	
	var max_i = 3 #default
	
	if ing_tier_to_amount_of_particles_map.has(arg_tier_of_ing):
		max_i = ing_tier_to_amount_of_particles_map[arg_tier_of_ing]
	else:
		max_i = 3
		arg_tier_of_ing = 1
	
	for i in max_i:
		var particle = absorb_ing_particle_pool_component.get_or_create_attack_sprite_from_pool()
		particle.center_pos_of_basis = global_position
		particle.tier = arg_tier_of_ing
		particle.particle_i_val = i
		particle.particle_max_i_val = max_i
		particle.lifetime = 0.6
		
		particle.visible = true
		particle.reset_for_another_use__absorb_ing_specific()
		particle.reset_for_another_use()
	

func _initialize_absorb_ing_particle_pool_component():
	absorb_ing_particle_pool_component = AttackSpritePoolComponent.new()
	absorb_ing_particle_pool_component.node_to_parent_attack_sprites = get_tree().get_root()
	absorb_ing_particle_pool_component.node_to_listen_for_queue_free = self
	absorb_ing_particle_pool_component.source_for_funcs_for_attk_sprite = self
	absorb_ing_particle_pool_component.func_name_for_creating_attack_sprite = "_create_abosrb_ing_particle"
	absorb_ing_particle_pool_component.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_absorb_ing_particle_properties_when_get_from_pool_after_add_child"


func _create_abosrb_ing_particle():
	var particle = AbsorbIngParticle_Scene.instance()
	particle.speed_accel_towards_center = 450
	particle.initial_speed_towards_center = -100
	
	particle.min_starting_distance_from_center = 35
	particle.max_starting_distance_from_center = 35
	
	particle.queue_free_at_end_of_lifetime = false
	
	return particle

func _set_absorb_ing_particle_properties_when_get_from_pool_after_add_child(arg_particle):
	pass


# SYNERGIES RELATED -----------------------------------------
# YELLOW - energy module related

func set_energy_module(module):
	if energy_module != null:
		energy_module.tower_connected_to = null
		energy_module.module_effect_descriptions = []
		
		call_deferred("emit_signal", "energy_module_detached")
		energy_module.disconnect("module_turned_on", self, "_module_turned_on")
		energy_module.disconnect("module_turned_off", self, "_module_turned_off")
	
	energy_module = module
	
	if module != null:
		energy_module.tower_connected_to = self
		call_deferred("emit_signal", "energy_module_attached")
		energy_module.connect("module_turned_on", self, "_module_turned_on")
		energy_module.connect("module_turned_off", self, "_module_turned_off")


func _module_turned_on(_first_time_per_round : bool):
	pass

func _module_turned_off():
	pass


# ORANGE - heat module

func set_heat_module(arg_heat_module):
	if base_heat_effect == null:
		_construct_heat_effect()
	
	# this is just here for future purposes. Although
	# right now setting the tower's heat module
	# to null is never used yet.
	if heat_module != null:
		heat_module.tower = null
	
		if heat_module.is_connected("should_be_shown_in_info_panel_changed", self, "_emit_heat_module_should_change_visibility"):
			heat_module.disconnect("should_be_shown_in_info_panel_changed", self, "_emit_heat_module_should_change_visibility")
			heat_module.disconnect("current_heat_effect_changed", self, "_heat_module_current_heat_effect_changed")
			heat_module.disconnect("on_overheat_reached", self, "_emit_heat_module_overheat")
			heat_module.disconnect("in_overheat_cooldown", self, "_emit_heat_module_overheat_cooldown")
		
		#if tower_heat_module_bar != null:
		#	tower_heat_module_bar.queue_free()
	
	heat_module = arg_heat_module
	
	if heat_module != null:
		heat_module.base_heat_effect = base_heat_effect
		heat_module.tower = self
		
		if !heat_module.is_connected("should_be_shown_in_info_panel_changed", self, "_emit_heat_module_should_change_visibility"):
			heat_module.connect("should_be_shown_in_info_panel_changed", self, "_emit_heat_module_should_change_visibility", [], CONNECT_PERSIST)
			heat_module.connect("current_heat_effect_changed", self, "_heat_module_current_heat_effect_changed", [], CONNECT_PERSIST)
			heat_module.connect("on_overheat_reached", self, "_emit_heat_module_overheat", [], CONNECT_PERSIST)
			heat_module.connect("in_overheat_cooldown", self, "_emit_heat_module_overheat_cooldown", [], CONNECT_PERSIST)
		
		if tower_heat_module_bar == null:
			tower_heat_module_bar = TowerHeatModuleBar_Scene.instance()
			tower_heat_module_bar.heat_module = heat_module
			
			add_infobar_control(tower_heat_module_bar)


func _construct_heat_effect():
	pass

func _emit_heat_module_should_change_visibility():
	emit_signal("heat_module_should_be_displayed_changed")

func _heat_module_current_heat_effect_changed():
	pass

func _emit_heat_module_overheat():
	emit_signal("on_heat_module_overheat")

func _emit_heat_module_overheat_cooldown():
	emit_signal("on_heat_module_overheat_cooldown")

