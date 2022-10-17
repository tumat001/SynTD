extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")


const Prominence_SwordBeam_Pic01 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_01.png")
const Prominence_SwordBeam_Pic02 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_02.png")
const Prominence_SwordBeam_Pic03 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_03.png")
const Prominence_SwordBeam_Pic04 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_04.png")
const Prominence_SwordBeam_Pic05 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_05.png")
const Prominence_SwordBeam_Pic06 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_06.png")
const Prominence_SwordBeam_Pic07 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_07.png")
const Prominence_SwordBeam_Pic08 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_08.png")

const Prominence_SwordBeam_Explosion_Pic01 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion01.png")
const Prominence_SwordBeam_Explosion_Pic02 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion02.png")
const Prominence_SwordBeam_Explosion_Pic03 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion03.png")
const Prominence_SwordBeam_Explosion_Pic04 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion04.png")
const Prominence_SwordBeam_Explosion_Pic05 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion05.png")
const Prominence_SwordBeam_Explosion_Pic06 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion06.png")
const Prominence_SwordBeam_Explosion_Pic07 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion07.png")
const Prominence_SwordBeam_Explosion_Pic08 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion08.png")
const Prominence_SwordBeam_Explosion_Pic09 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion09.png")

const EffectIcon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Prominence.png")
const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const main_attack_trigger_count : int = 5
const explosion_pierce : int = 3
var explosion_base_damage_ratio : float = 2.0


var _attached_tower


var _current_attack_count : int = 0

var beam_attack_module : WithBeamInstantDamageAttackModule
var explosion_attk_module : AOEAttackModule


func _init().(StoreOfTowerEffectsUUID.ING_PROMINENCE):
	effect_icon = EffectIcon
	_update_description()
	
	_can_be_scaled_by_yel_vio = true

func _update_description():
	
	var interpreter_for_sword_dmg = TextFragmentInterpreter.new()
	interpreter_for_sword_dmg.display_body = true
	interpreter_for_sword_dmg.display_header = true
	interpreter_for_sword_dmg.header_description = "damage"
	
	var ins_for_sword_dmg = []
	ins_for_sword_dmg.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, explosion_base_damage_ratio * _current_additive_scale, DamageType.PHYSICAL))
	
	interpreter_for_sword_dmg.array_of_instructions = ins_for_sword_dmg
	
	var plain_fragment__ability_cast = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "ability cast")
	
	
	description = ["After every |0| or %s main attack, fire a beam that explodes at the current target, dealing |1| to %s enemies.%s" % [str(main_attack_trigger_count) + "th", str(explosion_pierce), _generate_desc_for_persisting_total_additive_scaling(true)], [plain_fragment__ability_cast, interpreter_for_sword_dmg]]


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	if !tower.is_connected("on_main_attack", self, "_on_tower_main_attack"):
		tower.connect("on_main_attack", self, "_on_tower_main_attack", [], CONNECT_PERSIST)
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
		tower.connect("on_tower_ability_after_cast_end", self, "_on_tower_casted_ability", [], CONNECT_PERSIST)
	
	if beam_attack_module == null:
		_construct_and_add_beam_attack_module()
	
	if explosion_attk_module == null:
		_construct_and_add_explosion_attack_module()

#

func _construct_and_add_beam_attack_module():
	beam_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	beam_attack_module.base_damage = 0
	beam_attack_module.base_damage_type = DamageType.PHYSICAL
	beam_attack_module.base_attack_speed = 10
	beam_attack_module.base_attack_wind_up = 1.0 / 0.15
	beam_attack_module.is_main_attack = false
	beam_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	#beam_attack_module.position.y -= sword_epicenter_y_shift
	beam_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	beam_attack_module.on_hit_damage_scale = 0
	
	beam_attack_module.benefits_from_bonus_attack_speed = false
	beam_attack_module.benefits_from_bonus_base_damage = false
	beam_attack_module.benefits_from_bonus_on_hit_damage = false
	beam_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	beam_attack_module.commit_to_targets_of_windup = true
	beam_attack_module.fill_empty_windup_target_slots = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic01)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic02)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic03)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic04)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic05)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic06)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic07)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic08)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 8 / 0.15)
	
	beam_attack_module.beam_scene = BeamAesthetic_Scene
	beam_attack_module.beam_sprite_frames = beam_sprite_frame
	beam_attack_module.beam_is_timebound = true
	beam_attack_module.beam_time_visible = 0.15
	beam_attack_module.show_beam_at_windup = true
	beam_attack_module.show_beam_regardless_of_state = true
	
	beam_attack_module.can_be_commanded_by_tower = false
	
	beam_attack_module.is_displayed_in_tracker = false
	
	beam_attack_module.connect("on_enemy_hit", self, "_on_beam_attack_module_hit_enemy", [], CONNECT_PERSIST)
	
	_attached_tower.add_attack_module(beam_attack_module)


