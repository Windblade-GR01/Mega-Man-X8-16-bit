extends Node

@onready var up: AnimatedSprite2D = $"../up"
@onready var down: AnimatedSprite2D = $"../down"

func _ready() -> void:
	pass

func _on_deflected() -> void:
	if up.visible:
		up.visible = false
	else:
		down.visible = false

func _on_resetted() -> void:
	up.material.set_shader_parameter("Flash",0)
	down.material.set_shader_parameter("Flash",0)
	up.visible = true
	down.visible = true


func _on_started_deflect() -> void:
	if up.visible:
		up.material.set_shader_parameter("Flash",1)
	else:
		down.material.set_shader_parameter("Flash",1)

func _on_vanished() -> void:
	up.visible = false
	down.visible = false
	pass # Replace with function body.
