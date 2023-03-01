extends MarginContainer

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
const BaseTooltip = preload("res://GameHUDRelated/Tooltips/BaseTooltip.gd")



var dom_syn_vio_v02 setget set_dom_syn_vio_v02


var _is_descs_initialized : bool

var base_desc_for_gold : Array
var base_desc_for_ing : Array
var base_desc_for_omni_color__inactive : Array
var base_desc_for_omni_color__active : Array


var _current_tooltip

#

onready var gold_text_panel = $MarginContainer/VBoxContainer/GoldContainer/GoldHContainer/GoldTextPanel
onready var ing_text_panel = $MarginContainer/VBoxContainer/HBoxContainer/IngContainer/HBoxContainer/IngTextPanel
onready var omni_color_texture_rect = $MarginContainer/VBoxContainer/HBoxContainer/OmniColorContainer/OnmiColorTextureRect

onready var gold_container = $MarginContainer/VBoxContainer/GoldContainer
onready var ing_container = $MarginContainer/VBoxContainer/HBoxContainer/IngContainer
onready var omni_color_container = $MarginContainer/VBoxContainer/HBoxContainer/OmniColorContainer

onready var gold_texture_rect = $MarginContainer/VBoxContainer/GoldContainer/GoldHContainer/GoldTextureRect


#


func _initialize_descs():
	if !_is_descs_initialized:
		_is_descs_initialized = true 
		
		#
		
		var plain_fragment__total_salvaged_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "total salvaged gold")
		var plain_fragment__violet_synergys = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_VIOLET, "Violet Synergy's")
		
		base_desc_for_gold = [
			["The |0|. The basis of |1| power.", [plain_fragment__total_salvaged_gold, plain_fragment__violet_synergys]]
		]
		
		#
		
		var plain_fragment__bonus_ingredient_slots = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "bonus ingredient slots")
		
		var plain_fragment__violet_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_VIOLET, "Violet towers")
		var plain_fragment__x_ingredient_slot = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "1 bonus ingredient slot")
		var plain_fragment__x_salvaged_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s salvaged gold" % dom_syn_vio_v02.salvage_gold_per_bonus_ing_slot)
		
		base_desc_for_ing = [
			["The |0| gained from the |1|.", [plain_fragment__bonus_ingredient_slots, plain_fragment__total_salvaged_gold]],
			["|0| gain |1| per |2|.", [plain_fragment__violet_towers, plain_fragment__x_ingredient_slot, plain_fragment__x_salvaged_gold]]
		]
		
		#
		
		var plain_fragment__x_salvaged_gold_for_omni = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s salvaged gold" % dom_syn_vio_v02.salvage_gold_breakpoint_for_omni_color)
		
		base_desc_for_omni_color__inactive = [
			["Upon reaching |0|, |1| can absorb any ingredient regardless of color.", [plain_fragment__x_salvaged_gold_for_omni, plain_fragment__violet_towers]]
		]
		
		base_desc_for_omni_color__active = [
			["|0| can absorb any ingredient regardless of color.", [plain_fragment__violet_towers]]
		]
		
		
	



#

func _ready():
	connect("visibility_changed", self, "_on_visiblity_changed", [], CONNECT_PERSIST)
	
	_on_syn_current_salvaged_gold_changed(null)
	_on_syn_current_bonus_ingredient_slot_count_changed(null)
	_on_syn_is_applying_omni_color_changed(null)
	_on_synergy_applied_or_removed(null)

