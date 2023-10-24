extends Area2D

@export var damage = Global.ENEMY_DEFAULT_DAMAGE
@onready var collision = $CollisionShape2D
@onready var disableHitBoxTimer = $DisableHitBoxTimer

# Enables the hitbox (after the cooldown is off)
func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set", "disabled", false)
