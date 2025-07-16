extends Node2D
@onready var wind_particles: Node2D = $particles2D
@onready var damage_on_touch: Node2D = $damage_on_touch
@onready var start: GPUParticles2D = $particles2D2
@onready var smoke: GPUParticles2D = $particles2D3

func _ready() -> void:
	Tools.timer(1,"queue_free",self)
	wind_particles.emitting = true
	smoke.emitting = true
	start.emitting = true
	damage_on_touch.activate()


func set_direction(value):
	scale.x = -value
	
