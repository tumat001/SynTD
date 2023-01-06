extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")
const Hero_VOLEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/Hero_VOLEffect.gd")
const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")

const Hero_LevelUpParticle_Scene = preload("res://TowerRelated/Color_White/Hero/Hero_OtherAssets/Hero_LevelUpParticle.tscn")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const ShowTowersWithParticleComponent = preload("res://MiscRelated/CommonComponents/ShowTowersWithParticleComponent.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")

const HeroAttk_NormalPic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_Normal.png")
const HeroAttk_LightWavePic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_LightWave.png")
const HeroAttk_LightBlast01Pic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_LightExplosion01.png")
const HeroAttk_LightBlast02Pic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_LightExplosion02.png")
const HeroAttk_LightBlast03Pic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_LightExplosion03.png")
const HeroAttk_LightBlast04Pic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_LightExplosion04.png")
const HeroAttk_LightBlast05Pic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_LightExplosion05.png")
const HeroAttk_LightBlast06Pic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_LightExplosion06.png")
const HeroAttk_LightBlast07Pic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_LightExplosion07.png")
const HeroAttk_LightBlast08Pic = preload("res://TowerRelated/Color_White/Hero/HeroAttks/HeroAttk_LightExplosion08.png")
const Judgement_AttkSprite = preload("res://TowerRelated/Color_White/Hero/HeroAttks/JudgementAttkSprite.tscn")
const VOL_BlessSprite = preload("res://TowerRelated/Color_White/Hero/HeroAttks/VOL_BlessParticle/VOL_BlessParticle.tscn")

const Hero_BaseStaffPic = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_BaseStaff.png")
const Hero_StaffPic01 = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_LightWave01Staff.png")
const Hero_StaffPic02 = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_LightWave02Staff.png")
const Hero_StaffPic03 = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_LightWave03Staff.png")
const Hero_StaffPic04 = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_LightWave04Staff.png")

const Hero_Judgement01Pic = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_Judgement01.png")
const Hero_Judgement02Pic = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_Judgement02.png")
const Hero_Judgement03Pic = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_Judgement03.png")
const Hero_Judgement04Pic = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_Judgement04.png")

const Hero_VOLRobe01Pic = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_VOLRobe01.png")
const Hero_VOLRobe02Pic = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_VOLRobe02.png")
const Hero_VOLRobe03Pic = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_VOLRobe03.png")
const Hero_VOLRobe04Pic = preload("res://TowerRelated/Color_White/Hero/HeroWeapons_Assets/Hero_VOLRobe04.png")

const Hero_VOL_StatusBarIcon = preload("res://TowerRelated/Color_White/Hero/Hero_OtherAssets/VOL_StatusBarIcon.png")
const Hero_LevelUp_StatusBarIcon = preload("res://TowerRelated/Color_White/Hero/Hero_OtherAssets/Hero_LevelUp_StatusBarIcon.png")

const LightWave_AttackModuleIcon = preload("res://TowerRelated/Color_White/Hero/AttackModuleAssets/LightWave_AttackModuleIcon.png")
const Judgement_AttackModuleIcon = preload("res://TowerRelated/Color_White/Hero/AttackModuleAssets/Judgement_AttackModuleIcon.png")
const LightExplosion_AttackModuleIcon = preload("res://TowerRelated/Color_White/Hero/AttackModuleAssets/LightExplosion_AttackModuleIcon.png")

const Hero_PopupGUI_LevelUp_Scene = preload("res://TowerRelated/Color_White/Hero/PopupGUI_LevelUp/Hero_PopupGUI_LevelUp.tscn")
const Hero_PopupGUI_LevelUp = preload("res://TowerRelated/Color_White/Hero/PopupGUI_LevelUp/Hero_PopupGUI_LevelUp.gd")

const RelicStoreOfferOption = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Classes/RelicStoreOfferOption.gd")
const Hero_IncreaseLevels_Normal_Pic = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Assets/Buttons/Hero_IncreaseLevels_Normal.png")
const Hero_IncreaseLevels_Highlighted_Pic = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Assets/Buttons/Hero_IncreaseLevels_Highlighted.png")


signal current_xp_changed(gained_amount, curr_xp)
signal xp_needed_for_next_level_changed(new_req)
signal max_level_reached()
signal current_spendables_changed(curr_spendables)
signal hero_level_changed(new_level)
signal white_is_dom_state_changed()

signal light_waves_level_changed(new_level)
signal judgement_level_changed(new_level)
signal vol_level_changed(new_level)

signal can_spend_gold_and_xp_for_level_up_updated(val)
signal can_spend_relics_for_level_up_updated(val)

signal notify_xp_cap_of_level_reached()


const hero_base_health : float = 25.0
const extra_comp_syn_slot_amount_at_max_natural_level : int = 1

const hero_max_extra_ingredient_limit : int = 4
const hero_extra_ing_limit_per_level_up : int = 1
var hero_current_extra_ingredient_limit : int

const hero_max_nat_level_bonus_base_damage_amount : float = 1.5
const hero_max_nat_level_bonus_attk_speed_amount : float = 40.0
const hero_max_nat_level_bonus_ability_potency : float = 0.5

const xp_ratio_per_damage : float = 1.0
const xp_per_kill : float = 2.0
#const xp_scale_on_boss_enemy : float = 2.0
const xp_scale_if_not_white_dom_color : float = 0.7
const max_hero_level : int = 6 # max hero natural level
const max_hero_boosted_level : int = 12 # including lvl up from relics

const xp_needed_per_level : Array = [97, 394, 1162, 2175, 2475, 2625] #[130, 525, 1550, 2900, 3300, 3500]
const gold_needed_per_level : Array = [2, 4, 7, 9, 9, 10]

const xp_about_descriptions = [
	"Hero gains EXP from damaging enemies, killing enemies, and casting Voice of Light.",
	"Hero gains EXP equal to the post-mitigated damage dealt to enemies.",
	"Hero gains %s EXP from a kill." % [str(xp_per_kill)],
	#"EXP gain from attacks and kills is multiplied by %s against boss enemies" % [(str(xp_scale_on_boss_enemy) + "x")],
	"Hero gains EXP from casting Voice of Light. The amount depends on this ability's level.",
	"",
	"There is no EXP limit for Hero. Hero can only gain %s levels from gold and EXP." % str(max_hero_level),
	"Only %s of exp is earned when White is not the dominant color." % [(str(xp_scale_if_not_white_dom_color * 100) + "%")]
]


const main_attack_proj_speed : float = 675.0 #500.0
const attks_needed_for_light_wave_in_levels : Array = [3, 2, 2, 1]
const attks_needed_for_light_explosion : int = 35
const light_wave_base_damage_in_levels : Array = [1.5, 1.5, 2, 3.5]
const light_explosion_dmg_ratio_in_levels : Array = [0, 0, 0.4, 0.9]
const light_explosion_pierce : int = 8

const judgement_dmg_ratio_in_levels : Array = [0.5, 1, 2, 4]
const judgement_bonus_on_hit_dmg_in_levels : Array = [1, 1.5, 2.5, 6.5]
var judgement_bonus_on_hit_dmg_dmg_type : int = DamageType.PHYSICAL

const judgement_bonus_dmg_ratio : float = 1.20
const judgement_bonus_dmg_threshold_trigger : float = 0.35
const judgement_stack_trigger : int = 3

const current_attks_needed_for_vol : int = 8
const VOL_towers_affected_in_levels : Array = [3, 4, 6, 13]
const VOL_range_in_levels : Array = [70, 105, 160, 250]
const VOL_dmg_ratio_buff_in_levels : Array = [1.3, 1.4, 1.5, 2.0]
const VOL_buff_attack_count_in_levels : Array = [3, 3, 4, 12]
const VOL_xp_gain_per_tower_affected_in_levels : Array = [5, 7, 8, 16]
#const VOL_hero_on_hit_effect_scale : Array = [1.1, 1.2, 1.3, 1.5]

var white_dom_active : bool

var current_hero_xp : float = 0  #current_xp   #current_exp   #left these text for ctrl F purposes
var current_hero_natural_level : int = 0
var current_hero_effective_level : int = 0
var current_spendables : int = 0

var ability_VOL_level : int = 0 setget set_vol_level
var ability_light_waves_level : int = 0 setget set_light_waves_level
var ability_judgement_level : int = 0 setget set_judgement_level

