extends MarginContainer

const HeatModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/HeatModule.gd")

const Bar_Below25 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/HeatModuleBar/HeatBar_FillForeground_Below25.png")
const Bar_Below50 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/HeatModuleBar/HeatBar_FillForeground_Below50.png")
const Bar_Below75 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/HeatModuleBar/HeatBar_FillForeground_Below75.png")
const Bar_Below100 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/HeatModuleBar/HeatBar_FillForeground_Below100.png")
const Bar_At100 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/HeatModuleBar/HeatBar_FillForeground_At100.png")
const Bar_MaxPerRoundReached = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/HeatModuleBar/HeatBar_FillForeground_MaxHeatPerRound.png")
const Bar_OverheatCooldown = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/HeatModuleBar/HeatBar_FillForeground_CoolingDown.png")

var heat_module : HeatModule setget set_heat_module

onready var current_heat_label = $VBoxContainer/Headers/TotalHeader/Marginer/CurrentHeatLabel
onready var heat_per_attack_label = $VBoxContainer/Headers/PerAttackHeader/Marginer/HeatPerAttackLabel
onready var current_heat_bar = $VBoxContainer/Body/CurrentHeatBar

func _ready():
	current_heat_bar.yield_before_update = true


func set_heat_module(arg_heat_module : HeatModule):
	if heat_module != null:
		heat_module.disconnect("current_heat_changed", self, "_module_current_heat_changed")
		heat_module.disconnect("heat_per_attack_changed", self, "_module_heat_per_attack_changed")
		heat_module.disconnect("on_round_end", self, "_module_current_heat_changed")
		heat_module.disconnect("max_heat_per_round_reached", self, "_module_current_heat_changed")
	
	heat_module = arg_heat_module
	
	if heat_module != null:
		heat_module.connect("current_heat_changed", self, "_module_current_heat_changed", [], CONNECT_PERSIST)
		heat_module.connect("heat_per_attack_changed", self, "_module_heat_per_attack_changed", [], CONNECT_PERSIST)
		heat_module.connect("on_round_end", self, "_module_current_heat_changed", [], CONNECT_PERSIST)
		heat_module.connect("max_heat_per_round_reached", self, "_module_current_heat_changed", [], CONNECT_PERSIST)


func _module_current_heat_changed():
	var curr_heat : int = heat_module.current_heat
	
	current_heat_label.text = str(curr_heat)
	current_heat_bar.current_value = curr_heat
	
	
	if heat_module.is_in_overheat_cooldown:
		current_heat_bar.fill_foreground_pic = Bar_OverheatCooldown
		return
	
	
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
	
	

func _module_heat_per_attack_changed():
	heat_per_attack_label.text = str(heat_module.heat_per_attack)


func update_display():
	_module_current_heat_changed()
	_module_heat_per_attack_changed()
