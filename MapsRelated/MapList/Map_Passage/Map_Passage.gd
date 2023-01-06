extends "res://MapsRelated/BaseMap.gd"

const InMapAreaPlacable_Scene = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.tscn")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

#

const initial_path_water_on_state : bool = false
const initial_path_fire_on_state : bool = true

const enemy_path_id__edge_to__edge = 0
const enemy_path_id__edge_to__middle = 1
const enemy_path_id__middle_to__edge = 2
const enemy_path_id__middle_to__middle = 3

#

const fire_percent_health_dmg_per_sec : float = 4.0
const fire_percent_type : int = PercentType.MAX  # if changing this, change description as well
const fire_dmg_type : int = DamageType.ELEMENTAL
const fire_dmg_minimum : float = 0.20

const water_slow_amount_percent : float = -65.0
var water_slow_effect : EnemyAttributesEffect

var map_passage__aoe_creator__hidden_tower

#

var _vector_arr__left_to_right__special_path_vectors : Array
var _vector_arr__left_to_right__normal_path_vectors : Array
var _vector_arr__down_to_up__path_vectors : Array

var _center_pos_of_playable_map : Vector2
var _slide_to_right_amount : float   # for sliding vectors from left to right (for symmetry)
var _slide_to_top_amount : float   # for sliding vectors from bottom to top (for symmetry)


# "00" is when both paths are closed (all mid)
# "10" is when fire path is open, and water path is closed
# there are 2 arrays inside, with each array being a curve
# first index (0) is bottom curve, then second index (1) is top curve
var _path_configuration_to_vector_arr_map : Dictionary = {
	"00" : [],
	"10" : [],
	"01" : [],
	"11" : [],
}

#

var game_elements

enum ButtonActivatableClauses {
	ROUND_STARTED = 0,
	BEAM_FORMING_OR_ENDING = 1
}
var button_activatable_conditional_clauses : ConditionalClauses

var _descriptions_for_path_fire : Array
var _descriptions_for_path_water : Array

var _path_to_water_on : bool
var _path_to_fire_on : bool

var _do_not_update_path_curve : bool = true  # true only at the very start to avoid 1 unneeded calc


#

onready var background = $Environment/Background
onready var center_of_map_node_2d = $MarkerTemplates/CenterOfMap

onready var path_button__fire = $Environment/PathButton_Fire
onready var path_button__water = $Environment/PathButton_Water

onready var path_description_panel__fire = $Environment/PathDescriptionPanel_Fire
onready var path_description_panel__water = $Environment/PathDescriptionPanel_Water

onready var special_path_vectors_poly2d = $MarkerTemplates/SpecialPathVectors
onready var normal_path_vectors_poly2d = $MarkerTemplates/NormalPathVectors
onready var down_to_up_vectors_poly2d = $MarkerTemplates/DownToUpVectors
onready var path_aoe_basis_vectors = $MarkerTemplates/PathAOEBasis

onready var enemy_path_top = $EnemyPaths/EnemyPathTop
onready var enemy_path_bottom = $EnemyPaths/EnemyPathBottom

onready var path_barrier__fire_top = $Environment/PathBarrier_Fire_Top
onready var path_barrier__fire_bottom = $Environment/PathBarrier_Fire_Bottom
onready var path_barrier__water_top = $Environment/PathBarrier_Water_Top
onready var path_barrier__water_bottom = $Environment/PathBarrier_Water_Bottom
onready var path_barrier__middle_left = $Environment/PathBarrier_Middle_Left
onready var path_barrier__middle_right = $Environment/PathBarrier_Middle_Right



var map_passage_path_fire_tower

#

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	game_elements = arg_game_elements
	
	game_elements.enemy_manager.current_path_to_spawn_pattern = arg_game_elements.enemy_manager.PathToSpawnPattern.SWITCH_PER_SPAWN
	
	button_activatable_conditional_clauses = ConditionalClauses.new()
	button_activatable_conditional_clauses.connect("clause_inserted", self, "_on_button_activatable_conditional_clauses_updated", [], CONNECT_PERSIST)
	button_activatable_conditional_clauses.connect("clause_removed", self, "_on_button_activatable_conditional_clauses_updated", [], CONNECT_PERSIST)
	
	_mirror_placables_to_other_quadrants()
	
	_initialize_path_vectors()
	_initialize_path_descriptions__and_buttons()
	_initialize_and_configure_path_barriers()
	
	_initialize_hidden_towers_and_path_AOEs()