var basic_attack_module : BulletAttackModule
var judgement_attack_module : InstantDamageAttackModule
var judgement_effect_adder : TowerOnHitEffectAdderEffect

var lightwave_attack_module : BulletAttackModule
var lightexplosion_attack_module : AOEAttackModule
var VOL_range_module : TowerDetectingRangeModule
var VOL_effect : Hero_VOLEffect
var VOL_ability : BaseAbility

var current_attack_count_in_round : int = 0

var current_attks_needed_for_light_wave : int
var current_attk_count_for_light_wave : int
var current_light_explosion_dmg_ratio : float
var current_light_wave_base_damage : float

var current_attk_count_for_vol : int
var current_towers_affected_by_vol : int
var current_xp_per_tower_affected_by_vol : int

var current_vol_damage_scale : float
var current_vol_count : int
var current_hero_on_hit_effect_scale : float

var current_judgement_dmg_ratio : float
var current_judgement_bonus_on_hit_amount : float
var judgment_on_hit_dmg : OnHitDamage

#

var vol_candidate_tower_indicator_shower : ShowTowersWithParticleComponent


# level particle related

var non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
var particle_timer : Timer

const total_particle_count_per_show : int = 15
const delay_per_particle : float = 0.2
var _current_particle_showing_count : int = 0

#

var notify_xp_cap_of_level_reached : bool = false

#

var _can_spend_relic_for_level_up__for_popup_gui : bool
var _can_spend_gold_for_level_up__for_popup_gui : bool
var popup_gui : Hero_PopupGUI_LevelUp

## relic offer related

var hero_level_up_with_relic_shop_offer_id : int = -1 #initually unavailable


# gui reservation

var reservation_for_whole_screen_gui #: AdvancedQueue.Reservation

#

onready var staff_proj_origin_pos2D : Position2D = $TowerBase/KnockUpLayer/StaffProjPosition
onready var staff_sprite : Sprite = $TowerBase/KnockUpLayer/StaffSprite
onready var judgement_sprite : Sprite = $TowerBase/KnockUpLayer/JudgementSprite
onready var volrobe_sprite : Sprite = $TowerBase/KnockUpLayer/VOLRobeSprite
onready var max_nat_level_wings_sprite = $TowerBase/KnockUpLayer/MaxNatLevelWingsSprite

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.HERO)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	base_health = hero_base_health
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position -= staff_proj_origin_pos2D.position
	
	# Normal main attack
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = main_attack_proj_speed
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position += staff_proj_origin_pos2D.position
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(HeroAttk_NormalPic)
	
	basic_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	#
	connect("on_any_post_mitigation_damage_dealt", self, "_any_post_mitigation_dmg_dealt_h", [], CONNECT_PERSIST)
	connect("on_main_attack", self, "_on_main_attack_h", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_h", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_on_round_start_h", [], CONNECT_PERSIST)
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_h", [], CONNECT_PERSIST)
	connect("on_any_attack_module_enemy_hit", self, "_on_any_attack_hit_h", [], CONNECT_PERSIST)
	
	connect("can_spend_relics_for_level_up_updated", self, "_can_spend_relics_for_level_up_updated", [], CONNECT_PERSIST)
	connect("can_spend_gold_and_xp_for_level_up_updated", self, "_can_spend_gold_and_xp_for_level_up_updated", [], CONNECT_PERSIST)
	connect("on_tower_transfered_to_placable", self , "_on_transfer_to_placable_h", [], CONNECT_PERSIST)
	
	game_elements.synergy_manager.connect("synergies_updated", self, "_update_if_white_dom_active", [], CONNECT_PERSIST)
	game_elements.gold_manager.connect("current_gold_changed", self, "_gold_manager_gold_changed", [], CONNECT_PERSIST)
	game_elements.relic_manager.connect("current_relic_count_changed", self, "_relic_manager_relic_count_changed", [], CONNECT_PERSIST)
	
	#
	set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.HERO, 0)
	
	judgement_sprite.visible = false
	volrobe_sprite.visible = false
	max_nat_level_wings_sprite.visible = false
	
	#current_hero_on_hit_effect_scale = 1
	
	_construct_vol_tower_indicator_shower()
	_initialize_queue_reservation()
	
	_post_inherit_ready()

#

func _construct_vol_tower_indicator_shower():
	vol_candidate_tower_indicator_shower = ShowTowersWithParticleComponent.new()
	vol_candidate_tower_indicator_shower.set_tower_particle_indicator_to_usual_properties()
	vol_candidate_tower_indicator_shower.set_source_and_provider_func_name(self, "_get_vol_target_towers")

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	#reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	#reservation_for_whole_screen_gui.on_removed_method
	

# Xp gain

func _any_post_mitigation_dmg_dealt_h(damage_instance_report, killed, enemy, damage_register_id, module):
	var effective_dmg = damage_instance_report.get_total_effective_damage()
	
	var additional_scale : float = 1.0
	
	#if enemy.is_enemy_type_boss():
	#	additional_scale *= xp_scale_on_boss_enemy
	
	_increase_exp(effective_dmg * xp_ratio_per_damage * additional_scale)
	if killed:
		_increase_exp(xp_per_kill * additional_scale)


# Random essential things

func _can_accept_ingredient_color(tower_selected) -> bool:
	return true


func _on_round_end_h():
	current_attack_count_in_round = 0
	current_attk_count_for_light_wave = current_attks_needed_for_light_wave
	
	current_attk_count_for_vol = current_attks_needed_for_vol
	
	call_deferred("_on_round_end__relic_gui_related")

func _on_main_attack_h(attk_speed_delay, enemies, module):
	current_attack_count_in_round += 1
	current_attk_count_for_light_wave -= 1
	current_attk_count_for_vol -= 1
	
	if white_dom_active:
		if ability_light_waves_level >= 1 and current_attk_count_for_light_wave <= 0:
			if enemies.size() > 0:
				call_deferred("_summon_light_wave_to_enemy", enemies[0])
				current_attk_count_for_light_wave = current_attks_needed_for_light_wave
		
		if ability_VOL_level >= 1 and current_attk_count_for_vol <= 0:
			current_attk_count_for_vol = current_attks_needed_for_vol
			call_deferred("_cast_VOL")


func _on_main_attack_hit_h(enemy, damage_register_id, damage_instance, module):
	if white_dom_active:
		if ability_light_waves_level >= 3 and current_attack_count_in_round >= attks_needed_for_light_explosion:
			call_deferred("_summon_light_explosion_to_enemy", enemy, damage_instance.get_copy_damage_only_scaled_by(current_light_explosion_dmg_ratio))
		
		#if ability_VOL_level > 0:
		#	damage_instance.scale_only_on_hit_effect_by(current_hero_on_hit_effect_scale)


func _on_any_attack_hit_h(enemy, damage_register_id, damage_instance, module):
	if white_dom_active:
		if ability_judgement_level >= 1 and module.benefits_from_bonus_on_hit_effect:
			if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.HERO_JUDGEMENT_STACK):
				var effect = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.HERO_JUDGEMENT_STACK]
				
				if effect._current_stack >= judgement_stack_trigger - 1:
					judgement_attack_module.call_deferred("on_command_attack_enemies", [enemy])


# Light waves related

func _summon_light_wave_to_enemy(enemy):
	if is_instance_valid(enemy):
		var wave = lightwave_attack_module.construct_bullet(enemy.global_position)
		lightwave_attack_module.set_up_bullet__add_child_and_emit_signals(wave)

func _summon_light_explosion_to_enemy(enemy, damage_instance_copy):
	if is_instance_valid(enemy):
		var explosion = lightexplosion_attack_module.construct_aoe(enemy.global_position, enemy.global_position)
		explosion.damage_instance = damage_instance_copy
		explosion.damage_instance.on_hit_effects.clear()
		
		lightexplosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)


