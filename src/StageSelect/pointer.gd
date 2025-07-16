extends AnimatedSprite2D

@export var button_sprites : NodePath
@onready var tween := TweenController.new(self,false)

signal reposition_map(pos)

func _ready() -> void:
	for sprite in get_node(button_sprites).get_children():
		if sprite.has_signal("moved_cursor"):
			var _s = sprite.connect("moved_cursor", Callable(self, "move"))

func move(destination : Vector2) -> void:
	position = destination
	emit_signal("reposition_map",destination)
