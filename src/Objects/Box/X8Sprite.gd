extends AnimatedSprite2D

func make_invisible() -> void:
	visible = false

func restart() -> void:
	playing = true
	frame = 0
