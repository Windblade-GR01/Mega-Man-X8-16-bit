extends EnemyShield

func _ready() -> void:
	pass

func activate() -> void:
	super.activate()
	character.add_invulnerability(name)
	
func deactivate() -> void:
	super.deactivate()
	character.remove_invulnerability(name)