func _construct_and_add_light_waves_attack_module():
	lightwave_attack_module = BulletAttackModule_Scene.instance()
	lightwave_attack_module.base_damage = 0
	lightwave_attack_module.base_damage_type = DamageType.ELEMENTAL
	lightwave_attack_module.base_attack_speed = 0
	lightwave_attack_module.base_attack_wind_up = 0
	lightwave_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	lightwave_attack_module.is_main_attack = false
	lightwave_attack_module.base_pierce = 3
	lightwave_attack_module.base_proj_speed = main_attack_proj_speed
	lightwave_attack_module.base_proj_life_distance = basic_attack_module.range_module.base_range_radius
	lightwave_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	lightwave_attack_module.position += staff_proj_origin_pos2D.position
	
	lightwave_attack_module.benefits_from_bonus_on_hit_effect = false
	lightwave_attack_module.benefits_from_bonus_on_hit_damage = false
	lightwave_attack_module.benefits_from_bonus_base_damage = false
	lightwave_attack_module.benefits_from_bonus_attack_speed = false
	lightwave_attack_module.benefits_from_bonus_pierce = true
	lightwave_attack_module.benefits_from_bonus_proj_speed = true
	
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(6, 18)
	
	lightwave_attack_module.bullet_shape = bullet_shape
	lightwave_attack_module.bullet_scene = BaseBullet_Scene
	lightwave_attack_module.set_texture_as_sprite_frame(HeroAttk_LightWavePic)
	
	lightwave_attack_module.can_be_commanded_by_tower = false
	
	lightwave_attack_module.set_image_as_tracker_image(LightWave_AttackModuleIcon)
	
	add_attack_module(lightwave_attack_module)

func _construct_and_add_light_explosion_module():
	lightexplosion_attack_module = AOEAttackModule_Scene.instance()
	lightexplosion_attack_module.base_damage = 0
	lightexplosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	lightexplosion_attack_module.base_attack_speed = 0
	lightexplosion_attack_module.base_attack_wind_up = 0
	lightexplosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	lightexplosion_attack_module.is_main_attack = false
	lightexplosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	lightexplosion_attack_module.base_explosion_scale = 1.5
	
	lightexplosion_attack_module.benefits_from_bonus_explosion_scale = true
	lightexplosion_attack_module.benefits_from_bonus_base_damage = false
	lightexplosion_attack_module.benefits_from_bonus_attack_speed = false
	lightexplosion_attack_module.benefits_from_bonus_on_hit_damage = false
	lightexplosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", HeroAttk_LightBlast01Pic)
	sprite_frames.add_frame("default", HeroAttk_LightBlast02Pic)
	sprite_frames.add_frame("default", HeroAttk_LightBlast03Pic)
	sprite_frames.add_frame("default", HeroAttk_LightBlast04Pic)
	sprite_frames.add_frame("default", HeroAttk_LightBlast05Pic)
	sprite_frames.add_frame("default", HeroAttk_LightBlast06Pic)
	sprite_frames.add_frame("default", HeroAttk_LightBlast07Pic)
	sprite_frames.add_frame("default", HeroAttk_LightBlast08Pic)
	
	lightexplosion_attack_module.aoe_sprite_frames = sprite_frames
	lightexplosion_attack_module.sprite_frames_only_play_once = true
	lightexplosion_attack_module.pierce = light_explosion_pierce
	lightexplosion_attack_module.duration = 0.3
	lightexplosion_attack_module.damage_repeat_count = 1
	
	lightexplosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	lightexplosion_attack_module.base_aoe_scene = BaseAOE_Scene
	lightexplosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	lightexplosion_attack_module.can_be_commanded_by_tower = false
	
	lightexplosion_attack_module.set_image_as_tracker_image(LightExplosion_AttackModuleIcon)
	
	add_attack_module(lightexplosion_attack_module)


func can_level_up_light_waves():
	return ability_light_waves_level < 4 and current_spendables != 0

func level_up_light_waves():
	if can_level_up_light_waves():
		_increase_spendables(-1)
		set_light_waves_level(ability_light_waves_level + 1)

func set_light_waves_level(new_level):
	ability_light_waves_level = new_level
	
	if ability_light_waves_level == 1:
		if !is_instance_valid(lightwave_attack_module):
			_construct_and_add_light_waves_attack_module()
		lightwave_attack_module.base_damage = light_wave_base_damage_in_levels[0]
		current_attks_needed_for_light_wave = attks_needed_for_light_wave_in_levels[0]
		staff_sprite.texture = Hero_StaffPic01
		
	elif ability_light_waves_level == 2:
		lightwave_attack_module.base_damage = light_wave_base_damage_in_levels[1]
		current_attks_needed_for_light_wave = attks_needed_for_light_wave_in_levels[1]
		staff_sprite.texture = Hero_StaffPic02
		
	elif ability_light_waves_level == 3:
		lightwave_attack_module.base_damage = light_wave_base_damage_in_levels[2]
		current_attks_needed_for_light_wave = attks_needed_for_light_wave_in_levels[2]
		if !is_instance_valid(lightexplosion_attack_module):
			_construct_and_add_light_explosion_module()
		current_light_explosion_dmg_ratio = light_explosion_dmg_ratio_in_levels[2]
		staff_sprite.texture = Hero_StaffPic03
		
	elif ability_light_waves_level == 4:
		lightwave_attack_module.base_damage = light_wave_base_damage_in_levels[3]
		current_attks_needed_for_light_wave = attks_needed_for_light_wave_in_levels[3]
		current_light_explosion_dmg_ratio = light_explosion_dmg_ratio_in_levels[3]
		staff_sprite.texture = Hero_StaffPic04
		
	else:
		lightwave_attack_module.base_damage = 0
		current_attks_needed_for_light_wave = 10
		staff_sprite.texture = Hero_BaseStaffPic
	
	current_light_wave_base_damage = lightwave_attack_module.base_damage
	
	lightwave_attack_module.calculate_final_base_damage()
	
	emit_signal("light_waves_level_changed", ability_light_waves_level)


# Judgement related

func _construct_and_add_judgement_effect():
	var enemy_stack_effect = EnemyStackEffect.new(null, 1, judgement_stack_trigger, StoreOfEnemyEffectsUUID.HERO_JUDGEMENT_STACK, true, true)
	enemy_stack_effect.is_timebound = false
	#enemy_stack_effect.time_in_seconds = 5
	
	judgement_effect_adder = TowerOnHitEffectAdderEffect.new(enemy_stack_effect, StoreOfTowerEffectsUUID.HERO_JUDGEMENT_STACK_EFFECT)
	judgement_effect_adder.is_timebound = false
	
	add_tower_effect(judgement_effect_adder)

func _construct_and_add_judgement_attack_module():
	judgement_attack_module = InstantDamageAttackModule_Scene.instance()
	judgement_attack_module.base_damage = 0
	judgement_attack_module.base_damage_type = DamageType.PHYSICAL
	judgement_attack_module.base_attack_speed = 0
	judgement_attack_module.base_attack_wind_up = 0
	judgement_attack_module.is_main_attack = false
	judgement_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	judgement_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	
	judgement_attack_module.benefits_from_bonus_attack_speed = false
	judgement_attack_module.benefits_from_bonus_base_damage = false
	judgement_attack_module.benefits_from_bonus_on_hit_effect = false
	judgement_attack_module.benefits_from_bonus_on_hit_damage = true
	
	judgement_attack_module.attack_sprite_scene = Judgement_AttkSprite
	judgement_attack_module.attack_sprite_match_lifetime_to_windup = true
	judgement_attack_module.attack_sprite_show_in_windup = false
	judgement_attack_module.attack_sprite_show_in_attack = true
	
	judgement_attack_module.connect("on_enemy_hit", self, "_on_judgement_enemy_hit", [], CONNECT_PERSIST)
	
	judgement_attack_module.can_be_commanded_by_tower = false
	
	judgement_attack_module.set_image_as_tracker_image(Judgement_AttackModuleIcon)
	
	add_attack_module(judgement_attack_module)
	
	#
	var judgement_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HERO_JUDGEMENT_ON_HIT_DMG)
	
	judgment_on_hit_dmg = OnHitDamage.new(StoreOfTowerEffectsUUID.HERO_JUDGEMENT_ON_HIT_DMG, judgement_modi, judgement_bonus_on_hit_dmg_dmg_type)


func _on_judgement_enemy_hit(enemy, damage_register_id, damage_instance, module):
	if is_instance_valid(main_attack_module):
		var health_ratio : float = enemy.current_health / enemy._last_calculated_max_health
		
		var final_mod : float = current_judgement_dmg_ratio * main_attack_module.last_calculated_final_damage
		#if health_ratio < judgement_bonus_dmg_threshold_trigger:
		#	final_mod *= judgement_bonus_dmg_ratio
		
		damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE].damage_as_modifier.flat_modifier = final_mod
		damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.HERO_JUDGEMENT_ON_HIT_DMG] = judgment_on_hit_dmg
		
		if health_ratio < judgement_bonus_dmg_threshold_trigger:
			damage_instance.scale_only_damage_by(judgement_bonus_dmg_ratio)


