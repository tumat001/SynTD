extends Node

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const GameElements = preload("res://GameElementsRelated/GameElements.gd")
const InMapPlacablesManager = preload("res://GameElementsRelated/InMapPlacablesManager.gd")

var tower_inventory_bench
var game_elements : GameElements
var in_map_placables_manager : InMapPlacablesManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Adding tower as child of this to monitor it
func add_tower(tower_instance : AbstractTower):
	add_child(tower_instance)
	tower_instance.connect("tower_being_dragged", self, "_tower_being_dragged")
	tower_instance.connect("tower_dropped_from_dragged", self, "_tower_dropped_from_dragged")
	tower_instance.connect("tower_show_info", self, "_tower_show_info")
	tower_instance.connect("tower_in_queue_free", self, "_tower_in_queue_free")
	tower_instance.connect("update_active_synergy", self, "_update_active_synergy")
	

func _tower_being_dragged():
	tower_inventory_bench.make_all_slots_glow()
	in_map_placables_manager.make_all_placables_glow()

func _tower_dropped_from_dragged():
	tower_inventory_bench.make_all_slots_not_glow()
	in_map_placables_manager.make_all_placables_not_glow()

func _tower_show_info():
	pass

func _tower_in_queue_free():
	_update_active_synergy()

func _update_active_synergy():
	game_elements.synergy_manager.update_synergies(_get_all_synegy_contributing_towers())


func _get_all_synegy_contributing_towers() -> Array:
	var bucket : Array = []
	for tower in get_children():
		if tower is AbstractTower and tower.is_contributing_to_synergy:
			bucket.append(tower)
	
	return bucket

