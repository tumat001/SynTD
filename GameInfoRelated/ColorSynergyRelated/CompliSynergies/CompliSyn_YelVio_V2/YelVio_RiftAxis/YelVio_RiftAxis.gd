extends "res://TowerRelated/AbstractTower.gd"

const TowerEffect_YelVio_VioletSide = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Effects/TowerEffect_YelVio_VioletSideEffect.gd")
const TowerEffect_YelVio_YellowSide = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Effects/TowerEffect_YelVio_YellowSideEffect.gd")

const RiftSwapSides_AbilityPic = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/YelVio_RiftAxis/GUI/Assets/YelVio_RiftAxis_SwapRiftSide_AbilityIcon.png")

#

var _rift_angle_point : float
const _rift_angle_to_direction_point_modi : float = 90.0
const _rift_pivot_point_modi : Vector2 = Vector2(0, -15)

var _rotated_rift_height_as_vector
var _rotated_rift_height_as_vector__plus_PI
var _rotated_rift_height_as_vector__plus_half_PI
var _rotated_rift_height_as_vector__plus_three_half_PI

#

var _rift_start_animation_delta_timer : Timer
var _is_in_rift_expand_animation : bool
const _rift_expand_delta : float = 0.02
const _rift_expand_percent_per_sec : float = 0.3
var _current_rift_expand_percent : float = 0.0

const _yellow_rift_modulate := Color(233/255.0, 1, 0, 0.1)
const _violet_rift_modulate := Color(163/255.0, 77/255.0, 253/255.0, 0.3)
const _boundary_rift_modulate := Color(217/255.0, 81/255.0, 2/255.0, 0.4)

const _rift_height : float = 1700.0
var _rift_height_as_vector : Vector2 = Vector2(0, 0)  #Vector2(0, _rift_height) #use this if no need for rift expand animation on first time summon


var is_rift_sides_flipped : bool = false
var is_rift_axis_activated : bool = true

const round_ongoing_clause : int = -10
var rift_swap_sides_ability : BaseAbility
var rift_swap_sides_ability_condi_clause : ConditionalClauses

var yel_vio_syn

#

