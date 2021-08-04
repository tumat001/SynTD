extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")

const Douser_Beam01 = preload("res://TowerRelated/Color_Blue/Douser/Douser_AttkBeam/Douser_AttkBeam01.png")
const Douser_Beam02 = preload("res://TowerRelated/Color_Blue/Douser/Douser_AttkBeam/Douser_AttkBeam02.png")
const Douser_Beam03 = preload("res://TowerRelated/Color_Blue/Douser/Douser_AttkBeam/Douser_AttkBeam03.png")
const Douser_Beam04 = preload("res://TowerRelated/Color_Blue/Douser/Douser_AttkBeam/Douser_AttkBeam04.png")
const Douser_Beam05 = preload("res://TowerRelated/Color_Blue/Douser/Douser_AttkBeam/Douser_AttkBeam05.png")
const Douser_Beam06 = preload("res://TowerRelated/Color_Blue/Douser/Douser_AttkBeam/Douser_AttkBeam06.png")

const Douser_Bullet = preload("res://TowerRelated/Color_Blue/Douser/Douser_Bullet.png")

const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const BaseTowerDetectingBullet_Scene = preload("res://EnemyRelated/TowerInteractingRelated/Spawnables/BaseTowerDetectingBullet.tscn")


const base_douser_base_damage_buff : float = 0.75
const base_douser_base_time : float = 10.0
const base_douser_base_count : int = 4

const base_attack_count_for_buff : int = 4
var current_attack_count_for_buff : int = base_attack_count_for_buff
var current_attack_count : int = 0

var tower_detecting_range_module : TowerDetectingRangeModule
var buffing_attack_module : BulletAttackModule

var base_damage_buff_mod : FlatModifier
var base_damage_buff_effect : TowerAttributesEffect

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.DOUSER)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.detection_range = info.base_range
	tower_detecting_range_module.can_display_range = false
	add_child(tower_detecting_range_module)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 16
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1.0 / 0.15
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 16
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Douser_Beam01)
	beam_sprite_frame.add_frame("default", Douser_Beam02)
	beam_sprite_frame.add_frame("default", Douser_Beam03)
	beam_sprite_frame.add_frame("default", Douser_Beam04)
	beam_sprite_frame.add_frame("default", Douser_Beam05)
	beam_sprite_frame.add_frame("default", Douser_Beam06)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 6.0 / 0.15)
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.15
	attack_module.show_beam_at_windup = true
	
	add_attack_module(attack_module)
	
	# Dummy am for buffing bullet
	
	buffing_attack_module = BulletAttackModule_Scene.instance()
	buffing_attack_module.base_damage = 0
	buffing_attack_module.base_damage_type = DamageType.ELEMENTAL
	buffing_attack_module.base_attack_speed = 0
	buffing_attack_module.base_attack_wind_up = 0
	buffing_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	buffing_attack_module.is_main_attack = false
	buffing_attack_module.base_pierce = 2
	buffing_attack_module.base_proj_speed = 400
	buffing_attack_module.base_proj_life_distance = info.base_range
	buffing_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	buffing_attack_module.on_hit_damage_scale = 0
	buffing_attack_module.position.y -= 16
	
	buffing_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(buffing_attack_module)
	
	
	connect("on_main_attack_finished", self, "_on_main_attack_finished_d", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_d", [], CONNECT_PERSIST)
	connect("final_range_changed", self, "_on_range_changed_d", [], CONNECT_PERSIST)
	connect("final_ability_potency_changed", self, "_on_ap_changed_d", [], CONNECT_PERSIST)
	connect("final_ability_cd_changed", self, "on_acd_changed_d", [], CONNECT_PERSIST)
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	_construct_effect()
	
	_on_ap_changed_d()
	_on_acd_changed_d()


# effect

func _construct_effect():
	base_damage_buff_mod = FlatModifier.new(StoreOfTowerEffectsUUID.DOUSER_BASE_DAMAGE_INC)
	base_damage_buff_mod.flat_modifier = base_douser_base_damage_buff
	
	base_damage_buff_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS, base_damage_buff_mod, StoreOfTowerEffectsUUID.DOUSER_BASE_DAMAGE_INC)
	base_damage_buff_effect.is_timebound = true
	base_damage_buff_effect.time_in_seconds = base_douser_base_time
	
	base_damage_buff_effect.is_countbound = true
	base_damage_buff_effect.count = base_douser_base_count


