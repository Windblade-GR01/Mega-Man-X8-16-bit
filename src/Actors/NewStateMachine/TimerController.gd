extends Object
class_name TimerController

var timer_list : Array
var owner : Node
func _init(_owner, reset_signal := "no_signal") -> void:
	owner = _owner
	connect_reset(reset_signal)

func connect_reset(end_signal := "stop") -> void:
	if end_signal != "no_signal":
		owner.connect(end_signal,self,"reset") # warning-ignore:return_value_discarded

func reset(_discard = null) -> void:
	for timer in timer_list:
		if is_instance_valid(timer):
			var s = Timer.new()
			
			timer.kill()
