extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerEffect_DomSynBlack_DmgBonus = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Effects/TowerEffect_DomSyn_Black_DmgBonus.gd")
const TowerEffect_DomSynBlack_AttkSpeedGiver = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Effects/TowerEffect_DomSyn_Black_AttkSpeedBuffGiver.gd")
const TowerEffect_DomSyn_Black_BlackBeamAndFireBall = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Effects/TowerEffect_DomSyn_Black_BlackBeamAndFireBall.gd")
const TowerEffect_DomSyn_Black_OverkillExplosionAMGiver = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Effects/TowerEffect_DomSyn_Black_OverkillExplosionAMGiver.gd")

const ExpandingAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/ExpandingAttackSprite.tscn")

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const BaseBlackPath = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Classes/BaseBlackPath.gd")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")

const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const Black_CapacitorLightning_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Scenes/Capacitor_Lightning/Black_CapacitorLightning.tscn")

const Black_SynInteractable_Icon_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/GUI/SynInteractable/Black_SynInteracableIcon.tscn")
const Black_SynInteractable_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/GUI/SynInteractable/Black_SynInteracableIcon.gd")


const Black_Disarray_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/GUIAssets/Choice_Disarray_Icon.png")
const Black_Overflow_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/GUIAssets/Choice_Overflow_Icon.png")
const Black_Capacitor_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/GUIAssets/Choice_Capacitor_Icon.png")

const Black_WholeScreenGUI_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/GUI/WholeScreen/Black_WholeScreenGUI.tscn")
const Black_WholeScreenGUI = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/GUI/WholeScreen/Black_WholeScreenGUI.gd")

const Black_Capacitor_Nova_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Scenes/Capacitor_Nova/Black_Capacitor_Nova.tscn")

const Black_LightningExplosion_Pic01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/LightningExplosion/LightningExplosion_01.png")
const Black_LightningExplosion_Pic02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/LightningExplosion/LightningExplosion_02.png")
const Black_LightningExplosion_Pic03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/LightningExplosion/LightningExplosion_03.png")
const Black_LightningExplosion_Pic04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/LightningExplosion/LightningExplosion_04.png")
const Black_LightningExplosion_Pic05 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/LightningExplosion/LightningExplosion_05.png")
const Black_LightningExplosion_Pic06 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/LightningExplosion/LightningExplosion_06.png")
const Black_LightningExplosion_Pic07 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/LightningExplosion/LightningExplosion_07.png")

const Black_Nova_Explosion01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/NovaExplosionParticle/Black_Nova_Explosion.png")

const Black_NovaAPEffect_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/StatusBarIcons/Black_NovaAPEffect_StatusBarIcon.png")
const Black_LightningAPEffect_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/StatusBarIcons/Black_LightningAPEffect_StatusBarIcon.png")


const SYN_INACTIVE : int = -1

const SYN_TIER_ATTK_SPD_GIVER : int = 3
const SYN_TIER_PATH_BASIC_LEVEL : int = 2
const SYN_TIER_PATH_ADV_LEVEL : int = 1



var _initialized_one_time_features : bool

var all_black_towers : Array = []
var game_elements : GameElements

var curr_tier : int

#

var all_black_paths : Array
var chosen_black_path : BaseBlackPath

var black_whole_screen_gui : Black_WholeScreenGUI
var black_syn_icon : Black_SynInteractable_Icon

# Disarray related


const disarray_beam_cooldown : float = 0.1

const disarray_beam_base_damage_tier_2 : float = 1.5
const disarray_beam_base_damage_tier_1 : float = 1.5

const disarray_beam_bonus_base_dmg_scale : float = 0.25
const disarray_beam_bonus_on_hit_dmg_scale : float = 0.25

const disarray_beam_applies_on_hit_effects_tier_2 : bool = false
const disarray_beam_applies_on_hit_effects_tier_1 : bool = true

const disarray_name : String = "Disarray"
const disarray_descriptions_tier_2_simple : Array = [
	"Main attacks on hit cause a black beam to hit a random enemy in range.",
	"The beam deals %s physical damage, and benefits base damage and on hit damage buffs at %s%% efficiency." % [str(disarray_beam_base_damage_tier_2), str(disarray_beam_bonus_base_dmg_scale * 100)],
	"This can be triggered only once every %s seconds." % [str(disarray_beam_cooldown)]
]


const disarray_fireball_base_damage : float = 5.0
const disarray_fireball_pierce : int = 4
const disarray_fireball_proj_speed : float = 150.0

const disarray_fireball_bonus_base_dmg_scale : float = 1.0
const disarray_fireball_bonus_on_hit_dmg_scale : float = 1.0

const disarray_fireball_black_beam_count_for_summon : int = 10

const disarray_descriptions_tier_1_simple : Array = [
	"Black beams now apply on hit effects.",
	"Every %sth black beam is replaced by a fireball, dealing %s damage to %s enemies. Benefits from base damage and on hit damage buffs." % [str(disarray_fireball_black_beam_count_for_summon), str(disarray_fireball_base_damage), str(disarray_fireball_pierce)]
]

