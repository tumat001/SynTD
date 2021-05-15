extends MarginContainer


onready var buy_sell_panel = $BuySellLevelRollPanel
onready var ingredient_notif = $IngredientModeNotification
onready var sell_panel = $SellPanel


func _ready():
	show_only_buy_sell_panel()
	make_sell_panel_invisible()


func show_only_buy_sell_panel():
	buy_sell_panel.visible = true
	ingredient_notif.visible = false

func show_only_ingredient_notification_mode():
	buy_sell_panel.visible = false
	buy_sell_panel.kill_all_tooltips_of_buycards()
	ingredient_notif.visible = true


func make_sell_panel_visible():
	sell_panel.visible = true
	sell_panel.update_display()

func make_sell_panel_invisible():
	sell_panel.visible = false
