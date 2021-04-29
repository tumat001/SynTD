extends Node2D

const TowerBenchSlot = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/TowerBenchSlot.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")

const MONO_SCENE = preload("res://TowerRelated/Color_Gray/Mono/Mono.tscn")

var tower_manager : TowerManager
var all_bench_slots : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = ZIndexStore.TOWER_BENCH
	
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
		$BenchSlot10
	]

func insert_tower(tower_id : int):
	var bench_slot = _find_empty_slot()
	
	if bench_slot != null:
		var center_pos : Vector2 = bench_slot.get_tower_center_position()
		var tower_as_instance : AbstractTower = Towers.get_tower_scene(tower_id).instance()
		
		# TODO Make this a child of something else that
		# will keep track of the colors and towers
		tower_as_instance.hovering_over_placable = bench_slot
		tower_manager.add_tower(tower_as_instance)

# Returns null if no empty slot
func _find_empty_slot() -> TowerBenchSlot:
	for bench_slot in all_bench_slots:
		if bench_slot.tower_occupying == null:
			return bench_slot
	
	return null

func is_bench_full() -> bool:
	return _find_empty_slot() == null


func make_all_slots_glow():
	for bench in all_bench_slots:
		bench.set_area_texture_to_glow()

func make_all_slots_not_glow():
	for bench in all_bench_slots:
		bench.set_area_texture_to_not_glow()
