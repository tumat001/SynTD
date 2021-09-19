extends MarginContainer

const AbstractAttackModule = preload("res://TowerRelated/Modules/AbstractAttackModule.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

var attack_module : AbstractAttackModule setget set_attack_module

var in_round_total_dmg : float = 0

onready var damage_label = $HBoxContainer/VBoxContainer/DamageLabel
onready var damage_bar = $HBoxContainer/VBoxContainer/DamageBar
onready var attack_module_texture_rect = $HBoxContainer/AttackModuleIconMarginer/AttackModuleIcon
onready var attack_module_icon_marginer = $HBoxContainer/AttackModuleIconMarginer

func _ready():
	attack_module_icon_marginer.rect_size = AbstractAttackModule.image_size
	attack_module_icon_marginer.rect_min_size = AbstractAttackModule.image_size


func set_attack_module(arg_attack_module : AbstractAttackModule):
	if attack_module != null:
		attack_module.disconnect("on_in_round_total_dmg_changed", self, "_on_attk_module_in_round_total_damage_changed")
	
	attack_module = arg_attack_module
	
	if attack_module != null:
		attack_module.connect("on_in_round_total_dmg_changed", self, "_on_attk_module_in_round_total_damage_changed", [], CONNECT_PERSIST | CONNECT_DEFERRED)
		attack_module_texture_rect.texture = attack_module.tracker_image
		
		_on_attk_module_in_round_total_damage_changed(attack_module.in_round_total_damage_dealt)


func _on_attk_module_in_round_total_damage_changed(new_total):
	in_round_total_dmg = new_total


# called update

func update_display(new_max_value : float):
	damage_bar.max_value = new_max_value
	damage_bar.current_value = in_round_total_dmg
	
	damage_label.text = str(stepify(in_round_total_dmg, 0.001))
