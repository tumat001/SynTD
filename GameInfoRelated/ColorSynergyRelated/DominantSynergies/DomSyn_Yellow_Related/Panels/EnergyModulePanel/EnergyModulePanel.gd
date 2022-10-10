extends MarginContainer

const EnergyModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/EnergyModule.gd")
const EnergyEffectDescriptionTooltip = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Panels/EnergyModulePanel/EnergyEffectDescriptionTooltip.gd")
const EnergyEffectDescriptionTooltip_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Panels/EnergyModulePanel/EnergyEffectDescriptionTooltip.tscn")
const AboutEnergyModuleTooltip_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Panels/EnergyModulePanel/AboutEnergyModuleTooltip/AboutEnergyModuleTooltip.tscn")

const module_candidate_on_pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Panels/EnergyModulePanel/EnergyModuleButton_On.png")
const module_candidate_off_pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Panels/EnergyModulePanel/EnergyModuleButton_Off.png")

var _desc_tooltip : EnergyEffectDescriptionTooltip
var energy_module : EnergyModule setget _set_energy_module

var _about_tooltip

onready var module_button : TextureButton = $VBoxContainer/BodyMarginer/EnergyModuleButton


func _set_energy_module(module):
	if energy_module != null:
		energy_module.disconnect("module_turned_on", self, "_module_successfully_turned_on")
		energy_module.disconnect("module_turned_off", self, "_module_successfully_turned_off")
	
	
	energy_module = module
	
	energy_module.connect("module_turned_on", self, "_module_successfully_turned_on")
	energy_module.connect("module_turned_off", self, "_module_successfully_turned_off")
	
	update_display()

func update_display():
	if energy_module != null:
		if energy_module.is_turned_on:
			module_button.texture_normal = module_candidate_on_pic
		else:
			module_button.texture_normal = module_candidate_off_pic


# Module button related

func _on_EnergyModuleButton_pressed():
	if energy_module.is_turned_on:
		energy_module.attempt_turn_off()
	else:
		energy_module.attempt_turn_on()


func _module_successfully_turned_on(first_time_per_round : bool):
	module_button.texture_normal = module_candidate_on_pic

func _module_successfully_turned_off():
	module_button.texture_normal = module_candidate_off_pic


# Effect Desc related

func _on_EffectDescriptionButton_mouse_entered():
	if !is_instance_valid(_desc_tooltip):
		_desc_tooltip = EnergyEffectDescriptionTooltip_Scene.instance()
		get_tree().get_root().add_child(_desc_tooltip)
	
	_desc_tooltip.energy_module = energy_module
	_desc_tooltip.update_display()
	_desc_tooltip.visible = true


func _on_EffectDescriptionButton_mouse_exited():
	if is_instance_valid(_desc_tooltip):
		_desc_tooltip.visible = false
		_desc_tooltip.queue_free()


# Module Description related


func _on_ModuleDescription_pressed():
	if !is_instance_valid(_about_tooltip):
		_about_tooltip = AboutEnergyModuleTooltip_Scene.instance()
		get_tree().get_root().add_child(_about_tooltip)
		
	else:
		_about_tooltip.queue_free()


func _on_ModuleDescription_mouse_exited():
	if is_instance_valid(_about_tooltip):
		_about_tooltip.queue_free()


# freeing

func queue_free():
	if is_instance_valid(_desc_tooltip):
		_desc_tooltip.queue_free()
	
	if is_instance_valid(_about_tooltip):
		_about_tooltip.queue_free()
	
	.queue_free()