var disarray_path : BaseBlackPath


# Capacitor related

enum EntityType {
	TOWER = 1,
	ENEMY = 2,
}

const capacitor_ability_cast_count_requirement : int = 25
const capacitor_buff_duration_tier_2 : float = 50.0
const capacitor_buff_duration_tier_1 : float = 50.0

const capacitor_ap_buff_amount_tier_2 : float = 0.75
const capacitor_ap_buff_amount_tier_1 : float = 0.75

const capacitor_cdr_buff_amount_tier_2 : float = 25.0
const capacitor_cdr_buff_amount_tier_1 : float = 25.0

const capacitor_nova_ongoing_cooldown_percent_type : int = PercentType.CURRENT
const capacitor_ongoing_cooldown_percent_reduction_tier_2 : float = 0.25
const capacitor_ongoing_cooldown_percent_reduction_tier_1 : float = 0.25


const capacitor_nova_ramp_up_time : float = 3.0
const capacitor_nova_stun_time : float = 3.0
const capacitor_nova_stop_enemy_spawn_time : float = capacitor_nova_stun_time

var _capacitor_nova_created_in_round : bool
var _capacitor_current_cast_count_in_round : int

const capacitor_name : String = "Capacitor"
const capacitor_descriptions_tier_2_simple : Array = [
	"After %s abilities are casted, summon a nova that explodes after %s seconds, stunning all enemies for %s seconds, and preventing new enemies from spawning for %s seconds. All tower abilities's ongoing cooldowns are reduced by %s%%" % [str(capacitor_ability_cast_count_requirement), str(capacitor_nova_ramp_up_time), str(capacitor_nova_stun_time), str(capacitor_nova_stop_enemy_spawn_time), str(capacitor_ongoing_cooldown_percent_reduction_tier_2 * 100)],
	"For the next %s seconds, towers gain %s ability potency and %s%% cooldown reduction." % [str(capacitor_buff_duration_tier_2), str(capacitor_ap_buff_amount_tier_2), str(capacitor_cdr_buff_amount_tier_2)]
]


const capacitor_lightning_delay_after_nova : float = capacitor_nova_stun_time

const capacitor_lightning_count_tier_1 : int = 5
const capacitor_lightning_delay_per_strke : float = 1.0

const capacitor_lightning_tower_ap_amount : float = 0.75
const capacitor_lightning_ongoing_cooldown_percent_type : int = PercentType.CURRENT
const capacitor_lightning_ongoing_cd_reduction : float = 1.0

const capacitor_lightning_enemy_damage_percent : float = 75.0
const capacitor_lightning_enemy_damage_max_amount : float = 250.0
const capacitor_lightning_enemy_explosion_pierce : int = 5

const capacitor_lightning_delay_from_sky_to_ground : float = 0.1

var _queued_for_lightning : bool
var _capacitor_lightning_queue_timer : Timer
var _capacitor_lightning_delay_for_next_lightning_timer : Timer
var _capacitor_lightning_from_ground_to_strike_timer : Timer

var _capacitor_current_lightning_count_to_summon : int
var _capacitor_delay_for_next_lightning : float
#var _capacitor_current_entities_hit : Array = []

var _capacitor_lightning_explosion_attack_module : AOEAttackModule

const capacitor_descriptions_tier_1_simple : Array = [
	"%s seconds after the nova detonation, %s lightning strikes are summoned, hitting either a tower or enemy at random." % [str(capacitor_lightning_delay_after_nova), str(capacitor_lightning_count_tier_1)],
	"If a tower is hit: gain %s additional ability potency, and reducing %s%% of its ongoing ability cooldowns." % [str(capacitor_lightning_tower_ap_amount), str(capacitor_lightning_ongoing_cd_reduction * 100)],
	"If an enemy is hit: create an explosion that deals %s%% of their max health as elemental damage, up to %s. Hits up to %s enemies." % [str(capacitor_lightning_enemy_damage_percent), str(capacitor_lightning_enemy_damage_max_amount), str(capacitor_lightning_enemy_explosion_pierce)]
]

var capacitor_path : BaseBlackPath

var _capacitor_nova_particle

# Overflow

const overflow_idle_time_for_scale_to_start : float = 2.0
const overflow_damage_scale_base_amount : float = 0.5
const overflow_damage_scale_per_second : float = 0.1
const overflow_total_max_damage_scale : float = 1.0

const overflow_overkill_damage_ratio_tier_2 : float = 1.5
const overflow_overkill_damage_ratio_tier_1 : float = 2.25
const overflow_overkill_explosion_pierce : int = 5
const overflow_overkill_explosion_base_scale : float = 2.0

const overflow_overkill_can_summon_overkill_explosion_tier_2 : bool = false
const overflow_overkill_can_summon_overkill_explosion_tier_1 : bool = true

