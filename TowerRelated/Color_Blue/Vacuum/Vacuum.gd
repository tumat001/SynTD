extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const MainProj_Bullet_pic = preload("res://TowerRelated/Color_Blue/Vacuum/Assets/Vacuum_MainProj.png")

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")



#

onready var center_pos_2d_for_suck_particles = $TowerBase/CenterOfSuck



#

const slow_duration_per_apply : float = 0.5
const slow_apply_delay : float = 0.5 # wait for 0.5 sec before applying another slow
const base_suck_duration : float = 3.0

var suck_ability : BaseAbility
var is_suck_ability_ready : bool
var _current_duration_before_suck_end_and_shockwave_start : float
const base_suck_cooldown : float = 32.0
const is_sucking_clause : int = -10
var suck_slow_applier_timer : Timer
var suck_duration_timer : Timer

const shockwave_stun_duration : float = 1.5


const trail_color : Color = Color(0.3, 0.4, 1, 0.75)
const base_trail_length : int = 10
const base_trail_width : int = 3

var multiple_trail_component : MultipleTrailsForNodeComponent


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.VACUUM)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift_of_attack_module : float = 26
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += y_shift_of_attack_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 375
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y += y_shift_of_attack_module
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(4, 10)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(MainProj_Bullet_pic)
	
	add_attack_module(attack_module)
	
	#
	
	multiple_trail_component = MultipleTrailsForNodeComponent.new()
	multiple_trail_component.node_to_host_trails = self
	multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	
	#
	
	
	_post_inherit_ready()

#

func _construct_and_register_ability():
	suck_ability = BaseAbility.new()
	
	suck_ability.is_timebound = true
	
	suck_ability.set_properties_to_usual_tower_based()
	suck_ability.tower = self
	
	suck_ability.connect("updated_is_ready_for_activation", self, "_can_cast_suck_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(suck_ability, false)
	
	#
	
	suck_slow_applier_timer = Timer.new()
	suck_slow_applier_timer.one_shot = false
	suck_slow_applier_timer.connect("timeout", self, "_on_suck_slow_applier_timer_timeout", [], CONNECT_PERSIST)
	add_child(suck_slow_applier_timer)
	
	suck_duration_timer = Timer.new()
	suck_duration_timer.one_shot = true
	suck_duration_timer.connect("timeout", self, "_on_suck_duration_timer_timeout", [], CONNECT_PERSIST)
	add_child(suck_duration_timer)
	

func _can_cast_suck_updated(is_ready):
	is_suck_ability_ready = is_ready
	_attempt_cast_suck()

func _attempt_cast_suck():
	if is_suck_ability_ready:
		_cast_suck()

func _cast_suck():
	var cd = _get_cd_to_use(base_suck_cooldown)
	suck_ability.on_ability_before_cast_start(cd)
	
	suck_ability.start_time_cooldown(cd)
	_start_suck_timers()
	disabled_from_attacking_clauses.attempt_insert_clause(is_sucking_clause)
	
	suck_ability.on_ability_after_cast_ended(cd)
	


#

func _start_suck_timers():
	var duration_of_suck = base_suck_duration * suck_ability.get_potency_to_use(last_calculated_final_ability_potency)
	


func _on_suck_slow_applier_timer_timeout():
	pass

func _on_suck_duration_timer_timeout():
	pass


#

func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = base_trail_length
	arg_trail.trail_color = trail_color
	arg_trail.width = base_trail_width


