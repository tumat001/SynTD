extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"


const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")


const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const PingShot01_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_01.png")
const PingShot02_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_02.png")
const PingShot03_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_03.png")
const PingShot04_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_04.png")
const PingShot05_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_05.png")
const PingShot06_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_06.png")
const PingShot07_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_07.png")
const PingShot08_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_08.png")

const Pinglet_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Eye_Awake.png")
const Pinglet_AttackModule_Icon = preload("res://TowerRelated/Color_Violet/Ping/AttackModule_Assets/Pinglet_AttackModule_Icon.png")

const Ingredient_pic = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Pinglet.png")


var shot_attack_module : WithBeamInstantDamageAttackModule

var ping_base_dmg : float = 3.0
var ping_base_dmg_scale : float = 0.25
var ping_on_hit_dmg_scale : float = 0.25


func _init().(StoreOfTowerEffectsUUID.ING_PING):
	effect_icon = Ingredient_pic
	#
	_update_description()
	
	_can_be_scaled_by_yel_vio = true

func _update_description():
	var interpreter_for_dmg = TextFragmentInterpreter.new()
	interpreter_for_dmg.display_body = true
	interpreter_for_dmg.display_header = true
	
	var ins_for_dmg = []
	ins_for_dmg.append(NumericalTextFragment.new(ping_base_dmg * _current_additive_scale, false, DamageType.PHYSICAL))
	ins_for_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
	ins_for_dmg.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, ping_base_dmg_scale * _current_additive_scale, DamageType.PHYSICAL))
	ins_for_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
	ins_for_dmg.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, ping_on_hit_dmg_scale * _current_additive_scale)) # stat basis does not matter here
	
	interpreter_for_dmg.array_of_instructions = ins_for_dmg
	
	#
	var interpreter_for_range = TextFragmentInterpreter.new()
	interpreter_for_range.display_body = false
	
	var ins_for_range = []
	ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", 120, false))
	
	interpreter_for_range.array_of_instructions = ins_for_range
	
	#
	
	
	description = ["Pinglet: Summons a Pinglet beside your tower that attacks on its own. Has |0|. Its shots deal |1|. Applies on hit effects. Benefits from bonus attack speed.%s" % _generate_desc_for_persisting_total_additive_scaling(true), [interpreter_for_range, interpreter_for_dmg]]




func _construct_pinglet():
	var shot_range_module = RangeModule_Scene.instance()
	shot_range_module.base_range_radius = 120
	shot_range_module.set_range_shape(CircleShape2D.new())
	shot_range_module.can_display_range = true
	shot_range_module.benefits_from_bonus_range = false
	
	shot_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	shot_attack_module.base_damage_scale = ping_base_dmg_scale
	shot_attack_module.on_hit_damage_scale = ping_on_hit_dmg_scale
	shot_attack_module.base_damage = ping_base_dmg / shot_attack_module.base_damage_scale
	shot_attack_module.base_damage_type = DamageType.PHYSICAL
	shot_attack_module.base_attack_speed = 0.8
	shot_attack_module.base_attack_wind_up = 1.0 / 0.15
	shot_attack_module.is_main_attack = false
	shot_attack_module.module_id = StoreOfAttackModuleID.INDEPENDENT
	shot_attack_module.position.y -= 12
	shot_attack_module.position.x += 24
	shot_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", PingShot01_pic)
	beam_sprite_frame.add_frame("default", PingShot02_pic)
	beam_sprite_frame.add_frame("default", PingShot03_pic)
	beam_sprite_frame.add_frame("default", PingShot04_pic)
	beam_sprite_frame.add_frame("default", PingShot05_pic)
	beam_sprite_frame.add_frame("default", PingShot06_pic)
	beam_sprite_frame.add_frame("default", PingShot07_pic)
	beam_sprite_frame.add_frame("default", PingShot08_pic)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 8.0 / 0.15)
	
	shot_attack_module.beam_scene = BeamAesthetic_Scene
	shot_attack_module.beam_sprite_frames = beam_sprite_frame
	shot_attack_module.beam_is_timebound = true
	shot_attack_module.beam_time_visible = 0.15
	shot_attack_module.show_beam_at_windup = true
	shot_attack_module.show_beam_regardless_of_state = true
	
	shot_attack_module.use_self_range_module = true
	shot_attack_module.range_module = shot_range_module
	
	shot_attack_module.can_be_commanded_by_tower = true
	
	shot_attack_module.commit_to_targets_of_windup = true
	shot_attack_module.fill_empty_windup_target_slots = false
	
	shot_attack_module.set_image_as_tracker_image(Pinglet_AttackModule_Icon)
	
	var pinglet_sprite : Sprite = Sprite.new()
	pinglet_sprite.texture = Pinglet_pic
	shot_attack_module.add_child(pinglet_sprite)


func _make_modifications_to_tower(tower):
	if !is_instance_valid(shot_attack_module):
		_construct_pinglet()
		tower.add_attack_module(shot_attack_module)


func _undo_modifications_to_tower(tower):
	if is_instance_valid(shot_attack_module):
		tower.remove_attack_module(shot_attack_module)
		shot_attack_module.queue_free()

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
	ping_base_dmg *= _current_additive_scale
	ping_base_dmg_scale *= _current_additive_scale
	ping_on_hit_dmg_scale *= _current_additive_scale
	_current_additive_scale = 1
