extends MarginContainer

const MorphSingleSelectionPane = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/GUI/MorphSingleSelectionPane/MorphSingleSelectionPane.gd")
const AbstractMorph = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/AbstractMorph.gd")

#

signal all_animations_done(arg_selected_morph)

#

const morph_icon_size := Vector2(45, 45)

#

var _current_selected_morph : AbstractMorph
var _current_selected_morph_single_pane : MorphSingleSelectionPane


var _current_morph_icon_aesth : TextureRect
var _current_enemy_icon_aesth : TextureRect

##

onready var morph_selection_panel = $MorphSelectionPanel
onready var morph_side_collection_panel = $SideCollectionContainer/MorphSideCollectionPanel
onready var aesthetics_container = $AestheticsContainer

###

func configure_self_with_faction_passive(arg_faction_passive):
	morph_side_collection_panel.set_duo_image_slot_count_and_size(arg_faction_passive.rounds_to_offer_morph.size(), morph_icon_size)
	
	call_deferred("_deferred_configure_self", arg_faction_passive)


func _deferred_configure_self(arg_faction_passive):
	morph_side_collection_panel.rect_global_position.y = (540 - morph_side_collection_panel.rect_size.y) / 2.0
	

###

func _ready():
	morph_selection_panel.connect("morph_selected_from_random_roll__animation_done", self, "_on_morph_selected_from_random_roll__animation_done", [], CONNECT_PERSIST)

func _on_morph_selected_from_random_roll__animation_done(arg_morph, arg_morph_pane):
	_current_selected_morph = arg_morph
	_current_selected_morph_single_pane = arg_morph_pane
	
	start_morph_side_collection_panel_slide_to_view()


func start_morph_side_collection_panel_slide_to_view():
	var final_pos = Vector2(960 - morph_side_collection_panel.rect_size.x, morph_side_collection_panel.rect_global_position.y)
	
	var tweener = create_tween()
	tweener.connect("finished", self, "_on_morph_slide_to_view_tweener_finished")
	tweener.tween_property(morph_side_collection_panel, "rect_global_position", final_pos, 0.4).set_trans(Tween.TRANS_QUAD)
	

func _on_morph_slide_to_view_tweener_finished():
	start_morph_icons_go_to_side_collection_panel_slots()
	


func start_morph_icons_go_to_side_collection_panel_slots():
	var enemy_and_morph_poses = _current_selected_morph_single_pane.get_enemy_and_morph_icon_global_pos()
	
	_current_enemy_icon_aesth = TextureRect.new()
	_current_enemy_icon_aesth.texture = _current_selected_morph.enemy_based_icon
	_current_enemy_icon_aesth.rect_position = enemy_and_morph_poses[0]
	aesthetics_container.add_child(_current_enemy_icon_aesth)
	
	_current_morph_icon_aesth = TextureRect.new()
	_current_morph_icon_aesth.texture = _current_selected_morph.morph_based_icon
	_current_morph_icon_aesth.rect_position = enemy_and_morph_poses[1]
	aesthetics_container.add_child(_current_morph_icon_aesth)
	
	_current_selected_morph_single_pane.set_visibility_of_enemy_and_morph_icon(false)
	
	#####
	var poses_for_duo_img_slot = morph_side_collection_panel.get_global_poses_of_duo_image_slot_images()
	var enemy_side_img_slot_pos = poses_for_duo_img_slot[0]
	var morph_side_img_slot_pos = poses_for_duo_img_slot[1]
	
	
	var enemy__opposite_dir_x_mag_pos = Vector2(50, 0).rotated(_current_enemy_icon_aesth.rect_global_position.angle_to_point(enemy_side_img_slot_pos) + PI) + _current_enemy_icon_aesth.rect_global_position
	var morph__opposite_dir_x_mag_pos = Vector2(50, 0).rotated(_current_morph_icon_aesth.rect_global_position.angle_to_point(morph_side_img_slot_pos) + PI) + _current_morph_icon_aesth.rect_global_position
	
	######
	
	var enemy_icon_tweener = create_tween()
	enemy_icon_tweener.connect("finished", self, "_on_morph_aesth_icons_reached_destination")
	enemy_icon_tweener.tween_property(_current_enemy_icon_aesth, "rect_global_position", enemy__opposite_dir_x_mag_pos, 0.3)
	enemy_icon_tweener.tween_property(_current_enemy_icon_aesth, "rect_global_position", enemy_side_img_slot_pos, 0.7)
	
	var morph_icon_tweener = create_tween()
	morph_icon_tweener.tween_property(_current_morph_icon_aesth, "rect_global_position", morph__opposite_dir_x_mag_pos, 0.3)
	morph_icon_tweener.tween_property(_current_morph_icon_aesth, "rect_global_position", morph_side_img_slot_pos, 0.7)
	
	


func _on_morph_aesth_icons_reached_destination():
	morph_side_collection_panel.set_available_duo_image_slot_images(_current_selected_morph.enemy_based_icon, _current_selected_morph.morph_based_icon)
	_current_enemy_icon_aesth.visible = false
	_current_enemy_icon_aesth.queue_free()
	
	_current_morph_icon_aesth.visible = false
	_current_morph_icon_aesth.queue_free()
	
	start_morph_side_collection_panel_slide_to_hide()
	


func start_morph_side_collection_panel_slide_to_hide():
	var final_pos = Vector2(960, morph_side_collection_panel.rect_global_position.y)
	
	var tweener = create_tween()
	tweener.connect("finished", self, "_on_morph_slide_to_hide_tweener_finished")
	tweener.tween_property(morph_side_collection_panel, "rect_global_position", final_pos, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	

func _on_morph_slide_to_hide_tweener_finished():
	emit_signal("all_animations_done", _current_selected_morph)
	





