extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")


const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")

const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")

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

const Ping_ShotAttackModule_Icon = preload("res://TowerRelated/Color_Violet/Ping/AttackModule_Assets/Ping_ShotAttackModule_Icon.png")

#

const Ping_TopHalf_Normal_Pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_TopHalf.png")
const Ping_TopHalf_NoHealth_Pic = preload("res://TowerRelated/Color_Violet/Ping/Ping_TopHalf_NoHealth.png")

#

const Ping_seek_register_id : int = Towers.PING

var arrow_attack_module : AbstractAttackModule
#var template : SpawnAOETemplate
var seek_attack_module : AOEAttackModule


# Eye

onready var ping_eye_sprite = $TowerBase/KnockUpLayer/PingEye
onready var top_half_sprite = $TowerBase/KnockUpLayer/TopHalf

# Mark and hit related

var _enemies_marked : Array = []
var _markers : Array = []
const original_mark_count_limit : int = 4
var base_mark_count_limit : int = original_mark_count_limit
var current_mark_count_limit : int = original_mark_count_limit

var _started_timer : bool = false
var _current_time : float = 0
var _shot_trigger_time : float = 0.75

var shot_attack_module : WithBeamInstantDamageAttackModule

# shots related
const empowered_base_damage : float = 6.0
const normal_base_damage : float = 3.0

const empowered_on_hit_damage_scale : float = 3.0
const normal_on_hit_damage_scale : float = 1.5

const original_empowered_num_of_targets_limit : int = 1
var empowered_num_of_targets_limit : int = original_empowered_num_of_targets_limit

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.PING)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	
	var attack_module_y_shift : float = 25.0
	var eye_attk_module_y_shift : float = 42.0
	var info_bar_y_shift : float = 40.0
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attack_module_y_shift
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 294 #245
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= attack_module_y_shift
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(9, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Ping_arrow_pic)
	
	arrow_attack_module = attack_module
	
	arrow_attack_module.connect("before_bullet_is_shot", self, "_before_arrow_is_shot", [], CONNECT_PERSIST)
	
	arrow_attack_module.set_image_as_tracker_image(Ping_arrow_pic)
	
	add_attack_module(attack_module)
	
#	# AOE
#	var spawn_aoe_mod : SpawnAOEModuleModification = SpawnAOEModuleModification.new()
#	spawn_aoe_mod.template = _generate_template()
#
#	attack_module.modifications = [spawn_aoe_mod]
#
	# AOE attack module
	seek_attack_module = AOEAttackModule_Scene.instance()
	seek_attack_module.base_damage = 0
	seek_attack_module.base_damage_type = DamageType.PURE
	seek_attack_module.base_attack_speed = 0
	seek_attack_module.base_attack_wind_up = 0
	seek_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	seek_attack_module.is_main_attack = false
	seek_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	seek_attack_module.benefits_from_bonus_explosion_scale = true
	seek_attack_module.benefits_from_bonus_base_damage = false
	seek_attack_module.benefits_from_bonus_attack_speed = false
	seek_attack_module.benefits_from_bonus_on_hit_damage = false
	seek_attack_module.benefits_from_bonus_on_hit_effect = false
	
	seek_attack_module.pierce = current_mark_count_limit
	seek_attack_module.damage_repeat_count = 1
	seek_attack_module.damage_register_id = Ping_seek_register_id
	seek_attack_module.duration = 0.3
	seek_attack_module.aoe_texture = PingAreaPing_pic
	
	seek_attack_module.base_aoe_scene = PingMarker_Scene
	seek_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	seek_attack_module.can_be_commanded_by_tower = false
	
	seek_attack_module.connect("on_enemy_hit", self, "_enemy_seeked", [], CONNECT_PERSIST)
	
	seek_attack_module.is_displayed_in_tracker = false
	
	add_attack_module(seek_attack_module)
	
	
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
	shot_attack_module.position.y -= eye_attk_module_y_shift
	shot_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
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
	
	shot_attack_module.connect("on_post_mitigation_damage_dealt", self, "_check_if_shot_killed_enemy", [], CONNECT_PERSIST)
	
	shot_attack_module.use_self_range_module = true
	shot_attack_module.range_module = shot_range_module
	
	shot_attack_module.can_be_commanded_by_tower = false
	
	shot_attack_module.set_image_as_tracker_image(Ping_ShotAttackModule_Icon)
	
	add_attack_module(shot_attack_module)
	
	#
	
	info_bar_layer.position.y -= info_bar_y_shift
	
	connect("final_ability_potency_changed", self, "_on_final_ap_changed_p", [], CONNECT_PERSIST)
	
	connect("changed_anim_from_alive_to_dead", self, "_on_changed_anim_from_alive_to_dead", [], CONNECT_PERSIST)
	connect("changed_anim_from_dead_to_alive", self, "_on_changed_anim_from_dead_to_alive", [], CONNECT_PERSIST)
	
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	_set_mark_amount_amount(base_mark_count_limit)



