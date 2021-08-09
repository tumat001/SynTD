extends MarginContainer

var domsyn_green setget set_domsyn_green

onready var layer_beyond = $VBoxContainer/Layer_Beyond
onready var layer_triumph = $VBoxContainer/Layer_Triumph
onready var layer_bloom = $VBoxContainer/Layer_Bloom
onready var layer_foundation = $VBoxContainer/Layer_Foundation

#

func set_domsyn_green(arg_syn):
	domsyn_green = arg_syn


func _ready():
	layer_foundation.base_green_layer = domsyn_green._curr_tier_4_layer
	layer_bloom.base_green_layer = domsyn_green._curr_tier_3_layer
	layer_triumph.base_green_layer = domsyn_green._curr_tier_2_layer
	layer_beyond.base_green_layer = domsyn_green._curr_tier_1_layer

