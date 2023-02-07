extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const Smite_Explosion_01 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_01.png")
const Smite_Explosion_02 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_02.png")
const Smite_Explosion_03 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_03.png")
const Smite_Explosion_04 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_04.png")
const Smite_Explosion_05 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_05.png")
const Smite_Explosion_06 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_06.png")
const Smite_Explosion_07 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_07.png")
const Smite_Explosion_08 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_08.png")
const Fulgurant_SmiteBeam_Scene = preload("res://TowerRelated/Color_Red/Fulgurant/Fulgurant_SmiteBeam.tscn")
const Fulgurant_SmiteLaunch_Scene = preload("res://TowerRelated/Color_Red/Fulgurant/Fulgurant_SmiteLaunch.tscn")
const IngIcon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_FulgurantSmite.png")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

var smite_explosion_flat_dmg : float = 3.0
var smite_explosion_base_dmg_scale : float = 0.5
const smite_explosion_pierce : int = 3
const smite_stun_duration : float = 0.5

const smite_cooldown : float = 10.0
var smite_timer : TimerForTower

var smite_explosion_attk_module : AOEAttackModule
var smite_stun_effect : EnemyStunEffect

var smite_beam_attk_sprite_pool_component : AttackSpritePoolComponent
var smite_launch_fx_attk_sprite_pool_component : AttackSpritePoolComponent

var _attached_tower
var y_shift_of_launch_particle : float

func _init().(StoreOfTowerEffectsUUID.ING_FULGURANT):
	effect_icon = IngIcon
	
	_update_description()
	
	_can_be_scaled_by_yel_vio = true


func _update_description():
	var _flat_dmg_portion = smite_explosion_flat_dmg * _current_additive_scale
	var _base_dmg_ratio_portion = smite_explosion_base_dmg_scale * _current_additive_scale
	
	var interpreter_for_smite_dmg = TextFragmentInterpreter.new()
	interpreter_for_smite_dmg.display_body = true
	
	var outer_ins = []
	var ins = []
	ins.append(NumericalTextFragment.new(_flat_dmg_portion, false, DamageType.ELEMENTAL))
	ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
	ins.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, _base_dmg_ratio_portion, DamageType.ELEMENTAL))
	outer_ins.append(ins)
	
	outer_ins.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
	outer_ins.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
	
	interpreter_for_smite_dmg.array_of_instructions = outer_ins
	
	
	var plain_fragment__stunning = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunning")
	
	#
	
	description = ["Smite a random enemy out of range every %s s, dealing |0| to %s enemies and |1| for %s s." % [str(smite_cooldown), str(smite_explosion_pierce), str(smite_stun_duration)], [interpreter_for_smite_dmg, plain_fragment__stunning]]

#

func _make_modifications_to_tower(tower):
	if !is_instance_valid(smite_explosion_attk_module):
		_attached_tower = tower
		y_shift_of_launch_particle = _attached_tower.get_current_anim_size().y
		
		_construct_smite_explosion_attk_module()
		_construct_attk_sprite_pool_components()
		_construct_smite_timer()
		
		tower.add_attack_module(smite_explosion_attk_module)
		
		smite_timer.start(smite_cooldown)
	

func _construct_smite_explosion_attk_module():
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = smite_explosion_base_dmg_scale
	explosion_attack_module.base_damage = smite_explosion_flat_dmg / explosion_attack_module.base_damage_scale
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.base_explosion_scale = 1.5
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Smite_Explosion_01)
	sprite_frames.add_frame("default", Smite_Explosion_02)
	sprite_frames.add_frame("default", Smite_Explosion_03)
	sprite_frames.add_frame("default", Smite_Explosion_04)
	sprite_frames.add_frame("default", Smite_Explosion_05)
	sprite_frames.add_frame("default", Smite_Explosion_06)
	sprite_frames.add_frame("default", Smite_Explosion_07)
	sprite_frames.add_frame("default", Smite_Explosion_08)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = smite_explosion_pierce
	explosion_attack_module.duration = 0.32
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(IngIcon)
	
	smite_explosion_attk_module = explosion_attack_module
	
	#
	
	smite_stun_effect = EnemyStunEffect.new(smite_stun_duration, StoreOfEnemyEffectsUUID.FULGURANT_ING_SMITE_STUN_EFFECT)

