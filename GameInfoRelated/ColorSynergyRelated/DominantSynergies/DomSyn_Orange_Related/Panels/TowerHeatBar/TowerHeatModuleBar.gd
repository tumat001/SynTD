extends MarginContainer


const Bar_Below25 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/TowerHeatBar/TowerHeatBar_BarBelow25.png")
const Bar_Below50 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/TowerHeatBar/TowerHeatBar_BarBelow50.png")
const Bar_Below75 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/TowerHeatBar/TowerHeatBar_BarBelow75.png")
const Bar_Below100 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/TowerHeatBar/TowerHeatBar_BarBelow100.png")
const Bar_At100 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/TowerHeatBar/TowerHeatBar_BarAt100.png")
const Bar_MaxPerRoundReached = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/TowerHeatBar/TowerHeatBar_BarHeatLimit.png")


var heat_module setget set_heat_module

onready var current_heat_bar = $HeatBar

#

func _ready():
	update_display()

#

func set_heat_module(arg_module):
	if heat_module != null:
		heat_module.disconnect("current_heat_changed", self, "_module_current_heat_changed")
		heat_module.disconnect("on_round_end", self, "_module_current_heat_changed")
		heat_module.disconnect("max_heat_per_round_reached", self, "_module_current_heat_changed")
		heat_module.disconnect("should_be_shown_in_info_panel_changed", self, "_should_be_shown_status_changed")
	
	heat_module = arg_module
	
	if heat_module != null:
		heat_module.connect("current_heat_changed", self, "_module_current_heat_changed", [], CONNECT_PERSIST)
		heat_module.connect("on_round_end", self, "_module_current_heat_changed", [], CONNECT_PERSIST)
		heat_module.connect("max_heat_per_round_reached", self, "_module_current_heat_changed", [], CONNECT_PERSIST)
		heat_module.connect("should_be_shown_in_info_panel_changed", self, "_should_be_shown_status_changed", [], CONNECT_PERSIST)
		
		if is_instance_valid(current_heat_bar):
			update_display()

#


func _module_current_heat_changed():
	var curr_heat : int = heat_module.current_heat
	
	current_heat_bar.current_value = curr_heat
	
	
	if curr_heat >= 75 and curr_heat != 100:
		current_heat_bar.fill_foreground_pic = Bar_Below100
	elif curr_heat >= 50:
		current_heat_bar.fill_foreground_pic = Bar_Below75
	elif curr_heat >= 25:
		current_heat_bar.fill_foreground_pic = Bar_Below50
	elif curr_heat >= 0:
		current_heat_bar.fill_foreground_pic = Bar_Below25
	
	if heat_module.is_max_heat_per_round_reached and curr_heat != 100:
		current_heat_bar.fill_foreground_pic = Bar_MaxPerRoundReached
	
	if curr_heat == 100:
		current_heat_bar.fill_foreground_pic = Bar_At100


func _should_be_shown_status_changed():
	visible = heat_module.should_be_shown_in_info_panel
	_module_current_heat_changed()

#

func update_display():
	#_module_current_heat_changed()
	_should_be_shown_status_changed()