# for symmetry, only 1 quadrant is defined in the map, so create the rest using the poses of the defined (in the editor)
func _mirror_placables_to_other_quadrants():
	# q3 (bot left)
	var original_placables_q3 = get_all_placables__copy()
	_center_pos_of_playable_map = center_of_map_node_2d.global_position 
	
	# q2 (top left)
	_mirror_positions_of_node_2Ds__vertical(_create_copy_of_placables(original_placables_q3), _center_pos_of_playable_map)
	# q1 (top right)
	_mirror_positions_of_node_2Ds__vert_and_horiz(_create_copy_of_placables(original_placables_q3), _center_pos_of_playable_map)
	# q4 (bot right)
	_mirror_positions_of_node_2Ds__horizontal(_create_copy_of_placables(original_placables_q3), _center_pos_of_playable_map)
	

func _create_copy_of_placables(arg_placables) -> Array:
	var arr = []
	for placable in arg_placables:
		var new_placable = InMapAreaPlacable_Scene.instance()
		placable.configure_placable_to_copy_own_properties(new_placable)
		
		arr.append(new_placable)
		
		add_in_map_placable(new_placable, placable.global_position)
	
	return arr


## MIRROR RELATED

func _mirror_positions_of_node_2Ds__vertical(arg_node_2ds, arg_center : Vector2):
	for node_2d in arg_node_2ds:
		var new_pos = _mirror_vector__vertical(node_2d.global_position, arg_center)
		node_2d.global_position = new_pos

func _mirror_positions_of_node_2Ds__horizontal(arg_node_2ds, arg_center : Vector2):
	for node_2d in arg_node_2ds:
		var new_pos = _mirror_vector__horizontal(node_2d.global_position, arg_center)
		node_2d.global_position = new_pos

func _mirror_positions_of_node_2Ds__vert_and_horiz(arg_node_2ds, arg_center : Vector2):
	for node_2d in arg_node_2ds:
		var new_pos = _mirror_vector__vert_and_horiz(node_2d.global_position, arg_center)
		node_2d.global_position = new_pos


func _mirror_vector__vertical(arg_pos_vec : Vector2, arg_center : Vector2):
	var diff_vec = arg_center - arg_pos_vec
	
	arg_center.y += diff_vec.y
	arg_center.x = arg_pos_vec.x
	return arg_center

func _mirror_vector__horizontal(arg_pos_vec : Vector2, arg_center : Vector2):
	var diff_vec = arg_center - arg_pos_vec
	
	arg_center.x += diff_vec.x
	arg_center.y = arg_pos_vec.y
	return arg_center

func _mirror_vector__vert_and_horiz(arg_pos_vec : Vector2, arg_center : Vector2):
	var diff_vec = arg_center - arg_pos_vec
	
	return arg_center + diff_vec


func _mirror_positions_of_control__vertical(arg_controls, arg_center : Vector2):
	for control in arg_controls:
		var new_pos = _mirror_vector__vertical(control.rect_position, arg_center)
		control.rect_position = new_pos

func _mirror_positions_of_control__horizontal(arg_controls, arg_center : Vector2):
	for control in arg_controls:
		var new_pos = _mirror_vector__horizontal(control.rect_position, arg_center)
		control.rect_position = new_pos

func _mirror_positions_of_control__vert_and_horiz(arg_controls, arg_center : Vector2):
	for control in arg_controls:
		var new_pos = _mirror_vector__vert_and_horiz(control.rect_position, arg_center)
		control.rect_position = new_pos
	


########################### Path related

