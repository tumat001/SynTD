extends Node

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

var tower_inventory_bench

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_tower(tower_instance : AbstractTower):
	add_child(tower_instance)
	tower_instance.connect("tower_being_dragged", self, "_tower_being_dragged")
	tower_instance.connect("tower_dropped_from_dragged", self, "_tower_dropped_from_dragged")
	tower_instance.connect("tower_show_info", self, "_tower_show_info")


func _tower_being_dragged():
	tower_inventory_bench.make_all_slots_glow()

func _tower_dropped_from_dragged():
	tower_inventory_bench.make_all_slots_not_glow()

func _tower_show_info():
	pass
