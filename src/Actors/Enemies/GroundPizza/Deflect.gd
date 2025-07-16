extends PizzaAbility
@export var wait_duration := 3.0

func _Setup() -> void:
	attack_stage = 0
	retract_projectile()

func _Update(_delta) -> void:
	if timer > wait_duration:
		EndAbility()

func retract_projectile() -> void:
	var tween = get_tree().create_tween()
	tween.tween_callback(Callable(self, "toggle_projectile_damage").bind(false))
	tween.tween_callback(Callable(self, "deactivate_touch_damage"))
	tween.tween_property(projectile,"position",Vector2(0.0, 13.0),0.5)
	tween.tween_callback(Callable(self, "hide_projectile"))
	tween.tween_callback(Callable(self, "play_animation_once").bind("close"))

	
