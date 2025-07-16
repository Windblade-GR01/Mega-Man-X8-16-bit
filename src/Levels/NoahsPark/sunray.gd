extends Node2D

@onready var sprites :Array

func _ready() -> void:
	for child in get_children():
		if child is AnimatedSprite2D:
			sprites.append(child)

	decide_next_animation()

func _on_animation_finished() -> void:
	Tools.timer(randf_range(0.1,.5),"decide_next_animation",self)

func decide_next_animation():
	var next_animation = randf_range(0,3)
	
	if next_animation < 1:
		play_animation("1")
	elif next_animation >= 1 and next_animation < 2:
		play_animation("2")
	else:
		play_animation("3")

func play_animation(anim : String):
	var speed = randf_range(.7,1)
	var alpha = randf_range(.1,.5)
	for animatedSprite in sprites:
		animatedSprite.play(anim)
		animatedSprite.speed_scale = speed
		animatedSprite.modulate.a = alpha
