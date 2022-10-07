extends MarginContainer

const SynDifficultyPic_GrayEmpty = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynDifficultyAssets/SynDifficulty_Indicator_GrayEmpty.png")
const SynDifficultyPic_GreenEffortless = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynDifficultyAssets/SynDifficulty_Indicator_GreenEffortless.png")
const SynDifficultyPic_LGreenEasy = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynDifficultyAssets/SynDifficulty_Indicator_LGreenEasy.png")
const SynDifficultyPic_YellowChallenging = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynDifficultyAssets/SynDifficulty_Indicator_YellowChallenging.png")
const SynDifficultyPic_OrangeDifficult = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynDifficultyAssets/SynDifficulty_Indicator_OrangeDifficult.png")
const SynDifficultyPic_RedComplex = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynDifficultyAssets/SynDifficulty_Indicator_RedComplex.png")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

const difficulty_preface_base = "Difficulty: %s"
const difficulty_effortless_desc = "Effortless"
const difficulty_easy_desc = "Easy"
const difficulty_challenging_desc = "Challenging"
const difficulty_difficult_desc = "Difficult"
const difficulty_complex_desc = "Complex"


onready var difficulty_label = $VBoxContainer/MarginContainer/Label
onready var difficulty_pic_01 = $VBoxContainer/HBoxContainer/DifficultyPic01
onready var difficulty_pic_02 = $VBoxContainer/HBoxContainer/DifficultyPic02
onready var difficulty_pic_03 = $VBoxContainer/HBoxContainer/DifficultyPic03
onready var difficulty_pic_04 = $VBoxContainer/HBoxContainer/DifficultyPic04
onready var difficulty_pic_05 = $VBoxContainer/HBoxContainer/DifficultyPic05


func _ready():
	pass


func set_difficulty(arg_difficulty_num):
	if arg_difficulty_num == ColorSynergy.Difficulty.EFFORTLESS:
		set_difficulty_as_01()
	elif arg_difficulty_num == ColorSynergy.Difficulty.EASY:
		set_difficulty_as_02()
	elif arg_difficulty_num == ColorSynergy.Difficulty.CHALLENGING:
		set_difficulty_as_03()
	elif arg_difficulty_num == ColorSynergy.Difficulty.DIFFICULT:
		set_difficulty_as_04()
	elif arg_difficulty_num == ColorSynergy.Difficulty.COMPLEX:
		set_difficulty_as_05()

func set_difficulty_label_with_suffix(arg_suffix : String):
	difficulty_label.text = difficulty_preface_base % arg_suffix


#

func set_difficulty_as_01():
	difficulty_pic_01.texture = SynDifficultyPic_GreenEffortless
	difficulty_pic_02.texture = SynDifficultyPic_GrayEmpty
	difficulty_pic_03.texture = SynDifficultyPic_GrayEmpty
	difficulty_pic_04.texture = SynDifficultyPic_GrayEmpty
	difficulty_pic_05.texture = SynDifficultyPic_GrayEmpty
	set_difficulty_label_with_suffix(difficulty_effortless_desc)

func set_difficulty_as_02():
	difficulty_pic_01.texture = SynDifficultyPic_LGreenEasy
	difficulty_pic_02.texture = SynDifficultyPic_LGreenEasy
	difficulty_pic_03.texture = SynDifficultyPic_GrayEmpty
	difficulty_pic_04.texture = SynDifficultyPic_GrayEmpty
	difficulty_pic_05.texture = SynDifficultyPic_GrayEmpty
	set_difficulty_label_with_suffix(difficulty_easy_desc)

func set_difficulty_as_03():
	difficulty_pic_01.texture = SynDifficultyPic_YellowChallenging
	difficulty_pic_02.texture = SynDifficultyPic_YellowChallenging
	difficulty_pic_03.texture = SynDifficultyPic_YellowChallenging
	difficulty_pic_04.texture = SynDifficultyPic_GrayEmpty
	difficulty_pic_05.texture = SynDifficultyPic_GrayEmpty
	set_difficulty_label_with_suffix(difficulty_challenging_desc)

func set_difficulty_as_04():
	difficulty_pic_01.texture = SynDifficultyPic_OrangeDifficult
	difficulty_pic_02.texture = SynDifficultyPic_OrangeDifficult
	difficulty_pic_03.texture = SynDifficultyPic_OrangeDifficult
	difficulty_pic_04.texture = SynDifficultyPic_OrangeDifficult
	difficulty_pic_05.texture = SynDifficultyPic_GrayEmpty
	set_difficulty_label_with_suffix(difficulty_difficult_desc)

func set_difficulty_as_05():
	difficulty_pic_01.texture = SynDifficultyPic_RedComplex
	difficulty_pic_02.texture = SynDifficultyPic_RedComplex
	difficulty_pic_03.texture = SynDifficultyPic_RedComplex
	difficulty_pic_04.texture = SynDifficultyPic_RedComplex
	difficulty_pic_05.texture = SynDifficultyPic_RedComplex
	set_difficulty_label_with_suffix(difficulty_complex_desc)

