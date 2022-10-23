extends MarginContainer

const SynergyIconPanel = preload("res://GameHUDRelated/SynergyIconPanel/SynergyIconPanel.gd")
const SynergyIconPanel_Scene = preload("res://GameHUDRelated/SynergyIconPanel/SynergyIconPanel.tscn")


onready var hbox_container = $MarginContainer/HBoxContainer

# expects [[syn_id, tier_num], [...], [...]]
func set_synergy_and_tier_arr(arg_syn_and_tier_arr):
	_clear_syn_icon_container()
	
	for syn_and_tier in arg_syn_and_tier_arr:
		var icon_panel = SynergyIconPanel_Scene.instance()
		icon_panel.show_tier = true
		icon_panel.set_synergy_id_and_tier(syn_and_tier[0], syn_and_tier[1])
		
		hbox_container.add_child(icon_panel)

func _clear_syn_icon_container():
	for child in hbox_container.get_children():
		child.queue_free()

