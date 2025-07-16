extends SimplePlayerProjectile
@onready var remains: GPUParticles2D = $remains_particles
@onready var particles: GPUParticles2D = $particles2D

func _Setup() -> void:
	super._Setup()
	set_horizontal_speed(400 * get_facing_direction())

func _Update(delta) -> void:
	super._Update(delta)
	var rotate_speed = (delta * 12) * get_facing_direction()
	animatedSprite.rotate(rotate_speed)
	
func _OnHit(target_remaining_HP) -> void: #override
	shatter()

func _OnDeflect() -> void:
	shatter()

func _DamageTarget(_body) -> int:
	var target_hp = _body.damage(damage, self)
	return _body.damage(damage, self)

func shatter() -> void:
	visible = true
	remains.emitting = true
	particles.emitting = false
	disable_visuals()
	var sound = $crash
	sound.pitch_scale = randf_range(0.9,1.1)
	sound.play()
	
