extends MarginContainer


func _ready():
	show_buy_sell_panel()

func show_buy_sell_panel():
	$BuySellLevelRollPanel.visible = true
	$IngredientModeNotification.visible = false

func show_ingredient_notification_mode():
	$BuySellLevelRollPanel.visible = false
	$BuySellLevelRollPanel.kill_all_tooltips_of_buycards()
	$IngredientModeNotification.visible = true