onready var rift_layer = $RiftLayer


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.YELVIO_RIFT_AXIS)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = 0
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	
	tower_limit_slots_taken = 0
	is_a_summoned_tower = true
	
	can_be_sold_conditonal_clauses.attempt_insert_clause(CanBeSoldClauses.IS_NOT_SELLABLE_GENERIC_TAG)
	can_be_used_as_ingredient_conditonal_clauses.attempt_insert_clause(CanBeUsedAsIngredientClauses.CANNOT_BE_USED_AS_ING_GENERIC_TAG)
	can_be_placed_in_bench_conditional_clause.attempt_insert_clause(CanBePlacedInBenchClauses.GENERIC_CANNOT_BE_PLACED_IN_BENCH)
	untargetability_clauses.attempt_insert_clause(UntargetabilityClauses.GENERIC_IS_UNTARGETABLE_CLAUSE)
	
	rift_layer.position += _rift_pivot_point_modi
	rift_layer.z_as_relative = false
	rift_layer.z_index = ZIndexStore.ABOVE_MAP_ENVIRONMENT
	
	_post_inherit_ready()
	
	#
	
	connect("on_tower_transfered_to_placable", self, "_on_transfered_to_new_placable", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	connect("global_position_changed", self, "_on_global_pos_changed", [], CONNECT_PERSIST)
	rift_layer.connect("draw", self, "_draw_on_rift_layer", [], CONNECT_PERSIST)
	game_elements.tower_manager.connect("tower_added", self, "_connect_signals_for_tower_on_dropped_to_placable", [], CONNECT_PERSIST)
	game_elements.map_manager.connect("all_enemy_paths_of_base_map_changed", self, "_on_enemy_paths_in_map_changed", [], CONNECT_PERSIST)
	
	#
	_update_rift_angle_point()
	call_deferred("_called_from_ready__update_rift_poses_draw_rift_and_give_stats")
	
	_construct_abilities()
	
	#
	
	# rift expand anim related
	_rift_start_animation_delta_timer = Timer.new()
	_rift_start_animation_delta_timer.one_shot = false
	_rift_start_animation_delta_timer.connect("timeout", self, "_on_rift_start_animation_delta_timer_timeout", [], CONNECT_PERSIST)
	add_child(_rift_start_animation_delta_timer)
	_rift_start_animation_delta_timer.start(_rift_expand_delta)

#


func _get_rift_pivot_point() -> Vector2:
	return global_position + _rift_pivot_point_modi

func _update_rift_angle_point():
	var ave_exit_pos_of_all_paths = game_elements.map_manager.get_average_exit_position_of_all_paths()
	
	_rift_angle_point = _get_rift_pivot_point().angle_to_point(ave_exit_pos_of_all_paths)
	_rift_angle_point += deg2rad(_rift_angle_to_direction_point_modi)
	

#

func _called_from_ready__update_rift_poses_draw_rift_and_give_stats():
	_update_rift_poses__and_draw_rift()
	_give_tower_effects_based_on_rift_side_pos()
	for tower in tower_manager.get_all_towers_except_in_queue_free():
		_connect_signals_for_tower_on_dropped_to_placable(tower, false)
		

func _update_rift_poses__and_draw_rift():
	_update_rotated_rift_height_poses()
	_update_draw_of_rift_layer()

func _update_rotated_rift_height_poses():
	_update_rift_angle_point()
	

func _update_draw_of_rift_layer():
	rift_layer.update()


func _draw_on_rift_layer():
	_rift_height_as_vector = Vector2(0, _rift_height * _current_rift_expand_percent)
	
	_rotated_rift_height_as_vector = _rift_height_as_vector.rotated(_rift_angle_point)
	_rotated_rift_height_as_vector__plus_PI = _rift_height_as_vector.rotated(_rift_angle_point + PI)
	_rotated_rift_height_as_vector__plus_half_PI = _rift_height_as_vector.rotated(_rift_angle_point + (PI / 2))
	_rotated_rift_height_as_vector__plus_three_half_PI = _rift_height_as_vector.rotated(_rift_angle_point + (3 * PI / 2))

	
	var yellow_poly_points : Array = []
	yellow_poly_points.append(_rotated_rift_height_as_vector)
	yellow_poly_points.append(_rotated_rift_height_as_vector__plus_PI)
	if !is_rift_sides_flipped:
		yellow_poly_points.append(_rotated_rift_height_as_vector__plus_PI - _rotated_rift_height_as_vector__plus_half_PI)
		yellow_poly_points.append(_rotated_rift_height_as_vector - _rotated_rift_height_as_vector__plus_half_PI)
	else:
		yellow_poly_points.append(_rotated_rift_height_as_vector__plus_PI + _rotated_rift_height_as_vector__plus_half_PI)
		yellow_poly_points.append(_rotated_rift_height_as_vector + _rotated_rift_height_as_vector__plus_half_PI)
	
	var yellow_colors : Array = []
	for i in yellow_poly_points.size():
		yellow_colors.append(_yellow_rift_modulate)
	rift_layer.draw_polygon(PoolVector2Array(yellow_poly_points), PoolColorArray(yellow_colors))
	
	rift_layer.draw_line(_rotated_rift_height_as_vector, _rotated_rift_height_as_vector__plus_PI, _boundary_rift_modulate, 3)
	
	#
	var violet_poly_points : Array = []
	violet_poly_points.append(_rotated_rift_height_as_vector)
	violet_poly_points.append(_rotated_rift_height_as_vector__plus_PI)
	if !is_rift_sides_flipped:
		violet_poly_points.append(_rotated_rift_height_as_vector__plus_PI + _rotated_rift_height_as_vector__plus_half_PI)
		violet_poly_points.append(_rotated_rift_height_as_vector + _rotated_rift_height_as_vector__plus_half_PI)
	else:
		violet_poly_points.append(_rotated_rift_height_as_vector__plus_PI - _rotated_rift_height_as_vector__plus_half_PI)
		violet_poly_points.append(_rotated_rift_height_as_vector - _rotated_rift_height_as_vector__plus_half_PI)
	
	var violet_colors : Array = []
	for i in violet_poly_points.size():
		violet_colors.append(_violet_rift_modulate)
	rift_layer.draw_polygon(PoolVector2Array(violet_poly_points), PoolColorArray(violet_colors))
	
	rift_layer.draw_line(_rotated_rift_height_as_vector, _rotated_rift_height_as_vector__plus_PI, _boundary_rift_modulate, 3)

func _give_tower_effects_based_on_rift_side_pos():
	for tower in game_elements.tower_manager.get_all_towers_except_in_queue_free():
		_give_tower_effects_based_on_rift_side_pos_to_tower(tower)

func _give_tower_effects_based_on_rift_side_pos_to_tower(arg_tower):
	if is_rift_axis_activated:
		if arg_tower != self:
			if _is_tower_on_violet_side(arg_tower):
				_give_tower_violet_effect_side(arg_tower)
			else:
				_give_tower_yellow_effect_side(arg_tower)



func _is_tower_on_violet_side(arg_tower):
	var tower_pos = arg_tower.global_position
	
	var angle_to_tower = _get_rift_pivot_point().angle_to_point(tower_pos)
	
	if !is_rift_sides_flipped:
		var angle_01 = rad2deg(_rift_angle_point + (PI / 2)) 
		var angle_02 = rad2deg(_rift_angle_point + (3 * PI / 2))
		
		if _rift_angle_point < 0:#angle_01 > angle_02:
			
			return !Targeting.is_angle_between_angles(rad2deg(angle_to_tower), angle_02, angle_01)
		else:
			
			if _rift_angle_point <= (PI / 2):
				return !Targeting.is_angle_between_angles(rad2deg(angle_to_tower), angle_02, angle_01)
			else:
				return Targeting.is_angle_between_angles(rad2deg(angle_to_tower), angle_02, angle_01)
		
		
	else:
		var angle_01 = rad2deg(_rift_angle_point + (PI / 2))
		var angle_02 = rad2deg(_rift_angle_point + (3 * PI / 2))
		
		if _rift_angle_point < 0:#angle_01 > angle_02:
			
			return Targeting.is_angle_between_angles(rad2deg(angle_to_tower), angle_02, angle_01)
		else:
			
			if _rift_angle_point <= (PI / 2):
				return Targeting.is_angle_between_angles(rad2deg(angle_to_tower), angle_02, angle_01)
			else:
				return !Targeting.is_angle_between_angles(rad2deg(angle_to_tower), angle_02, angle_01)
		
		
#		if angle_01 > angle_02:
#			return !Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_01, angle_02)
#		else:
#			return !Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_02, angle_01)


#func _is_tower_on_violet_side(arg_tower):
#	var tower_pos = arg_tower.global_position
#
#	var angle_to_tower = _get_rift_pivot_point().angle_to_point(tower_pos)
#
#	if !is_rift_sides_flipped:
#		var angle_01 = rad2deg(_rift_angle_point + (PI / 2)) 
#		var angle_02 = rad2deg(_rift_angle_point + (3 * PI / 2))
#
#		if _rift_angle_point < 0:#angle_01 > angle_02:
#			#return Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_01, angle_02)
#			return !Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_02, angle_01)
#		else:
#			return Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_02, angle_01)
#
#
#	else:
#		var angle_01 = rad2deg(_rift_angle_point + (PI / 2))
#		var angle_02 = rad2deg(_rift_angle_point + (3 * PI / 2))
#
#		if _rift_angle_point < 0:#angle_01 > angle_02:
#			#return Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_01, angle_02)
#			return Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_02, angle_01)
#		else:
#			return !Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_02, angle_01)
#
#
##		if angle_01 > angle_02:
##			return !Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_01, angle_02)
##		else:
##			return !Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_02, angle_01)



func _give_tower_yellow_effect_side(arg_tower):
	var vio_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.YELVIO_VIOLET_SIDE_EFFECT)
	if vio_effect != null:
		arg_tower.remove_tower_effect(vio_effect)
	
	if !arg_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.YELVIO_YELLOW_SIDE_EFFECT):
		var effect = TowerEffect_YelVio_YellowSide.new()
		effect.explosion_base_damage = yel_vio_syn.current_yel_side_explosion_damage
		
		effect.connect_signals_with_syn(yel_vio_syn)
		arg_tower.add_tower_effect(effect)


