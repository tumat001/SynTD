extends Reference

signal entertained_reservation(arg_reservation)
signal no_reservations_left()

signal reservation_removed(arg_reservation_removed, arg_incomming_reservation)
signal reservation_deferred(arg_deferred_reservation, arg_incomming_reservation)
signal reservation_removed_or_deferred(arg_removed_or_def_res)

signal before_reservation_completed(arg_reservation_completed)

signal request_advance_queue_reservation()


const reservation_ignore_new_reservations_metadata := "ADVANCED_QUEUE__IGNORE_NEW_RESERVATIONS"

enum QueueMode {
	
	WAIT_FOR_NEXT = 1,  # "Normal"
	
	FORCED__REMOVE_CURRENT = 10,    
	FORCED__REMOVE_ALL = 11,
	FORCED__REMOVE_ALL_AND_FLUSH_NEW_WHILE_ACTIVE = 12,
	#FORCED__DEFERR_CURRENT_TO_NEXT,
	
}

class Reservation:
	
	const BLANK_ID := -1
	
	########### obj of reservation side
	
	var wr_obj_of_reservation : WeakRef
	
	var on_entertained_method : String
	var on_removed_method : String
	#var on_deferred_to_next_method : String
	
	var queue_mode : int = QueueMode.WAIT_FOR_NEXT
	
	var _queue_id : int = BLANK_ID
	
	#
	var metadata_map : Dictionary = {}
	
	
	func _init(arg_obj):
		wr_obj_of_reservation = weakref(arg_obj)
	
	func reservation_completed():  # called by wr_obj_of_reservation
		reset_id()
		queue.call(on_completed_method)
		
	
	func reset_id():
		_queue_id = BLANK_ID
	
	####### queue side
	
	var queue
	const on_completed_method : String = "_on_current_reservation_completed"
	
	######## misc
	
	func is_obj_have_method(arg_method):
		var obj = wr_obj_of_reservation.get_ref()
		
		return obj != null and obj.has_method(arg_method)
	
	func call_method_on_obj(arg_method):
		wr_obj_of_reservation.get_ref().call(arg_method)

##

var _auto_entertain_next_in_queue : bool = true  # false if you want to do actions before entertaining next (or manually control when to do it next)
var _requested_queue_advance : bool = false

var _current_reservation : Reservation
var _reservations : Array  # implement this as reverse

var _current_id_to_give_to_next : int = 1

var _ignore_new_reservations : bool = false

##

func _init(arg_auto_entertain_next_in_queue : bool):
	_auto_entertain_next_in_queue = arg_auto_entertain_next_in_queue

##

func queue_reservation(arg_reservation : Reservation):
	if !_ignore_new_reservations:
		if (arg_reservation._queue_id == arg_reservation.BLANK_ID or !is_reservation_id_exists(arg_reservation._queue_id)) and is_current_reservation_null_or_not_have_id(arg_reservation._queue_id):
			arg_reservation.queue = self
			arg_reservation._queue_id = _current_id_to_give_to_next
			_current_id_to_give_to_next += 1
			
			#print("accepted reservation: %s, id: %s, mode: %s" % [arg_reservation, arg_reservation._queue_id, arg_reservation.queue_mode])
			#_ignore_new_reservations = false
			arg_reservation.metadata_map[reservation_ignore_new_reservations_metadata] = false
			
			if arg_reservation.queue_mode == QueueMode.WAIT_FOR_NEXT:
				if _current_reservation == null:
					if _auto_entertain_next_in_queue:
						_entertain_reservation_and_make_it_current(arg_reservation)
					else:
						_reservations.insert(0, arg_reservation)
						attempt_request_reservation_queue_advance()
				else:
					_reservations.insert(0, arg_reservation)
				
				
			elif arg_reservation.queue_mode == QueueMode.FORCED__REMOVE_ALL:
				_reservations.clear()
				_remove_current_reservation_via_force(arg_reservation)
				
				if _auto_entertain_next_in_queue:
					_entertain_reservation_and_make_it_current(arg_reservation)
				else:
					_reservations.append(arg_reservation)
					attempt_request_reservation_queue_advance()
				
			elif arg_reservation.queue_mode == QueueMode.FORCED__REMOVE_ALL_AND_FLUSH_NEW_WHILE_ACTIVE:
				_reservations.clear()
				_remove_current_reservation_via_force(arg_reservation)
				
				arg_reservation.metadata_map[reservation_ignore_new_reservations_metadata] = true
				if _auto_entertain_next_in_queue:
					#_ignore_new_reservations = true
					_entertain_reservation_and_make_it_current(arg_reservation)
				else:
					_reservations.append(arg_reservation)
					attempt_request_reservation_queue_advance()
				
			elif arg_reservation.queue_mode == QueueMode.FORCED__REMOVE_CURRENT:
				_remove_current_reservation_via_force(arg_reservation)
				
				if _auto_entertain_next_in_queue:
					_entertain_reservation_and_make_it_current(arg_reservation)
				else:
					_reservations.append(arg_reservation)
					attempt_request_reservation_queue_advance()


func _remove_current_reservation_via_force(arg_incoming_res : Reservation):
	if _current_reservation != null and _current_reservation.is_obj_have_method(_current_reservation.on_removed_method):
		_current_reservation.call_method_on_obj(_current_reservation.on_removed_method)
	emit_signal("reservation_removed", _current_reservation, arg_incoming_res)
	emit_signal("reservation_removed_or_deferred", _current_reservation)
	

func _entertain_reservation_and_make_it_current(arg_res : Reservation):
	_current_reservation = arg_res
	
	_ignore_new_reservations = arg_res.metadata_map[reservation_ignore_new_reservations_metadata]
	
	if _current_reservation.is_obj_have_method(_current_reservation.on_entertained_method):
		_current_reservation.call_method_on_obj(_current_reservation.on_entertained_method)
	emit_signal("entertained_reservation", _current_reservation)


#

func _on_current_reservation_completed():
	_current_reservation.reset_id()
	_current_reservation = null
	_ignore_new_reservations = false
	
	if _auto_entertain_next_in_queue:
		entertain_next_reservation_in_line()
	else:
		attempt_request_reservation_queue_advance()

func entertain_next_reservation_in_line():
	_requested_queue_advance = false
	
	if _reservations.size() > 0:
		var latest_reservation = _consume_reservation_stack()
		
		_entertain_reservation_and_make_it_current(latest_reservation)
		
	else:
		emit_signal("no_reservations_left")

func _consume_reservation_stack():
	var last_index : int = _reservations.size() - 1
	var latest_reservation = _reservations[last_index]
	_reservations.remove(last_index)
	
	return latest_reservation


##

func is_current_reservation_null_or_not_have_id(arg_id):
	return _current_reservation == null or _current_reservation._queue_id != arg_id

func is_reservation_id_exists(arg_id) -> bool:
	for res in _reservations:
		if res._queue_id == arg_id:
			return true
	

	return false
#

func complete_reservation_status_of_current():
	if _current_reservation != null:
		emit_signal("before_reservation_completed", _current_reservation)
		_current_reservation.reservation_completed()
		

############

func attempt_request_reservation_queue_advance():
	if !_requested_queue_advance:
		_requested_queue_advance = true
		emit_signal("request_advance_queue_reservation")

