extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")
const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const ConditionalClause = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const BreezeAbility_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/Ability_Breeze_Icon.png")
const ManaBlast_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/Ability_ManaBlast_Icon.png")

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const BaseTowerDetectingAOE = preload("res://EnemyRelated/TowerInteractingRelated/Spawnables/BaseTowerDetectingAOE.gd")
const BaseTowerDetectingAOE_Scene = preload("res://EnemyRelated/TowerInteractingRelated/Spawnables/BaseTowerDetectingAOE.tscn")
const TD_AOEAttackModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TD_AOEAttackModule.gd")
const TD_AOEAttackModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TD_AOEAttackModule.tscn")

const ManaBurst_Mark_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_Mark.tscn")
const ManaBurst_Exp_Pic01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_01.png")
const ManaBurst_Exp_Pic02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_02.png")
const ManaBurst_Exp_Pic03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_03.png")
const ManaBurst_Exp_Pic04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_04.png")
const ManaBurst_Exp_Pic05 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_05.png")
const ManaBurst_Exp_Pic06 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_06.png")
const ManaBurst_Exp_Pic07 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_07.png")


var game_elements : GameElements
var enemy_manager : EnemyManager

#
var breeze_ability : BaseAbility
const base_breeze_ability_cooldown : float = 28.0

const base_breeze_first_slow_amount : float = -50.0
const base_breeze_first_slow_duration : float = 4.0
var breeze_first_slow_modifier : PercentModifier
var breeze_first_slow_effect : EnemyAttributesEffect

const base_breeze_second_slow_amount : float = -15.0
const base_breeze_second_slow_duration : float = 6.0 + base_breeze_first_slow_duration
var breeze_second_slow_modifier : PercentModifier
var breeze_second_slow_effect : EnemyAttributesEffect

const base_breeze_damage : float = 1.0

#
var mana_blast_ability : BaseAbility
const mana_blast_ability_cooldown : float = 40.0

var mana_blast_module : AOEAttackModule
const mana_blast_base_damage : float = 10.0
const mana_blast_extra_main_target_dmg_scale : float = 2.0

var mana_blast_buff_aoe_module : TD_AOEAttackModule
var mana_blast_buff_tower_effect : TowerAttributesEffect
const mana_blast_ap_buff_amount : float = 0.75
const mana_blast_buff_duration : float = 12.0

#



func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
		enemy_manager = game_elements.enemy_manager
	
	if tier <= 3:
		if breeze_ability == null:
			_construct_breeze_ability()
	
	if tier <= 2:
		if mana_blast_ability == null:
			_construct_mana_blast_relateds()
	
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


func register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	game_elements.ability_manager.add_ability(ability, add_to_panel)


# Breeze related

func _construct_breeze_ability():
	breeze_ability = BaseAbility.new()
	
	breeze_ability.is_timebound = true
	breeze_ability.connect("ability_activated", self, "_breeze_ability_activated", [], CONNECT_PERSIST)
	breeze_ability.icon = BreezeAbility_Pic
	
	breeze_ability.set_properties_to_usual_synergy_based()
	breeze_ability.synergy = self
	
	breeze_ability.descriptions = [
		"Slows all enemies by 50% for 4 seconds, then slows by 15% for 6 seconds. Also deals 1 elemental damage.",
		"Cooldown : 28s",
		"",
		"Ability potency increases the slow percentage and the damage."
	]
	breeze_ability.display_name = "Breeze"
	
	breeze_ability.set_properties_to_auto_castable()
	breeze_ability.auto_cast_func = "_breeze_ability_activated"
	
	register_ability_to_manager(breeze_ability)
	
	# breeze first slow
	breeze_first_slow_modifier = PercentModifier.new(StoreOfEnemyEffectsUUID.BLUE_BREEZE_FIRST_SLOW)
	breeze_first_slow_modifier.percent_amount = base_breeze_first_slow_amount
	breeze_first_slow_modifier.percent_based_on = PercentType.BASE
	
	breeze_first_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, breeze_first_slow_modifier, StoreOfEnemyEffectsUUID.BLUE_BREEZE_FIRST_SLOW)
	breeze_first_slow_effect.is_timebound = true
	breeze_first_slow_effect.time_in_seconds = base_breeze_first_slow_duration
	
	# breeze second slow
	breeze_second_slow_modifier = PercentModifier.new(StoreOfEnemyEffectsUUID.BLUE_BREEZE_SECOND_SLOW)
	breeze_second_slow_modifier.percent_amount = base_breeze_second_slow_amount
	breeze_second_slow_modifier.percent_based_on = PercentType.BASE
	
	breeze_second_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, breeze_second_slow_modifier, StoreOfEnemyEffectsUUID.BLUE_BREEZE_SECOND_SLOW)
	breeze_second_slow_effect.is_timebound = true
	breeze_second_slow_effect.time_in_seconds = base_breeze_second_slow_duration