func can_level_up_judgement():
	return ability_judgement_level < 4 and current_spendables != 0

func level_up_judgement():
	if can_level_up_judgement():
		_increase_spendables(-1)
		set_judgement_level(ability_judgement_level + 1)

func set_judgement_level(new_level):
	ability_judgement_level = new_level
	
	if ability_judgement_level == 1:
		if !is_instance_valid(judgement_attack_module):
			_construct_and_add_judgement_attack_module()
		if judgement_effect_adder == null:
			_construct_and_add_judgement_effect()
		
		current_judgement_dmg_ratio = judgement_dmg_ratio_in_levels[0]
		current_judgement_bonus_on_hit_amount = judgement_bonus_on_hit_dmg_in_levels[0]
		judgement_sprite.texture = Hero_Judgement01Pic
		judgement_sprite.visible = true
		
	elif ability_judgement_level == 2:
		current_judgement_dmg_ratio = judgement_dmg_ratio_in_levels[1]
		current_judgement_bonus_on_hit_amount = judgement_bonus_on_hit_dmg_in_levels[1]
		judgement_sprite.texture = Hero_Judgement02Pic
		judgement_sprite.visible = true
		
	elif ability_judgement_level == 3:
		current_judgement_dmg_ratio = judgement_dmg_ratio_in_levels[2]
		current_judgement_bonus_on_hit_amount = judgement_bonus_on_hit_dmg_in_levels[2]
		judgement_sprite.texture = Hero_Judgement03Pic
		judgement_sprite.visible = true
		
	elif ability_judgement_level == 4:
		current_judgement_dmg_ratio = judgement_dmg_ratio_in_levels[3]
		current_judgement_bonus_on_hit_amount = judgement_bonus_on_hit_dmg_in_levels[3]
		judgement_sprite.texture = Hero_Judgement04Pic
		judgement_sprite.visible = true
		
	else:
		current_judgement_dmg_ratio = 0
		current_judgement_bonus_on_hit_amount = 0
		judgement_sprite.visible = false
	
	judgment_on_hit_dmg.damage_as_modifier.flat_modifier = current_judgement_bonus_on_hit_amount
	
	emit_signal("judgement_level_changed", ability_judgement_level)


# VOL related

func _construct_and_add_VOL_range_module():
	VOL_range_module = TowerDetectingRangeModule_Scene.instance()
	VOL_range_module.can_display_range = false
	VOL_range_module.detection_range = 0
	
	VOL_range_module.can_display_circle_arc = true
	VOL_range_module.circle_arc_color = Color(0.3, 0.3, 1, 0.3)
	
	VOL_range_module
	
	add_child(VOL_range_module)
	
	if is_instance_valid(range_module) and range_module.displaying_range:
		VOL_range_module.show_range()

func _construct_and_add_VOL_ability():
	VOL_ability = BaseAbility.new()
	
	VOL_ability.is_timebound = true
	
	VOL_ability.set_properties_to_usual_tower_based()
	VOL_ability.tower = self
	
	register_ability_to_manager(VOL_ability, false)

func _construct_VOL_effect():
	VOL_effect = Hero_VOLEffect.new()
	VOL_effect.is_timebound = false
	VOL_effect.is_countbound = true
	
	VOL_effect.status_bar_icon = Hero_VOL_StatusBarIcon


func toggle_module_ranges():
	.toggle_module_ranges()
	
	if is_instance_valid(VOL_range_module):
		if is_showing_ranges:
			VOL_range_module.show_range()
			
			if current_placable is InMapAreaPlacable:
				_on_tower_show_range()
			
		else:
			VOL_range_module.hide_range()
			_on_tower_hide_range()


func _on_tower_show_range():
	if is_instance_valid(VOL_range_module):
		VOL_range_module.glow_all_towers_in_range()

func _on_tower_hide_range():
	if is_instance_valid(VOL_range_module):
		VOL_range_module.unglow_all_towers_in_range()



func _cast_VOL():
	VOL_ability.on_ability_before_cast_start(VOL_ability.ON_ABILITY_CAST_NO_COOLDOWN)
	
	var counter : int = 0
	for tower in _get_vol_target_towers():
		var effect : Hero_VOLEffect = VOL_effect._shallow_duplicate()
		effect.damage_scale *= VOL_ability.get_potency_to_use(last_calculated_final_ability_potency)
		
		tower.add_tower_effect(effect)
		
		_increase_exp(current_xp_per_tower_affected_by_vol)
		
		#
		
		var particle = VOL_BlessSprite.instance()
		particle.position = tower.global_position
		CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)
	
	VOL_ability.on_ability_after_cast_ended(VOL_ability.ON_ABILITY_CAST_NO_COOLDOWN)

func _get_vol_target_towers():
	if is_instance_valid(VOL_range_module):
		var in_range_towers = VOL_range_module.get_all_in_map_towers_in_range()
		
		var sorted_towers = Targeting.enemies_to_target(in_range_towers, Targeting.CLOSE, in_range_towers.size(), global_position, true)
		var final_towers : Array = []
		var counter : int = 0
		for tower in sorted_towers:
			if tower != self and tower.last_calculated_has_commandable_attack_modules:
				final_towers.append(tower)
				counter += 1
				
				if counter >= current_towers_affected_by_vol:
					break
		
		return final_towers


func can_level_up_VOL():
	return ability_VOL_level < 4 and current_spendables != 0

func level_up_VOL():
	if can_level_up_VOL():
		_increase_spendables(-1)
		set_vol_level(ability_VOL_level + 1)

func set_vol_level(new_level):
	ability_VOL_level = new_level
	
	if ability_VOL_level == 1:
		if !is_instance_valid(VOL_range_module):
			_construct_and_add_VOL_range_module()
		if VOL_effect == null:
			_construct_VOL_effect()
		if VOL_ability == null:
			_construct_and_add_VOL_ability()
		
		VOL_effect.count = VOL_buff_attack_count_in_levels[0]
		VOL_effect.damage_scale = VOL_dmg_ratio_buff_in_levels[0]
		current_towers_affected_by_vol = VOL_towers_affected_in_levels[0]
		VOL_range_module.detection_range = VOL_range_in_levels[0]
		current_xp_per_tower_affected_by_vol = VOL_xp_gain_per_tower_affected_in_levels[0]
		
		volrobe_sprite.texture = Hero_VOLRobe01Pic
		volrobe_sprite.visible = true
		
		#current_hero_on_hit_effect_scale = VOL_hero_on_hit_effect_scale[0]
		
	elif ability_VOL_level == 2:
		VOL_effect.count = VOL_buff_attack_count_in_levels[1]
		VOL_effect.damage_scale = VOL_dmg_ratio_buff_in_levels[1]
		current_towers_affected_by_vol = VOL_towers_affected_in_levels[1]
		VOL_range_module.detection_range = VOL_range_in_levels[1]
		current_xp_per_tower_affected_by_vol = VOL_xp_gain_per_tower_affected_in_levels[1]
		
		volrobe_sprite.texture = Hero_VOLRobe02Pic
		volrobe_sprite.visible = true
		
		#current_hero_on_hit_effect_scale = VOL_hero_on_hit_effect_scale[1]
		
	elif ability_VOL_level == 3:
		VOL_effect.count = VOL_buff_attack_count_in_levels[2]
		VOL_effect.damage_scale = VOL_dmg_ratio_buff_in_levels[2]
		current_towers_affected_by_vol = VOL_towers_affected_in_levels[2]
		VOL_range_module.detection_range = VOL_range_in_levels[2]
		current_xp_per_tower_affected_by_vol = VOL_xp_gain_per_tower_affected_in_levels[2]
		
		volrobe_sprite.texture = Hero_VOLRobe03Pic
		volrobe_sprite.visible = true
		
		#current_hero_on_hit_effect_scale = VOL_hero_on_hit_effect_scale[2]
		
	elif ability_VOL_level == 4:
		VOL_effect.count = VOL_buff_attack_count_in_levels[3]
		VOL_effect.damage_scale = VOL_dmg_ratio_buff_in_levels[3]
		current_towers_affected_by_vol = VOL_towers_affected_in_levels[3]
		VOL_range_module.detection_range = VOL_range_in_levels[3]
		current_xp_per_tower_affected_by_vol = VOL_xp_gain_per_tower_affected_in_levels[3]
		
		volrobe_sprite.texture = Hero_VOLRobe04Pic
		volrobe_sprite.visible = true
		
		#current_hero_on_hit_effect_scale = VOL_hero_on_hit_effect_scale[3]
		
	else:
		VOL_effect.count = 1
		VOL_effect.damage_scale = 0
		current_towers_affected_by_vol = 0
		VOL_range_module.detection_range = 0
		current_xp_per_tower_affected_by_vol = 0
		
		volrobe_sprite.visible = false
		
		#current_hero_on_hit_effect_scale = 1
	
	current_vol_count = VOL_effect.count
	current_vol_damage_scale = VOL_effect.damage_scale
	
	emit_signal("vol_level_changed", ability_VOL_level)


