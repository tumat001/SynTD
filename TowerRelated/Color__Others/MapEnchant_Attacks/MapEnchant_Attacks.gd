extends "res://TowerRelated/AbstractTower.gd"


const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BulletHomingComponent = preload("res://TowerRelated/CommonBehaviorRelated/BulletHomingComponent.gd")
const BulletHomingComponentPool = preload("res://MiscRelated/PoolRelated/Implementations/BulletHomingComponentPool.gd")
const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")

const Enchant_PurpleProj_Pic = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Proj/Map_Enchant_PurpleProj.png")
const Enchant_PurpleExplosion_Pic01 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Explosion/Map_Enchant_PurpleExplosion_01.png")
const Enchant_PurpleExplosion_Pic02 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Explosion/Map_Enchant_PurpleExplosion_02.png")
const Enchant_PurpleExplosion_Pic03 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Explosion/Map_Enchant_PurpleExplosion_03.png")
const Enchant_PurpleExplosion_Pic04 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Explosion/Map_Enchant_PurpleExplosion_04.png")
const Enchant_PurpleExplosion_Pic05 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Explosion/Map_Enchant_PurpleExplosion_05.png")
const Enchant_PurpleExplosion_Pic06 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Explosion/Map_Enchant_PurpleExplosion_06.png")
const Enchant_PurpleExplosion_Pic07 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Explosion/Map_Enchant_PurpleExplosion_07.png")
const Enchant_PurpleExplosion_AMI = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Explosion/Map_Enchant_PurpleExplosion_AttackModuleIcon.png")


#

signal attack_execution_completed()

var purple_proj_bullet_attk_module : BulletAttackModule
var purple_proj_homing_component_pool : BulletHomingComponentPool
var purple_explosion_attk_module : AOEAttackModule
var multiple_trail_component : MultipleTrailsForNodeComponent

var _purple_proj_amount_per_barrage : int
var _purple_bolt_delay_per_fire : float

const purple_proj_home_max_deg_turn_per_sec : float = 200.0


#

var _current_purple_proj_amount_for_barrage_left : int
var barrage_timer : TimerForTower

#

func _init():
	is_tower_hidden = true


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.MAP_ENCHANT__ATTACKS)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	tower_limit_slots_taken = 0
	
	#
	
	purple_proj_bullet_attk_module = BulletAttackModule_Scene.instance()
	purple_proj_bullet_attk_module.base_damage = 0
	purple_proj_bullet_attk_module.base_damage_type = DamageType.ELEMENTAL
	purple_proj_bullet_attk_module.base_attack_speed = 0
	purple_proj_bullet_attk_module.base_attack_wind_up = 0
	purple_proj_bullet_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	purple_proj_bullet_attk_module.is_main_attack = true
	purple_proj_bullet_attk_module.base_pierce = 1
	purple_proj_bullet_attk_module.base_proj_speed = 504 #420
	purple_proj_bullet_attk_module.base_proj_life_distance = 1500.0
	purple_proj_bullet_attk_module.module_id = StoreOfAttackModuleID.MAIN
	purple_proj_bullet_attk_module.on_hit_damage_scale = 1
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 8)
	
	purple_proj_bullet_attk_module.bullet_shape = bullet_shape
	purple_proj_bullet_attk_module.bullet_scene = BaseBullet_Scene
	purple_proj_bullet_attk_module.set_texture_as_sprite_frame(Enchant_PurpleProj_Pic)
	
	purple_proj_bullet_attk_module.can_be_commanded_by_tower = false
	purple_proj_bullet_attk_module.is_displayed_in_tracker = false
	
	add_attack_module(purple_proj_bullet_attk_module)
	
	###
	
	purple_proj_homing_component_pool = BulletHomingComponentPool.new()
	purple_proj_homing_component_pool.node_to_parent = CommsForBetweenScenes.current_game_elements__other_node_hoster
	purple_proj_homing_component_pool.source_of_create_resource = self
	purple_proj_homing_component_pool.func_name_for_create_resource = "_create_purple_proj_homing_component"
	
	multiple_trail_component = MultipleTrailsForNodeComponent.new()
	multiple_trail_component.node_to_host_trails = self
	multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	
	
	##
	
	
	
	purple_explosion_attk_module = AOEAttackModule_Scene.instance()
	purple_explosion_attk_module.base_damage = 0
	purple_explosion_attk_module.base_damage_type = DamageType.ELEMENTAL
	purple_explosion_attk_module.base_attack_speed = 0
	purple_explosion_attk_module.base_attack_wind_up = 0
	purple_explosion_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	purple_explosion_attk_module.is_main_attack = false
	purple_explosion_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	purple_explosion_attk_module.base_explosion_scale = 1.5
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Enchant_PurpleExplosion_Pic01)
	sprite_frames.add_frame("default", Enchant_PurpleExplosion_Pic02)
	sprite_frames.add_frame("default", Enchant_PurpleExplosion_Pic03)
	sprite_frames.add_frame("default", Enchant_PurpleExplosion_Pic04)
	sprite_frames.add_frame("default", Enchant_PurpleExplosion_Pic05)
	sprite_frames.add_frame("default", Enchant_PurpleExplosion_Pic06)
	sprite_frames.add_frame("default", Enchant_PurpleExplosion_Pic07)
	
	purple_explosion_attk_module.aoe_sprite_frames = sprite_frames
	purple_explosion_attk_module.sprite_frames_only_play_once = true
	#purple_explosion_attk_module.pierce = purple_bolt__explosion_pierce
	purple_explosion_attk_module.duration = 0.35
	purple_explosion_attk_module.damage_repeat_count = 1
	
	purple_explosion_attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	purple_explosion_attk_module.base_aoe_scene = BaseAOE_Scene
	purple_explosion_attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	purple_explosion_attk_module.can_be_commanded_by_tower = false
	
	purple_explosion_attk_module.set_image_as_tracker_image(Enchant_PurpleExplosion_AMI)
	
	add_attack_module(purple_explosion_attk_module)
	
	#
	
	barrage_timer = TimerForTower.new()
	barrage_timer.one_shot = false
	barrage_timer.connect("timeout", self, "_on_barrage_activation_timer_timeout", [], CONNECT_PERSIST)
	barrage_timer.set_tower_and_properties(self)
	add_child(barrage_timer)
	
	visible = false
	
	_post_inherit_ready()


