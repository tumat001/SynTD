enum {
	GRAY = 0,
	WHITE = 1,
	BLACK = 2,
	RED = 3,
	ORANGE = 4,
	YELLOW = 5,
	GREEN = 6,
	BLUE = 7,
	VIOLET = 8,
}

const gray_symbol = preload("res://GameHUDRelated/BuySellPanel/GraySymbol.png")
const white_symbol = preload("res://GameHUDRelated/BuySellPanel/WhiteSymbol.png")
const black_symbol = preload("res://GameHUDRelated/BuySellPanel/BlackSymbol.png")
const red_symbol = preload("res://GameHUDRelated/BuySellPanel/RedSymbol.png")
const orange_symbol = preload("res://GameHUDRelated/BuySellPanel/OrangeSymbol.png")
const yellow_symbol = preload("res://GameHUDRelated/BuySellPanel/YellowSymbol.png")
const green_symbol = preload("res://GameHUDRelated/BuySellPanel/GreenSymbol.png")
const blue_symbol = preload("res://GameHUDRelated/BuySellPanel/BlueSymbol.png")
const violet_symbol = preload("res://GameHUDRelated/BuySellPanel/VioletSymbol.png")

static func get_all_colors() -> Array:
	return [
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

static func get_color_symbol_on_card(tower_color : int):
	if tower_color == GRAY:
		return gray_symbol
	elif tower_color == WHITE:
		return white_symbol
	elif tower_color == BLACK:
		return black_symbol
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
	elif tower_color == WHITE:
		return "White"
	elif tower_color == BLACK:
		return "Black"
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
