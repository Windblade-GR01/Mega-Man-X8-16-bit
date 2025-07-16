extends AnimatedSprite2D

@onready var parent: AnimatedSprite2D = $".."

func _process(delta: float) -> void:
	animation = parent.animation
	frame = parent.frame
