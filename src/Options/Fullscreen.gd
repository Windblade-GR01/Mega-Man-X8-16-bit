extends X8OptionButton

func _ready() -> void:
	Configurations.listen("value_changed",self,"fullscreen_changed")
	
func fullscreen_changed(key) -> void:
	if key == "Fullscreen":
		display()

func setup() -> void:
	set_fullscreen(get_fullscreen())
	display()

func increase_value() -> void: #override
	set_fullscreen(!get_fullscreen())
	display()

func decrease_value() -> void: #override
	set_fullscreen(!get_fullscreen())
	display()


func set_fullscreen(value:bool) -> void:
	Configurations.set("Fullscreen",value)
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (value) else Window.MODE_WINDOWED

func get_fullscreen() -> bool:
	if Configurations.get("Fullscreen"):
		return true
	else:
		return false

func display():
	if Configurations.get("Fullscreen"):
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")