func _breeze_ability_activated():
	var final_ap_scale : float = breeze_ability.get_potency_to_use(1)
	breeze_first_slow_modifier.percent_amount = base_breeze_first_slow_amount * final_ap_scale
	breeze_second_slow_modifier.percent_amount = base_breeze_second_slow_amount * final_ap_scale
	
	var dmg_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.BREEZE_DAMAGE)
	dmg_modi.flat_modifier = base_breeze_damage * final_ap_scale
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.BREEZE_DAMAGE, dmg_modi, DamageType.ELEMENTAL)
	var dmg_instance : DamageInstance = DamageInstance.new()
	dmg_instance.on_hit_damages[StoreOfTowerEffectsUUID.BREEZE_DAMAGE] = on_hit_dmg
	dmg_instance.on_hit_effects[StoreOfEnemyEffectsUUID.BLUE_BREEZE_FIRST_SLOW] = breeze_first_slow_effect
	dmg_instance.on_hit_effects[StoreOfEnemyEffectsUUID.BLUE_BREEZE_SECOND_SLOW] = breeze_second_slow_effect
	
	for enemy in enemy_manager.get_all_enemies():
		call_deferred("_apply_breeze_to_enemy", enemy, dmg_instance)
	
	breeze_ability.start_time_cooldown(base_breeze_ability_cooldown)

func _apply_breeze_to_enemy(enemy, dmg_instance):
	enemy.hit_by_damage_instance(dmg_instance)


# Mana Blast

func _construct_mana_blast_relateds():
	mana_blast_ability = BaseAbility.new()
	
	mana_blast_ability.is_timebound = true
	mana_blast_ability.connect("ability_activated", self, "_mana_blast_ability_activated", [], CONNECT_PERSIST)
	mana_blast_ability.icon = ManaBlast_Pic
	
	mana_blast_ability.set_properties_to_usual_synergy_based()
	mana_blast_ability.synergy = self
	
	mana_blast_ability.descriptions = [
		"After a brief delay, summon a blast of mana to the strongest enemy's location.",
		"The blast deals 30 damage to the main target, and deals 33% of that damage to secondary targets.",
		"Towers caught in the blast gain 0.75 ability potency for 12 seconds.",
		"Cooldown: 40s"
		
	]
	mana_blast_ability.display_name = "Mana Blast"
	
	mana_blast_ability.set_properties_to_auto_castable()
	mana_blast_ability.auto_cast_func = "_mana_blast_ability_activated"
	
	register_ability_to_manager(mana_blast_ability)
	
	# aoe module
	
	mana_blast_module = AOEAttackModule_Scene.instance()
	
	mana_blast_module.base_damage = mana_blast_base_damage
	mana_blast_module.base_damage_type = DamageType.ELEMENTAL
	mana_blast_module.base_attack_speed = 0
	mana_blast_module.base_attack_wind_up = 0
	mana_blast_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	mana_blast_module.is_main_attack = true
	mana_blast_module.module_id = StoreOfAttackModuleID.MAIN
	
	mana_blast_module.benefits_from_bonus_explosion_scale = true
	mana_blast_module.benefits_from_bonus_base_damage = true
	mana_blast_module.benefits_from_bonus_attack_speed = false
	mana_blast_module.benefits_from_bonus_on_hit_damage = true
	mana_blast_module.benefits_from_bonus_on_hit_effect = true
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic01)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic02)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic03)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic04)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic05)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic06)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic07)
	
	mana_blast_module.aoe_sprite_frames = sprite_frames
	mana_blast_module.sprite_frames_only_play_once = true
	mana_blast_module.pierce = -1
	mana_blast_module.duration = 0.3
	mana_blast_module.damage_repeat_count = 1
	
	mana_blast_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	mana_blast_module.base_aoe_scene = BaseAOE_Scene
	mana_blast_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	mana_blast_module.can_be_commanded_by_tower = false
	
	game_elements.add_child(mana_blast_module)
	
	
	# mana blast buff
	
	mana_blast_buff_aoe_module = TD_AOEAttackModule_Scene.instance()
	
	var buff_sprite_frames = SpriteFrames.new()
	buff_sprite_frames.add_frame("default", ManaBurst_Exp_Pic01)
	
	mana_blast_buff_aoe_module.aoe_sprite_frames = buff_sprite_frames
	mana_blast_buff_aoe_module.sprite_frames_only_play_once = true
	mana_blast_buff_aoe_module.pierce = -1
	mana_blast_buff_aoe_module.duration = 0.3
	mana_blast_buff_aoe_module.damage_repeat_count = 1
	
	mana_blast_buff_aoe_module.aoe_default_coll_shape = BaseTowerDetectingAOE.BaseAOEDefaultShapes.CIRCLE
	mana_blast_buff_aoe_module.base_aoe_scene = BaseTowerDetectingAOE_Scene
	mana_blast_buff_aoe_module.spawn_location_and_change = TD_AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	game_elements.add_child(mana_blast_buff_aoe_module)
	
	
	var buff_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.MANA_BLAST_BONUS_AP)
	buff_modi.flat_modifier = mana_blast_ap_buff_amount
	
	mana_blast_buff_tower_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, buff_modi, StoreOfTowerEffectsUUID.MANA_BLAST_BONUS_AP)
	mana_blast_buff_tower_effect.time_in_seconds = mana_blast_buff_duration
	mana_blast_buff_tower_effect.is_timebound = true


