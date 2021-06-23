extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"


const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

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

const Ingredient_pic = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Pinglet.png")


var shot_attack_module : WithBeamInstantDamageAttackModule


func _init().(StoreOfTowerEffectsUUID.ING_PING):
	effect_icon = Ingredient_pic
	description = "Pinglet: Summons a Pinglet beside your tower. Has 120 range, 4 physical base damage and 0.8 attack speed. Benefits from on hit damages and base damage buffs at 10% efficiency."


func _construct_pinglet():
	
	var shot_range_module = RangeModule_Scene.instance()
	shot_range_module.base_range_radius = 120
	shot_range_module.set_range_shape(CircleShape2D.new())
	shot_range_module.can_display_range = true
	shot_range_module.benefits_from_bonus_range = false
	
	shot_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	shot_attack_module.base_damage_scale = 0.1
	shot_attack_module.base_damage = 4 / shot_attack_module.base_damage_scale
	shot_attack_module.base_damage_type = DamageType.PHYSICAL
	shot_attack_module.base_attack_speed = 0.8
	shot_attack_module.base_attack_wind_up = 1.0 / 0.15
	shot_attack_module.is_main_attack = false
	shot_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	shot_attack_module.position.y -= 10
	shot_attack_module.position.x += 20
	shot_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	shot_attack_module.on_hit_damage_scale = 0.1
	
	
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
	
	var pinglet_sprite : Sprite = Sprite.new()
	pinglet_sprite.texture = Pinglet_pic
	shot_attack_module.add_child(pinglet_sprite)


func _make_modifications_to_tower(tower):
	_construct_pinglet()
	tower.add_attack_module(shot_attack_module)


func _undo_modifications_to_tower(tower):
	if shot_attack_module != null:
		tower.remove_attack_module(shot_attack_module)
		shot_attack_module.queue_free()

