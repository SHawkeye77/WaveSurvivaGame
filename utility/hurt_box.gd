extends Area2D

@onready var collision = $CollisionShape2D
@onready var disableHurtBoxTimer = $DisableHurtBoxTimer

# Custom signal for when this is being hurt
signal hurt(damage)

# Triggered when hurt box is entered (aka being attacked)
func _on_area_entered(area):
	if area.get_parent() != null:
		# Checked so hitbox on node "a" doesn't damage hurtbox on node "a"
		if area.get_parent() == self.get_parent():
			return
		# Check to make sure its not two enemies fighting eachother
		if self.get_parent().is_in_group("enemy") && area.get_parent().is_in_group("enemy"):
			return
	if area.is_in_group("attack"):
		# If the attacker has damage
		if not area.get("damage") == null:
			# Disabling the collision shape and putting it on cooldown
			collision.call_deferred("set", "disabled", true)
			disableHurtBoxTimer.start()
			var damage = area.damage
			emit_signal("hurt", damage)
			# Notifying the weapon that it hit an enemy
			if area.has_method("enemy_hit"):
				area.enemy_hit()


func _on_disable_hurt_box_timer_timeout():
	# Re-enables the collision shape
	collision.call_deferred("set", "disabled", false)
