extends AudioStreamPlayer

@onready var tween := TweenController.new(self,false)

func _ready() -> void:
	Event.connect("lumine_went_seraph", Callable(self, "activate"))
	Event.connect("enemy_kill", Callable(self, "deactivate"))

func deactivate(enemy):
	if enemy is String:
		if enemy == "SeraphLumine":
			tween.attribute("volume_db",-80,3.0)

func activate() -> void:
	volume_db = -80
	play()
	tween.attribute("volume_db",-17,2.0)
