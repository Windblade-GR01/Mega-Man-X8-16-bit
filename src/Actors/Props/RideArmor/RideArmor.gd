extends Actor
class_name RideArmor
onready var ride: Node = $Ride

export var song_intro : AudioStream
export var song_loop : AudioStream
var song_timer := 0.0
export var damage_reduction := 0.5
var grounded := false
var listening_to_inputs := true
var queued_up_for_destruction := false
signal spawned 
signal on_floor
signal not_on_floor
signal land  
signal grab_eject
signal force_eject
signal listening_to_inputs(state)

func _ready() -> void:
	Event.listen("cutscene_start",self,"stop_listening_to_inputs")
	Event.listen("cutscene_over",self,"start_listening_to_inputs")
	Event.listen("end_cutscene_start",self,"end_stage")
	call_deferred("emit_signal","spawned")

func end_stage():
	stop_listening_to_inputs()
	active = false
	Tools.timer_p(12,"emit_signal",self,"force_eject")

func stop_listening_to_inputs() -> void:
	listening_to_inputs = false
	end_all_abilities()
	emit_signal("listening_to_inputs",false)
	
func start_listening_to_inputs() -> void:
	listening_to_inputs = true
	emit_signal("listening_to_inputs",true)

func should_execute_abilities() -> bool:
	return active and ride.is_executing() and listening_to_inputs

func _physics_process(delta: float) -> void:
	process_song_timer(delta)
	process_destruction()
	if not is_on_floor():
		grounded = false
		emit_signal("not_on_floor")
	else:
		if not grounded:
			emit_signal("land")
			grounded = true
		emit_signal("on_floor")

func grab_eject() -> void:
	emit_signal("grab_eject")
	
func force_eject() -> void:
	emit_signal("force_eject")

func process_movement():
	if animatedSprite.visible:
		final_velocity = velocity + bonus_velocity
		final_velocity.x += conveyor_belt_speed
		move_and_collide(Vector2.ZERO) # warning-ignore:return_value_discarded
		final_velocity = process_final_velocity()
		velocity.y = final_velocity.y

func get_animation() -> String:
	return "idle"

func _on_new_direction(_dir) -> void:
	update_facing_direction()

func get_all_abilities() -> Array:
	var abilities = []
	for node in get_children():
		if node is NewAbility:
			abilities.append(node)
	return abilities

func damage(value, inflicter = null) -> float:
	if is_invulnerable() or !has_health():
		return current_health
	
	var objName = inflicter.get_name()
	
	if objName.begins_with("SimpleEnemyProjectile") and max_health > 20:
		emit_signal("damage", 0, inflicter)
	elif (inflicter is Enemy \
		and !(inflicter is Panda) \
		and objName != "RidearmorReploid" \
	):
		inflicter.damage(20, self)
	elif objName == "Vile":
		return current_health
	else:
		emit_signal("damage", value, inflicter)
		reduce_health(value)
		set_invulnerability(0.75)
	return current_health

func is_invulnerable() -> bool:
	return not active or not listening_to_inputs or invulnerability > 0 or toggleable_invulnerabilities.size() > 0

func reduce_health(value : float):
	if value <= 1:
		current_health -= value
	var health_to_reduce = floor(value * (1 - damage_reduction))
	current_health -= health_to_reduce

func flash(duration := 0.032):
	animatedSprite.material.set_shader_param("Flash", 1)
	Tools.timer(duration,"end_flash",self)
	
func end_flash():
	animatedSprite.material.set_shader_param("Flash", 0)
	
func blink(duration := 0.725):
	animatedSprite.material.set_shader_param("Alpha_Blink", 1)
	Tools.timer(duration,"end_blink",self)
	
func end_blink():
	animatedSprite.material.set_shader_param("Alpha_Blink", 0)

func make_invisible() -> void:
	animatedSprite.material.set_shader_param("Alpha", 0)
	
func is_executing(state) -> bool:
	if state == "Ride":
		return ride.is_executing()
	
	for ability in get_all_abilities():
		if ability.name == state:
			return true
	return false

func void_touch() -> void:
	emit_signal("force_eject")
	emit_signal("death")

func end_all_abilities() -> void:
	var exceptions := ["Ride","Idle","Fall","Death","Shutdown","Eject","Start"]
	for ability in get_all_abilities():
		if not ability.name in exceptions:
			ability.EndAbility()

func should_play_song() -> bool:
	if song_loop and GameManager.music_player:
		return not GameManager.music_player.is_playing_boss_song() \
		and not GameManager.music_player.is_playing_miniboss_song()
	return false

func play_ridearmor_song() ->void:
	song_timer = 0
	if should_play_song():
		GameManager.music_player.play_song(song_loop,song_intro)

func play_stage_song() -> void:
	if should_play_song():
		song_timer = 0.1

func play_delayed_stage_song() -> void:
	if ride.is_executing():
		return
	if should_play_song():
		if GameManager.music_player.is_stream(song_loop,song_intro):
			GameManager.music_player.play_stage_song()

func process_song_timer(delta) -> void:
	if song_timer > 0:
		song_timer += delta
		if song_timer > 4.5:
			fade_out()
		if song_timer > 8.0:
			play_delayed_stage_song()
			song_timer = 0
			if queued_up_for_destruction:
				destroy()

func fade_out() -> void:
	if GameManager.music_player and not GameManager.music_player.slow_fade_out:
		if GameManager.music_player.is_stream(song_loop,song_intro):
			GameManager.music_player.start_slow_fade_out()
	
func process_destruction() -> void:
	pass

func queue_up_for_destruction():
	if song_timer > 0:
		queued_up_for_destruction = true
	else:
		Tools.timer(5.0,"destroy",self)