func _give_tower_violet_effect_side(arg_tower):
	var yel_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.YELVIO_YELLOW_SIDE_EFFECT)
	if yel_effect != null:
		arg_tower.remove_tower_effect(yel_effect)
	
	if !arg_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.YELVIO_VIOLET_SIDE_EFFECT):
		var effect = TowerEffect_YelVio_VioletSide.new()
		effect.scale_amount_to_use = yel_vio_syn.current_vio_side_ing_upgrade_amount
		
		arg_tower.add_tower_effect(effect)


func _remove_rift_tower_effects_from_towers():
	for arg_tower in tower_manager.get_all_towers_except_in_queue_free():
		var yel_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.YELVIO_YELLOW_SIDE_EFFECT)
		if yel_effect != null:
			arg_tower.remove_tower_effect(yel_effect)
		
		var vio_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.YELVIO_VIOLET_SIDE_EFFECT)
		if vio_effect != null:
			arg_tower.remove_tower_effect(vio_effect)


#

func _on_global_pos_changed(arg_old_pos, arg_new_pos):
	_update_rift_poses__and_draw_rift()
	

func _on_transfered_to_new_placable(arg_self, arg_placable):
	_update_rift_poses__and_draw_rift()
	_give_tower_effects_based_on_rift_side_pos()

