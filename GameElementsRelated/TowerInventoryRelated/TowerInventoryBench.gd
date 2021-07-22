extends Node2D

const TowerBenchSlot = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/TowerBenchSlot.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")

const MONO_SCENE = preload("res://TowerRelated/Color_Gray/Mono/Mono.tscn")


signal before_tower_is_added(tower)

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

func insert_tower(tower_id : int, arg_bench_slot = _find_empty_slot()):
	var bench_slot = arg_bench_slot
	
	if bench_slot != null:
		var tower_as_instance : AbstractTower = Towers.get_tower_scene(tower_id).instance()
		
		tower_as_instance.hovering_over_placable = bench_slot
		emit_signal("before_tower_is_added", tower_as_instance)
		tower_manager.add_tower(tower_as_instance)

func insert_tower_from_last(tower_id : int):
	insert_tower(tower_id, _find_empty_slot_from_last())


# Returns null if no empty slot
func _find_empty_slot() -> TowerBenchSlot:
	for bench_slot in all_bench_slots:
		if bench_slot.tower_occupying == null:
			return bench_slot
	
	return null

func _find_empty_slot_from_last() -> TowerBenchSlot:
	for i in range(all_bench_slots.size() - 1, 0, -1):
		if all_bench_slots[i].tower_occupying == null:
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
