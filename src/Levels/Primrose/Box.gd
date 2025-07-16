extends CharacterBody2D

const up_direction := Vector2.UP
var velocity = Vector2.ZERO
var final_velocity : Vector2

func _physics_process(delta: float) -> void:
	final_velocity.y += 800.0 * delta
	set_velocity(final_velocity)
	set_up_direction(up_direction)
	set_floor_stop_on_slope_enabled(true)
	set_max_slides(4)
	set_floor_max_angle(0.8)
	move_and_slide()
	final_velocity = velocity
