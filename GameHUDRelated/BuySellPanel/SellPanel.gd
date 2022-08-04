extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

const pic_sell_panel_unhighlighted = preload("res://GameHUDRelated/BuySellPanel/BuySellBackground.png")
const pic_sell_panel_highlighted = preload("res://GameHUDRelated/BuySellPanel/BuySellBackground_Highlighted.png")

onready var sell_label = $SellLabel
onready var sell_panel_background = $SellPanelBackground

var tower : AbstractTower
var _is_mouse_inside : bool


func update_display():
	if tower != null:
		if tower.last_calculated_can_be_sold:
			sell_label.text = "Sell for " + str(tower._calculate_sellback_value())
		else:
			sell_label.text = "Tower cannot be sold"
	
	if _is_mouse_inside:
		sell_panel_background.texture = pic_sell_panel_highlighted
	else:
		sell_panel_background.texture = pic_sell_panel_unhighlighted


func _on_SellPanel_mouse_entered():
	_is_mouse_inside = true
	sell_panel_background.texture = pic_sell_panel_highlighted


func _on_SellPanel_mouse_exited():
	_is_mouse_inside = false
	sell_panel_background.texture = pic_sell_panel_unhighlighted


func _input(event):
	if _is_mouse_inside and event is InputEventMouseButton and !event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				_sell_tower()


func _sell_tower():
	if tower != null:
		tower.sell_tower()
	
	#_is_mouse_inside = false
	_on_SellPanel_mouse_exited()
