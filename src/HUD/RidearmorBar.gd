extends NinePatchRect

@onready var hud: CanvasLayer = $".."
@onready var texture_progress: TextureProgressBar = $textureProgress

func _ready() -> void:
	Event.listen("ridearmor_activate",self,"move_in")
	Event.listen("ridearmor_deactivate",self,"move_out")
	set_process(false)

func move_in() -> void:
	hud.tween_focus_on_bar(self,hud.player_bar,13,Color.GRAY)
	set_process(true)

func move_out() -> void:
	hud.tween_focus_on_bar(hud.player_bar,self,-14,Color.WHITE)
	set_process(false)

func _process(_delta: float) -> void:
	if not GameManager.player.ride:
		return
	position.y = 56 - (GameManager.player.ride.max_health - 16) * 2
	size.y =  52 + (GameManager.player.ride.max_health - 16) * 2
	var sizeOffset = size.y - 108
	#texture_progress.rect_position.y = -28
	var hpValue = ceil(GameManager.player.ride.current_health)
	texture_progress.value = hpValue