# Leveling handlers

func _update_if_white_dom_active():
	var syns_reses = synergy_manager.active_dom_color_synergies_res
	white_dom_active = false
	for syn_res in syns_reses:
		if syn_res.synergy.synergy_name == TowerColors.get_color_name_on_card(TowerColors.WHITE):
			white_dom_active = true
	
	emit_signal("white_is_dom_state_changed")


func _increase_exp(amount):
	if !white_dom_active:
		amount *= xp_scale_if_not_white_dom_color
	
	current_hero_xp += amount
	emit_signal("current_xp_changed", amount, current_hero_xp)
	
	if current_hero_natural_level < max_hero_level:
		if current_hero_xp >= xp_needed_per_level[current_hero_natural_level]:
			can_spend_gold_and_xp_for_level_up()
			
			if !notify_xp_cap_of_level_reached:
				notify_xp_cap_of_level_reached = true
				_show_level_up_cosmetic_effects()
				emit_signal("notify_xp_cap_of_level_reached")
				status_bar.add_status_icon(StoreOfTowerEffectsUUID.HERO_LEVEL_UP_STATUS_BAR_ICON_INDEX, Hero_LevelUp_StatusBarIcon)


func _increase_spendables(amount):
	current_spendables += amount
	emit_signal("current_spendables_changed", current_spendables)

func _attempt_increase_extra_ingredient_amount(increment_amount):
	var curr_extra = _ingredient_id_limit_modifier_map[StoreOfIngredientLimitModifierID.HERO]
	
	if curr_extra < hero_max_extra_ingredient_limit:
		if curr_extra + increment_amount > hero_max_extra_ingredient_limit:
			increment_amount = hero_current_extra_ingredient_limit - curr_extra
		
		var new_amount = curr_extra + increment_amount
		set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.HERO, new_amount)



func _attempt_spend_gold_and_xp_for_level_up():
	if can_spend_gold_and_xp_for_level_up():
		var xp_needed = xp_needed_per_level[current_hero_natural_level]
		
		game_elements.gold_manager.decrease_gold_by(gold_needed_per_level[current_hero_natural_level], game_elements.GoldManager.DecreaseGoldSource.TOWER_USE)
		
		current_hero_natural_level += 1
		current_hero_effective_level += 1
		_increase_exp(-xp_needed)
		_increase_spendables(1)
		_attempt_increase_extra_ingredient_amount(hero_extra_ing_limit_per_level_up)
		
		notify_xp_cap_of_level_reached = false
		status_bar.remove_status_icon(StoreOfTowerEffectsUUID.HERO_LEVEL_UP_STATUS_BAR_ICON_INDEX)
		emit_signal("notify_xp_cap_of_level_reached")
		
		emit_signal("hero_level_changed", current_hero_effective_level)
		can_spend_relics_for_level_up()
		if current_hero_natural_level < max_hero_level:
			emit_signal("xp_needed_for_next_level_changed", xp_needed_per_level[current_hero_natural_level])
		else:
			emit_signal("max_level_reached") # max natural level
			
			_max_natural_level_reached()

func _max_natural_level_reached():
	# compo syn
	var compo_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HERO_COMPO_SYN_MODI_ID)
	compo_modi.flat_modifier = extra_comp_syn_slot_amount_at_max_natural_level
	
	synergy_manager.add_composite_syn_limit_modi(compo_modi)
	
	
	# stats related
	var base_dmg_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HERO_MAX_NATURAL_LEVEL_BASE_DAMAGE_EFFECT)
	base_dmg_modi.flat_modifier = hero_max_nat_level_bonus_base_damage_amount
	
	var base_dmg_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS, base_dmg_modi, StoreOfTowerEffectsUUID.HERO_MAX_NATURAL_LEVEL_BASE_DAMAGE_EFFECT)
	
	
	var attk_speed_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.HERO_MAX_NATURAL_LEVEL_ATTK_SPEED_EFFECT)
	attk_speed_modi.percent_amount = hero_max_nat_level_bonus_attk_speed_amount
	attk_speed_modi.percent_based_on = PercentType.BASE
	
	var attk_speed_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_modi, StoreOfTowerEffectsUUID.HERO_MAX_NATURAL_LEVEL_ATTK_SPEED_EFFECT)
	
	
	var ap_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HERO_MAX_NATURAL_LEVEL_ABILITY_POTENCY_EFFECT)
	ap_modi.flat_modifier = hero_max_nat_level_bonus_ability_potency
	
	var ap_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, ap_modi, StoreOfTowerEffectsUUID.HERO_MAX_NATURAL_LEVEL_ABILITY_POTENCY_EFFECT)
	
	
	add_tower_effect(base_dmg_effect)
	add_tower_effect(attk_speed_effect)
	add_tower_effect(ap_effect)
	
	
	# visuals
	max_nat_level_wings_sprite.visible = true


func can_spend_gold_and_xp_for_level_up() -> bool:
	var can = false
	
	if current_hero_natural_level < max_hero_level and current_hero_effective_level != max_hero_boosted_level:
		var xp_needed = xp_needed_per_level[current_hero_natural_level]
		var gold_needed = gold_needed_per_level[current_hero_natural_level]
		
		can = xp_needed <= current_hero_xp and gold_needed <= game_elements.gold_manager.current_gold
	
	emit_signal("can_spend_gold_and_xp_for_level_up_updated", can)
	return can


func can_spend_relics_for_level_up() -> bool:
	var can = current_hero_natural_level >= max_hero_level and 1 <= game_elements.relic_manager.current_relic_count and current_hero_effective_level != max_hero_boosted_level
	
	emit_signal("can_spend_relics_for_level_up_updated", can)
	return can

#

func _gold_manager_gold_changed(gold):
	can_spend_gold_and_xp_for_level_up()

func _relic_manager_relic_count_changed(relic_count):
	can_spend_relics_for_level_up()

#

func get_xp_for_next_level() -> float:
	if current_hero_natural_level < max_hero_level:
		return xp_needed_per_level[current_hero_natural_level]
	else:
		return 0.0

#

func get_light_waves_ability_descriptions() -> Array:
	if ability_light_waves_level != 0:
		var every_attk_desc : String
		if current_attks_needed_for_light_wave == 4:
			every_attk_desc = "4th "
		elif current_attks_needed_for_light_wave == 3:
			every_attk_desc = "3rd "
		elif current_attks_needed_for_light_wave == 2:
			every_attk_desc = "2nd "
		elif current_attks_needed_for_light_wave == 1:
			every_attk_desc = ""
		
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_to_use_for_tower_stat_fragments = self
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", current_light_wave_base_damage))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		
		var descs = [
			"Every %smain attack is followed by a light wave." % every_attk_desc,
			["Light waves deal |0|, and have 3 pierce", [interpreter_for_flat_on_hit]],
		]
		
#		var descs = [
#			"Every %s main attack is followed by a light wave." % every_attk_desc,
#			"Light waves deal %s elemental damage, and have 3 pierce" % current_light_wave_base_damage,
#			"Light waves do not benefit from base damage buffs, on hit damages and effects.",
#		]
		
		if ability_light_waves_level >= 3:
			for exp_desc in _get_light_explosion_ability_descs():
				descs.append(exp_desc)
		
		return descs
	else:
		return [
			"Locked."
		]