func _on_enemy_paths_in_map_changed(arg_base_map, arg_paths):
	_update_rift_poses__and_draw_rift()
	_give_tower_effects_based_on_rift_side_pos()

#

func _connect_signals_for_tower_on_dropped_to_placable(arg_tower, arg_give_effect : bool = true):
	if arg_tower != self:
		if !arg_tower.is_connected("on_tower_transfered_to_placable", self, "_on_non_self_tower_transfered_to_new_placable"):
			arg_tower.connect("on_tower_transfered_to_placable", self, "_on_non_self_tower_transfered_to_new_placable", [], CONNECT_PERSIST)
		
		if arg_give_effect:
			_on_non_self_tower_transfered_to_new_placable(arg_tower, null)


func _on_non_self_tower_transfered_to_new_placable(arg_tower, arg_placable):
	_give_tower_effects_based_on_rift_side_pos_to_tower(arg_tower)


# rift expand anim related

func _on_rift_start_animation_delta_timer_timeout():
	_current_rift_expand_percent += _rift_expand_percent_per_sec * _rift_expand_delta
	
	if _current_rift_expand_percent >= 1.0:
		_current_rift_expand_percent = 1.0
		
		_rift_start_animation_delta_timer.stop()
	
	_update_draw_of_rift_layer()

func set_current_rift_expand(arg_val):
	_current_rift_expand_percent = arg_val
	
	_update_draw_of_rift_layer()

######

func _construct_abilities():
	rift_swap_sides_ability = BaseAbility.new()
	
	rift_swap_sides_ability.is_timebound = true
	rift_swap_sides_ability.connect("ability_activated", self, "_rift_swap_sides_ability_activated", [], CONNECT_PERSIST)
	rift_swap_sides_ability.icon = RiftSwapSides_AbilityPic
	
	rift_swap_sides_ability.set_properties_to_usual_tower_based()
	rift_swap_sides_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	rift_swap_sides_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	rift_swap_sides_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	rift_swap_sides_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	rift_swap_sides_ability_condi_clause = rift_swap_sides_ability.activation_conditional_clauses
	
	rift_swap_sides_ability_condi_clause.blacklisted_clauses.erase(BaseAbility.ActivationClauses.ROUND_ONGOING_STATE)
	
	rift_swap_sides_ability.tower = self
	
	rift_swap_sides_ability.descriptions = [
		"Swaps the side of the rift."
	]
	rift_swap_sides_ability.display_name = "Swap Sides"
	
	register_ability_to_manager(rift_swap_sides_ability, false)

func _rift_swap_sides_ability_activated():
	is_rift_sides_flipped = !is_rift_sides_flipped
	
	_update_rift_poses__and_draw_rift()
	_give_tower_effects_based_on_rift_side_pos()


## called from syn

func activate_rift_axis():
	is_rift_axis_activated = true
	_current_rift_expand_percent = 1.0
	_update_rift_poses__and_draw_rift()
	_give_tower_effects_based_on_rift_side_pos()
	
	can_be_sold_conditonal_clauses.attempt_insert_clause(CanBeSoldClauses.IS_NOT_SELLABLE_GENERIC_TAG)

func deactivate_rift_axis():
	is_rift_axis_activated = false
	_remove_rift_tower_effects_from_towers()
	_current_rift_expand_percent = 0.0
	_rift_start_animation_delta_timer.stop()
	_update_rift_poses__and_draw_rift()
	
	can_be_sold_conditonal_clauses.remove_clause(CanBeSoldClauses.IS_NOT_SELLABLE_GENERIC_TAG)

##