func _create_purple_proj_homing_component():
	var homing_component = BulletHomingComponent.new()
	homing_component.max_deg_angle_turn_amount_per_sec = purple_proj_home_max_deg_turn_per_sec
	
	return homing_component


##

func set_purple_bolt_explosion_pierce(arg_val):
	purple_explosion_attk_module.pierce = arg_val

func set_purple_bolt_explosion_dmg(arg_val):
	purple_explosion_attk_module.base_damage = arg_val
	purple_explosion_attk_module.calculate_final_base_damage()

func set_purple_bolt_amount_per_barrage(arg_val : int):
	_purple_proj_amount_per_barrage = arg_val

func set_purple_bolt_delay_per_fire(arg_val):
	_purple_bolt_delay_per_fire = arg_val


######

func execute_attacks():
	set_current_purple_proj_amount_for_barrage_left(_purple_proj_amount_per_barrage)
	_fire_and_decrease_barrage_counter()
	
	if _current_purple_proj_amount_for_barrage_left > 0:
		barrage_timer.start(_purple_bolt_delay_per_fire)


func _on_barrage_activation_timer_timeout():
	_fire_and_decrease_barrage_counter()
	

func _fire_and_decrease_barrage_counter():
	var candidate_targets = _get_targets_for_purple_proj()
	var target
	
	if candidate_targets.size() > 0:
		target = candidate_targets[0]
	
	if is_instance_valid(target):
		var purple_proj = purple_proj_bullet_attk_module.construct_bullet(target.global_position)
		purple_proj.speed_inc_per_sec = 40
		
		var bullet_homing_component : BulletHomingComponent = purple_proj_homing_component_pool.get_or_create_resource_from_pool()
		bullet_homing_component.bullet = purple_proj
		bullet_homing_component.target_node_to_home_to = target
		
		if !bullet_homing_component.is_connected("on_bullet_tree_exiting", self, "_on_purple_proj_tree_exiting"):
			bullet_homing_component.connect("on_bullet_tree_exiting", self, "_on_purple_proj_tree_exiting", [bullet_homing_component])
			bullet_homing_component.connect("on_target_tree_exiting", self, "_on_bullet_homing_compo_target_lost", [purple_proj, bullet_homing_component])
		
		
		purple_proj.connect("hit_an_enemy", self, "_on_purple_proj_hit_enemy", [], CONNECT_ONESHOT)
		purple_proj.connect("tree_entered", self, "_purple_proj_tree_entered", [purple_proj], CONNECT_ONESHOT)
		
		purple_proj_bullet_attk_module.set_up_bullet__add_child_and_emit_signals(purple_proj)
		
		#
		
		set_current_purple_proj_amount_for_barrage_left(_current_purple_proj_amount_for_barrage_left - 1)

func set_current_purple_proj_amount_for_barrage_left(arg_val):
	_current_purple_proj_amount_for_barrage_left = arg_val
	
	if _current_purple_proj_amount_for_barrage_left <= 0:
		barrage_timer.stop()
		emit_signal("attack_execution_completed")


func _get_targets_for_purple_proj():
	return game_elements.enemy_manager.get_random_targetable_enemies(1)


func _on_purple_proj_tree_exiting(arg_bullet_homing_compo):
	if arg_bullet_homing_compo.is_connected("on_bullet_tree_exiting", self, "_on_purple_proj_tree_exiting"):
		arg_bullet_homing_compo.disconnect("on_bullet_tree_exiting", self, "_on_purple_proj_tree_exiting")
		arg_bullet_homing_compo.disconnect("on_target_tree_exiting", self, "_on_bullet_homing_compo_target_lost")
	
	purple_proj_homing_component_pool.declare_resource_as_available(arg_bullet_homing_compo)


func _on_bullet_homing_compo_target_lost(arg_bullet, arg_bullet_homing_compo : BulletHomingComponent):
	if is_instance_valid(range_module):
		
		var map_targets = game_elements.enemy_manager.get_all_targetable_enemies()
		map_targets = Targeting.enemies_to_target(map_targets, Targeting.CLOSE, 1, global_position)
		if map_targets.size() > 0:
			arg_bullet_homing_compo.target_node_to_home_to = map_targets[0]
			return
	
	arg_bullet.trigger_on_death_events()


func _on_purple_proj_hit_enemy(arg_bullet, arg_enemy):
	var pos = arg_enemy.global_position
	var aoe = purple_explosion_attk_module.construct_aoe(pos, pos)
	
	purple_explosion_attk_module.set_up_aoe__add_child_and_emit_signals(aoe)



func _purple_proj_tree_entered(arg_bullet):
	multiple_trail_component.create_trail_for_node(arg_bullet)

func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = 15
	arg_trail.trail_color = Color(217/255.0, 2/255.0, 167/255.0)
	arg_trail.width = 3
	arg_trail.modulate.a = 0.6

