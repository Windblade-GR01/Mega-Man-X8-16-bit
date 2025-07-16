extends X8TextureButton

@export var pick_sound : NodePath

func on_press() -> void:
	get_node(pick_sound).play()
	strong_flash()
	menu.lock_buttons()
	menu.fader.SoftFadeOut()
	await menu.fader.finished
	GameManager.go_to_stage_select()
