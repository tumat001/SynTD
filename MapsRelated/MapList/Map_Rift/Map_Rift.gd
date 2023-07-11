extends "res://MapsRelated/BaseMap.gd"

const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const EnemyInvisibilityEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyInvisibilityEffect.gd")

const RectDrawNode = preload("res://MiscRelated/DrawRelated/RectDrawNode/RectDrawNode.gd")


#

var game_elements

var top_right_pos : Vector2
var bot_left_pos : Vector2
var middle_pos : Vector2

var _dist_from_top_right_to_bot_left : float
var _angle_from_top_right_to_bot_left : float


const rift_color__for_speed := Color(16/255.0, 8/255.0, 68/255.0, 0.4)
const rift_color__for_invis := Color(16/255.0, 8/255.0, 68/255.0, 0.85)

const rift_expand_time : float = 1.0 # do not change this, for now. fix the underlying bug that makes the coll shape and rift draw not consistent with each other if this is not 1


class RiftProperties:
	
	var speed_amount : float = 20.0
	#var speed_duration : float = -1
	#var invis_duration : float = -1
	
	
	var rift_width__for_speed : int
	var rift_width__for_invis : int


var stage_num_to_rift_properties_map : Dictionary = {}

#

var rift_aoe_attack_module : AOEAttackModule
#var rift_aoe_attack_module__invisibility : AOEAttackModule

var rift_aoe__speed : BaseAOE
var rift_aoe__invisiblity : BaseAOE

#

#var _next_stageround_id : String
#var _next_rift_properties : RiftProperties

var _current_speed_amount : float = 20.0

var _current_rift_properties : RiftProperties


var _current_draw_params__for_rift_speed : RectDrawNode.DrawParams
var _current_draw_params__for_rift_invis : RectDrawNode.DrawParams

var _prev_draw_params__for_rift_speed : RectDrawNode.DrawParams
var _prev_draw_params__for_rift_invis : RectDrawNode.DrawParams

#

onready var rect_draw_node = $Environment/RectDrawNode

#

func _ready():
	_construct_aoe_attk_modules_and_rift_aoes()
	
	rect_draw_node.z_index = ZIndexStore.ABOVE_ABOVE_MAP_ENVIRONMENT
	rect_draw_node.z_as_relative = false
	rect_draw_node.global_position = Vector2(0, 0)

func _construct_aoe_attk_modules_and_rift_aoes():
	rift_aoe_attack_module = AOEAttackModule_Scene.instance()
	rift_aoe_attack_module.base_damage = 0
	rift_aoe_attack_module.base_damage_type = DamageType.PHYSICAL
	rift_aoe_attack_module.base_attack_speed = 0
	rift_aoe_attack_module.base_attack_wind_up = 0
	rift_aoe_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	rift_aoe_attack_module.is_main_attack = false
	rift_aoe_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	rift_aoe_attack_module.benefits_from_bonus_explosion_scale = false
	rift_aoe_attack_module.benefits_from_bonus_base_damage = false
	rift_aoe_attack_module.benefits_from_bonus_attack_speed = false
	rift_aoe_attack_module.benefits_from_bonus_on_hit_damage = false
	rift_aoe_attack_module.benefits_from_bonus_on_hit_effect = false
	rift_aoe_attack_module.benefits_from_ingredient_effect = false
	
	rift_aoe_attack_module.pierce = -1
	rift_aoe_attack_module.duration = 1
	rift_aoe_attack_module.is_decrease_duration = false
	rift_aoe_attack_module.damage_repeat_count = 1
	
	rift_aoe_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.RECTANGLE
	rift_aoe_attack_module.base_aoe_scene = BaseAOE_Scene
	rift_aoe_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	rift_aoe_attack_module.can_be_commanded_by_tower = false
	
	
	rift_aoe_attack_module.kill_all_created_aoe_at_round_end = false
	rift_aoe_attack_module.is_displayed_in_tracker = false
	
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(rift_aoe_attack_module)
	
	########
	
	rift_aoe__speed = rift_aoe_attack_module.construct_aoe(middle_pos, middle_pos)
	#var shape__speed = RectangleShape2D.new()
	_configure_rift_aoe__commonalities(rift_aoe__speed)
	rift_aoe_attack_module.set_up_aoe__add_child_and_emit_signals(rift_aoe__speed)
	rift_aoe__speed.connect("enemy_entered", self, "_on_rift_aoe_speed_enemy_entered", [], CONNECT_PERSIST)
	rift_aoe__speed.connect("enemy_exited", self, "_on_rift_aoe_speed_enemy_exited", [], CONNECT_PERSIST)
	
	
	rift_aoe__invisiblity = rift_aoe_attack_module.construct_aoe(middle_pos, middle_pos)
	#var shape__invis = RectangleShape2D.new()
	_configure_rift_aoe__commonalities(rift_aoe__invisiblity)
	rift_aoe_attack_module.set_up_aoe__add_child_and_emit_signals(rift_aoe__invisiblity)
	rift_aoe__invisiblity.connect("enemy_entered", self, "_on_rift_aoe_invis_enemy_entered", [], CONNECT_PERSIST)
	rift_aoe__invisiblity.connect("enemy_exited", self, "_on_rift_aoe_invis_enemy_exited", [], CONNECT_PERSIST)
	


