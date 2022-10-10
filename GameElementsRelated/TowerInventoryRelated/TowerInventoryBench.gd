extends Node2D

const TowerBenchSlot = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/TowerBenchSlot.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")

const MONO_SCENE = preload("res://TowerRelated/Color_Gray/Mono/Mono.tscn")


signal before_tower_is_added(tower)
signal before_tower_is_added__is_tower_bought_aware(tower, is_tower_bought)

signal tower_entered_bench_slot(tower, bench_slot)
signal tower_removed_from_bench_slot(tower, bench_slot)

var tower_manager : TowerManager
var all_bench_slots : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = ZIndexStore.TOWER_BENCH
	z_as_relative = false
	
	all_bench_slots = [
		$BenchSlot01,
		$BenchSlot02,
		$BenchSlot03,
		$BenchSlot04,
		$BenchSlot05,
		$BenchSlot06,
		$BenchSlot07,
		$BenchSlot08,
		$BenchSlot09,
		$BenchSlot10,
	]
	
	for bench_slot in all_bench_slots:
		bench_slot.connect("on_occupancy_changed", self, "_on_occupancy_in_bench_slot_changed", [bench_slot], CONNECT_PERSIST)
		bench_slot.connect("on_tower_left_placement", self, "_on_tower_left_bench_slot", [bench_slot], CONNECT_PERSIST)
		bench_slot.z_index = ZIndexStore.TOWER_BENCH_PLACABLES


func insert_tower(tower_id : int, arg_bench_slot = _find_empty_slot(), is_tower_bought : bool = false) -> AbstractTower:
	var bench_slot = arg_bench_slot
	
	if is_instance_valid(bench_slot):
		return create_tower_and_add_to_scene(tower_id, bench_slot, is_tower_bought)
	else:
		return null

func insert_tower_from_last(tower_id : int, is_tower_bought : bool = false) -> AbstractTower:
	return insert_tower(tower_id, _find_empty_slot_from_last(), is_tower_bought)


#

func create_tower_and_add_to_scene(tower_id : int, arg_placable_slot, is_tower_bought : bool = false) -> AbstractTower:
	var tower_as_instance := create_tower(tower_id, arg_placable_slot)
	
	add_tower_to_scene(tower_as_instance, is_tower_bought)
	
	return tower_as_instance


func create_tower(tower_id : int, arg_placable_slot) -> AbstractTower:
	# if it says "called instance on nil", you probably did not give the GDScript in Towers's get_tower_scene function
	var tower_as_instance : AbstractTower = Towers.get_tower_scene(tower_id).instance()
	
	tower_as_instance.hovering_over_placable = arg_placable_slot
	tower_as_instance.current_placable = arg_placable_slot
	
	return tower_as_instance

func add_tower_to_scene(arg_tower_instance, is_tower_bought : bool = false):
	arg_tower_instance.is_tower_bought = is_tower_bought
	
	emit_signal("before_tower_is_added", arg_tower_instance)
	emit_signal("before_tower_is_added__is_tower_bought_aware", arg_tower_instance, is_tower_bought)
	tower_manager.add_tower(arg_tower_instance)


#

func _find_number_of_empty_slots() -> int:
	var amount : int = 0
	
	for bench_slot in all_bench_slots:
		if !is_instance_valid(bench_slot.tower_occupying):
			amount += 1
	
	return amount


# Returns null if no empty slot
func _find_empty_slot() -> TowerBenchSlot:
	for bench_slot in all_bench_slots:
		if !is_instance_valid(bench_slot.tower_occupying):
			return bench_slot
	
	return null

func _find_empty_slot_from_last() -> TowerBenchSlot:
	for i in range(all_bench_slots.size() - 1, 0, -1):
		if !is_instance_valid(all_bench_slots[i].tower_occupying):
			return all_bench_slots[i]
	
	return null


func is_bench_full() -> bool:
	return _find_empty_slot() == null


func make_all_slots_glow():
	for bench in all_bench_slots:
		bench.set_area_texture_to_glow()

func make_all_slots_not_glow():
	for bench in all_bench_slots:
		bench.set_area_texture_to_not_glow()

#


func _on_occupancy_in_bench_slot_changed(tower, bench_slot):
	if is_instance_valid(tower):
		emit_signal("tower_entered_bench_slot", tower, bench_slot)
	else:
		emit_signal("tower_removed_from_bench_slot", tower, bench_slot)

func _on_tower_left_bench_slot(tower, bench_slot):
	#emit_signal("tower_removed_from_bench_slot", tower, bench_slot)
	pass