func _mana_blast_ability_activated():
	var enemies : Array = Targeting.enemies_to_target(enemy_manager.get_all_enemies(), Targeting.STRONGEST, 1, Vector2(0, 0))
	if enemies.size() >= 1:
		_place_marker(enemies[0])
		mana_blast_ability.start_time_cooldown(mana_blast_ability_cooldown)

func _place_marker(enemy):
	var marker = ManaBurst_Mark_Scene.instance()
	marker.frames_based_on_lifetime = true
	marker.lifetime = 0.6
	marker.global_position = enemy.global_position
	
	marker.connect("tree_exiting", self, "_marker_expire", [marker, enemy], CONNECT_ONESHOT)
	game_elements.get_tree().get_root().add_child(marker)

func _marker_expire(marker : Node2D, enemy):
	var pos := marker.global_position
	var explosion = mana_blast_module.construct_aoe(pos, pos)
	
	explosion.scale *= 3
	explosion.global_position = marker.global_position
	explosion.connect("before_enemy_hit_aoe", self, "_on_explosion_hit_enemy", [enemy], CONNECT_DEFERRED)
	
	game_elements.get_tree().get_root().add_child(explosion)
	_summon_tower_detecting_aoe(marker.global_position)


func _summon_tower_detecting_aoe(pos : Vector2):
	var aoe = mana_blast_buff_aoe_module.construct_aoe(pos, pos)
	aoe.scale *= 3
	aoe.global_position = pos
	aoe.modulate = Color(0, 0, 0, 0)
	aoe.coll_source_layer = CollidableSourceAndDest.Source.FROM_TOWER
	
	aoe.connect("on_tower_hit", self, "_on_buff_aoe_hit_tower", [])
	game_elements.get_tree().get_root().add_child(aoe)


func _on_explosion_hit_enemy(enemy, main_enemy):
	if enemy == main_enemy and main_enemy != null:
		var dmg_instance = mana_blast_module.construct_damage_instance()
		main_enemy.hit_by_damage_instance(dmg_instance.get_copy_damage_only_scaled_by(mana_blast_extra_main_target_dmg_scale))

func _on_buff_aoe_hit_tower(tower):
	tower.add_tower_effect(mana_blast_buff_tower_effect._shallow_duplicate())




# GIDEAS

# for last tier, make 3rd blue ability casted have special/empowered effect
