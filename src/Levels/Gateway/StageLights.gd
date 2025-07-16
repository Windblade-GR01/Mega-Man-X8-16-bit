extends CanvasModulate

@onready var tween := TweenController.new(self,false)

func _ready() -> void:
	Event.listen("darkness",self,"start_darkness")
	Event.listen("turn_off_darkness",self,"end_darkness")
	color = Color.DARK_GRAY

func start_darkness():
	print("Starting darkness")
	tween.reset()
	tween.attribute("color", Color.BLACK, 1)
	
func end_darkness():
	print("Ending darkness")
	tween.reset()
	tween.attribute("color", Color.DARK_GRAY, 1)