const overflow_name : String = "Overflow"
const overflow_descriptions_tier_2_simple : Array = [
	"After %s seconds of not dealing damage, the next damage instance deals +%s%% more damage, increasing by %s%% every second, up to %s%%." % [str(overflow_idle_time_for_scale_to_start), str(overflow_damage_scale_base_amount * 100), str(overflow_damage_scale_per_second * 100), str(overflow_total_max_damage_scale * 100)],
	"Killing an enemy creates an explosion that deals %s%% of the overkill damage. The explosion hits up to %s enemies" % [str(overflow_overkill_damage_ratio_tier_2 * 100), str(overflow_overkill_explosion_pierce)],
	"The overkill explosion does not trigger from an overkill explosion."
]

const overflow_descriptions_tier_1_simple : Array = [
	"Overkill explosions now instead deal %s%% of the overkill damage" % [str(overflow_overkill_damage_ratio_tier_1 * 100)],
	"Overkill explosions can now trigger from an overkill explosion."
]

var overflow_path : BaseBlackPath

####


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if !game_elements.stage_round_manager.is_connected("round_started", self, "_on_round_start"):
		game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	
	curr_tier = tier
	
	#
	
	if curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
		if !_initialized_one_time_features:
			_initialize_black_paths()
			
			_initialize_syn_interactable_icon()
			_initialize_whole_screen_black_panel()
			
			_initialized_one_time_features = true
	
	if curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
		if chosen_black_path == disarray_path:
			_apply_disarray_effects_to_game(curr_tier)
		elif chosen_black_path == overflow_path:
			_apply_overflow_effects_to_game(curr_tier)
		elif chosen_black_path == capacitor_path:
			_apply_capacitor_effects_to_game(curr_tier)
	
	
	#
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = SYN_INACTIVE
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	
	
	if game_elements.stage_round_manager.is_connected("round_started", self, "_on_round_start"):
		game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_start")
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	
	if chosen_black_path == disarray_path:
		_unapply_disarray_effects_from_game()
	elif chosen_black_path == overflow_path:
		_unapply_overflow_effects_from_game()
	elif chosen_black_path == capacitor_path:
		_unapply_capacitor_effects_from_game()
		_clean_up_capacitor_states()
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


# misc

func _get_all_black_towers() -> Array:
	return game_elements.tower_manager.get_all_active_towers_with_color(TowerColors.BLACK)
#	var all_black_towers_bucket : Array = []
#
#	var all_towers = game_elements.tower_manager.get_all_active_towers()
#	for tower in all_towers:
#		if tower._tower_colors.has(TowerColors.BLACK):
#			all_black_towers_bucket.append(tower)
#	
#	return all_black_towers

# Giving related

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	if tower._tower_colors.has(TowerColors.BLACK):
		_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLACK_ATTACK_DAMAGE_BUFF):
		tower.add_tower_effect(TowerEffect_DomSynBlack_DmgBonus.new())
	
	if curr_tier <= SYN_TIER_ATTK_SPD_GIVER:
		if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLACK_ATTACK_SPEED_BUFF_GIVER):
			var effect = TowerEffect_DomSynBlack_AttkSpeedGiver.new()
			effect.all_black_towers = all_black_towers
			tower.add_tower_effect(effect)
	
	if curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
		if chosen_black_path == disarray_path:
			_apply_disarray_effects_to_tower(tower)
		elif chosen_black_path == overflow_path:
			_apply_overflow_effects_to_tower(tower)
		elif chosen_black_path == capacitor_path:
			_apply_capacitor_effects_to_tower(tower)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var dmg_bonus_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.BLACK_ATTACK_DAMAGE_BUFF)
	if dmg_bonus_effect != null:
		tower.remove_tower_effect(dmg_bonus_effect)
	
	var atk_spd_giver_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.BLACK_ATTACK_SPEED_BUFF_GIVER)
	if atk_spd_giver_effect != null:
		tower.remove_tower_effect(atk_spd_giver_effect)
	
	if curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
		if chosen_black_path == disarray_path:
			_unapply_disarray_effects_from_tower(tower)
		elif chosen_black_path == overflow_path:
			_unapply_overflow_effects_from_tower(tower)
		elif chosen_black_path == capacitor_path:
			_unapply_capacitor_effects_from_tower(tower)

# Attk speed buff giver related

func _on_round_start(curr_stageround):
	if curr_tier <= SYN_TIER_ATTK_SPD_GIVER and curr_tier != SYN_INACTIVE:
		all_black_towers.clear()
		for tower in game_elements.tower_manager.get_all_active_towers_with_color(TowerColors.BLACK):
			all_black_towers.append(tower)


# Path related

func _initialize_black_paths():
	disarray_path = BaseBlackPath.new(disarray_name, {2: disarray_descriptions_tier_2_simple, 1: disarray_descriptions_tier_1_simple}, Black_Disarray_Icon)
	overflow_path = BaseBlackPath.new(overflow_name, {2: overflow_descriptions_tier_2_simple, 1: overflow_descriptions_tier_1_simple}, Black_Overflow_Icon)
	capacitor_path = BaseBlackPath.new(capacitor_name, {2: capacitor_descriptions_tier_2_simple, 1: capacitor_descriptions_tier_1_simple}, Black_Capacitor_Icon)
	
	all_black_paths.append(disarray_path)
	all_black_paths.append(overflow_path)
	all_black_paths.append(capacitor_path)