# Mark related

func _before_arrow_is_shot(arrow : BaseBullet):
	arrow.connect("hit_an_enemy", self, "_enemy_hit_by_arrow", [], CONNECT_ONESHOT)


func _enemy_hit_by_arrow(arrow, enemy):
	var aoe : BaseAOE = seek_attack_module.construct_aoe(enemy.global_position, enemy.global_position)
	for enemy in _enemies_marked:
		aoe.enemies_to_ignore.append(enemy)
	
	seek_attack_module.set_up_aoe__add_child_and_emit_signals(aoe)


func _enemy_seeked(enemy, damage_register_id : int, damage_instance, module):
	#if damage_register_id == Ping_seek_register_id and _enemies_marked.size() < current_mark_count_limit:
	if !_enemies_marked.has(enemy):
		_enemies_marked.append(enemy)
		enemy.add_child(_construct_mark_sprite())
		
		_started_timer = true
		
		if _enemies_marked.size() > empowered_num_of_targets_limit:
			ping_eye_sprite.texture = PingEye_awake_pic
		elif _enemies_marked.size() <= empowered_num_of_targets_limit and !_enemies_marked.size() < 0:
			ping_eye_sprite.texture = PingEye_awakeRed_pic



func _construct_mark_sprite():
	var mark_sprite_child = Sprite.new()
	mark_sprite_child.texture = PingMarked_pic
	
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
		if is_instance_valid(mark) and !mark.is_queued_for_deletion():
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
	
	var empowered : bool = _enemies_marked.size() <= empowered_num_of_targets_limit
	if empowered:
		shot_attack_module.on_hit_damage_scale = empowered_on_hit_damage_scale
		shot_attack_module.base_damage = empowered_base_damage
		
		shot_attack_module.calculate_final_base_damage()
	
	shot_attack_module._attack_enemies(_enemies_marked)
	for mark in _markers:
		if is_instance_valid(mark):
			mark.call_deferred("queue_free")
	_markers.clear()
	
	if empowered:
		shot_attack_module.on_hit_damage_scale = normal_on_hit_damage_scale
		shot_attack_module.base_damage = normal_base_damage
		
		shot_attack_module.calculate_final_base_damage()
	
	_enemies_marked.clear()
	ping_eye_sprite.texture = PingEye_sleep_pic


func _check_if_shot_killed_enemy(damage_report, killed_enemy : bool, enemy, damage_register_id : int, module):
	if killed_enemy == true:
		arrow_attack_module.call_deferred("reset_attack_timers")


#

func _on_final_ap_changed_p():
	_set_mark_amount_amount(base_mark_count_limit) # refresh

func _set_mark_amount_amount(arg_pierce : int):
	base_mark_count_limit = arg_pierce
	current_mark_count_limit = int(round(arg_pierce + ((last_calculated_final_ability_potency - base_ability_potency) * 2)))
	
	seek_attack_module.pierce = current_mark_count_limit


#

func _on_changed_anim_from_alive_to_dead():
	top_half_sprite.texture = Ping_TopHalf_NoHealth_Pic
	ping_eye_sprite.texture = PingEye_sleep_pic

func _on_changed_anim_from_dead_to_alive():
	top_half_sprite.texture = Ping_TopHalf_Normal_Pic


# energy module related

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Ping can mark up to 13 enemies per shot.",
			"Ping can empower its shots when marking up to 4 enemies."
		]


func _module_turned_on(_first_time_per_round : bool):
	empowered_num_of_targets_limit = 4
	_set_mark_amount_amount(13)


func _module_turned_off():
	empowered_num_of_targets_limit = original_empowered_num_of_targets_limit
	_set_mark_amount_amount(original_mark_count_limit)
