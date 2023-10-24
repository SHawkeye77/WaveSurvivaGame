extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var shotgunBullets = get_tree().get_first_node_in_group("ShotgunBullets")
@onready var sprite = $Sprite2D
@onready var shotgunShotTimer = get_node("%ShotgunShotTimer")

func _ready():
	updateWeaponStats()
	shotgunShotTimer.start()

func _process(delta):
	# Making the gun orbit the player
	var mousePos = get_global_mouse_position()
	var playerPos = player.get_global_position()
	var playerToMouse = mousePos - playerPos
	var gunPosition = playerToMouse.normalized() * Global.GUN_DISTANCE_FROM_PLAYER
	look_at(mousePos)
	if mousePos.x < playerPos.x:
		sprite.scale.y = -1 * abs(sprite.scale.y)
	else:
		sprite.scale.y = abs(sprite.scale.y)
	position = gunPosition

func _on_shotgun_shot_timer_timeout():
	var mousePos = get_global_mouse_position()
	var playerPos = player.get_global_position()
	var playerToMouse = mousePos - playerPos
	# Spawn bullets
	for i in range(0, Global.SHOTGUN_BULLETS[player.bulletAmountIndex]):
		var newBullet = Global.BULLET.instantiate()
		var rotationInDeg = -(Global.SHOTGUN_SPREAD_DEGREES / 2) + (i * Global.SHOTGUN_SPREAD_DEGREES / Global.SHOTGUN_BULLETS[player.bulletAmountIndex])
		var dir = (mousePos - playerPos).normalized().rotated(deg_to_rad(rotationInDeg))
		newBullet.direction = dir
		newBullet.global_position = playerPos + playerToMouse.normalized() * Global.GUN_DISTANCE_FROM_PLAYER
		newBullet.look_at(dir)
		shotgunBullets.call_deferred("add_child", newBullet)

func updateWeaponStats():
	shotgunShotTimer.wait_time = Global.SHOTGUN_BULLET_WAIT_TIME[player.fireRateIndex]