func _get_light_explosion_ability_descs() -> Array:
	
	var interpreter_for_perc_on_hit = TextFragmentInterpreter.new()
	interpreter_for_perc_on_hit.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_perc_on_hit.display_body = false
	interpreter_for_perc_on_hit.header_description = "of the damage of the main attack"
	
	var ins_for_perc_on_hit = []
	ins_for_perc_on_hit.append(NumericalTextFragment.new((current_light_explosion_dmg_ratio * 100), true, -1))
	
	interpreter_for_perc_on_hit.array_of_instructions = ins_for_perc_on_hit
	
	return [
		"",
		"After %s main attacks in a round, every main attack that hits an enemy causes an explosion." % attks_needed_for_light_explosion,
		["The explosion deals |0| to %s enemies." % [str(light_explosion_pierce)], [interpreter_for_perc_on_hit]],
		"The explosion does not apply on hit effects."
	]
	
#	return [
#		"",
#		"After %s main attacks in a round, every main attack that hits an enemy causes an explosion." % attks_needed_for_light_explosion,
#		"The explosion deals elemental damage equal to %s of the damage of the main attack to %s enemies." % [(str(current_light_explosion_dmg_ratio * 100) + "%"), str(light_explosion_pierce)],
#		"The explosion does not apply on hit effects."
#	]


func get_judgement_ability_descs() -> Array:
	if ability_judgement_level != 0:
		
		var interpreter_for_judgement_damage = TextFragmentInterpreter.new()
		interpreter_for_judgement_damage.tower_to_use_for_tower_stat_fragments = self
		interpreter_for_judgement_damage.display_body = true
		
		var ins_for_judgement_dmg = []
		ins_for_judgement_dmg.append(NumericalTextFragment.new(current_judgement_bonus_on_hit_amount, false, DamageType.PHYSICAL))
		ins_for_judgement_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_judgement_dmg.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, current_judgement_dmg_ratio, DamageType.PHYSICAL))
		
		interpreter_for_judgement_damage.array_of_instructions = ins_for_judgement_dmg
		
		#
		
		var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg.tower_to_use_for_tower_stat_fragments = self
		interpreter_for_bonus_dmg.display_body = false
		interpreter_for_bonus_dmg.header_description = "more damage"
		
		var ins_for_bonus_dmg = []
		ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", (judgement_bonus_dmg_ratio - 1) * 100, true))
		interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
		
		
		#
		
		return [
			"Every attack that applies on hit effects applies a Judge stack to enemies hit.",
			["At %s Judge stacks, Judgement is brought to the enemy, dealing |0|" % [str(judgement_stack_trigger)], [interpreter_for_judgement_damage]],
			["Judgement is enhanced to deal |0| when the enemy has less than %s health." % [(str(judgement_bonus_dmg_threshold_trigger * 100) + "%")], [interpreter_for_bonus_dmg]],
			"Judgement does not apply on hit effects."
		]
		
#		return [
#			"Every attack that applies on hit effects applies a Judge stack to enemies hit.",
#			"At %s Judge stacks, Judgement is brought to the enemy, dealing %s of this tower's base damage as physical damage, and dealing bonus %s physical damage." % [str(judgement_stack_trigger), (str(current_judgement_dmg_ratio * 100) + "%"), str(current_judgement_bonus_on_hit_amount)],
#			"Judgement is enhanced to deal %s more damage when the enemy has less than %s health." % [(str((judgement_bonus_dmg_ratio - 1) * 100) + "%"), (str(judgement_bonus_dmg_threshold_trigger * 100) + "%")],
#			"Judgement does not apply on hit effects."
#		]
	else:
		return [
			"Locked."
		]


func get_vol_ability_descs() -> Array:
	if ability_VOL_level != 0:
		
		
		var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg.tower_to_use_for_tower_stat_fragments = self
		interpreter_for_bonus_dmg.display_body = true
		interpreter_for_bonus_dmg.header_description = ""
		
		var ins_for_bonus_dmg = []
		ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, ""))
		ins_for_bonus_dmg.append(NumericalTextFragment.new((current_vol_damage_scale - 1) * 100, true, -1, "", false, TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP))
		ins_for_bonus_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_bonus_dmg.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
		
		
		var descs = [
			"Every %s attack is accompanied by Hero casting Voice of Light." % (str(current_attks_needed_for_vol) + "th"),
			"Voice of Light buffs %s towers in range, prioritizing the closest towers, and ignoring towers that cannot attack." % current_towers_affected_by_vol,
			["Voice of Light buffs tower's outgoing damage %s times by |0|" % [current_vol_count], [interpreter_for_bonus_dmg]],
		]
		
		
		descs.append("")
		if current_hero_natural_level < max_hero_level:
			descs.append("Each tower affected by Voice of Light gives Hero additional %s EXP." % current_xp_per_tower_affected_by_vol)
		descs.append("Hero does not benefit from Voice of Light.")
		
		#descs.append("")
		#descs.append("Hero's attacks also apply on hit effects at %s efficiency" % (str(current_hero_on_hit_effect_scale * 100) + "%"))
		
		return descs
	else:
		return [
			"Locked."
		]


#

func get_light_waves_upgrade_descs() -> Array:
	var descs
	
	if can_level_up_light_waves():
		if ability_light_waves_level != 0:
			
			var interpreter_for_flat_on_hit_curr = TextFragmentInterpreter.new()
			interpreter_for_flat_on_hit_curr.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_flat_on_hit_curr.display_body = false
			
			var ins_for_flat_on_hit_curr = []
			ins_for_flat_on_hit_curr.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "", current_light_wave_base_damage))
			
			interpreter_for_flat_on_hit_curr.array_of_instructions = ins_for_flat_on_hit_curr
			
			#
			
			var interpreter_for_flat_on_hit_next = TextFragmentInterpreter.new()
			interpreter_for_flat_on_hit_next.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_flat_on_hit_next.display_body = false
			
			var ins_for_flat_on_hit_next = []
			ins_for_flat_on_hit_next.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "", light_wave_base_damage_in_levels[ability_light_waves_level]))
			
			interpreter_for_flat_on_hit_next.array_of_instructions = ins_for_flat_on_hit_next
			
			#
			
			descs = [
				"Attacks per lightwave: %s -> %s" % [current_attks_needed_for_light_wave, attks_needed_for_light_wave_in_levels[ability_light_waves_level]],
				["lightwave base damage: |0| -> |1|", [interpreter_for_flat_on_hit_curr, interpreter_for_flat_on_hit_next]],
			]
			
			if ability_light_waves_level + 1 == 3:
				descs.append("")
				descs.append("New: Light Explosion")
				descs.append("After %s main attacks in a round, every main attack that hits an enemy causes an explosion." % attks_needed_for_light_explosion)
				
				#
				var interpreter_for_perc_on_hit = TextFragmentInterpreter.new()
				interpreter_for_perc_on_hit.tower_to_use_for_tower_stat_fragments = self
				interpreter_for_perc_on_hit.display_body = false
				interpreter_for_perc_on_hit.header_description = "of the damage of the main attack"
				
				var ins_for_perc_on_hit = []
				ins_for_perc_on_hit.append(NumericalTextFragment.new(light_explosion_dmg_ratio_in_levels[2] * 100, true, -1))
				
				interpreter_for_perc_on_hit.array_of_instructions = ins_for_perc_on_hit
				#
				
				descs.append(["The explosion deals |0| to %s enemies." % [str(light_explosion_pierce)], [interpreter_for_perc_on_hit]])
				#descs.append("The explosion deals elemental damage equal to %s of the damage of the main attack to %s enemies." % [(str(light_explosion_dmg_ratio_in_levels[2] * 100) + "%"), str(light_explosion_pierce)])
				
			elif ability_light_waves_level + 1 == 4:
				descs.append("light explosion damage ratio: %s -> %s" % [str(current_light_explosion_dmg_ratio * 100) + "%", str(light_explosion_dmg_ratio_in_levels[3] * 100) + "%"])
			
			
		else:
			
			var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
			interpreter_for_flat_on_hit.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_flat_on_hit.display_body = false
			
			var ins_for_flat_on_hit = []
			ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", light_wave_base_damage_in_levels[0]))
			
			interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
			
			
			descs = [
				"Every %s main attack is followed by a light wave." % (str(attks_needed_for_light_wave_in_levels[0]) + "rd"),
				["Light waves deal |0|, and have 3 pierce.", [interpreter_for_flat_on_hit]],
			]
	
	return descs


