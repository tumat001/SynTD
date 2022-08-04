extends MarginContainer

const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerBuyCardScene = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCard.tscn")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerBuyCard = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCard.gd")

signal tower_bought(tower_id)

var current_child
var tower_inventory_bench
var game_settings_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func roll_buy_card_to_tower_id(tower_id : int):
	if tower_id != -1:
		var tower_info = Towers.get_tower_info(tower_id)
		if current_child != null:
			current_child.queue_free()
		
		if tower_info != null:
			var buy_card_scene = TowerBuyCardScene.instance()
			buy_card_scene.tower_information = tower_info
			buy_card_scene.tower_inventory_bench = tower_inventory_bench
			buy_card_scene.game_settings_manager = game_settings_manager
			
			add_child(buy_card_scene)
			current_child = buy_card_scene
			current_child.connect("tower_bought", self, "_on_tower_bought")


func _on_tower_bought(tower_type_info : TowerTypeInformation):
	emit_signal("tower_bought", tower_type_info)

func kill_tooltip_of_tower_card():
	if current_child is TowerBuyCard:
		current_child.kill_current_tooltip()
