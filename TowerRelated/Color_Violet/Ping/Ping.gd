extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")


const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const SpawnAOEModuleModification = preload("res://TowerRelated/Modification/ModuleModification/SpawnAOEModuleModification.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const SpawnAOETemplate = preload("res://TowerRelated/Templates/SpawnAOETemplate.gd")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")


const Ping_arrow_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Arrow.png")

const PingMarker_Scene = preload("res://TowerRelated/Color_Violet/Ping/PingMarker.tscn")
const PingAreaPing_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_AreaPing.png")

const PingMarked_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Marked.png")

const PingShot01_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_01.png")
const PingShot02_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_02.png")
const PingShot03_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_03.png")
const PingShot04_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_04.png")
const PingShot05_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_05.png")
const PingShot06_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_06.png")
const PingShot07_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_07.png")
const PingShot08_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Shot_08.png")


const PingEye_awake_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Eye_Awake.png")
const PingEye_awakeRed_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Eye_AwakeRed.png")
const PingEye_sleep_pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_Eye_Sleep.png")

const Ping_seek_register_id : int = 117
const Ping_shot_register_id : int = 207

var arrow_attack_module : AbstractAttackModule
var template : SpawnAOETemplate


# Eye

onready var ping_eye_sprite = $TowerBase/PingEye

# Mark and hit related

var _enemies_marked : Array = []
var _markers : Array = []
const mark_count_limit : int = 4

var _started_timer : bool = false
var _current_time : float = 0
var _shot_trigger_time : float = 0.75

var shot_attack_module : WithBeamInstantDamageAttackModule

const empowered_base_damage : float = 13.0
const normal_base_damage : float = 7.0
const empowered_on_hit_damage_scale : float = 1.5
const normal_on_hit_damage_scale : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.PING)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 16
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_name = "ping_arrow"
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 167
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 16
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(9, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Ping_arrow_pic)
	
	attack_module.connect("on_enemy_hit", self, "_enemy_hit")
	
	# AOE
	
	arrow_attack_module = attack_module
	var spawn_aoe_mod : SpawnAOEModuleModification = SpawnAOEModuleModification.new()
	spawn_aoe_mod.template = _generate_template()
	
	#
	
	attack_module.modifications = [spawn_aoe_mod]
	add_attack_module(attack_module)
	
	
	# Shot maker module
	
	var shot_range_module = RangeModule_Scene.instance()
	shot_range_module.base_range_radius = 600
	shot_range_module.set_range_shape(CircleShape2D.new())
	shot_range_module.can_display_range = false
	
	shot_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	shot_attack_module.base_damage = normal_base_damage
	shot_attack_module.base_damage_type = DamageType.PHYSICAL
	shot_attack_module.base_attack_speed = 0
	shot_attack_module.base_attack_wind_up = 0
	shot_attack_module.is_main_attack = false
	shot_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	shot_attack_module.position.y -= 30
	shot_attack_module.base_on_hit_damage_internal_name = "ping_shot"
	shot_attack_module.on_hit_damage_scale = normal_on_hit_damage_scale
	
	
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
	beam_sprite_frame.set_animation_speed("default", 60)
	
	shot_attack_module.beam_scene = BeamAesthetic_Scene
	shot_attack_module.beam_sprite_frames = beam_sprite_frame
	shot_attack_module.beam_is_timebound = true
	shot_attack_module.beam_time_visible = 0.15
	shot_attack_module.show_beam_at_windup = false
	shot_attack_module.show_beam_regardless_of_state = true
	
	shot_attack_module.damage_register_id = Ping_shot_register_id
	shot_attack_module.connect("on_post_mitigation_damage_dealt", self, "_check_if_shot_killed_enemy")
	
	shot_attack_module.use_self_range_module = true
	shot_attack_module.range_module = shot_range_module
	
	shot_attack_module.can_be_commanded_by_tower = false
	add_attack_module(shot_attack_module)
	
	_post_inherit_ready()


func _generate_template():
	template = SpawnAOETemplate.new()
	
	template.aoe_scene = PingMarker_Scene
	
	template.aoe_damage_repeat_count = 1
	template.aoe_duration = 0.3
	template.aoe_pierce = 4
	
	template.aoe_base_damage = 0
	template.aoe_base_damage_type = DamageType.PURE
	template.aoe_base_on_hit_damage_internal_name = "ping_seek_ping"
	
	template.aoe_on_hit_damage_scale = 0
	template.aoe_on_hit_effect_scale = 0
	
	template.aoe_sprite_frames_play_only_once = true
	#template.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	template.tree = get_tree()
	
	#template.aoe_texture = PingAreaPing_pic
	
	template.attack_module_source = arrow_attack_module
	template.damage_register_id = Ping_seek_register_id
	
	return template


# Mark related

func _enemy_hit(enemy, damage_register_id : int, module):
	if damage_register_id == Ping_seek_register_id and _enemies_marked.size() < mark_count_limit:
		_enemies_marked.append(enemy)
		enemy.add_child(_construct_mark_sprite())
		
		_started_timer = true
		
		if _enemies_marked.size() == 1:
			ping_eye_sprite.texture = PingEye_awakeRed_pic
		elif _enemies_marked.size() > 1:
			ping_eye_sprite.texture = PingEye_awake_pic


func _construct_mark_sprite():
	var mark_sprite_child = Sprite.new()
	mark_sprite_child.texture = PingMarked_pic
	mark_sprite_child.scale = Vector2(2, 2)
	
	_markers.append(mark_sprite_child)
	
	return mark_sprite_child


func _on_round_end():
	._on_round_end()
	
	shot_attack_module.on_hit_damage_scale = normal_on_hit_damage_scale
	shot_attack_module.base_damage = normal_base_damage
	_started_timer = false
	_current_time = 0
	_enemies_marked.clear()
	ping_eye_sprite.texture = PingEye_sleep_pic
	
	for mark in _markers:
		if mark != null:
			mark.queue_free()
	_markers.clear()


func _process(delta):
	
	if _started_timer:
		_current_time += delta
		
		if _current_time >= _shot_trigger_time:
			_shoot_marked_enemies()

func _shoot_marked_enemies():
	_current_time = 0
	_started_timer = false
	
	if _enemies_marked.size() == 1:
		shot_attack_module.on_hit_damage_scale = empowered_on_hit_damage_scale
		shot_attack_module.base_damage = empowered_base_damage
	
	shot_attack_module._attack_enemies(_enemies_marked)
	for mark in _markers:
		if mark != null:
			mark.call_deferred("queue_free")
	_markers.clear()
	
	if _enemies_marked.size() == 1:
		shot_attack_module.on_hit_damage_scale = normal_on_hit_damage_scale
		shot_attack_module.base_damage = normal_base_damage
	
	_enemies_marked.clear()
	ping_eye_sprite.texture = PingEye_sleep_pic


func _check_if_shot_killed_enemy(damage : float, damage_type : int, killed_enemy : bool, enemy, damage_register_id : int, module):
	if damage_register_id == Ping_shot_register_id and killed_enemy == true:
		arrow_attack_module.reset_attack_timers()