func _configure_rift_aoe__commonalities(arg_rift_aoe : BaseAOE):#, arg_shape : RectangleShape2D):
	#arg_shape.extents.x = top_right_pos.distance_to(bot_left_pos)
	
	arg_rift_aoe.rotation = top_right_pos.angle_to(bot_left_pos)


#

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	game_elements = arg_game_elements
	
	##
	
	_configure_rift_poses_and_properties()
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)


func _configure_rift_poses_and_properties():
	var top_left_pos = game_elements.get_top_left_coordinates_of_playable_map()
	var bot_right_pos = game_elements.get_bot_right_coordinates_of_playable_map()
	
	top_right_pos = Vector2(bot_right_pos.x, top_left_pos.y)
	bot_left_pos = Vector2(top_left_pos.x, bot_right_pos.y)
	middle_pos = game_elements.get_middle_coordinates_of_playable_map()
	
	_dist_from_top_right_to_bot_left = top_right_pos.distance_to(bot_left_pos)
	_angle_from_top_right_to_bot_left = bot_left_pos.angle_to_point(top_right_pos)
	
	#
	
	rift_aoe__speed.global_position = middle_pos
	rift_aoe__invisiblity.global_position = middle_pos
	
	rift_aoe__speed.rotation = _angle_from_top_right_to_bot_left
	rift_aoe__invisiblity.rotation = _angle_from_top_right_to_bot_left
	
	#
	
#	var texture = Sprite.new()
#	texture.position = top_right_pos
#	texture.texture = preload("res://MiscRelated/CommonTextures/CommonTextures_TargetParticle.png")
#	add_child(texture)
#
#	var texture2 = Sprite.new()
#	texture2.position = bot_left_pos
#	texture2.texture = preload("res://MiscRelated/CommonTextures/CommonTextures_TargetParticle.png")
#	add_child(texture2)
	
	#######
	
	_current_rift_properties = RiftProperties.new()
	_current_rift_properties.rift_width__for_speed = 0
	_current_rift_properties.rift_width__for_invis = 0
	
	_update_current_draw_params()
	
	######
	
	var rift_properties_01 = RiftProperties.new()
	rift_properties_01.rift_width__for_speed = 50
	rift_properties_01.rift_width__for_invis = 0
	stage_num_to_rift_properties_map["01"] = rift_properties_01
	
	var rift_properties_11 = RiftProperties.new()
	rift_properties_11.rift_width__for_speed = 100
	rift_properties_11.rift_width__for_invis = 0
	stage_num_to_rift_properties_map["11"] = rift_properties_11
	
	var rift_properties_21 = RiftProperties.new()
	rift_properties_21.rift_width__for_speed = 150
	rift_properties_21.rift_width__for_invis = 0
	stage_num_to_rift_properties_map["21"] = rift_properties_21
	
	var rift_properties_31 = RiftProperties.new()
	rift_properties_31.rift_width__for_speed = 200
	rift_properties_31.rift_width__for_invis = 0
	stage_num_to_rift_properties_map["31"] = rift_properties_31
	
	var rift_properties_41 = RiftProperties.new()
	rift_properties_41.rift_width__for_speed = 200
	rift_properties_41.rift_width__for_invis = 20
	stage_num_to_rift_properties_map["41"] = rift_properties_41
	
	var rift_properties_51 = RiftProperties.new()
	rift_properties_51.rift_width__for_speed = 240
	rift_properties_51.rift_width__for_invis = 40
	stage_num_to_rift_properties_map["51"] = rift_properties_51
	
	var rift_properties_61 = RiftProperties.new()
	rift_properties_61.rift_width__for_speed = 280
	rift_properties_61.rift_width__for_invis = 60
	stage_num_to_rift_properties_map["61"] = rift_properties_61
	
	var rift_properties_71 = RiftProperties.new()
	rift_properties_71.rift_width__for_speed = 320
	rift_properties_71.rift_width__for_invis = 80
	stage_num_to_rift_properties_map["71"] = rift_properties_71
	
	var rift_properties_81 = RiftProperties.new()
	rift_properties_81.rift_width__for_speed = 400 #360
	rift_properties_81.rift_width__for_invis = 140 #120
	stage_num_to_rift_properties_map["81"] = rift_properties_81
	
	var rift_properties_91 = RiftProperties.new()
	rift_properties_91.rift_width__for_speed = 400
	rift_properties_91.rift_width__for_invis = 140 #160
	stage_num_to_rift_properties_map["91"] = rift_properties_91
	