func _initialize_path_vectors():
	for vector in special_path_vectors_poly2d.polygon:
		_vector_arr__left_to_right__special_path_vectors.append(vector)
	
	for vector in normal_path_vectors_poly2d.polygon:
		_vector_arr__left_to_right__normal_path_vectors.append(vector)
	
	for vector in down_to_up_vectors_poly2d.polygon:
		_vector_arr__down_to_up__path_vectors.append(vector)
	
	_slide_to_right_amount = _center_pos_of_playable_map.x - game_elements.get_top_left_coordinates_of_playable_map().x
	_slide_to_top_amount = _center_pos_of_playable_map.y - game_elements.get_top_left_coordinates_of_playable_map().y - 5 # note: allowance

#

func _initialize_path_descriptions__and_buttons():
	var plain_fragment__burn = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BURN, "Burn")
	var plain_fragment__enemies = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "enemies")
	
	var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
	interpreter_for_flat_on_hit.display_body = false
	
	var ins_for_flat_on_hit = []
	ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, fire_dmg_type, "max health", fire_percent_health_dmg_per_sec, true))
	
	interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
	
	
	_descriptions_for_path_fire = [
		["|0| |1| for |2| every second (min %s)." % [fire_dmg_minimum], [plain_fragment__burn, plain_fragment__enemies, interpreter_for_flat_on_hit]]
	]
	
	
	var plain_fragment__slow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "Slow")
	
	_descriptions_for_path_water = [
		["|0| |1| by %s%%." % [-water_slow_amount_percent], [plain_fragment__slow, plain_fragment__enemies]]
	]
	
	##
	
	path_description_panel__fire.set_descriptions_of_tooltip(_descriptions_for_path_fire)
	path_description_panel__water.set_descriptions_of_tooltip(_descriptions_for_path_water)
	
	##
	
	if game_elements.stage_round_manager.round_started:
		button_activatable_conditional_clauses.attempt_insert_clause(ButtonActivatableClauses.ROUND_STARTED)
	
	_do_not_update_path_curve = true
	path_button__fire.set_button_on_state(initial_path_fire_on_state)
	_do_not_update_path_curve = false
	path_button__water.set_button_on_state(initial_path_water_on_state)
	
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_ended__path_button_related", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("round_started", self, "_on_round_started__path_button_related", [], CONNECT_PERSIST)


# PATH BUTTON RELATED

func _on_button_activatable_conditional_clauses_updated(arg_clause_id):
	path_button__fire.button_border_activatable_state = button_activatable_conditional_clauses.is_passed
	path_button__water.button_border_activatable_state = button_activatable_conditional_clauses.is_passed
	

func _on_round_ended__path_button_related(arg_stageround):
	#path_button__fire.button_border_activatable_state = true
	#path_button__water.button_border_activatable_state = true
	button_activatable_conditional_clauses.remove_clause(ButtonActivatableClauses.ROUND_STARTED)

func _on_round_started__path_button_related(arg_stageround):
	#path_button__fire.button_border_activatable_state = false
	#path_button__water.button_border_activatable_state = false
	button_activatable_conditional_clauses.attempt_insert_clause(ButtonActivatableClauses.ROUND_STARTED)

func _on_PathButton_Fire_button_on_state_changed(arg_val):
	_path_to_fire_on = arg_val
	
	path_description_panel__fire.set_panel_on_state(arg_val)
	if _path_to_fire_on:
		path_barrier__fire_bottom.start_hide()
		path_barrier__fire_top.start_hide()
		path_barrier__middle_left.start_show()
		
	else:
		path_barrier__fire_bottom.start_show()
		path_barrier__fire_top.start_show()
		path_barrier__middle_left.start_hide()
	
	button_activatable_conditional_clauses.attempt_insert_clause(ButtonActivatableClauses.BEAM_FORMING_OR_ENDING)
	
	if !_do_not_update_path_curve:
		_update_enemy_paths_curve_based_on_path_on_states()

func _on_PathButton_Water_button_on_state_changed(arg_val):
	_path_to_water_on = arg_val
	
	path_description_panel__water.set_panel_on_state(arg_val)
	if _path_to_water_on:
		path_barrier__water_bottom.start_hide()
		path_barrier__water_top.start_hide()
		path_barrier__middle_right.start_show()
	else:
		path_barrier__water_bottom.start_show()
		path_barrier__water_top.start_show()
		path_barrier__middle_right.start_hide()
	
	button_activatable_conditional_clauses.attempt_insert_clause(ButtonActivatableClauses.BEAM_FORMING_OR_ENDING)
	
	if !_do_not_update_path_curve:
		_update_enemy_paths_curve_based_on_path_on_states()

