extends Reference

const FOV = preload("res://GameInfoRelated/TerrainRelated/FOV.gd")

## layer related

static func is_layer_in_sight_to(layer_a : int, layer_b : int):
	return layer_a >= layer_b

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

# returns polygon_of_vision
static func get_polygon_resulting_from_vertices__circle(
		arg_terrain_vertices_array : Array, #[[PoolVector2Array, a, b, c], [d, ... , g], [h, i, j]] # each array defines a shape
		arg_radius : float,
		arg_fov_node : FOV
		):
	
	var circle_vertex_arr = _get_radius_as_point_array(arg_radius)
	var vertices_array : Array = _slide_points_of_vertices_array_to_in_range(arg_terrain_vertices_array, arg_radius)
	vertices_array.append(circle_vertex_arr)
	
	return arg_fov_node.get_fov_from_polygons(vertices_array, Vector2(0, 0))

## circle vertices
static func _get_radius_as_point_array(arg_radius : float):
	var point_arr = []
	var vertex_count : int = arg_radius 
	
	for i in vertex_count:
		point_arr.append(_get_point_pos_using_radius_and_index(arg_radius, i))
	
	return PoolVector2Array(point_arr)

static func _get_point_pos_using_radius_and_index(arg_radius, arg_index) -> Vector2:
	return Vector2(arg_radius, 0).rotated(2 * PI * arg_index / arg_radius)

## sliding points to in-range to prevent vertices/segment intersection
static func _slide_points_of_vertices_array_to_in_range(
		arg_terrain_vertices_array : Array,
		arg_radius : float
		):
	
	var slid_points_pool_array := []
	for pool_vector2_array in arg_terrain_vertices_array:
		var point_arr := []
		for point in pool_vector2_array:
			point_arr.append(point.limit_length(arg_radius))
		
		var slid_pvector2_arr = PoolVector2Array(point_arr)
		slid_points_pool_array.append(slid_pvector2_arr)
	
	return slid_points_pool_array

