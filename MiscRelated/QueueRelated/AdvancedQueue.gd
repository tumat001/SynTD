extends Reference

signal entertained_reservation(arg_reservation)
signal no_reservations_left()

signal reservation_removed(arg_reservation_removed, arg_incomming_reservation)
signal reservation_deferred(arg_deferred_reservation, arg_incomming_reservation)

signal reservation_removed_or_deferred(arg_removed_or_def_res)

enum QueueMode {
	
	WAIT_FOR_NEXT,  # "Normal"
	
	FORCED__REMOVE_CURRENT,    
	FORCED__REMOVE_ALL,
	#FORCED__DEFERR_CURRENT_TO_NEXT,
	
}

class Reservation:
	
	########### obj of reservation side
	
	var obj_of_reservation : Object
	
	var on_entertained_method : String
	var on_removed_method : String
	#var on_deferred_to_next_method : String
	
	var queue_mode : int = QueueMode.WAIT_FOR_NEXT
	
	func reservation_completed():  # called by obj_of_reservation
		queue.call(on_completed_method)
		
	
	
	####### queue side
	
	var queue
	const on_completed_method : String = "_on_current_reservation_completed"

##

var metadata_map : Dictionary = {}

var _current_reservation : Reservation
var _reservations : Array  # implement this as reverse

##

func queue_reservation(arg_reservation : Reservation):
	arg_reservation.queue = self
	
	if arg_reservation.queue_mode == QueueMode.WAIT_FOR_NEXT:
		if _current_reservation == null:
			_entertain_reservation_and_make_it_current(arg_reservation)
		else:
			_reservations.insert(_reservations.size() - 1, arg_reservation)
		
		
	elif arg_reservation.queue_mode == QueueMode.FORCED__REMOVE_ALL:
		_reservations.clear()
		_remove_current_reservation_via_force(arg_reservation)
		
		_entertain_reservation_and_make_it_current(arg_reservation)
		
	elif arg_reservation.queue_mode == QueueMode.FORCED__REMOVE_CURRENT:
		_remove_current_reservation_via_force(arg_reservation)
		
		_entertain_reservation_and_make_it_current(arg_reservation)

func _remove_current_reservation_via_force(arg_incoming_res : Reservation):
	_current_reservation.call(_current_reservation.on_removed_method)
	emit_signal("reservation_removed", _current_reservation, arg_incoming_res)
	emit_signal("reservation_removed_or_deferred", _current_reservation)
	

func _entertain_reservation_and_make_it_current(arg_res : Reservation):
	_current_reservation = arg_res
	_current_reservation.call(_current_reservation.on_entertained_method)
	emit_signal("entertained_reservation", _current_reservation)


#

func _on_current_reservation_completed():
	_current_reservation = null
	_entertain_next_reservation_in_line()

func _entertain_next_reservation_in_line():
	if _reservations.size() > 0:
		var last_index : int = _reservations.size() - 1
		var candidate_reservation = _reservations[last_index]
		_reservations.remove(last_index)
		
		_entertain_reservation_and_make_it_current(candidate_reservation)
		
	else:
		emit_signal("no_reservations_left")

