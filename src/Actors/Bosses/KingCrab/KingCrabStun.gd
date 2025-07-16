extends EnemyStun
class_name KingCrabStun

@export var shield_to_disable: NodePath

func _ready() -> void:
	shield = get_node(shield_to_disable)

func _on_KingCrab_guard_break() -> void:
	if active:
		character.interrupt_all_moves()
		ExecuteOnce()
