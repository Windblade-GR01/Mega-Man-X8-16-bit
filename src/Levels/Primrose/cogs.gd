extends Node2D

@onready var medium: Sprite2D = $medium
@onready var medium_2: Sprite2D = $medium2
@onready var big: Sprite2D = $big

func _physics_process(delta: float) -> void:
	big.rotation_degrees += 10 * delta
	medium.rotation_degrees -= 10 * delta
	medium_2.rotation_degrees -= 10 * delta