func set_dom_syn_vio_v02(arg_syn):
	dom_syn_vio_v02 = arg_syn
	
	if arg_syn != null:
		_initialize_descs()
		
		dom_syn_vio_v02.connect("current_salvaged_gold_changed", self, "_on_syn_current_salvaged_gold_changed", [], CONNECT_PERSIST)
		dom_syn_vio_v02.connect("current_bonus_ingredient_slot_count_changed", self, "_on_syn_current_bonus_ingredient_slot_count_changed", [], CONNECT_PERSIST)
		dom_syn_vio_v02.connect("is_applying_omni_color_changed", self, "_on_syn_is_applying_omni_color_changed", [], CONNECT_PERSIST)
		dom_syn_vio_v02.connect("synergy_applied", self, "_on_synergy_applied_or_removed", [], CONNECT_PERSIST)
		dom_syn_vio_v02.connect("synergy_removed", self, "_on_synergy_applied_or_removed", [], CONNECT_PERSIST)
		
		_on_syn_current_salvaged_gold_changed(null)
		_on_syn_current_bonus_ingredient_slot_count_changed(null)
		_on_syn_is_applying_omni_color_changed(null)
		_on_synergy_applied_or_removed(null)

func _on_syn_current_salvaged_gold_changed(_arg_val):
	if is_inside_tree():
		gold_text_panel.text_to_use = str(dom_syn_vio_v02.current_salvaged_gold)

func _on_syn_current_bonus_ingredient_slot_count_changed(_arg_val):
	if is_inside_tree():
		ing_text_panel.text_to_use = str(dom_syn_vio_v02.current_bonus_ingredient_slot_count)

func _on_syn_is_applying_omni_color_changed(_arg_val):
	if is_inside_tree():
		if dom_syn_vio_v02.is_applying_omni_color:
			omni_color_texture_rect.modulate = Color(1, 1, 1, 1)
		else:
			omni_color_texture_rect.modulate = Color(0.3, 0.3, 0.3, 0.8)
		

func _on_synergy_applied_or_removed(_arg_tier):
	if is_inside_tree():
		if dom_syn_vio_v02.current_tier != 0:
			modulate = Color(1, 1, 1, 1)
		else:
			modulate = Color(0.3, 0.3, 0.3, 0.8)
	

###########

func _on_visiblity_changed():
	_queue_free_current_tooltip()
	


func _on_OmniColorContainer_mouse_entered():
	var tooltip = _construct_tooltip_for__omni_color()
	_queue_free_current_tooltip__and_set_new(tooltip, omni_color_container)

func _on_OmniColorContainer_mouse_exited():
	_queue_free_current_tooltip()


func _construct_tooltip_for__omni_color() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	
	if dom_syn_vio_v02.is_applying_omni_color:
		a_tooltip.descriptions = base_desc_for_omni_color__active
	else:
		a_tooltip.descriptions = base_desc_for_omni_color__inactive
	
	a_tooltip.header_left_text = "VioSyn - Omni Color"
	
	return a_tooltip

#

func _on_GoldContainer_mouse_entered():
	var tooltip = _construct_tooltip_for__gold()
	_queue_free_current_tooltip__and_set_new(tooltip, gold_container)


func _on_GoldContainer_mouse_exited():
	_queue_free_current_tooltip()


func _construct_tooltip_for__gold() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	
	a_tooltip.descriptions = base_desc_for_gold
	
	a_tooltip.header_left_text = "VioSyn - Salvaged Gold"
	
	return a_tooltip



func _on_IngContainer_mouse_entered():
	var tooltip = _construct_tooltip_for__ingredient()
	_queue_free_current_tooltip__and_set_new(tooltip, ing_container)


func _on_IngContainer_mouse_exited():
	_queue_free_current_tooltip()


func _construct_tooltip_for__ingredient() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	
	a_tooltip.descriptions = base_desc_for_ing
	
	a_tooltip.header_left_text = "VioSyn - Bonus Ing Slots"
	
	return a_tooltip

######

func _queue_free_current_tooltip__and_set_new(arg_new, arg_new_owner):
	_queue_free_current_tooltip()
	
	_current_tooltip = arg_new
	if is_instance_valid(_current_tooltip):
		_current_tooltip.visible = true
		_current_tooltip.tooltip_owner = arg_new_owner
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_current_tooltip)
		_current_tooltip.update_display()
	

func _queue_free_current_tooltip():
	if is_instance_valid(_current_tooltip) and !_current_tooltip.is_queued_for_deletion():
		_current_tooltip.queue_free()

