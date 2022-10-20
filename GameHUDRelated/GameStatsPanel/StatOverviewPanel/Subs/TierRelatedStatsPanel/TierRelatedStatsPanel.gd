extends MarginContainer


var stat_overview
var selected_tiers_arr

onready var tower_tier_buttons_panel = $VBoxContainer/TowerTierButtonsPanel
onready var absorb_panel = $VBoxContainer/VBoxContainer/AbsorbPanel
onready var combination_panel = $VBoxContainer/VBoxContainer/CombinationPanel

func _ready():
	tower_tier_buttons_panel.select_all_tier_buttons()
	selected_tiers_arr = tower_tier_buttons_panel.selected_tiers

#

func _on_TowerTierButtonsPanel_tiers_selected_changed(arg_selected_tiers_arr):
	selected_tiers_arr = arg_selected_tiers_arr
	
	update_display()

func update_display():
	if stat_overview != null:
		_update_absorb_panel(selected_tiers_arr)
		_update_combination_panel(selected_tiers_arr)


func _update_absorb_panel(arg_selected_tiers_arr):
	var total = _get_total_of_selected_tiers_in_map(stat_overview.ing_tier_to_total_count_map, arg_selected_tiers_arr)
	absorb_panel.text = str(total)

func _update_combination_panel(arg_selected_tiers_arr):
	var total = _get_total_of_selected_tiers_in_map(stat_overview.combi_tier_to_total_count_map, arg_selected_tiers_arr)
	combination_panel.text = str(total)

#


func _get_total_of_selected_tiers_in_map(arg_map : Dictionary, arg_tiers : Array) -> int:
	var total = 0
	
	for tier in arg_map.keys():
		if arg_tiers.has(tier):
			total += arg_map[tier]
	
	return total
