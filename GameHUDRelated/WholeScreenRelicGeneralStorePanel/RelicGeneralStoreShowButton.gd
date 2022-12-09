extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButtonWithTooltip.gd"


func set_relic_manager(arg_manager):
	arg_manager.connect("current_relic_count_changed", self, "_on_current_relic_amount_changed")
	_on_current_relic_amount_changed(arg_manager.current_relic_count)


func _on_current_relic_amount_changed(arg_val):
	visible = arg_val > 0

