extends CameraLimits

@export var limit_to_disable: NodePath

func _ready() -> void:
	connect("body_entered", Callable(self, "start_disable_timer"))# warning-ignore:return_value_discarded

func start_disable_timer(_body) -> void:
	if limit_to_disable:
		var timer = get_tree().create_timer(0.5)
		timer.connect("timeout", Callable(self, "disable_limit"))

func disable_limit() -> void:
	get_node(limit_to_disable).disable()
	
