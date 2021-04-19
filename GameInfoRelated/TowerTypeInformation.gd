var tower_name : String
var tower_cost : int
var energy_consumption_levels : Array = []
var colors : Array = []
var ingredient_buffs : Array = []
var ingredient_buff_description : String = ""
var tower_image_in_buy_card

func _init(arg_tower_name):
	tower_name = arg_tower_name
	tower_cost = 0
