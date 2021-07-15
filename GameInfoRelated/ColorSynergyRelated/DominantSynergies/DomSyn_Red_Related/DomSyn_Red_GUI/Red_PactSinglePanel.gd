extends MarginContainer

const Red_BasePact = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd")
const Red_PactCard = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactCard.gd")
const Red_PactCard_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactCard.tscn")


signal pact_card_clicked(pact)
signal pact_card_removed(pact)


var card_limit : int setget set_card_limit
export(String) var header_title : String setget set_header_title
const card_height : float = 140.0

onready var header_label = $VBoxContainer/HeaderMarginer/MarginContainer/HeaderLabel
onready var pact_card_container = $VBoxContainer/HBoxContainer/BodyMarginer/MarginContainer/PactCardContainer


func set_card_limit(new_limit : int):
	card_limit = new_limit
	
	if pact_card_container != null:
		var height = card_height * card_limit
		
		pact_card_container.rect_min_size.y = height
		pact_card_container.rect_size.y = height
		
		
		var excess = pact_card_container.get_child_count() - card_limit
		if excess > 0:
			for i in excess:
				remove_oldest_pact()


func set_header_title(new_title : String):
	header_title = new_title
	
	if header_label != null and header_title != null:
		header_label.text = new_title

func _ready():
	set_card_limit(card_limit)
	set_header_title(header_title)


func add_pact(pact : Red_BasePact):
	var pact_card := _create_pact_card(pact)
	
	pact_card.connect("pact_card_pressed", self, "_emit_pact_card_clicked", [], CONNECT_PERSIST)
	pact_card_container.add_child(pact_card)
	pact_card_container.move_child(pact_card, 0)
	
	var card_count = pact_card_container.get_children().size()
	if  card_count > card_limit:
		remove_pact(pact_card_container.get_children()[card_count - 1].base_pact)


func _create_pact_card(pact : Red_BasePact) -> Red_PactCard:
	var card = Red_PactCard_Scene.instance()
	card.set_base_pact(pact)
	
	return card

func _emit_pact_card_clicked(pact):
	emit_signal("pact_card_clicked", pact)

func _emit_pact_card_removed(pact):
	emit_signal("pact_card_removed", pact)



func remove_pact(pact : Red_BasePact):
	for card in pact_card_container.get_children():
		if card.base_pact == pact:
			_emit_pact_card_removed(card.base_pact)
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
