extends MarginContainer

onready var multiple_tower_damage_stats_container = $MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/MultipleTowerRoundDamageStatsPanel
onready var single_tower_detailed_damage_stats_panel = $MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/SingleTowerDetailedRDSP
onready var stats_container_container = $MarginContainer/VBoxContainer/ScrollContainer/MarginContainer

func set_tower_manager(arg_manager):
	multiple_tower_damage_stats_container.tower_manager = arg_manager

func set_stage_round_manager(arg_manager):
	multiple_tower_damage_stats_container.stage_round_manager = arg_manager
	single_tower_detailed_damage_stats_panel.stage_round_manager = arg_manager

#

func _ready():
	show_multiple_tower_rdsp_only()
	
	single_tower_detailed_damage_stats_panel.connect("on_tower_queue_free", self, "_on_tower_in_single_tower_rdsp_tree_exiting", [], CONNECT_PERSIST)
	multiple_tower_damage_stats_container.connect("on_tower_in_single_panel_left_clicked", self, "_on_tower_in_multiple_tower_rdsp_selected", [], CONNECT_PERSIST)
	single_tower_detailed_damage_stats_panel.connect("on_back_button_pressed", self, "_on_single_tower_detailed_panel_back_button_pressed", [], CONNECT_PERSIST)


func show_multiple_tower_rdsp_only():
	#multiple_tower_damage_stats_container.visible = true
	#single_tower_detailed_damage_stats_panel.visible = false
	stats_container_container.move_child(multiple_tower_damage_stats_container, 1)
	stats_container_container.move_child(single_tower_detailed_damage_stats_panel, 0)

func show_single_tower_detailed_rdsp_only():
	#multiple_tower_damage_stats_container.visible = false
	#single_tower_detailed_damage_stats_panel.visible = true
	stats_container_container.move_child(multiple_tower_damage_stats_container, 0)
	stats_container_container.move_child(single_tower_detailed_damage_stats_panel, 1)

#

func _on_tower_in_single_tower_rdsp_tree_exiting(tower):
	show_multiple_tower_rdsp_only()
	single_tower_detailed_damage_stats_panel.set_tower(null)


func _on_tower_in_multiple_tower_rdsp_selected(tower):
	if is_instance_valid(tower):
		show_single_tower_detailed_rdsp_only()
		single_tower_detailed_damage_stats_panel.set_tower(tower)


func _on_single_tower_detailed_panel_back_button_pressed():
	show_multiple_tower_rdsp_only()
	single_tower_detailed_damage_stats_panel.set_tower(null)
