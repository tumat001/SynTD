extends MarginContainer


const Bar_Normal = preload("res://TowerRelated/Color_Blue/Accumulae/SiphonStacksBar/AbilityPotencyBar_BarFill.png")
const Bar_Overflow = preload("res://TowerRelated/Color_Blue/Accumulae/SiphonStacksBar/AbilityPotencyBar_BarFillOverflow.png")


onready var siphon_bar = $APBar

var tower setget set_tower

#

func _ready():
	update_display()

#

func set_tower(arg_tower):
	if is_instance_valid(tower):
		tower.disconnect("current_siphon_stacks_changed", self, "_tower_curr_stacks_changed")
		tower.disconnect("tower_not_in_active_map", self, "_should_be_shown_status_changed")
		tower.disconnect("tower_active_in_map", self, "_should_be_shown_status_changed")
	
	tower = arg_tower
	
	if is_instance_valid(tower):
		tower.connect("current_siphon_stacks_changed", self, "_tower_curr_stacks_changed", [], CONNECT_PERSIST)
		tower.connect("tower_not_in_active_map", self, "_should_be_shown_status_changed", [], CONNECT_PERSIST)
		tower.connect("tower_active_in_map", self, "_should_be_shown_status_changed", [], CONNECT_PERSIST)
		
		update_display()

#


func _tower_curr_stacks_changed():
	siphon_bar.current_value = tower.current_siphon_stacks
	#print(str(ap_bar.current_value) + " --- " + str(ap_bar.max_value))
	
	if tower.current_siphon_stacks > siphon_bar.max_value:
		siphon_bar.fill_foreground_pic = Bar_Overflow
	else:
		siphon_bar.fill_foreground_pic = Bar_Normal


func _should_be_shown_status_changed():
	#visible = tower.is_current_placable_in_map()
	pass

#

func update_display():
	if is_instance_valid(tower):
		_should_be_shown_status_changed()
		_tower_curr_stacks_changed()


