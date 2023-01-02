extends Reference

const FOV = preload("res://GameInfoRelated/TerrainRelated/FOV.gd")


## layer related

static func is_layer_in_sight_to(layer_a : int, layer_b : int):
	return layer_a <= layer_b

static func is_layer_between_layers_min_and_max_incl(layer_a : int, layer_min : int, layer_max : int):
	return layer_a >= layer_min and layer_a <= layer_max

##

static func convert_areas_to_polygons(
	arg_areas, 
	arg_global_position,
	arg_curr_terrain_layer = -1
	):
	var polygons := []
	
	for area in arg_areas:
		for child in area.get_children():
			if arg_curr_terrain_layer == -1 or area.should_block_vision_on_terrain_layer(arg_curr_terrain_layer):
				if child is CollisionPolygon2D:
					#polygons.append(child.polygon)
					var points := []
					for point in child.polygon:
						
						points.append(point + area.global_position - arg_global_position)
					
					polygons.append(PoolVector2Array(points))
	
	return polygons

#######################

## uses threads to calculate polygon_of_vision, calling an object's method when done
#static func thread__get_polygon_resulting_from_vertices__circle(
#		arg_terrain_vertices_array : Array,
#		arg_radius : float,
#		arg_fov_node : FOV,
#		arg_obj_to_call : Object,
#		arg_obj_method : String
#		):
#
#	print("called thread method from TerrainFuncs")
#	var circle_vertex_arr = _get_radius_as_point_array(arg_radius)
#	var vertices_array : Array = arg_terrain_vertices_array.duplicate()
#	vertices_array.append(circle_vertex_arr)
#
#	arg_fov_node.request_get_fov_from_polygons_using_threads(vertices_array, Vector2(0, 0), arg_obj_to_call, arg_obj_method)


# returns polygon_of_vision instantly, not using threads.
static func get_polygon_resulting_from_vertices__circle(
		arg_terrain_vertices_array : Array, #[[PoolVector2Array, a, b, c], [d, ... , g], [h, i, j]] # each array defines a shape
		arg_radius : float,
		arg_fov_node : FOV
		):
	
	var circle_vertex_arr = _get_radius_as_point_array(arg_radius)
	var vertices_array : Array = arg_terrain_vertices_array.duplicate()
	vertices_array.append(circle_vertex_arr)
	#vertices_array.insert(0, circle_vertex_arr)
	
	
	#return _slide_points_of_array_to_in_range(arg_fov_node.get_fov_from_polygons(vertices_array, Vector2(0, 0)), arg_radius)
	var vision_polygon = arg_fov_node.get_fov_from_polygons(vertices_array, Vector2(0, 0))
	if !Geometry.triangulate_polygon(vision_polygon).empty():
		return vision_polygon
	else:
		print("ERROR TRIANGULATION FAILED -- TerrainFuncs")
		return circle_vertex_arr
#	var circle_vertex_arr = _get_radius_as_point_array(arg_radius)
#	var vertices_array : Array = _slide_points_of_vertices_array_to_in_range(arg_terrain_vertices_array, arg_radius)
#	vertices_array.append(circle_vertex_arr)
#
#	return arg_fov_node.get_fov_from_polygons(vertices_array, Vector2(0, 0))


## circle vertices
static func _get_radius_as_point_array(arg_radius : float):
	var point_arr = []
	var vertex_count : int = int(arg_radius / 2.75)
	
	for i in vertex_count:
		point_arr.append(_get_point_pos_using_radius_and_index(arg_radius, i, vertex_count))
	
	return PoolVector2Array(point_arr)

static func _get_point_pos_using_radius_and_index(arg_radius, arg_index : float, arg_max_index : float) -> Vector2:
	return Vector2(arg_radius, 0).rotated(2 * PI * (arg_index / arg_max_index))


## sliding points to in-range to prevent vertices/segment intersection
static func _slide_points_of_vertices_array_to_in_range(
		arg_terrain_vertices_array : Array,
		arg_radius : float
		):
	
	#return arg_terrain_vertices_array
	
	var origin : Vector2 = Vector2.ZERO

	var slid_points_pool_array := []
	for pool_vector2_array in arg_terrain_vertices_array:
		var point_arr := []

		for point in pool_vector2_array:
			point_arr.append(point.limit_length(arg_radius))


		var slid_pvector2_arr = PoolVector2Array(point_arr)
		slid_points_pool_array.append(slid_pvector2_arr)

	return slid_points_pool_array
	
############
#	var origin : Vector2 = Vector2.ZERO
#
#	var slid_points_pool_array := []
#	for pool_vector2_array in arg_terrain_vertices_array:
#		var point_arr := []
#
#		var points_to_append := []
#		var point_indexes_to_append := []
#
#		var prev_point_index : int = -1
#		var is_prev_point_in_range : bool
#		for point in pool_vector2_array:
#			var distance = origin.distance_to(point)
#
#			if distance > arg_radius:
#				#point_arr.append(point.move_toward(origin, distance - arg_radius))
#				if is_prev_point_in_range and prev_point_index != -1:
#					points_to_append.append(point_arr[prev_point_index].limit_length(arg_radius))
#					point_indexes_to_append.append(prev_point_index + 1)
#
#				is_prev_point_in_range = false
#			else:
#				if !is_prev_point_in_range and prev_point_index != -1:
#					points_to_append.append(point_arr[prev_point_index].limit_length(arg_radius))
#					point_indexes_to_append.append(prev_point_index + 1)
#
#				is_prev_point_in_range = true
#
#			point_arr.append(point)
#			prev_point_index += 1
#
#		var i = 0
#		for point_index in point_indexes_to_append:
#			point_arr.insert(point_index, points_to_append[i])
#			i += 1
#
#		var slid_pvector2_arr = PoolVector2Array(point_arr)
#		slid_points_pool_array.append(slid_pvector2_arr)
#
#	return slid_points_pool_array


#

## sliding points to in-range to prevent vertices/segment intersection
static func _slide_points_of_array_to_in_range(
		arg_terrain_vertices_array : Array,
		arg_radius : float
		):
	
	var origin : Vector2 = Vector2.ZERO
	
	var slid_points_pool_array := []
	for point in arg_terrain_vertices_array:
		slid_points_pool_array.append(point.limit_length(arg_radius))
	
	return slid_points_pool_array