# Path related

func _update_enemy_paths_curve_based_on_path_on_states():
	var path_config_string = _get_current_path_configuration_as_string()
	var bottom_curve_vectors : Array
	var top_curve_vectors : Array
	
	if _path_configuration_to_vector_arr_map[path_config_string].size() == 0:
		bottom_curve_vectors = _construct_bottom_enemy_path_curve_for_current_path_config()
		_path_configuration_to_vector_arr_map[path_config_string].append(bottom_curve_vectors)
		
		top_curve_vectors = _construct_top_enemy_path_curve_for_current_path_config()
		_path_configuration_to_vector_arr_map[path_config_string].append(top_curve_vectors)
		
	else:
		bottom_curve_vectors = _path_configuration_to_vector_arr_map[path_config_string][0]
		top_curve_vectors = _path_configuration_to_vector_arr_map[path_config_string][1]
	
	#
	
	var path_id = _convert_config_string_to_path_id(path_config_string)
	
	enemy_path_bottom.set_curve_and_id__using_vector_points(bottom_curve_vectors, path_id)
	enemy_path_top.set_curve_and_id__using_vector_points(top_curve_vectors, path_id)


func _get_current_path_configuration_as_string():
	var base_string = "%s%s"
	
	var fire_config
	var water_cofig
	
	if _path_to_fire_on:
		fire_config = "1"
	else:
		fire_config = "0"
	
	if _path_to_water_on:
		water_cofig = "1"
	else:
		water_cofig = "0"
	
	return base_string % [fire_config, water_cofig]

func _convert_config_string_to_path_id(arg_config_id : String):
	if arg_config_id == "11":
		return enemy_path_id__edge_to__edge
	elif arg_config_id == "10":
		return enemy_path_id__edge_to__middle
	elif arg_config_id == "01":
		return enemy_path_id__middle_to__edge
	elif arg_config_id == "00":
		return enemy_path_id__middle_to__middle

#

func _construct_bottom_enemy_path_curve_for_current_path_config():
	var arr = []
	
	if _path_to_fire_on: # bottom left
		arr.append_array(_vector_arr__left_to_right__special_path_vectors)
		
	else: # middle left
		arr.append_array(_vector_arr__left_to_right__normal_path_vectors)
	
	##
	
	if _path_to_water_on:
		if _path_to_fire_on:  # straight edges
			_trim_start_of_copy_array__and_append_array_2(arr, _slide_vectors_to_right_side__and_append_to_2nd_arr(_vector_arr__left_to_right__special_path_vectors))
			
		else:   # cross middle to edge
			_trim_start_of_copy_array__and_append_array_2(arr, _get_copy_of_array_reversed(_vector_arr__down_to_up__path_vectors))
			_trim_start_of_copy_array__and_append_array_2(arr, _slide_vectors_to_right_side__and_append_to_2nd_arr(_vector_arr__left_to_right__special_path_vectors))
		
	else:
		if _path_to_fire_on:  # cross edge to middle
			_trim_start_of_copy_array__and_append_array_2(arr, _vector_arr__down_to_up__path_vectors)
			_trim_start_of_copy_array__and_append_array_2(arr, _slide_vectors_to_right_side__and_append_to_2nd_arr(_vector_arr__left_to_right__normal_path_vectors))
			
		else:   # straight middle
			_trim_start_of_copy_array__and_append_array_2(arr, _slide_vectors_to_right_side__and_append_to_2nd_arr(_vector_arr__left_to_right__normal_path_vectors))
	
	return arr


func _trim_start_of_copy_array__and_append_array_2(arr_01 : Array, arr_02 : Array):
	var new_arr = arr_02.duplicate(true)
	#new_arr.pop_front()
	arr_01.append_array(new_arr)