func _construct_and_add_explosion_attack_module():
	explosion_attk_module = AOEAttackModule_Scene.instance()
	explosion_attk_module.base_damage_scale = 0
	explosion_attk_module.base_damage = 0
	explosion_attk_module.base_damage_type = DamageType.PHYSICAL
	explosion_attk_module.base_attack_speed = 0
	explosion_attk_module.base_attack_wind_up = 0
	explosion_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attk_module.is_main_attack = false
	explosion_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attk_module.benefits_from_bonus_explosion_scale = true
	explosion_attk_module.benefits_from_bonus_base_damage = false
	explosion_attk_module.benefits_from_bonus_attack_speed = false
	explosion_attk_module.benefits_from_bonus_on_hit_damage = false
	explosion_attk_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic01)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic02)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic03)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic04)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic05)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic06)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic07)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic08)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic09)
	
	explosion_attk_module.aoe_sprite_frames = sprite_frames
	explosion_attk_module.sprite_frames_only_play_once = true
	explosion_attk_module.pierce = -1
	explosion_attk_module.duration = 0.25
	explosion_attk_module.damage_repeat_count = 1
	
	explosion_attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attk_module.base_aoe_scene = BaseAOE_Scene
	explosion_attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attk_module.can_be_commanded_by_tower = false
	
	explosion_attk_module.tracker_image = EffectIcon
	
	_attached_tower.add_attack_module(explosion_attk_module)
	


#

func _on_tower_main_attack(attack_delay, enemies, module):
	_current_attack_count += 1
	
	if _current_attack_count >= main_attack_trigger_count:
		_current_attack_count -= main_attack_trigger_count
		_execute_beam_attack_to_enemy()


func _on_tower_casted_ability(cooldown, ability):
	_execute_beam_attack_to_enemy()

#

func _execute_beam_attack_to_enemy():
	var enemies = _get_enemies_to_target()
	
	if enemies != null:
		beam_attack_module.on_command_attack_enemies_and_attack_when_ready(enemies)


func _get_enemies_to_target():
	if is_instance_valid(_attached_tower.range_module):
		var enemies_to_target = _attached_tower.range_module.get_targets_without_affecting_self_current_targets(1)
		if enemies_to_target.size() > 0:
			return enemies_to_target
	
	return null

#

func _on_beam_attack_module_hit_enemy(enemy, damage_register_id, damage_instance, module):
	var explosion = explosion_attk_module.construct_aoe(enemy.global_position, enemy.global_position)
	explosion.modulate.a = 0.7
	explosion.scale *= 1.75
	
	if is_instance_valid(_attached_tower.main_attack_module):
		explosion.damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE].damage_as_modifier.flat_modifier = _attached_tower.main_attack_module.last_calculated_final_damage * explosion_base_damage_ratio
	
	explosion_attk_module.set_up_aoe__add_child_and_emit_signals(explosion)


#

func _on_round_end():
	_current_attack_count = 0

#

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack", self, "_on_tower_main_attack"):
		tower.disconnect("on_main_attack", self, "_on_tower_main_attack")
		tower.disconnect("on_round_end", self, "_on_round_end")
		tower.disconnect("on_tower_ability_after_cast_end", self, "_on_tower_casted_ability")
	
	if is_instance_valid(beam_attack_module):
		_attached_tower.remove_attack_module(beam_attack_module)
		beam_attack_module.queue_free()
	
	if is_instance_valid(explosion_attk_module):
		_attached_tower.remove_attack_module(explosion_attk_module)
		explosion_attk_module.queue_free()
	
	_attached_tower = null

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	explosion_base_damage_ratio *= _current_additive_scale
	_current_additive_scale = 1
