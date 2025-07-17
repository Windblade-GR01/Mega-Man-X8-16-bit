extends AttackAbility

export var pursuit_speed := 80
onready var animator := $"../animatedSprite"

func _ready() -> void:
	Event.connect("stage_rotate_end",self,"EndAbility")

func _Setup() -> void:
	animator.set_speed_scale(1.5)

func _Interrupt() -> void:
	._Interrupt()
	animator.set_speed_scale(1)

func _EndCondition() -> bool:
	return character.global_position.distance_to(GameManager.get_player_position()) > 200

func _Update(_delta) -> void:
	var target_direction = (GameManager.get_player_position() - character.global_position).normalized()
	force_movement_regardless_of_direction(pursuit_speed * target_direction.x) #equivalente a set_horizontal_speed
	set_vertical_speed(pursuit_speed * target_direction.y * range_lerp(cos(timer*4),-1,1,-0.25,1) )
