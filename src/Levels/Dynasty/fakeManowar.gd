extends AnimatedSprite2D
@export var duration:= 12.0
@onready var path: PathFollow2D = $".."
var started := false

func move() -> void:
		var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
		tween.tween_property(path,"progress_ratio",1.0,duration)
# warning-ignore:return_value_discarded
		tween.tween_callback(Callable(self, "queue_free"))

func _on_trigger_zone_body_entered(_body: Node) -> void:
	if not started and not "manowar_weapon" in GameManager.collectibles:
		move()
		started = true
