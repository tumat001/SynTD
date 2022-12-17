extends MarginContainer

const Red_BasePact = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd")
const Red_PactCard = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactCard.gd")
const Red_PactCard_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactCard.tscn")

const BaseTooltip = preload("res://GameHUDRelated/Tooltips/BaseTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

signal pact_card_clicked(pact)
signal pact_card_removed(pact, replacing_pact)


var card_limit : int setget set_card_limit
export(String) var header_title : String setget set_header_title
const card_height : float = 140.0

var about_tooltip : BaseTooltip
var descriptions_about_panel : Array

var disable_card_pact_button : bool = false

onready var header_label = $VBoxContainer/HeaderMarginer/MarginContainer/HeaderLabel
onready var pact_card_container = $VBoxContainer/HBoxContainer/BodyMarginer/MarginContainer/PactCardContainer
onready var header_marginer = $VBoxContainer/HeaderMarginer


func set_card_limit(new_limit : int):
	card_limit = new_limit
	
	if is_instance_valid(pact_card_container):
		var height = card_height * card_limit
		
		pact_card_container.rect_min_size.y = height
		pact_card_container.rect_size.y = height
		
		
		var excess = pact_card_container.get_child_count() - card_limit
		if excess > 0:
			for i in excess:
				remove_oldest_pact()


func set_header_title(new_title : String):
	header_title = new_title
	
	if is_instance_valid(header_label) and header_title != null:
		header_label.text = new_title

func _ready():
	set_card_limit(card_limit)
	set_header_title(header_title)
	
	#connect("visibility_changed", self, "_on_visiblitiy_changed", [], CONNECT_PERSIST)
	header_marginer.connect("mouse_entered", self, "_on_mouse_entered_header_marginer", [], CONNECT_PERSIST)
	#header_marginer.connect("mouse_exited", self, "_on_mouse_exited_header_marginer", [], CONNECT_PERSIST)
	


func add_pact(pact : Red_BasePact):
	var pact_card := _create_pact_card(pact)
	
	var card_count = pact_card_container.get_children().size()
	if card_count >= card_limit:
		remove_pact(pact_card_container.get_children()[card_count - 1].base_pact, pact)
	
	pact_card.connect("pact_card_pressed", self, "_emit_pact_card_clicked", [], CONNECT_PERSIST)
	pact_card_container.add_child(pact_card)
	pact_card_container.move_child(pact_card, 0)
	
	pact_card.set_button_disabled(disable_card_pact_button)
	

func _create_pact_card(pact : Red_BasePact) -> Red_PactCard:
	var card = Red_PactCard_Scene.instance()
	card.set_base_pact(pact)
	
	return card

func _emit_pact_card_clicked(pact):
	emit_signal("pact_card_clicked", pact)

func _emit_pact_card_removed(pact, replacing_pact):
	emit_signal("pact_card_removed", pact, replacing_pact)



func remove_pact(pact : Red_BasePact, replacing_pact : Red_BasePact = null):
	for card in pact_card_container.get_children():
		if card.base_pact == pact:
			pact_card_container.remove_child(card)
			_emit_pact_card_removed(card.base_pact, replacing_pact)
			card.queue_free()
			
			return


func remove_oldest_pact():
	remove_pact(pact_card_container.get_children()[pact_card_container.get_child_count() - 1].base_pact)


func get_pact_count() -> int:
	return pact_card_container.get_child_count()

func get_all_pact_uuids() -> Array:
	var bucket : Array = []
	
	for pact_card in pact_card_container.get_children():
		bucket.append(pact_card.base_pact.pact_uuid)
	
	return bucket

##

#func _on_visiblitiy_changed():
#	if !visible:
#		_on_mouse_exited_header_marginer()

func _on_mouse_entered_header_marginer():
	if !is_instance_valid(about_tooltip):
		about_tooltip = _construct_tooltip()
		_display_requested_about_tooltip(about_tooltip)

#func _on_mouse_exited_header_marginer():
#	pass


func _construct_tooltip():
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = descriptions_about_panel
	a_tooltip.header_left_text = "Pacts"
	
	return a_tooltip

func _display_requested_about_tooltip(arg_about_tooltip : BaseTooltip):
	if is_instance_valid(arg_about_tooltip):
		about_tooltip = arg_about_tooltip
		about_tooltip.visible = true
		about_tooltip.tooltip_owner = header_marginer
		get_tree().get_root().add_child(about_tooltip)
		about_tooltip.update_display()