########

func _on_rift_aoe_speed_enemy_entered(arg_enemy):
	if !arg_enemy.has_effect_uuid(StoreOfEnemyEffectsUUID.MAP_RIFT__RIFT_SPEED_EFFECT):
		arg_enemy._add_effect(_construct_rift_speed_effect__based_on_current_properties())
	

func _construct_rift_speed_effect__based_on_current_properties():
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.MAP_RIFT__RIFT_SPEED_EFFECT)
	slow_modifier.percent_amount = _current_speed_amount
	slow_modifier.percent_based_on = PercentType.BASE
	
	var slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.MAP_RIFT__RIFT_SPEED_EFFECT)
	slow_effect.is_timebound = false
	slow_effect.is_from_enemy = true
	
	return slow_effect


func _on_rift_aoe_speed_enemy_exited(arg_enemy):
	var effect = arg_enemy.get_effect_with_uuid(StoreOfEnemyEffectsUUID.MAP_RIFT__RIFT_SPEED_EFFECT)
	if effect != null:
		arg_enemy._remove_effect(effect)
	


func _on_rift_aoe_invis_enemy_entered(arg_enemy):
	if !arg_enemy.has_effect_uuid(StoreOfEnemyEffectsUUID.MAP_RIFT__RIFT_INVIS_EFFECT):
		arg_enemy._add_effect(_construct_rift_invis_effect__based_on_current_properties())
	
	

func _construct_rift_invis_effect__based_on_current_properties():
	var invis_effect = EnemyInvisibilityEffect.new(-1, StoreOfEnemyEffectsUUID.MAP_RIFT__RIFT_INVIS_EFFECT)
	invis_effect.is_from_enemy = true
	invis_effect.is_timebound = false
	invis_effect.modulate_a_for_invis = 0.2
	invis_effect.break_invis_on_x_offset_remaining = false
	
	return invis_effect


func _on_rift_aoe_invis_enemy_exited(arg_enemy):
	var effect = arg_enemy.get_effect_with_uuid(StoreOfEnemyEffectsUUID.MAP_RIFT__RIFT_INVIS_EFFECT)
	if effect != null:
		arg_enemy._remove_effect(effect)
	
	

##############

func _on_round_ended(arg_stageround):
	var id = arg_stageround.id
	
	if stage_num_to_rift_properties_map.has(id):
		set_current_rift_properties(stage_num_to_rift_properties_map[id])
	

func set_current_rift_properties(arg_properties : RiftProperties):
	_current_rift_properties = arg_properties
	
	_update_current_draw_params()
	_update_draw_based_on_new_current_properties_and_draw_params()

#func set_next_rift_properties_and_ids(arg_properties : RiftProperties, arg_next_stageround_id : String):
#	pass
#


##########
# DRAW RELATED
##########


