enum {
	GRAY,
	WHITE,
	BLACK,
	RED,
	ORANGE,
	YELLOW,
	GREEN,
	BLUE,
	VIOLET,
}

const gray_symbol = preload("res://GameHUDRelated/BuySellPanel/GraySymbol.png")
const red_symbol = preload("res://GameHUDRelated/BuySellPanel/RedSymbol.png")
const orange_symbol = preload("res://GameHUDRelated/BuySellPanel/OrangeSymbol.png")
const yellow_symbol = preload("res://GameHUDRelated/BuySellPanel/YellowSymbol.png")
const green_symbol = preload("res://GameHUDRelated/BuySellPanel/GreenSymbol.png")
const blue_symbol = preload("res://GameHUDRelated/BuySellPanel/BlueSymbol.png")
const violet_symbol = preload("res://GameHUDRelated/BuySellPanel/VioletSymbol.png")

static func get_all_colors() -> Array:
	var bucket : Array = [
		GRAY,
		WHITE,
		BLACK,
		RED,
		ORANGE,
		YELLOW,
		GREEN,
		BLUE,
		VIOLET,
	]
	
	return bucket

static func get_color_symbol_on_card(tower_color : int):
	if tower_color == GRAY:
		return gray_symbol
	elif tower_color == RED:
		return red_symbol
	elif tower_color == ORANGE:
		return orange_symbol
	elif tower_color == YELLOW:
		return yellow_symbol
	elif tower_color == GREEN:
		return green_symbol
	elif tower_color == BLUE:
		return blue_symbol
	elif tower_color == VIOLET:
		return violet_symbol

static func get_color_name_on_card(tower_color : int) -> String:
	if tower_color == GRAY:
		return "Gray"
	elif tower_color == RED:
		return "Red"
	elif tower_color == ORANGE:
		return "Orange"
	elif tower_color == YELLOW:
		return "Yellow"
	elif tower_color == GREEN:
		return "Green"
	elif tower_color == BLUE:
		return "Blue"
	elif tower_color == VIOLET:
		return "Violet"
	else:
		return "nan"