func _initialize_syn_interactable_icon():
	black_syn_icon = Black_SynInteractable_Icon_Scene.instance()
	
	black_syn_icon.connect("pressed_mouse_event", self, "_mouse_input_event_on_syn_interactable_icon", [], CONNECT_PERSIST)
	game_elements.synergy_interactable_panel.add_synergy_interactable(black_syn_icon)

func _initialize_whole_screen_black_panel():
	black_whole_screen_gui = Black_WholeScreenGUI_Scene.instance()
	black_whole_screen_gui.set_black_dom_syn(self)
	black_whole_screen_gui.connect("on_path_selected", self, "_path_selected", [], CONNECT_PERSIST)

func _mouse_input_event_on_syn_interactable_icon(event):
	if event.button_index == BUTTON_LEFT:
		game_elements.whole_screen_gui.show_control(black_whole_screen_gui)
		black_whole_screen_gui.update_display()


func _path_selected(arg_path):
	chosen_black_path = arg_path
	
	if arg_path == disarray_path:
		_on_disarray_path_selected()
	elif arg_path == overflow_path:
		_on_overflow_path_selected()
	elif arg_path == capacitor_path:
		_on_capacitor_path_selected()
	
	black_whole_screen_gui.update_display()


######### Paths related
# Disarray related

func _on_disarray_path_selected():
	if curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
		_apply_disarray_effects_to_game(curr_tier)

func _apply_disarray_effects_to_game(arg_tier : int):
	var all_towers = _get_all_black_towers()
	for tower in all_towers:
		_apply_disarray_effects_to_tower(tower)

func _apply_disarray_effects_to_tower(arg_tower):
	if !arg_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLACK_BLACK_BEAM_AM):
		var disarray_effect := TowerEffect_DomSyn_Black_BlackBeamAndFireBall.new()
		
		disarray_effect.beam_cooldown = disarray_beam_cooldown
		disarray_effect.beam_bonus_base_dmg_scale = disarray_beam_bonus_base_dmg_scale
		disarray_effect.beam_bonus_on_hit_dmg_scale = disarray_beam_bonus_on_hit_dmg_scale
		
		if curr_tier <= SYN_TIER_PATH_ADV_LEVEL:
			disarray_effect.beam_base_damage = disarray_beam_base_damage_tier_1
			disarray_effect.beam_applies_on_hit_effects = disarray_beam_applies_on_hit_effects_tier_1
			disarray_effect.fireball_enabled = true
			
			disarray_effect.fireball_base_damage = disarray_fireball_base_damage
			disarray_effect.fireball_pierce = disarray_fireball_pierce
			disarray_effect.fireball_proj_speed = disarray_fireball_proj_speed
			disarray_effect.fireball_bonus_base_dmg_scale = disarray_fireball_bonus_base_dmg_scale
			disarray_effect.fireball_bonus_on_hit_dmg_scale = disarray_fireball_bonus_on_hit_dmg_scale
			disarray_effect.fireball_black_beam_count_for_summon = disarray_fireball_black_beam_count_for_summon
			
		elif curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
			disarray_effect.beam_base_damage = disarray_beam_base_damage_tier_2
			disarray_effect.beam_applies_on_hit_effects = disarray_beam_applies_on_hit_effects_tier_2
			disarray_effect.fireball_enabled = false
			
		
		
		arg_tower.add_tower_effect(disarray_effect)



func _unapply_disarray_effects_from_game():
	var all_towers = _get_all_black_towers()
	
	for tower in all_towers:
		_unapply_disarray_effects_from_tower(tower)

func _unapply_disarray_effects_from_tower(arg_tower):
	var disarray_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.BLACK_BLACK_BEAM_AM)
	if disarray_effect != null:
		arg_tower.remove_tower_effect(disarray_effect)


# Overflow related


func _on_overflow_path_selected():
	if curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
		_apply_overflow_effects_to_game(curr_tier)
	

func _apply_overflow_effects_to_game(arg_tier : int):
	var all_towers = _get_all_black_towers()
	for tower in all_towers:
		_apply_overflow_effects_to_tower(tower)
	

func _apply_overflow_effects_to_tower(arg_tower):
	if !arg_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLACK_OVERKILL_ATTKMOD_GIVER):
		var overflow_effect := TowerEffect_DomSyn_Black_OverkillExplosionAMGiver.new()
		overflow_effect.explosion_scale = overflow_overkill_explosion_base_scale
		overflow_effect.explosion_pierce = overflow_overkill_explosion_pierce
		
		overflow_effect.initial_delay_before_damage_scale = overflow_idle_time_for_scale_to_start
		overflow_effect.base_damage_scale_after_initial = overflow_damage_scale_base_amount
		overflow_effect.bonus_scale_per_second_after_delay = overflow_damage_scale_per_second
		overflow_effect.max_scale_including_base = overflow_total_max_damage_scale
		
		if curr_tier <= SYN_TIER_PATH_ADV_LEVEL:
			overflow_effect.overkill_ratio_damage = overflow_overkill_damage_ratio_tier_1
			overflow_effect.can_summon_overkill_explosion_from_overkill_explosion = overflow_overkill_can_summon_overkill_explosion_tier_1
			
		if curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
			overflow_effect.overkill_ratio_damage = overflow_overkill_damage_ratio_tier_2
			overflow_effect.can_summon_overkill_explosion_from_overkill_explosion = overflow_overkill_can_summon_overkill_explosion_tier_2
			
		
		arg_tower.add_tower_effect(overflow_effect)


