extends MarginContainer

const RightSidePanel = preload("res://GameHUDRelated/RightSidePanel/RightSidePanel.gd")

var right_side_panel : RightSidePanel


func _on_DamageStatsButton_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		if right_side_panel.panel_showing == RightSidePanel.Panels.ROUND_DAMAGE_STATS:
			_hide_round_dmg_stat_panel()
		else:
			_show_round_dmg_stat_panel()



func _hide_round_dmg_stat_panel():
	right_side_panel.show_default_panel()

func _show_round_dmg_stat_panel():
	right_side_panel.show_round_damage_stats_panel()

