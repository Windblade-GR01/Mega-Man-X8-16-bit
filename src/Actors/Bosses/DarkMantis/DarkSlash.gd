extends AttackAbility
class_name DarkSlash
var camera_center
var jump_duration := 0.5
var time_between_cuts := .45
var short_time_between_cuts := .15
onready var tween := TweenController.new(self,false)
onready var lighttween := TweenController.new(self,false)
onready var slash_fx : Light2D = $light2D
onready var slash_hitbox: Node2D = $SlashHitbox
onready var jump: AudioStreamPlayer2D = $jump
onready var land: AudioStreamPlayer2D = $land
onready var darkslash: AudioStreamPlayer2D = $darkslash
onready var desperation: AudioStreamPlayer2D = $desperation
signal ready_for_stun

func _Setup() -> void:
	._Setup()
	character.emit_signal("damage_reduction", 0.5)

func slash() -> void:
	play_animation_once("ult_cut")
	create_hitbox_and_vfx()
	screenshake()

func _Update(delta):
	if attack_stage == 0:
		process_gravity(delta) 
		if has_finished_last_animation():
			desperation.play()
			play_animation_once("desperation_loop")
			next_attack_stage_on_next_frame()

	if attack_stage == 1 and timer > 0.5:
		#set_direction_relative_to_camera()
		play_animation_once("desperation_jump_prepare")
		next_attack_stage_on_next_frame()
		
	if attack_stage == 2 and has_finished_last_animation():
		jump.play()
		play_animation_once("desperation_jump")
		go_to_center_of_screen()
		slash_hitbox.handle_direction()
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 3 and timer > jump_duration:
		force_movement(0)
		set_vertical_speed(0)
		turn()
		slash_hitbox.handle_direction()
		play_animation_once("ult_prepare")
		next_attack_stage_on_next_frame()
		emit_signal("ready_for_stun")
	
	elif attack_stage == 4 and timer > time_between_cuts: #first cut time
		next_attack_stage()
	
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation_once("ult_start")
		next_attack_stage()
	
	elif attack_stage == 6 and has_finished_last_animation():
		slash()
		next_attack_stage()
		
	elif attack_stage == 7 and has_finished_last_animation():
		play_animation_once("ult_end")
		if has_finished_last_animation():
			next_attack_stage()
		
	elif attack_stage == 8 and timer > 0.65:
		turn()
		play_animation_once("ult_prepare")
		next_attack_stage()
		
	elif attack_stage == 9 and timer > time_between_cuts: #second cut time
		next_attack_stage()
	
	elif attack_stage == 10 and has_finished_last_animation():
		play_animation_once("ult_start")
		next_attack_stage()
		
	elif attack_stage == 11 and has_finished_last_animation():
		slash()
		next_attack_stage()
	
	elif attack_stage == 12 and has_finished_last_animation():
		play_animation_once("ult_end")
		if has_finished_last_animation():
			next_attack_stage()
	
	elif attack_stage == 13 and timer > 0.4:
		turn()
		play_animation_once("ult_prepare")
		next_attack_stage()
		
	elif attack_stage == 14 and timer > short_time_between_cuts: #third cut time
		next_attack_stage()
	
	elif attack_stage == 15 and has_finished_last_animation():
		play_animation_once("ult_start")
		next_attack_stage()
		
	elif attack_stage == 16 and has_finished_last_animation():
		slash()
		next_attack_stage()
	
	elif attack_stage == 17 and timer > 0.15:
		play_animation_once("ult_end")
		if has_finished_last_animation():
			next_attack_stage()
	
	elif attack_stage == 18 and timer > 0.1:
		turn()
		play_animation_once("ult_prepare")
		next_attack_stage()
		
	elif attack_stage == 19 and timer > short_time_between_cuts: #fourth cut time
		next_attack_stage()
	
	elif attack_stage == 20 and has_finished_last_animation():
		play_animation_once("ult_start")
		next_attack_stage()
		
	elif attack_stage == 21 and has_finished_last_animation():
		slash()
		next_attack_stage()
		
	elif attack_stage == 22 and timer > 0.15:
		play_animation_once("ult_end")
		if has_finished_last_animation():
			next_attack_stage()

	elif attack_stage == 23 and timer > 0.1:
		turn()
		play_animation_once("ult_prepare")
		next_attack_stage()
		
	elif attack_stage == 24 and timer > short_time_between_cuts: #fifth cut time
		next_attack_stage()
	
	elif attack_stage == 25 and has_finished_last_animation():
		play_animation_once("ult_start")
		next_attack_stage()
		
	elif attack_stage == 26 and has_finished_last_animation():
		slash()
		next_attack_stage()
	
	elif attack_stage == 27 and has_finished_last_animation():
		play_animation_once("ult_end")
		if has_finished_last_animation():
			next_attack_stage()
	
	elif attack_stage == 28 and timer > 0.35:
		play_animation_once("ult_fall")
		set_vertical_speed(-get_jump_velocity()*0.15)
		next_attack_stage()
			
	elif attack_stage == 29:
		process_gravity(delta*.85)
		if character.is_on_floor():
			next_attack_stage()
			land.play()
			play_animation_once("land")
			EndAbility()

func _Interrupt():
	character.emit_signal("damage_reduction", 1)
	lighttween.end()
	tween.reset()

func go_to_center_of_screen() -> void:
	camera_center = GameManager.camera.get_camera_screen_center()
	var character_center = character.global_position
	var final_position = Vector2(camera_center.x,character_center.y - 98)
	var distance = abs(character_center.x - final_position.x) + abs(character_center.y - final_position.y)
	#var tween = get_tree().create_tween()
	jump_duration = 0.5 + 0.25 * clamp(inverse_lerp(112,200,distance),0,1)
	tween.create(Tween.EASE_OUT,Tween.TRANS_CUBIC)
	tween.add_attribute("global_position",final_position,jump_duration,character)
	#tween.tween_property(character,"global_position",final_position,jump_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func create_hitbox_and_vfx() -> void:
	darkslash.play()
	if character.get_facing_direction() == 1:
		slash_hitbox.activate()
		slash_vfx_left()
	else:
		slash_hitbox.activate()
		slash_vfx_right()

func turn() -> void:
	.turn()
	slash_hitbox.handle_direction()
	
func slash_vfx_left() -> void:
	slash_fx.scale.x = 1
	slash_fx.position.x = -56
	tween_light_down()

func slash_vfx_right() -> void:
	slash_fx.scale.x = -1
	slash_fx.position.x = 56
	tween_light_down()
	
func tween_light_down() -> void:
	slash_fx.energy = 5.5
	lighttween.attribute("energy",0.0,0.75,slash_fx)