func _unapply_overflow_effects_from_game():
	var all_towers = _get_all_black_towers()
	
	for tower in all_towers:
		_unapply_overflow_effects_from_tower(tower)

func _unapply_overflow_effects_from_tower(arg_tower):
	var overflow_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.BLACK_OVERKILL_ATTKMOD_GIVER)
	if overflow_effect != null:
		arg_tower.remove_tower_effect(overflow_effect)


# Capactior related

func _on_capacitor_path_selected():
	if curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
		_apply_capacitor_effects_to_game(curr_tier)
	
	_clean_up_capacitor_states()

func _apply_capacitor_effects_to_game(arg_tier : int):
	if curr_tier <= SYN_TIER_PATH_ADV_LEVEL:
		pass
	elif curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
		pass
	
	if _capacitor_lightning_queue_timer == null:
		_capacitor_lightning_queue_timer = Timer.new()
		_capacitor_lightning_queue_timer.one_shot = true
		_capacitor_lightning_queue_timer.connect("timeout", self, "_timer_for_lightning_queue_finished", [], CONNECT_PERSIST)
		game_elements.get_tree().get_root().add_child(_capacitor_lightning_queue_timer)
	
	if _capacitor_lightning_delay_for_next_lightning_timer == null:
		_capacitor_lightning_delay_for_next_lightning_timer = Timer.new()
		_capacitor_lightning_delay_for_next_lightning_timer.one_shot = true
		_capacitor_lightning_delay_for_next_lightning_timer.connect("timeout", self, "_timer_for_next_lightning_finished", [], CONNECT_PERSIST)
		game_elements.get_tree().get_root().add_child(_capacitor_lightning_delay_for_next_lightning_timer)
	
	if _capacitor_lightning_from_ground_to_strike_timer == null:
		_capacitor_lightning_from_ground_to_strike_timer = Timer.new()
		_capacitor_lightning_from_ground_to_strike_timer.one_shot = true
		game_elements.get_tree().get_root().add_child(_capacitor_lightning_from_ground_to_strike_timer)
	
	if _capacitor_lightning_explosion_attack_module == null:
		_capacitor_lightning_explosion_attack_module = AOEAttackModule_Scene.instance()
		
		_capacitor_lightning_explosion_attack_module.base_damage = 0
		_capacitor_lightning_explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
		_capacitor_lightning_explosion_attack_module.base_attack_speed = 0
		_capacitor_lightning_explosion_attack_module.base_attack_wind_up = 0
		_capacitor_lightning_explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
		_capacitor_lightning_explosion_attack_module.is_main_attack = false
		_capacitor_lightning_explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
		_capacitor_lightning_explosion_attack_module.base_explosion_scale = 1.5
		
		_capacitor_lightning_explosion_attack_module.benefits_from_bonus_explosion_scale = false
		_capacitor_lightning_explosion_attack_module.benefits_from_bonus_base_damage = false
		_capacitor_lightning_explosion_attack_module.benefits_from_bonus_attack_speed = false
		_capacitor_lightning_explosion_attack_module.benefits_from_bonus_on_hit_damage = false
		_capacitor_lightning_explosion_attack_module.benefits_from_bonus_on_hit_effect = true
		
		
		var sprite_frames = SpriteFrames.new()
		sprite_frames.add_frame("default", Black_LightningExplosion_Pic01)
		sprite_frames.add_frame("default", Black_LightningExplosion_Pic02)
		sprite_frames.add_frame("default", Black_LightningExplosion_Pic03)
		sprite_frames.add_frame("default", Black_LightningExplosion_Pic04)
		sprite_frames.add_frame("default", Black_LightningExplosion_Pic05)
		sprite_frames.add_frame("default", Black_LightningExplosion_Pic06)
		sprite_frames.add_frame("default", Black_LightningExplosion_Pic07)
		
		_capacitor_lightning_explosion_attack_module.aoe_sprite_frames = sprite_frames
		_capacitor_lightning_explosion_attack_module.sprite_frames_only_play_once = true
		_capacitor_lightning_explosion_attack_module.pierce = capacitor_lightning_enemy_explosion_pierce
		_capacitor_lightning_explosion_attack_module.duration = 0.5
		_capacitor_lightning_explosion_attack_module.damage_repeat_count = 1
		
		_capacitor_lightning_explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
		_capacitor_lightning_explosion_attack_module.base_aoe_scene = BaseAOE_Scene
		_capacitor_lightning_explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
		
		_capacitor_lightning_explosion_attack_module.can_be_commanded_by_tower = false
		
		#
		
		var percent_modi_damage = PercentModifier.new(StoreOfTowerEffectsUUID.BLACK_CAPACITOR_LIGHTNING_PERCENT_ON_HIT_DMG)
		percent_modi_damage.percent_amount = capacitor_lightning_enemy_damage_percent
		percent_modi_damage.percent_based_on = PercentType.MAX
		percent_modi_damage.flat_maximum = capacitor_lightning_enemy_damage_max_amount
		percent_modi_damage.flat_minimum = 0
		percent_modi_damage.ignore_flat_limits = false
		
		var on_hit_dmg = OnHitDamage.new(StoreOfTowerEffectsUUID.BLACK_CAPACITOR_LIGHTNING_PERCENT_ON_HIT_DMG, percent_modi_damage, DamageType.ELEMENTAL)
		var on_hit_dmg_as_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.BLACK_CAPACITOR_LIGHTNING_PERCENT_ON_HIT_DMG)
		
		_capacitor_lightning_explosion_attack_module.on_hit_damage_adder_effects[on_hit_dmg_as_effect.effect_uuid] = on_hit_dmg_as_effect
		
		
		#var enemy_effect : EnemyStunEffect = EnemyStunEffect.new(capacitor_lightning_, StoreOfEnemyEffectsUUID.BLACK_CAPACITOR_LIGHTNING_STUN_EFFECT)
		#var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.BLACK_CAPACITOR_LIGHTNING_STUN_ON_HIT_EFFECT)
		
		#_capacitor_lightning_explosion_attack_module.module.on_hit_effects[tower_effect.effect_uuid] = tower_effect
		
		#
		
		game_elements.get_tree().get_root().add_child(_capacitor_lightning_explosion_attack_module)
	
	black_syn_icon.set_visibility_of_nova_counter(true)
	
	var all_towers = _get_all_black_towers()
	for tower in all_towers:
		_apply_capacitor_effects_to_tower(tower)

