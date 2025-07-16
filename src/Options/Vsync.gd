extends X8OptionButton

func _ready() -> void:
	Event.connect("translation_updated", Callable(self, "display"))
	
func setup() -> void:
	set_vsync(get_vsync())
	display()

func increase_value() -> void: #override
	set_vsync(!get_vsync())
	display()

func decrease_value() -> void: #override
	set_vsync(!get_vsync())
	display()


func set_vsync(value:bool) -> void:
	Configurations.set("Vsync",value)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (value) else DisplayServer.VSYNC_DISABLED)

func get_vsync() -> bool:
	if Configurations.exists("Vsync"):
		return Configurations.get("Vsync")
	else:
		return false

func display():
	if Configurations.get("Vsync"):
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")
