extends MarginContainer


var stat_overview

onready var tower_icons_panel = $VBoxContainer/VBoxContainer/Towers/TowerIconsPanel
onready var synergy_icons_panel = $VBoxContainer/VBoxContainer/Synergies/SynergyIconsPanel
onready var total_damage_panel = $VBoxContainer/VBoxContainer/Damage/TotalDamagePanel

#

func update_display():
	if stat_overview != null:
		_update_tower_icons_panel()
		_update_syn_icons_panel()
		_update_total_damage_panel()

func _update_tower_icons_panel():
	tower_icons_panel.set_tower_ids_to_display(stat_overview.tower_ids_played_at_end)

func _update_syn_icons_panel():
	synergy_icons_panel.set_synergy_and_tier_arr(stat_overview.synergy_ids_and_tiers_played_at_end)

func _update_total_damage_panel():
	total_damage_panel.set_damage_values(stat_overview.total_damage_dealt, stat_overview.total_physical_damage_dealt, stat_overview.total_pure_damage_dealt, stat_overview.total_elemental_damage_dealt)

#

