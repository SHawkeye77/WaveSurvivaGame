extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var pistolBullets = get_tree().get_first_node_in_group("PistolBullets")
@onready var sprite = $Sprite2D
@onready var pistolShotTimer = get_node("%PistolShotTimer")

func _ready():
	updateWeaponStats()
	pistolShotTimer.start()

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

func _on_pistol_shot_timer_timeout():
	var mousePos = get_global_mouse_position()
	var playerPos = player.get_global_position()
	var playerToMouse = mousePos - playerPos
	# Spawn a bullet
	var newBullet = Global.BULLET.instantiate()
	newBullet.direction = (mousePos - playerPos).normalized()
	newBullet.global_position = playerPos + playerToMouse.normalized() * Global.GUN_DISTANCE_FROM_PLAYER
	newBullet.look_at(playerToMouse)
	pistolBullets.call_deferred("add_child", newBullet)

func updateWeaponStats():
	pistolShotTimer.wait_time = Global.PISTOL_BULLET_WAIT_TIME[player.fireRateIndex]
