extends Node2D

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

signal on_occupancy_changed(tower_occupying_nullable)
signal on_tower_left_placement(tower_left)
signal last_calculated_can_be_occupied_changed(arg_val)
signal last_calculated_occupancy_reserved_changed(arg_val)


#

var tower_occupying setget set_tower_occupying

#

enum CanBeOccupiedClauseIds {
	HAS_TOWER = 0,
	
	NOT_VISIBLE = 1,
	
	#
	
	OCCUPANCY_RESERVED = 2
}

var can_be_occupied_clauses : ConditionalClauses
var last_calculated_can_be_occupied : bool
var last_calculated_can_be_occupied__ignoring_has_tower_clause : bool
var last_calculated_can_be_occupied__ignoring_has_tower__and_transfer_atomic__clauses : bool

#

# used for queries with "if_slot_can_be_placed_with_tower",
enum OccupancyReservedClauseIds {
	TOWER_TRANSFER_TO_THIS_PLACABLE__ATOMIC = 0
	
	MAP_MEMORIES__IN_RECALL_BEAM_IN_FLIGHT = 1
	
}

var occupancy_reserved_clauses : ConditionalClauses
var last_calculated_occupancy_is_reserved : bool


###

export(int) var layer_on_terrain : int = 0 setget set_layer_on_terrain


var last_calculated_is_untargetable : bool = false    # used by targeting

#

func _init():
	can_be_occupied_clauses = ConditionalClauses.new()
	can_be_occupied_clauses.connect("clause_inserted", self, "_on_can_be_occupied_clause_added_or_removed", [], CONNECT_PERSIST)
	can_be_occupied_clauses.connect("clause_removed", self, "_on_can_be_occupied_clause_added_or_removed", [], CONNECT_PERSIST)
	
	occupancy_reserved_clauses = ConditionalClauses.new()
	occupancy_reserved_clauses.connect("clause_inserted", self, "_on_occupancy_reserved_clauses_added_or_removed", [], CONNECT_PERSIST)
	occupancy_reserved_clauses.connect("clause_removed", self, "_on_occupancy_reserved_clauses_added_or_removed", [], CONNECT_PERSIST)
	
	
	#
	
	if !is_connected("visibility_changed", self, "_on_visibility_changed_base"):
		connect("visibility_changed", self, "_on_visibility_changed_base", [], CONNECT_PERSIST)
	
	_on_visibility_changed_base()
	_update_is_tower_occupying_clause()
	_on_can_be_occupied_clause_added_or_removed(0)
	_update_last_calc_occupancy_reserved()

func _on_can_be_occupied_clause_added_or_removed(arg_clause_id):
	last_calculated_can_be_occupied = can_be_occupied_clauses.is_passed
	last_calculated_can_be_occupied__ignoring_has_tower_clause = can_be_occupied_clauses.has_only_clause_or_no_clause(CanBeOccupiedClauseIds.HAS_TOWER)
	last_calculated_can_be_occupied__ignoring_has_tower__and_transfer_atomic__clauses = can_be_occupied_clauses.has_only_clause_or_no_clause(CanBeOccupiedClauseIds.HAS_TOWER) and occupancy_reserved_clauses.has_only_clause_or_no_clause(OccupancyReservedClauseIds.TOWER_TRANSFER_TO_THIS_PLACABLE__ATOMIC)
	
	emit_signal("last_calculated_can_be_occupied_changed", last_calculated_can_be_occupied)

func _on_visibility_changed_base():
	if visible:
		can_be_occupied_clauses.remove_clause(CanBeOccupiedClauseIds.NOT_VISIBLE)
	else:
		can_be_occupied_clauses.attempt_insert_clause(CanBeOccupiedClauseIds.NOT_VISIBLE)


func _on_occupancy_reserved_clauses_added_or_removed(_arg_clause_id):
	_update_last_calc_occupancy_reserved()

func _update_last_calc_occupancy_reserved():
	last_calculated_occupancy_is_reserved = !occupancy_reserved_clauses.is_passed
	
	if last_calculated_occupancy_is_reserved:
		can_be_occupied_clauses.attempt_insert_clause(CanBeOccupiedClauseIds.OCCUPANCY_RESERVED)
		
	else:
		can_be_occupied_clauses.remove_clause(CanBeOccupiedClauseIds.OCCUPANCY_RESERVED)
		
	
	emit_signal("last_calculated_occupancy_reserved_changed", last_calculated_occupancy_is_reserved)



#

func add_reservation__tower_occupying_swap__atomic():
	occupancy_reserved_clauses.attempt_insert_clause(OccupancyReservedClauseIds.TOWER_TRANSFER_TO_THIS_PLACABLE__ATOMIC)

func flush_all_occupancy_reservation():
	if occupancy_reserved_clauses.has_any_clause():
		occupancy_reserved_clauses.remove_all_clauses()
	

#

func set_tower_occupying(arg_tower):
	if is_instance_valid(tower_occupying) and tower_occupying != arg_tower:
		emit_signal("on_tower_left_placement", tower_occupying)
	
	tower_occupying = arg_tower
	
	_update_is_tower_occupying_clause()
	
	if is_instance_valid(tower_occupying):
		#tower_occupying.layer_on_terrain = layer_on_terrain
		tower_occupying.set_placable_layer_on_terrain_modi(layer_on_terrain)
		flush_all_occupancy_reservation()
	
	emit_signal("on_occupancy_changed", tower_occupying)



func _update_is_tower_occupying_clause():
	if is_instance_valid(tower_occupying):
		can_be_occupied_clauses.attempt_insert_clause(CanBeOccupiedClauseIds.HAS_TOWER)
	else:
		can_be_occupied_clauses.remove_clause(CanBeOccupiedClauseIds.HAS_TOWER)
	


# Called when the node enters the scene tree for the first time.
func _ready():
	z_as_relative = false
	z_index = ZIndexStore.TOWER_PLACABLES
	
	_on_visibility_changed_base()

func get_tower_center_position() -> Vector2:
	return $TowerCenterLocation.global_position

func set_tower_highlight_sprite(texture : Resource):
	$TowerHighlightSprite.texture = texture

func set_area_texture_to_glow():
	pass

func set_area_texture_to_not_glow():
	pass

func get_area_shape():
	var new_rect = RectangleShape2D.new() 
	new_rect.extents.x = $AreaShape.shape.extents.x
	new_rect.extents.y = $AreaShape.shape.extents.y
	
	return new_rect

######

func set_layer_on_terrain(arg_val):
	layer_on_terrain = arg_val
	
	if is_instance_valid(tower_occupying):
		#tower_occupying.layer_on_terrain = layer_on_terrain
		tower_occupying.set_placable_layer_on_terrain_modi(layer_on_terrain)

#

func if_slot_can_be_placed_with_tower__for_find_unreserved():
	return if_slot_can_be_placed_with_tower__for_insert() and !last_calculated_occupancy_is_reserved

func if_slot_can_be_placed_with_tower__for_insert():
	return last_calculated_can_be_occupied and !is_instance_valid(tower_occupying)


