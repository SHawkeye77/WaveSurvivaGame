extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var repeaterBullets = get_tree().get_first_node_in_group("RepeaterBullets")
@onready var sprite = $Sprite2D
@onready var timeBetweenCyclesTimer = get_node("%TimeBetweenCyclesTimer")
@onready var timeBetweenShotsTimer = get_node("%TimeBetweenShotsTimer")
var bulletInCycle = 0

func _ready():
	timeBetweenShotsTimer.wait_time = Global.TIME_BETWEEN_REPEATER_SHOTS
	updateWeaponStats()
	timeBetweenCyclesTimer.start()

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

func spawnBullet():
	var mousePos = get_global_mouse_position()
	var playerPos = player.get_global_position()
	var playerToMouse = mousePos - playerPos
	# Spawn a bullet
	var newBullet = Global.BULLET.instantiate()
	newBullet.direction = (mousePos - playerPos).normalized()
	newBullet.global_position = playerPos + playerToMouse.normalized() * Global.GUN_DISTANCE_FROM_PLAYER
	newBullet.look_at(playerToMouse)
	repeaterBullets.call_deferred("add_child", newBullet)

func _on_time_between_cycles_timer_timeout():
	spawnBullet()
	# Increment the shot we are on
	bulletInCycle = 1
	timeBetweenShotsTimer.start()

func _on_time_between_shots_timer_timeout():
	if bulletInCycle < Global.REPEATER_SHOTS[player.bulletAmountIndex]:
		spawnBullet()
		bulletInCycle += 1
		timeBetweenShotsTimer.start()
	else:
		bulletInCycle = 0
		timeBetweenCyclesTimer.start()

func updateWeaponStats():
	timeBetweenCyclesTimer.wait_time = Global.TIME_BETWEEN_REPEATER_CYCLES[player.fireRateIndex]
