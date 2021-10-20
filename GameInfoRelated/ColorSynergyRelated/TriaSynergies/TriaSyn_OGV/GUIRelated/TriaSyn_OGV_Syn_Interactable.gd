extends MarginContainer



onready var healthbar = $MainContent/VBoxContainer/HealthBarPanel/HealthBar
onready var health_label = $MainContent/VBoxContainer/HealthTextPanel/TextPanel/HealthLabel

var ogv_synergy 


func configure_self_with_synergy(synergy):
	ogv_synergy = synergy
	
	if !ogv_synergy.is_connected("enemy_player_health_changed", self, "_on_ogv_health_changed"):
		ogv_synergy.connect("enemy_player_health_changed", self, "_on_ogv_health_changed", [], CONNECT_PERSIST)
	
	if is_inside_tree():
		_set_up_healthbar()

func _ready():
	_set_up_healthbar()

func _set_up_healthbar():
	healthbar.max_value = ogv_synergy.enemy_player_max_health
	_on_ogv_health_changed(ogv_synergy.enemy_player_max_health, ogv_synergy.enemy_player_current_health)


#

func _on_ogv_health_changed(max_val, new_curr_health_val):
	healthbar.current_value = new_curr_health_val
	
	health_label.text = "%s / %s" % [str(ceil(new_curr_health_val)), str(max_val)]