func _apply_capacitor_effects_to_tower(arg_tower):
	if !arg_tower.is_connected("on_tower_ability_before_cast_start", self, "_on_tower_before_ability_casted"):
		arg_tower.connect("on_tower_ability_before_cast_start", self, "_on_tower_before_ability_casted", [], CONNECT_PERSIST)




func _unapply_capacitor_effects_from_game():
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_unapply_capacitor_effects_from_tower(tower)

func _unapply_capacitor_effects_from_tower(arg_tower):
	if arg_tower.is_connected("on_tower_ability_before_cast_start", self, "_on_tower_before_ability_casted"):
		arg_tower.disconnect("on_tower_ability_before_cast_start", self, "_on_tower_before_ability_casted")



# Capacitor Nova

func _on_tower_before_ability_casted(cd, ability):
	if game_elements.stage_round_manager.round_started:
		if _capacitor_current_cast_count_in_round < capacitor_ability_cast_count_requirement:
			_capacitor_current_cast_count_in_round += 1
		else:
			_capacitor_current_cast_count_in_round = capacitor_ability_cast_count_requirement
		
		black_syn_icon.set_nova_counter(capacitor_ability_cast_count_requirement - _capacitor_current_cast_count_in_round)
		
		if !_capacitor_nova_created_in_round and _capacitor_current_cast_count_in_round >= capacitor_ability_cast_count_requirement:
			_summon_nova()

func _summon_nova():
	_capacitor_nova_created_in_round = true
	
	var nova = Black_Capacitor_Nova_Scene.instance()
	nova.connect("tree_exiting", self, "_on_nova_tree_exiting", [nova], CONNECT_ONESHOT)
	nova.modulate.a = 0.6
	nova.lifetime = capacitor_nova_ramp_up_time
	game_elements.get_tree().get_root().add_child(nova)
	nova.global_position = game_elements.get_middle_coordinates_of_playable_map()
	
	_capacitor_nova_particle = nova
	

func _on_nova_tree_exiting(arg_nova):
	if game_elements.stage_round_manager.round_started:
		_on_nova_detonated__start_effects(arg_nova)


func _on_nova_detonated__start_effects(arg_nova):
	var all_towers = _get_all_black_towers()
	
	_summon_nova_aesthetic_explosion(arg_nova)
	_give_towers_capacitor_nova_effects(all_towers)
	_give_enemies_capacitor_nova_effects()
	
	if curr_tier <= SYN_TIER_PATH_ADV_LEVEL:
		_start_lightning_queue()


func _summon_nova_aesthetic_explosion(arg_nova):
	var pos_to_summon = arg_nova.global_position
	
	var explosion = ExpandingAttackSprite_Scene.instance()
	explosion.scale_of_scale = 8.2
	explosion.modulate.a = 0.6
	explosion.transparency_per_sec = 0.6
	explosion.lifetime = 1
	explosion.lifetime_to_start_transparency = 1
	explosion.global_position = pos_to_summon
	explosion.queue_free_at_end_of_lifetime = true
	
	var sp = SpriteFrames.new()
	sp.add_frame("default", Black_Nova_Explosion01)
	explosion.frames = sp
	
	game_elements.get_tree().get_root().add_child(explosion)
	

