extends VBoxContainer

var active_synergies_res : Array = []
var non_active_dominant_synergies_res : Array = []
var non_active_composite_synergies_res : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()


func update_display():
	$ActiveSynergies.synergy_results = active_synergies_res
	$ActiveSynergies.update_display()
	#if active_synergies_res.size() == 0:
		#$ActiveSeparator.visible = false
	#else:
		#$ActiveSeparator.visible = true
	
	$NonActiveDominantSynergies.synergy_results = non_active_dominant_synergies_res
	$NonActiveDominantSynergies.update_display()
	if non_active_dominant_synergies_res.size() == 0:
		$NonActiveDominantSeparator.visible = false
	else:
		$NonActiveDominantSeparator.visible = true
	
	$NonActiveCompositionSynergies.synergy_results = non_active_composite_synergies_res
	$NonActiveCompositionSynergies.update_display()
	if non_active_composite_synergies_res.size() == 0:
		$NonActiveCompositionSeparator.visible = false
	else:
		$NonActiveCompositionSeparator.visible = true
