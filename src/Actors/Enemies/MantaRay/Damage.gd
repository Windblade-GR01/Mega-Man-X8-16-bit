extends EnemyDamage

func should_ignore_damage(inflicter) -> bool:
	if character.ignore_bike_melee and inflicter.is_in_group("Props"):
		return true
	return super.should_ignore_damage(inflicter)