func _give_towers_capacitor_nova_effects(arg_towers):
	for tower in arg_towers:
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.BLACK_CAPACITOR_NOVA_AP_EFFECT)
		
		if curr_tier <= SYN_TIER_PATH_ADV_LEVEL:
			base_ap_attr_mod.flat_modifier = capacitor_ap_buff_amount_tier_1
		elif curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
			base_ap_attr_mod.flat_modifier = capacitor_ap_buff_amount_tier_2
		
		var ap_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.BLACK_CAPACITOR_NOVA_AP_EFFECT)
		ap_attr_effect.is_roundbound = true
		ap_attr_effect.round_count = 1
		ap_attr_effect.status_bar_icon = Black_NovaAPEffect_StatusBarIcon
		
		if curr_tier <= SYN_TIER_PATH_ADV_LEVEL:
			ap_attr_effect.is_timebound = capacitor_buff_duration_tier_1 > 0
			ap_attr_effect.time_in_seconds = capacitor_buff_duration_tier_1
			
		elif curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
			ap_attr_effect.is_timebound = capacitor_buff_duration_tier_2 > 0
			ap_attr_effect.time_in_seconds = capacitor_buff_duration_tier_2
		
		tower.add_tower_effect(ap_attr_effect)
		
		#
		
		var cooldown_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.BLACK_CAPACITOR_NOVA_CDR_EFFECT)
		cooldown_modi.percent_based_on = PercentType.BASE
		
		
		if curr_tier <= SYN_TIER_PATH_ADV_LEVEL:
			cooldown_modi.percent_amount = capacitor_cdr_buff_amount_tier_1
		elif curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
			cooldown_modi.percent_amount = capacitor_cdr_buff_amount_tier_2
		
		var cdr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_ABILITY_CDR, cooldown_modi, StoreOfTowerEffectsUUID.BLACK_CAPACITOR_NOVA_CDR_EFFECT)
		cdr_effect.is_roundbound = true
		cdr_effect.round_count = 1
		
		if curr_tier <= SYN_TIER_PATH_ADV_LEVEL:
			cdr_effect.is_timebound = capacitor_buff_duration_tier_1 > 0
			cdr_effect.time_in_seconds = capacitor_buff_duration_tier_1
			
		elif curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
			cdr_effect.is_timebound = capacitor_buff_duration_tier_2 > 0
			cdr_effect.time_in_seconds = capacitor_buff_duration_tier_2
		
		tower.add_tower_effect(cdr_effect)
		
		#
		
		var percent_amount : float
		if curr_tier <= SYN_TIER_PATH_ADV_LEVEL:
			percent_amount = capacitor_ongoing_cooldown_percent_reduction_tier_1
		elif curr_tier <= SYN_TIER_PATH_BASIC_LEVEL:
			percent_amount = capacitor_ongoing_cooldown_percent_reduction_tier_2
		
		_reduce_current_cooldowns_of_tower_by_percent(tower, percent_amount, capacitor_nova_ongoing_cooldown_percent_type)
		

func _reduce_current_cooldowns_of_tower_by_percent(arg_tower, arg_percent_amount, arg_percent_type):
	var all_tower_abilities = arg_tower.all_tower_abiltiies
	for ability in all_tower_abilities:
		ability.time_decreased_by_percent(arg_percent_amount, arg_percent_type)
	


func _give_enemies_capacitor_nova_effects():
	var all_enemies = game_elements.enemy_manager.get_all_targetable_and_invisible_enemies()
	
	var stun_effect = EnemyStunEffect.new(capacitor_nova_stun_time, StoreOfEnemyEffectsUUID.BLACK_CAPACITOR_NOVA_STUN_EFFECT)
	stun_effect.is_from_enemy = false
	
	for enemy in all_enemies:
		enemy._add_effect(stun_effect)
	
	#
	
	game_elements.enemy_manager.pause_spawning(capacitor_nova_stop_enemy_spawn_time)

func _start_lightning_queue():
	_queued_for_lightning = true
	
	_capacitor_lightning_queue_timer.start(capacitor_lightning_delay_after_nova)


func _timer_for_lightning_queue_finished():
	if _queued_for_lightning and game_elements.stage_round_manager.round_started:
		_capacitor_current_lightning_count_to_summon = capacitor_lightning_count_tier_1
		
		_capacitor_lightning_delay_for_next_lightning_timer.start(capacitor_lightning_delay_per_strke)
		_summon_one_lightning_for_striking()
		_capacitor_current_lightning_count_to_summon -= 1

func _summon_one_lightning_for_striking():
	var entity_to_type_arr : Array = _get_random_tower_or_enemy()
	
	if entity_to_type_arr[1] == EntityType.TOWER:
		_summon_lightning_strike_onto_tower(entity_to_type_arr[0])
	elif entity_to_type_arr[1] == EntityType.ENEMY:
		_summon_lightning_strike_onto_enemy(entity_to_type_arr[0])

