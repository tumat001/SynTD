const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

var synergies : Array = [
	ColorSynergy.new("R", [TowerColors.RED], [6, 4, 2]),
	ColorSynergy.new("O", [TowerColors.ORANGE], [12, 9, 6, 3]),
	ColorSynergy.new("Y", [TowerColors.YELLOW], [9, 6, 3]),
	ColorSynergy.new("G", [TowerColors.GREEN], [3]),
	ColorSynergy.new("B", [TowerColors.BLUE], [2]),
	ColorSynergy.new("V", [TowerColors.VIOLET], [5, 4, 3, 2]),
	ColorSynergy.new("W", [TowerColors.WHITE], [1]),
]