func _update_current_draw_params():
	_prev_draw_params__for_rift_speed = _current_draw_params__for_rift_speed
	_prev_draw_params__for_rift_invis = _current_draw_params__for_rift_invis
	
	
	### SPEED
	if _current_rift_properties.rift_width__for_speed != 0:
		_current_draw_params__for_rift_speed = RectDrawNode.DrawParams.new()
		_current_draw_params__for_rift_speed.fill_color = rift_color__for_speed
		_current_draw_params__for_rift_speed.lifetime_to_start_transparency = -1
		_current_draw_params__for_rift_speed.angle_rad = _angle_from_top_right_to_bot_left
		_current_draw_params__for_rift_speed.lifetime_of_draw = rift_expand_time
		_current_draw_params__for_rift_speed.pivot_point = middle_pos
		
		if _prev_draw_params__for_rift_speed != null:
			_current_draw_params__for_rift_speed.initial_rect = _prev_draw_params__for_rift_speed.target_rect
		else:
			var initial_rect = Rect2()
			initial_rect.position = Vector2(_dist_from_top_right_to_bot_left, 0)
			initial_rect.end = Vector2(_dist_from_top_right_to_bot_left, 0)
			
			_current_draw_params__for_rift_speed.initial_rect = initial_rect
		
		_current_draw_params__for_rift_speed.target_rect = _construct_target_rect_from_rift_properties__for_speed(_current_rift_properties)
		var rect_shape = _construct_rect_shape_2d_from_rect_2(_current_draw_params__for_rift_speed.target_rect)
		
		if rift_aoe__speed.is_inside_tree():
			rift_aoe__speed.set_coll_shape(rect_shape)
		else:
			rift_aoe__speed.aoe_shape_to_set_on_ready = rect_shape
	
	### INVIS
	if _current_rift_properties.rift_width__for_invis != 0:
		_current_draw_params__for_rift_invis = RectDrawNode.DrawParams.new()
		_current_draw_params__for_rift_invis.fill_color = rift_color__for_invis
		_current_draw_params__for_rift_invis.lifetime_to_start_transparency = -1
		_current_draw_params__for_rift_invis.angle_rad = _angle_from_top_right_to_bot_left
		_current_draw_params__for_rift_invis.lifetime_of_draw = rift_expand_time
		_current_draw_params__for_rift_invis.pivot_point = middle_pos
		
		if _prev_draw_params__for_rift_invis != null:
			_current_draw_params__for_rift_invis.initial_rect = _prev_draw_params__for_rift_invis.target_rect
		else:
			var initial_rect = Rect2()
			initial_rect.position = Vector2(_dist_from_top_right_to_bot_left, 0)
			initial_rect.end = Vector2(_dist_from_top_right_to_bot_left, 0)
			
			_current_draw_params__for_rift_invis.initial_rect = initial_rect
		
		_current_draw_params__for_rift_invis.target_rect = _construct_target_rect_from_rift_properties__for_invis(_current_rift_properties)
		var rect_shape = _construct_rect_shape_2d_from_rect_2(_current_draw_params__for_rift_invis.target_rect)
		if rift_aoe__invisiblity.is_inside_tree():
			rift_aoe__invisiblity.set_coll_shape(rect_shape)
		else:
			rift_aoe__invisiblity.aoe_shape_to_set_on_ready = rect_shape
	

func _construct_target_rect_from_rift_properties__for_speed(arg_properties : RiftProperties):
	var target_rect = Rect2()
	target_rect.position = Vector2(_dist_from_top_right_to_bot_left, arg_properties.rift_width__for_speed / 2)
	target_rect.end = Vector2(-_dist_from_top_right_to_bot_left, -arg_properties.rift_width__for_speed / 2) 
	
	return target_rect

func _construct_target_rect_from_rift_properties__for_invis(arg_properties : RiftProperties):
	var target_rect = Rect2()
	target_rect.position = Vector2(_dist_from_top_right_to_bot_left, arg_properties.rift_width__for_invis / 2)
	target_rect.end = Vector2(-_dist_from_top_right_to_bot_left, -arg_properties.rift_width__for_invis / 2) 
	
	return target_rect


func _update_draw_based_on_new_current_properties_and_draw_params():
	if _prev_draw_params__for_rift_speed != null:
		rect_draw_node.remove_draw_param(_prev_draw_params__for_rift_speed)
	if _prev_draw_params__for_rift_invis != null:
		rect_draw_node.remove_draw_param(_prev_draw_params__for_rift_invis)
	
	if _current_draw_params__for_rift_speed != null:
		rect_draw_node.add_draw_param(_current_draw_params__for_rift_speed)
	if _current_draw_params__for_rift_invis != null:
		rect_draw_node.add_draw_param(_current_draw_params__for_rift_invis)
	


func _construct_rect_shape_2d_from_rect_2(arg_rect_2 : Rect2):
	var center = arg_rect_2.get_center()
	
	var shape = RectangleShape2D.new()
	shape.extents = (arg_rect_2.position - center)
	
	return shape