func _construct_attk_sprite_pool_components():
	smite_beam_attk_sprite_pool_component = AttackSpritePoolComponent.new()
	smite_beam_attk_sprite_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	smite_beam_attk_sprite_pool_component.node_to_listen_for_queue_free = _attached_tower
	smite_beam_attk_sprite_pool_component.source_for_funcs_for_attk_sprite = self
	smite_beam_attk_sprite_pool_component.func_name_for_creating_attack_sprite = "_create_smite_lightning"
	
	smite_launch_fx_attk_sprite_pool_component = AttackSpritePoolComponent.new()
	smite_launch_fx_attk_sprite_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	smite_launch_fx_attk_sprite_pool_component.node_to_listen_for_queue_free = _attached_tower
	smite_launch_fx_attk_sprite_pool_component.source_for_funcs_for_attk_sprite = self
	smite_launch_fx_attk_sprite_pool_component.func_name_for_creating_attack_sprite = "_create_smite_launch"

func _construct_smite_timer():
	smite_timer = TimerForTower.new()
	smite_timer.set_tower_and_properties(_attached_tower)
	smite_timer.one_shot = false
	smite_timer.connect("timeout", self, "_on_smite_timer_timeout", [], CONNECT_PERSIST)
	smite_timer.stop_on_round_end_instead_of_pause = false
	
	_attached_tower.add_child(smite_timer)

#

func _undo_modifications_to_tower(arg_tower):
	if is_instance_valid(smite_explosion_attk_module):
		_attached_tower.remove_attack_module(smite_explosion_attk_module)
		smite_explosion_attk_module.queue_free()
	
	if is_instance_valid(smite_timer):
		smite_timer.queue_free()



#

func _on_smite_timer_timeout():
	if is_instance_valid(_attached_tower) and _attached_tower.is_current_placable_in_map():
		var targets = _get_targets_for_smite()
		if targets.size() > 0:
			_summon_smite_launch_particle(targets[0].global_position)

func _get_targets_for_smite():
	if is_instance_valid(_attached_tower.range_module):
		return _attached_tower.range_module.get_all_targetable_enemies_outside_of_range(Targeting.RANDOM, 1, false)
	else:
		return []



func _summon_smite_launch_particle(arg_pos):
	var launch_particle = smite_launch_fx_attk_sprite_pool_component.get_or_create_attack_sprite_from_pool()
	launch_particle.lifetime = 0.25
	launch_particle.frame = 0
	
	launch_particle.global_position = _attached_tower.global_position - Vector2(0, y_shift_of_launch_particle)
	launch_particle.visible = true
	
	if launch_particle.is_connected("animation_finished", self, "_on_smite_launch_animation_ended"):
		launch_particle.disconnect("animation_finished", self, "_on_smite_launch_animation_ended")
	launch_particle.connect("animation_finished", self, "_on_smite_launch_animation_ended", [arg_pos], CONNECT_ONESHOT)


func _create_smite_launch():
	var launch_sprite = Fulgurant_SmiteLaunch_Scene.instance()
	launch_sprite.modulate.a = 0.6
	
	launch_sprite.queue_free_at_end_of_lifetime = false
	
	return launch_sprite

func _on_smite_launch_animation_ended(arg_pos):
	_summon_smite_lightning_onto_pos(arg_pos)



func _summon_smite_lightning_onto_pos(arg_pos):
	var smite_lightning = smite_beam_attk_sprite_pool_component.get_or_create_attack_sprite_from_pool()
	smite_lightning.lifetime = 0.25
	smite_lightning.frame = 0
	
	smite_lightning.global_position = arg_pos
	smite_lightning.visible = true
	

func _create_smite_lightning():
	var smite_lightning = Fulgurant_SmiteBeam_Scene.instance()
	
	smite_lightning.scale *= 2
	smite_lightning.offset.y -= smite_lightning.get_sprite_size().y / 2.0
	smite_lightning.modulate.a = 0.6
	
	smite_lightning.queue_free_at_end_of_lifetime = false
	
	smite_lightning.connect("animation_finished", self, "_on_smite_lightning_animation_ended", [smite_lightning])
	
	return smite_lightning


func _on_smite_lightning_animation_ended(arg_lightning):
	if is_instance_valid(smite_explosion_attk_module):
		var pos = arg_lightning.global_position
		var explosion = smite_explosion_attk_module.construct_aoe(pos, pos)
		explosion.modulate.a = 0.6
		explosion.damage_instance.on_hit_effects[smite_stun_effect.effect_uuid] = smite_stun_effect
		explosion.damage_instance.scale_only_damage_by(_attached_tower.last_calculated_final_ability_potency)
		
		smite_explosion_attk_module.set_up_aoe__add_child_and_emit_signals(explosion)

#

func _shallow_duplicate():
	var copy = get_script().new()
	_configure_copy_to_match_self(copy)
	
	return copy

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	smite_explosion_flat_dmg *= _current_additive_scale
	smite_explosion_base_dmg_scale *= _current_additive_scale
	_current_additive_scale = 1