# returns array with [entity, type of entity as int (EntityType enum)]
func _get_random_tower_or_enemy() -> Array:
	var rng_num = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.BLACK_CAPACITOR_NOVA_LIGHTNING_TOWER_OR_ENEMY_RNG).randi_range(1, 2)
	var candidate_list
	var entity
	
	if rng_num == EntityType.TOWER:
		candidate_list = _get_all_black_towers_without_lightning_buffs()
	else:
		candidate_list = game_elements.enemy_manager.get_all_targetable_and_invisible_enemies()
	
	var entity_in_list : Array = Targeting.enemies_to_target(candidate_list, Targeting.RANDOM, 1, Vector2(0, 0), true)
	if entity_in_list.size() > 0:
		entity = entity_in_list[0]
	
	return [entity, rng_num]

func _get_all_black_towers_without_lightning_buffs() -> Array:
	var all_black_towers = _get_all_black_towers()
	var bucket : Array = []
	
	for tower in all_black_towers:
		if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLACK_CAPACITOR_LIGHTNING_AP_EFFECT):
			bucket.append(tower)
	
	return bucket



func _timer_for_next_lightning_finished():
	if _capacitor_current_lightning_count_to_summon > 0 and game_elements.stage_round_manager.round_started:
		_capacitor_current_lightning_count_to_summon -= 1
		_summon_one_lightning_for_striking()
		
		if _capacitor_current_lightning_count_to_summon > 0:
			_capacitor_lightning_delay_for_next_lightning_timer.start(capacitor_lightning_delay_per_strke)
		else:
			_queued_for_lightning = false


func _summon_lightning_strike_onto_tower(arg_tower):
	_create_lightning_into_destination(arg_tower.global_position)
	_capacitor_lightning_from_ground_to_strike_timer.connect("timeout", self, "_on_lightning_strike_hit_tower", [arg_tower], CONNECT_ONESHOT)
	_capacitor_lightning_from_ground_to_strike_timer.start(capacitor_lightning_delay_from_sky_to_ground)

func _summon_lightning_strike_onto_enemy(arg_enemy):
	_create_lightning_into_destination(arg_enemy.global_position)
	_capacitor_lightning_from_ground_to_strike_timer.connect("timeout", self, "_on_lightning_strike_hit_enemy", [arg_enemy.global_position], CONNECT_ONESHOT)
	_capacitor_lightning_from_ground_to_strike_timer.start(capacitor_lightning_delay_from_sky_to_ground)


func _create_lightning_into_destination(arg_pos : Vector2):
	var lightning = Black_CapacitorLightning_Scene.instance()
	
	game_elements.get_tree().get_root().add_child(lightning)
	lightning.global_position = arg_pos + Vector2(0, -66)
	lightning.update_destination_position(arg_pos)



func _on_lightning_strike_hit_tower(arg_tower):
	if arg_tower != null:
		_give_tower_lightning_buffs(arg_tower)

func _give_tower_lightning_buffs(arg_tower):
	var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.BLACK_CAPACITOR_LIGHTNING_AP_EFFECT)
	base_ap_attr_mod.flat_modifier = capacitor_lightning_tower_ap_amount
	
	var ap_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.BLACK_CAPACITOR_LIGHTNING_AP_EFFECT)
	ap_attr_effect.is_roundbound = true
	ap_attr_effect.round_count = 1
	ap_attr_effect.status_bar_icon = Black_LightningAPEffect_StatusBarIcon
	
	arg_tower.add_tower_effect(ap_attr_effect)
	
	#
	
	_reduce_current_cooldowns_of_tower_by_percent(arg_tower, capacitor_lightning_ongoing_cd_reduction, capacitor_lightning_ongoing_cooldown_percent_type)



func _on_lightning_strike_hit_enemy(arg_position_of_enemy):
	_create_lightning_explosion_against_enemies(arg_position_of_enemy)

func _create_lightning_explosion_against_enemies(arg_pos):
	var explosion = _capacitor_lightning_explosion_attack_module.construct_aoe(arg_pos, arg_pos)
	game_elements.get_tree().get_root().add_child(explosion)


func _on_round_end(stageround):
	_clean_up_capacitor_states()

func _clean_up_capacitor_states():
	if chosen_black_path == capacitor_path:
		_capacitor_nova_created_in_round = false
		_queued_for_lightning = false
		
		_capacitor_current_cast_count_in_round = 0
		black_syn_icon.set_nova_counter(capacitor_ability_cast_count_requirement - _capacitor_current_cast_count_in_round)
		
		_capacitor_current_lightning_count_to_summon = 0
		_capacitor_delay_for_next_lightning = 0
		#_capacitor_current_entities_hit.clear()
		
		if _capacitor_nova_particle != null and !_capacitor_nova_particle.is_queued_for_deletion():
			_capacitor_nova_particle.queue_free()
