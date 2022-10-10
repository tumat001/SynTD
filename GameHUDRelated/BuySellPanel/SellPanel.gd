extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")


const pic_sell_panel_unhighlighted = preload("res://GameHUDRelated/BuySellPanel/BuySellBackground.png")
const pic_sell_panel_highlighted = preload("res://GameHUDRelated/BuySellPanel/BuySellBackground_Highlighted.png")

onready var sell_label = $SellLabel
onready var sell_panel_background = $SellPanelBackground

var tower : AbstractTower
var _is_mouse_inside : bool


#
enum CanSellClauses {
	
	TUTORIAL_DISABLE = 1000
}
var can_sell_clauses : ConditionalClauses
var last_calculated_can_sell : bool

#

func _ready():
	can_sell_clauses = ConditionalClauses.new()
	can_sell_clauses.connect("clause_inserted", self, "_on_can_sell_clauses_ins_or_rem", [], CONNECT_PERSIST)
	can_sell_clauses.connect("clause_removed", self, "_on_can_sell_clauses_ins_or_rem", [], CONNECT_PERSIST)
	_update_last_calculated_can_sell()


#

func update_display():
	if is_instance_valid(tower):
		if last_calculated_can_sell:
			if tower.last_calculated_can_be_sold:
				sell_label.text = "Sell for " + str(tower._calculate_sellback_value())
			else:
				sell_label.text = "Tower cannot be sold"
		else:
			sell_label.text = "You cannot sell"
	
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
	if is_instance_valid(tower) and last_calculated_can_sell:
		tower.sell_tower()
	
	#_is_mouse_inside = false
	_on_SellPanel_mouse_exited()

#

func _on_can_sell_clauses_ins_or_rem(arg_clause):
	_update_last_calculated_can_sell()

func _update_last_calculated_can_sell():
	last_calculated_can_sell = can_sell_clauses.is_passed
