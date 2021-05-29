extends Node

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

const tier_bronze_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Bronze.png")
const tier_silver_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Silver.png")
const tier_gold_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Gold.png")
const tier_dia_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Diamond.png")

const syn_dom_red = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Red.png")
const syn_dom_orange = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Orange.png")
const syn_dom_yellow = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Yellow.png")
const syn_dom_green = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Green.png")
const syn_dom_blue = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Blue.png")
const syn_dom_violet = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Violet.png")
const syn_dom_white = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_White.png")
const syn_dom_black = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Black.png")

const DomSyn_Violet = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Violet.gd")
const DomSyn_Yellow_GoldIncome = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/DomSyn_Yellow_GoldIncome.gd")
const DomSyn_Yellow_EnergyBattery = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/DomSyn_Yellow_EnergyBattery.gd")


var synergies : Dictionary = {
	"Red" : ColorSynergy.new("Red", [TowerColors.RED], [6, 4, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_dom_red,
	["RED description"]),
	
	"Orange" : ColorSynergy.new("Orange", [TowerColors.ORANGE], [12, 9, 6, 3],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_orange,
	["ORANGE description"]),
	
	"Yellow" : ColorSynergy.new("Yellow", [TowerColors.YELLOW], [8, 5, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_yellow,
	["YELLOW description"],
	[DomSyn_Yellow_GoldIncome.new(), DomSyn_Yellow_EnergyBattery.new()]),
	
	"Green" : ColorSynergy.new("Green", [TowerColors.GREEN], [3],
	[tier_bronze_pic],
	syn_dom_green,
	["GREEN description"]),
	
	"Blue" : ColorSynergy.new("Blue", [TowerColors.BLUE], [9, 7, 5, 3],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_blue,
	["BLUE description"]),
	
	"Violet" : ColorSynergy.new("Violet", [TowerColors.VIOLET], [5, 4, 3, 2],
	[tier_silver_pic, tier_bronze_pic, tier_gold_pic, tier_dia_pic],
	syn_dom_violet,
	["VIOLET description"],
	[DomSyn_Violet.new()]),
	
	"White" : ColorSynergy.new("White", [TowerColors.WHITE], [1],
	[tier_dia_pic],
	syn_dom_white,
	["WHITE description"]),
	
	"Black" : ColorSynergy.new("Black", [TowerColors.BLACK], [1],
	[tier_dia_pic],
	syn_dom_black,
	["BLACK description"])
}

func _init():
	pass
