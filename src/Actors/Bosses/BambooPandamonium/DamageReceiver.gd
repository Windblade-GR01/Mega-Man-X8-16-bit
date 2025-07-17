extends Area2D

export var health_path : NodePath
export var active := true
var health
signal received_damage(damage,inflicter)
signal got_hit
signal friendly_fire

func _ready() -> void:
	if active:
		Event.listen("player_death",self,"deactivate")
	if health_path:
		health = get_node(health_path)

func _on_area2D_body_entered(_body: Node) -> void:
	if active:
		if _body.is_in_group("Player Projectile"):
			_body.hit(self)

func _on_area2D_body_exited(_body: Node) -> void:
	if _body.is_in_group("Player Projectile"):
		_body.leave(self)

func damage(damage, inflicter) -> float:
	if active and GameManager.is_on_screen(global_position):
		emit_signal("received_damage",damage,inflicter)
		emit_signal("got_hit")
	return get_current_hp()

func get_current_hp() -> float:
	if health:
		return health.current_health
	return 10.0

func deactivate():
	active = false
	#$"../collisionShape2D".call_deferred("set_disabled",true)

func activate():
	active = true
	#$"../collisionShape2D".call_deferred("set_disabled",false)


func _on_DamageReceiver_area_entered(area: Area2D) -> void:
	if active:
		if area.is_in_group("FriendlyFire"):
			if area.get_parent().active:
				emit_signal("friendly_fire")
				#emit_signal("received_damage",10.0,area.get_parent())