func _slide_vectors_to_right_side__and_append_to_2nd_arr(arr_01 : Array):
	var new_arr = []
	
	for pos in arr_01:
		var new_pos = pos + Vector2(_slide_to_right_amount, 0)
		new_arr.append(new_pos)
	
	return new_arr

#func _slide_vectors_to_right_side__mirror_vertical__and_append_to_2nd_arr(arr_01 : Array, arr_02 : Array):
#	var new_arr = []
#
#	for pos in arr_01:
#		var new_pos = pos + Vector2(_slide_to_right_amount, 0)
#		_mirror_vector__vertical(new_pos, center_of_map_node_2d.global_position)
#		new_arr.append(new_pos)
#
#	return new_arr

func _get_copy_of_array_reversed(arr_01 : Array):
	var copy = arr_01.duplicate(true)
	copy.invert()
	return copy


func _construct_top_enemy_path_curve_for_current_path_config():
	var arr = []
	
	if _path_to_fire_on: # bottom left
		arr.append_array(_slide_vectors_to_top_side__and_append_to_2nd_arr(_vector_arr__left_to_right__special_path_vectors))
		
	else: # middle left
		arr.append_array(_vector_arr__left_to_right__normal_path_vectors)
	
	##
	
	if _path_to_water_on:
		if _path_to_fire_on:  # straight edges
			_trim_start_of_copy_array__and_append_array_2(arr, _slide_vectors_to_top_and_right_side__and_append_to_2nd_arr(_vector_arr__left_to_right__special_path_vectors))
			
		else:   # cross edge to middle
			_trim_start_of_copy_array__and_append_array_2(arr, _mirror_vertical_poses(_get_copy_of_array_reversed(_vector_arr__down_to_up__path_vectors)))
			_trim_start_of_copy_array__and_append_array_2(arr, _slide_vectors_to_top_and_right_side__and_append_to_2nd_arr(_vector_arr__left_to_right__special_path_vectors))
		
	else:
		if _path_to_fire_on:  # cross middle to edge
			_trim_start_of_copy_array__and_append_array_2(arr, _mirror_vertical_poses(_vector_arr__down_to_up__path_vectors))
			_trim_start_of_copy_array__and_append_array_2(arr, _slide_vectors_to_right_side__and_append_to_2nd_arr(_vector_arr__left_to_right__normal_path_vectors))
			
		else:   # straight middle
			_trim_start_of_copy_array__and_append_array_2(arr, _slide_vectors_to_right_side__and_append_to_2nd_arr(_vector_arr__left_to_right__normal_path_vectors))
	
	return arr
	


#func _construct_top_enemy_path_curve_for_current_path_config(arg_bottom_path_curve_arr : Array):
#	var arr = []
#
#	arr.append_array(_slide_vectors_to_top_side__and_append_to_2nd_arr(arg_bottom_path_curve_arr, arr))
#
#	return arr

func _slide_vectors_to_top_side__and_append_to_2nd_arr(arr_01 : Array):
	var new_arr = []
	
	for pos in arr_01:
		var new_pos = pos - Vector2(0, _slide_to_top_amount)
		new_arr.append(new_pos)
	
	return new_arr

func _slide_vectors_to_top_and_right_side__and_append_to_2nd_arr(arr_01 : Array):
	var new_arr = []
	
	for pos in arr_01:
		var new_pos = pos + Vector2(_slide_to_right_amount, -_slide_to_top_amount)
		new_arr.append(new_pos)
	
	return new_arr

func _mirror_vertical_poses(arr_01 : Array):
	var new_arr = []

	for pos in arr_01:
		var new_pos = _mirror_vector__vertical(pos, center_of_map_node_2d.global_position)
		new_arr.append(new_pos)

	return new_arr

#####

func _initialize_and_configure_path_barriers():
	path_barrier__fire_bottom.connect("beam_fully_started", self, "_on_barrier_beam_fully_formed_or_ended", [], CONNECT_PERSIST)
	path_barrier__fire_bottom.connect("beam_fully_ended", self, "_on_barrier_beam_fully_formed_or_ended", [], CONNECT_PERSIST)
	
	path_barrier__water_bottom.connect("beam_fully_started", self, "_on_barrier_beam_fully_formed_or_ended", [], CONNECT_PERSIST)
	path_barrier__water_bottom.connect("beam_fully_ended", self, "_on_barrier_beam_fully_formed_or_ended", [], CONNECT_PERSIST)

