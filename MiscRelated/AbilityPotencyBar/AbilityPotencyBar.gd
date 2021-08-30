extends MarginContainer


const Bar_Normal = preload("res://MiscRelated/AbilityPotencyBar/AbilityPotencyBar_BarFill.png")
const Bar_Overflow = preload("res://MiscRelated/AbilityPotencyBar/AbilityPotencyBar_BarFillOverflow.png")


onready var ap_bar = $APBar

var tower setget set_tower

#

func _ready():
	update_display()

#

func set_tower(arg_tower):
	if tower != null:
		tower.disconnect("final_ability_potency_changed", self, "_tower_ap_changed")
		tower.disconnect("tower_not_in_active_map", self, "_should_be_shown_status_changed")
		tower.disconnect("tower_active_in_map", self, "_should_be_shown_status_changed")
	
	tower = arg_tower
	
	if tower != null:
		tower.connect("final_ability_potency_changed", self, "_tower_ap_changed", [], CONNECT_PERSIST)
		tower.connect("tower_not_in_active_map", self, "_should_be_shown_status_changed", [], CONNECT_PERSIST)
		tower.connect("tower_active_in_map", self, "_should_be_shown_status_changed", [], CONNECT_PERSIST)
		
		update_display()

#


func _tower_ap_changed():
	ap_bar.current_value = tower.last_calculated_final_ability_potency
	#print(str(ap_bar.current_value) + " --- " + str(ap_bar.max_value))
	
	if tower.last_calculated_final_ability_potency > ap_bar.max_value:
		ap_bar.fill_foreground_pic = Bar_Overflow
	else:
		ap_bar.fill_foreground_pic = Bar_Normal


func _should_be_shown_status_changed():
	#visible = tower.is_current_placable_in_map()
	pass

#

func update_display():
	if tower != null:
		_should_be_shown_status_changed()
		_tower_ap_changed()