func get_judgement_upgrade_descs():
	var descs
	
	if can_level_up_judgement():
		if ability_judgement_level != 0:
			
			var interpreter_for_damage_ratio_curr = TextFragmentInterpreter.new()
			interpreter_for_damage_ratio_curr.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_damage_ratio_curr.display_body = true
			
			var ins_for_judgement_dmg_ratio_curr = []
			ins_for_judgement_dmg_ratio_curr.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "", current_judgement_dmg_ratio * 100, true))
			
			interpreter_for_damage_ratio_curr.array_of_instructions = ins_for_judgement_dmg_ratio_curr
			
			#
			
			var interpreter_for_damage_ratio_next = TextFragmentInterpreter.new()
			interpreter_for_damage_ratio_next.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_damage_ratio_next.display_body = true
			
			var ins_for_judgement_dmg_ratio_next = []
			ins_for_judgement_dmg_ratio_next.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "", judgement_dmg_ratio_in_levels[ability_judgement_level] * 100, true))
			
			interpreter_for_damage_ratio_next.array_of_instructions = ins_for_judgement_dmg_ratio_next
			
			#
			
			var interpreter_for_flat_dmg_curr = TextFragmentInterpreter.new()
			interpreter_for_flat_dmg_curr.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_flat_dmg_curr.display_body = true
			
			var ins_for_judgement_flat_dmg_curr = []
			ins_for_judgement_flat_dmg_curr.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "", current_judgement_bonus_on_hit_amount, false))
			
			interpreter_for_flat_dmg_curr.array_of_instructions = ins_for_judgement_flat_dmg_curr
			
			#
			
			var interpreter_for_flat_dmg_next = TextFragmentInterpreter.new()
			interpreter_for_flat_dmg_next.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_flat_dmg_next.display_body = true
			
			var ins_for_judgement_flat_dmg_next = []
			ins_for_judgement_flat_dmg_next.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "", judgement_bonus_on_hit_dmg_in_levels[ability_judgement_level], false))
			
			interpreter_for_flat_dmg_next.array_of_instructions = ins_for_judgement_flat_dmg_next
			
			
			#
			
			descs = [
				["Base damage ratio: |0| -> |1|", [interpreter_for_damage_ratio_curr, interpreter_for_damage_ratio_next]],
				["Bonus on hit dmg: |0| -> |1|", [interpreter_for_flat_dmg_curr, interpreter_for_flat_dmg_next]],
			]
			
#			descs = [
#				"Base damage ratio: %s -> %s" % [(str(current_judgement_dmg_ratio * 100) + "%"), (str(judgement_dmg_ratio_in_levels[ability_judgement_level] * 100) + "%")],
#				"Bonus on hit dmg: %s -> %s" % [str(current_judgement_bonus_on_hit_amount), str(judgement_bonus_on_hit_dmg_in_levels[ability_judgement_level])],
#			]
			
		else:
			
			var interpreter_for_judgement_damage = TextFragmentInterpreter.new()
			interpreter_for_judgement_damage.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_judgement_damage.display_body = true
			
			var ins_for_judgement_dmg = []
			ins_for_judgement_dmg.append(NumericalTextFragment.new(judgement_bonus_on_hit_dmg_in_levels[0], false, DamageType.PHYSICAL))
			ins_for_judgement_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
			ins_for_judgement_dmg.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, judgement_dmg_ratio_in_levels[0], DamageType.PHYSICAL))
			
			interpreter_for_judgement_damage.array_of_instructions = ins_for_judgement_dmg
			
			#
			
			var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
			interpreter_for_bonus_dmg.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_bonus_dmg.display_body = false
			interpreter_for_bonus_dmg.header_description = "more damage"
			
			var ins_for_bonus_dmg = []
			ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", (judgement_bonus_dmg_ratio - 1) * 100, true))
			interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
			
			
			#
			
			descs = [
				"Every attack that applies on hit effects applies a Judge stack to enemies hit.",
				["At %s Judge stacks, Judgement is brought to the enemy, dealing |0|" % [str(judgement_stack_trigger)], [interpreter_for_judgement_damage]],
				["Judgement is enhanced to deal |0| when the enemy has less than %s health." % [(str(judgement_bonus_dmg_threshold_trigger * 100) + "%")], [interpreter_for_bonus_dmg]],
				"Judgement does not apply on hit effects."
				]
			
#			descs = [
#				"Every attack that applies on hit effects applies a Judge stack to enemies hit.",
#				"At %s Judge stacks, Judgement is brought to the enemy, dealing %s of this tower's base damage as physical damage, and dealing bonus %s physical damage" % [str(judgement_stack_trigger), (str(judgement_dmg_ratio_in_levels[0] * 100) + "%"), str(judgement_bonus_on_hit_dmg_in_levels[0])],
#				"Judgement is enhanced to deal %s more damage when the enemy has less than %s health." % [(str((judgement_bonus_dmg_ratio - 1) * 100) + "%"), (str(judgement_bonus_dmg_threshold_trigger * 100) + "%")],
#				"Judgement does not apply on hit effects."
#			]
	
	return descs


func get_vol_upgrade_descs():
	var descs
	
	if can_level_up_VOL():
		if ability_VOL_level != 0:
			
			#
			
			var interpreter_for_bonus_dmg_curr = TextFragmentInterpreter.new()
			interpreter_for_bonus_dmg_curr.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_bonus_dmg_curr.display_body = false
			interpreter_for_bonus_dmg_curr.header_description = ""
			
			var ins_for_bonus_dmg_curr = []
			ins_for_bonus_dmg_curr.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "", (current_vol_damage_scale - 1) * 100, true))
			interpreter_for_bonus_dmg_curr.array_of_instructions = ins_for_bonus_dmg_curr
			
			#
			
			var interpreter_for_bonus_dmg_next = TextFragmentInterpreter.new()
			interpreter_for_bonus_dmg_next.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_bonus_dmg_next.display_body = false
			interpreter_for_bonus_dmg_next.header_description = ""
			
			var ins_for_bonus_dmg_next = []
			ins_for_bonus_dmg_next.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "", (VOL_dmg_ratio_buff_in_levels[ability_VOL_level] - 1) * 100, true))
			interpreter_for_bonus_dmg_next.array_of_instructions = ins_for_bonus_dmg_next
			
			
			#
			
			descs = [
				["Damage ratio buff: |0| -> |1|", [interpreter_for_bonus_dmg_curr, interpreter_for_bonus_dmg_next]],
				"Number of attacks buffed: %s -> %s" % [current_vol_count, VOL_buff_attack_count_in_levels[ability_VOL_level]],
				"Number of towers affected: %s -> %s" % [current_towers_affected_by_vol, VOL_towers_affected_in_levels[ability_VOL_level]],
				"Buff range: %s -> %s" % [VOL_range_module.detection_range, VOL_range_in_levels[ability_VOL_level]],
			]
			
#			descs = [
#				"Damage ratio buff: %s -> %s" % [(str(current_vol_damage_scale * 100) + "%"), (str(VOL_dmg_ratio_buff_in_levels[ability_VOL_level] * 100) + "%")],
#				"Number of attacks buffed: %s -> %s" % [current_vol_count, VOL_buff_attack_count_in_levels[ability_VOL_level]],
#				"Number of towers affected: %s -> %s" % [current_towers_affected_by_vol, VOL_towers_affected_in_levels[ability_VOL_level]],
#				"Buff range: %s -> %s" % [VOL_range_module.detection_range, VOL_range_in_levels[ability_VOL_level]],
#				#"On hit effect efficiency: %s -> %s" % [(str(current_hero_on_hit_effect_scale * 100) + "%"), (str(VOL_hero_on_hit_effect_scale[ability_VOL_level] * 100) + "%")]
#			]
			
		else:
			
			
			var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
			interpreter_for_bonus_dmg.tower_to_use_for_tower_stat_fragments = self
			interpreter_for_bonus_dmg.display_body = true
			interpreter_for_bonus_dmg.header_description = ""
			
			var ins_for_bonus_dmg = []
			ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, ""))
			ins_for_bonus_dmg.append(NumericalTextFragment.new((VOL_dmg_ratio_buff_in_levels[0] - 1) * 100, true, -1, "", false, TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP))
			ins_for_bonus_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_bonus_dmg.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
			
			interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
			
			
			descs = [
				"Every %s attack is accompanied by Hero casting Voice of Light." % (str(current_attks_needed_for_vol) + "th"),
				"Voice of Light buffs %s towers in range, prioritizing closer towers, and ignoring towers that cannot attack." % VOL_towers_affected_in_levels[0],
				["Voice of Light buffs tower's outgoing damage %s times by |0|" % [VOL_buff_attack_count_in_levels[0]], [interpreter_for_bonus_dmg]],
				"",
				"Each tower affected by Voice of Light gives Hero additional %s EXP." % VOL_xp_gain_per_tower_affected_in_levels[0],
				"Hero does not benefit from this ability.",
			]
			
