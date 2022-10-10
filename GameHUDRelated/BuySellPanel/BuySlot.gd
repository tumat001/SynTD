extends MarginContainer

const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerBuyCardScene = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCard.tscn")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerBuyCard = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCard.gd")

signal tower_bought(tower_id)
signal viewing_tower_description_tooltip(tower_type_id, arg_self)

signal card_pressed_down(arg_card)
signal card_released_up_and_not_queue_freed(arg_card)

var current_child # current child of card container
var tower_inventory_bench
var game_settings_manager
var buy_sell_level_roll_panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func roll_buy_card_to_tower_id(tower_id : int):
	if tower_id != -1:
		var tower_info = Towers.get_tower_info(tower_id)
		if is_instance_valid(current_child):
			current_child.queue_free()
		
		if tower_info != null:
			var buy_card_scene = TowerBuyCardScene.instance()
			buy_card_scene.tower_information = tower_info
			buy_card_scene.tower_inventory_bench = tower_inventory_bench
			buy_card_scene.game_settings_manager = game_settings_manager
			buy_card_scene.buy_sell_level_roll_panel = buy_sell_level_roll_panel
			buy_card_scene.buy_slot = self
			
			#card_container.add_child(buy_card_scene)
			add_child(buy_card_scene)
			current_child = buy_card_scene
			current_child.connect("tower_bought", self, "_on_tower_bought")
			current_child.connect("viewing_tower_description_tooltip", self, "_on_viewing_tower_description_tooltip")
			current_child.connect("card_pressed_down", self, "_on_card_pressed_down", [current_child])
			current_child.connect("card_released_up_and_not_queue_freed", self, "_on_card_released_up_and_not_queue_freed", [current_child])

func _on_tower_bought(tower_type_info : TowerTypeInformation):
	emit_signal("tower_bought", tower_type_info)

func _on_viewing_tower_description_tooltip(tower_type_info : TowerTypeInformation):
	emit_signal("viewing_tower_description_tooltip", tower_type_info, self)



func kill_tooltip_of_tower_card():
	if is_instance_valid(current_child) and current_child is TowerBuyCard:
		current_child.kill_current_tooltip()


func kill_current_tower_buy_card():
	if is_instance_valid(current_child) and current_child is TowerBuyCard and !current_child.is_queued_for_deletion():
		current_child.queue_free()

#

func get_current_tower_buy_card():
	if is_instance_valid(current_child) and current_child is TowerBuyCard and !current_child.is_queued_for_deletion():
		return current_child
	
	return null

#

func _on_card_pressed_down(arg_card):
	emit_signal("card_pressed_down", arg_card)

func _on_card_released_up_and_not_queue_freed(arg_card):
	emit_signal("card_released_up_and_not_queue_freed", arg_card)