func _on_barrier_beam_fully_formed_or_ended():
	button_activatable_conditional_clauses.remove_clause(ButtonActivatableClauses.BEAM_FORMING_OR_ENDING)
	



##########

func _initialize_hidden_towers_and_path_AOEs():
	_construct_water_slow_effect()
	
	map_passage__aoe_creator__hidden_tower = game_elements.tower_inventory_bench.create_hidden_tower_and_add_to_scene(Towers.MAP_PASSAGE__FIRE_PATH)
	
	map_passage__aoe_creator__hidden_tower.configure_fire_dmg_using_on_hit(_construct_on_hit_for_fire_dmg())
	
	#
	
	var vectors_of_basis = path_aoe_basis_vectors.polygon
	
	var center_pos_for_aoe_q3 = (vectors_of_basis[0] + vectors_of_basis[2]) / 2
	var extents = vectors_of_basis[3] - center_pos_for_aoe_q3
	
	var center_pos_for_aoe_q2 = _mirror_vector__vertical(center_pos_for_aoe_q3, _center_pos_of_playable_map)
	# fire aoe
	map_passage__aoe_creator__hidden_tower.create_fire_path_aoe_at_pos(center_pos_for_aoe_q3, extents)
	map_passage__aoe_creator__hidden_tower.create_fire_path_aoe_at_pos(center_pos_for_aoe_q2, extents)
	
	
	var center_pos_for_aoe_q4 = _mirror_vector__horizontal(center_pos_for_aoe_q3, _center_pos_of_playable_map)
	var center_pos_for_aoe_q1 = _mirror_vector__vertical(center_pos_for_aoe_q4, _center_pos_of_playable_map)
	# water aoe
	var water_aoe_01 = map_passage__aoe_creator__hidden_tower.create_water_path_aoe_at_pos(center_pos_for_aoe_q4, extents)
	var water_aoe_02 = map_passage__aoe_creator__hidden_tower.create_water_path_aoe_at_pos(center_pos_for_aoe_q1, extents)
	_connect_water_aoe_to_signals(water_aoe_01)
	_connect_water_aoe_to_signals(water_aoe_02)

func _construct_on_hit_for_fire_dmg() -> OnHitDamage:
	var fire_dmg_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.MAP_PASSAGE__FIRE_PATH_DMG)
	fire_dmg_modifier.percent_amount = fire_percent_health_dmg_per_sec
	fire_dmg_modifier.percent_based_on = fire_percent_type
	fire_dmg_modifier.ignore_flat_limits = false
	fire_dmg_modifier.flat_maximum = 10000.0
	fire_dmg_modifier.flat_minimum = fire_dmg_minimum
	
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.MAP_PASSAGE__FIRE_PATH_DMG, fire_dmg_modifier, fire_dmg_type)
	
	return on_hit_dmg

func _construct_water_slow_effect():
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.MAP_PASSAGE__WATER_PATH_SLOW)
	slow_modifier.percent_amount = water_slow_amount_percent
	slow_modifier.percent_based_on = PercentType.BASE
	
	water_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.MAP_PASSAGE__WATER_PATH_SLOW)
	water_slow_effect.is_timebound = false


func _connect_water_aoe_to_signals(arg_aoe):
	arg_aoe.connect("enemy_entered", self, "_on_enemy_entered_water_aoe", [], CONNECT_PERSIST)
	arg_aoe.connect("enemy_exited", self, "_on_enemy_exited_water_aoe", [], CONNECT_PERSIST)

func _on_enemy_entered_water_aoe(arg_enemy):
	arg_enemy._add_effect(water_slow_effect)

func _on_enemy_exited_water_aoe(arg_enemy):
	var slow_effect = arg_enemy.get_effect_with_uuid(water_slow_effect.effect_uuid)
	if slow_effect != null:
		arg_enemy._remove_effect(slow_effect)