#			descs = [
#				"Every %s attack is accompanied by Hero casting Voice of Light." % (str(current_attks_needed_for_vol) + "th"),
#				"Voice of Light buffs %s towers in range, prioritizing closer towers, and ignoring towers that cannot attack." % VOL_towers_affected_in_levels[0],
#				"Voice of Light buffs tower's outgoing damage %s times by %s" % [VOL_buff_attack_count_in_levels[0] , str((VOL_dmg_ratio_buff_in_levels[0] * 100) - 100) + "%."],
#				"",
#				"Each tower affected by Voice of Light gives Hero additional %s EXP." % VOL_xp_gain_per_tower_affected_in_levels[0],
#				"Hero does not benefit from this ability.",
#				"",
#				#"Hero's attacks also apply on hit effects at %s efficiency" % (str(VOL_hero_on_hit_effect_scale[0] * 100) + "%"),
#
#			]
	
	return descs

#

func get_light_waves_ability_name() -> String:
	return "Light Waves"

func get_judgement_ability_name() -> String:
	return "Judgement"

func get_voice_of_light_ability_name() -> String:
	return "Voice of Light"

#

func get_gold_xp_level_up_desc() -> Array:
	if current_hero_natural_level < max_hero_level:
		return [
			"Costs %s gold and %s EXP to level up." % [gold_needed_per_level[current_hero_natural_level], xp_needed_per_level[current_hero_natural_level]]
		]
	else:
		return [
			"Hero has already gained all levels from gold and EXP."
		]

func get_relic_level_up_desc() -> Array:
	return [
		"Costs 1 relic to level up trice.",
		"Hero needs to be level %s or above to use this option." % str(max_hero_level)
	]

func get_relic_level_up_desc__for_relic_shop_option() -> Array:
	return [
		"Spend 1 relic to level hero up trice.",
	]



func get_self_description_in_info_panel() -> Array:
	var last_part : String = "you"
	if current_hero_natural_level < max_hero_level:
		last_part += ", eventually."
	else:
		last_part += "."
	
	return [
		"Hero will save %s" % last_part,
		"Click on the hero icon below, or press %s, to view the hero's level and skills." % [str(InputMap.get_action_list("game_tower_panel_ability_01")[0].as_text())]
	]

#

func _show_level_up_cosmetic_effects():
	if !is_instance_valid(particle_timer):
		particle_timer = Timer.new()
		particle_timer.one_shot = true
		particle_timer.connect("timeout", self, "_on_particle_timer_expired", [], CONNECT_PERSIST)
		add_child(particle_timer)
	
	_on_particle_timer_expired()

func _on_particle_timer_expired():
	if _current_particle_showing_count < total_particle_count_per_show:
		_create_and_show_level_up_particle()
		_current_particle_showing_count += 1
		
		particle_timer.start(delay_per_particle)
	else:
		_current_particle_showing_count = 0


func _create_and_show_level_up_particle():
	var particle = Hero_LevelUpParticle_Scene.instance()
	
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	particle.position = global_position
	particle.scale *= 2
	
	particle.position.x += non_essential_rng.randi_range(-17, 17)
	particle.position.y += non_essential_rng.randi_range(-16, 10)
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)

##########

func _on_round_start_h():
	_update_level_up_relic_popup_gui_visiblity()
	_update_level_up_gold_popup_gui_visiblity()

func _on_round_end__relic_gui_related():
	_update_level_up_relic_popup_gui_visiblity()
	_update_level_up_gold_popup_gui_visiblity()

func _on_transfer_to_placable_h(arg_tower, arg_new_placable):
	_update_level_up_relic_popup_gui_visiblity()
	_update_level_up_gold_popup_gui_visiblity()


func _can_spend_relics_for_level_up_updated(arg_val):
	_can_spend_relic_for_level_up__for_popup_gui = arg_val
	_update_level_up_relic_popup_gui_visiblity()
	_update_hero_relic_store_options(arg_val)

func _update_level_up_relic_popup_gui_visiblity():
	if !is_round_started and _can_spend_relic_for_level_up__for_popup_gui and is_current_placable_in_map():
		_set_level_up_relic_popup_gui(true)
	else:
		_set_level_up_relic_popup_gui(false)

func _set_level_up_relic_popup_gui(arg_val):
	if arg_val:
		if popup_gui == null:
			_construct_popup_levelup_gui()
	
	if is_instance_valid(popup_gui):
		popup_gui.set_spend_relics_for_level_up_visible(arg_val)

func _construct_popup_levelup_gui():
	popup_gui = Hero_PopupGUI_LevelUp_Scene.instance()
	popup_gui.hero = self
	
	add_child(popup_gui)

# gold
func _can_spend_gold_and_xp_for_level_up_updated(arg_val):
	_can_spend_gold_for_level_up__for_popup_gui = arg_val
	_update_level_up_gold_popup_gui_visiblity()

func _update_level_up_gold_popup_gui_visiblity():
	if !is_round_started and _can_spend_gold_for_level_up__for_popup_gui and is_current_placable_in_map():
		_set_level_up_gold_popup_gui(true)
	else:
		_set_level_up_gold_popup_gui(false)

func _set_level_up_gold_popup_gui(arg_val):
	if arg_val:
		if popup_gui == null:
			_construct_popup_levelup_gui()
	
	if is_instance_valid(popup_gui):
		popup_gui.set_spend_gold_for_level_up_visible(arg_val)


### RELIC STORE OFFER


func _create_relic_store_offer_options():
	var hero_level_up_with_relic_shop_offer := RelicStoreOfferOption.new(self, "_on_hero_level_up_with_relic_shop_offer_selected", Hero_IncreaseLevels_Normal_Pic, Hero_IncreaseLevels_Highlighted_Pic)
	hero_level_up_with_relic_shop_offer.descriptions = get_relic_level_up_desc__for_relic_shop_option()
	hero_level_up_with_relic_shop_offer.header_left_text = "Hero Level Up"
	
	hero_level_up_with_relic_shop_offer_id = game_elements.whole_screen_relic_general_store_panel.add_relic_store_offer_option(hero_level_up_with_relic_shop_offer)

func _on_hero_level_up_with_relic_shop_offer_selected():
	return _attempt_spend_one_relic_for_level_up__from_relic_shop()

func _attempt_spend_one_relic_for_level_up__from_relic_shop() -> bool:
	if can_spend_relics_for_level_up():
		game_elements.relic_manager.decrease_relic_count_by(1, game_elements.RelicManager.DecreaseRelicSource.TOWER_USE)
		current_hero_effective_level += 3
		
		emit_signal("hero_level_changed", current_hero_effective_level)
		_increase_spendables(3)
		
		return true
	
	return false

func _attempt_spend_one_relic_for_level_up__from_hero_gui():
	game_elements.whole_screen_relic_general_store_panel.trigger_relic_store_offer_option(hero_level_up_with_relic_shop_offer_id)


func _update_hero_relic_store_options(arg_can_show):
	if arg_can_show:
		if !game_elements.whole_screen_relic_general_store_panel.is_shop_offer_id_exists(hero_level_up_with_relic_shop_offer_id):
			_create_relic_store_offer_options()
		
	else:
		if game_elements.whole_screen_relic_general_store_panel.is_shop_offer_id_exists(hero_level_up_with_relic_shop_offer_id):
			game_elements.whole_screen_relic_general_store_panel.remove_relic_store_offer_option(hero_level_up_with_relic_shop_offer_id)
			hero_level_up_with_relic_shop_offer_id = -1
