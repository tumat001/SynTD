extends MarginContainer

const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerBuyCardScene = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCard.tscn")
const Towers = preload("res://GameInfoRelated/Towers.gd")

signal tower_bought(tower_id)

var current_child

# Called when the node enters the scene tree for the first time.
func _ready():
	roll_buy_card(Towers.get_tower_info(Towers.MONO))

func roll_buy_card(tower_info : TowerTypeInformation):
	if current_child != null:
		current_child.queue_free()
	
	var buy_card_scene = TowerBuyCardScene.instance()
	buy_card_scene.tower_information = tower_info
	
	add_child(buy_card_scene)
	current_child = buy_card_scene
	current_child.connect("tower_bought", self, "_on_tower_bought")

func _on_tower_bought(tower_id : int):
	emit_signal("tower_bought", tower_id)
