const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

var synergies : Array = [
	#Complementary
	ColorSynergy.new("RG", [TowerColors.RED, TowerColors.GREEN], [2]),
	ColorSynergy.new("YV", [TowerColors.YELLOW, TowerColors.VIOLET], [2]),
	ColorSynergy.new("OB", [TowerColors.ORANGE, TowerColors.BLUE], [2]),
	
	#Triad
	ColorSynergy.new("RYB", [TowerColors.RED, TowerColors.YELLOW, TowerColors.BLUE], [2]),
	ColorSynergy.new("OVG", [TowerColors.ORANGE, TowerColors.VIOLET, TowerColors.GREEN], [2]),
	
	#Analogous (First color listed is the 'center')
	ColorSynergy.new("ROV", [TowerColors.RED, TowerColors.ORANGE, TowerColors.VIOLET], [2]),
	ColorSynergy.new("VRB", [TowerColors.VIOLET, TowerColors.RED, TowerColors.BLUE], [2]),
	ColorSynergy.new("BVG", [TowerColors.BLUE, TowerColors.VIOLET, TowerColors.GREEN], [2]),
	ColorSynergy.new("GBY", [TowerColors.GREEN, TowerColors.BLUE, TowerColors.YELLOW], [2]),
	ColorSynergy.new("YGO", [TowerColors.YELLOW, TowerColors.GREEN, TowerColors.ORANGE], [2]),
	ColorSynergy.new("OYR", [TowerColors.ORANGE, TowerColors.YELLOW, TowerColors.RED], [2]),
	
	#Specials
	ColorSynergy.new("RGB", [TowerColors.RED, TowerColors.GREEN, TowerColors.BLUE], [2, 3]),
	ColorSynergy.new("Omni", [TowerColors.RED, TowerColors.ORANGE, TowerColors.YELLOW, TowerColors.GREEN, TowerColors.BLUE, TowerColors.VIOLET], [2, 3]),
	
]