func _on_ap_changed_d():
	base_damage_buff_mod.flat_modifier = base_damage_buff_mod.flat_modifier * last_calculated_final_ability_potency

func _on_acd_changed_d():
	current_attack_count_for_buff = int(ceil(float(base_attack_count_for_buff) * (1 - last_calculated_final_percent_ability_cdr)))


# Attack Count related

func _on_round_end_d():
	current_attack_count = 0

func _on_main_attack_finished_d(module):
	current_attack_count += 1
	if current_attack_count >= current_attack_count_for_buff:
		_attempt_shoot_buffing_bullet()



# Range related
func _on_range_changed_d():
	if main_attack_module != null and main_attack_module.range_module != null:
		tower_detecting_range_module.detection_range = main_attack_module.range_module.last_calculated_final_range


# Shoot buffing bullet

func _attempt_shoot_buffing_bullet():
	var tower_to_target = _find_closest_unbuffed_tower()
	
	if tower_to_target != null:
		var bullet := _construct_buffing_bullet(tower_to_target.global_position)
		bullet.connect("hit_a_tower", self, "_bullet_hit_tower")
		
		bullet.add_to_group(BulletAttackModule.bullet_group_tag)
		bullet.z_as_relative = false
		bullet.z_index = ZIndexStore.PARTICLE_EFFECTS
		
		var coll_shape := RectangleShape2D.new()
		coll_shape.extents = Vector2(7, 5)
		bullet.set_shape(coll_shape)
		
		#bullet.collision_layer = 4
		
		get_tree().get_root().add_child(bullet)
		
		current_attack_count = 0


func _find_closest_unbuffed_tower() -> Node:
	var active_towers_in_range = tower_detecting_range_module.get_all_in_map_towers_in_range()
	active_towers_in_range = Targeting.enemies_to_target(active_towers_in_range, Targeting.CLOSE, active_towers_in_range.size(), global_position)
	
	for tower in active_towers_in_range:
		if tower != self and !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.DOUSER_BASE_DAMAGE_INC):
			return tower
	
	return null


func _construct_buffing_bullet(arg_tower_pos : Vector2) -> BaseTowerDetectingBullet:
	var buffing_bullet : BaseTowerDetectingBullet = BaseTowerDetectingBullet_Scene.instance()
	buffing_bullet.set_texture_as_sprite_frames(Douser_Bullet)
	buffing_bullet.speed = buffing_attack_module.last_calculated_final_proj_speed
	buffing_bullet.life_distance = buffing_attack_module.last_calculated_final_proj_life_distance
	buffing_bullet.current_life_distance = buffing_attack_module.last_calculated_final_proj_life_distance
	buffing_bullet.pierce = buffing_attack_module.last_calculated_final_pierce
	
	var dir : Vector2 = Vector2(arg_tower_pos.x - buffing_attack_module.global_position.x, arg_tower_pos.y - buffing_attack_module.global_position.y)
	buffing_bullet.direction_as_relative_location = dir.normalized()
	buffing_bullet.rotation_degrees = _get_angle(arg_tower_pos)
	
	buffing_bullet.global_position = buffing_attack_module.global_position
	
	return buffing_bullet

func _get_angle(destination_pos : Vector2):
	var dx = destination_pos.x - buffing_attack_module.global_position.x
	var dy = destination_pos.y - buffing_attack_module.global_position.y
	
	return rad2deg(atan2(dy, dx))


# Bullet hit

func _bullet_hit_tower(bullet, tower):
	tower.add_tower_effect(base_damage_buff_effect._shallow_duplicate())