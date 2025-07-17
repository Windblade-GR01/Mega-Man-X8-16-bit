extends Light2D
onready var sublight: Light2D = $sublight
onready var path: PathFollow2D = $".."

export var debug := false
export var path_speed := 50.0
export var inverse_speed := false

var timer := 0.0
var activated := true
var dissipated:= false

var current_tween

signal alarm_activated


func _physics_process(delta: float) -> void:
	timer += delta
	if activated:
		move_and_flicker(delta)
			
	if timer > 16 and not activated:
		restore_shape()
	if timer > 17.5 and not activated:
		activate()
	

func move_and_flicker(delta) -> void:
	var speed = path_speed
	if inverse_speed:
		speed = path_speed * -1
	
	path.offset += delta * speed
	energy = lerp(0.85, 1, sin(timer * 120))
	sublight.energy = 0.5
	sublight.scale.x = lerp(2, 2.1, sin(timer * 120))

func restore_shape() -> void:
		debug_print("Restoring original shape")
		var tween = get_tree().create_tween()
		current_tween = tween
		scale = Vector2 (4,4)
		tween.tween_property(self, "energy", 0.5, 0.95).set_trans(Tween.TRANS_QUAD)
		tween.parallel().tween_property(self, "scale", Vector2(1,1), 0.95).set_trans(Tween.TRANS_QUAD)
		#tween.tween_callback(self,"activate")

func activate() -> void:
	debug_print("Activating")
	activated = true
	timer = 0

func deactivate() -> void:
	debug_print("Deactivating due to Event alarm signal")
	activated = false
	timer = 0
	sublight.energy = 0
	energy = 0

func _ready() -> void:
	Event.listen("alarm",self,"deactivate")

func _on_playerDetector_body_entered(_body: Node) -> void:
	if activated:
		debug_print("Player collided, sending signals and starting")
		emit_signal("alarm_activated")
		Event.emit_signal("alarm")
		expand_shape()
	else:
		debug_print("Player collided, but not activated")

func expand_shape() -> void:
	energy = 1
	debug_print("Expanding shape")
	var tween = get_tree().create_tween()
	current_tween = tween
	tween.tween_property(self, "scale", Vector2(12,12), 0.25).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(self, "energy", 0.0, 0.5)

func debug_print(message) -> void:
	if debug:
		print_debug(name +": " +str(message))
