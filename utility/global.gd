extends Node

# Player
const MOVEMENT_SPEED = 100
const PLAYER_STARTING_HP = 100

# Enemies
const ENEMY_DEFAULT_DAMAGE = 5
const ENEMY_COMPUTE_PATH_FREQUENCY = 0.2

# Enemy 1
const ENEMY_1_SPEED = 90
const ENEMY_1_STARTING_HP = 5
const ENEMY_1_DAMAGE = 5
const ENEMY_1_COIN_VALUE = 1

# Enemy 2
const ENEMY_2_SPEED = 70
const ENEMY_2_STARTING_HP = 10
const ENEMY_2_DAMAGE = 20
const ENEMY_2_COIN_VALUE = 5

# Enemy 3
const ENEMY_3_SPEED = 50
const ENEMY_3_STARTING_HP = 20
const ENEMY_3_DAMAGE = 50
const ENEMY_3_COIN_VALUE = 7

# Mystery Box
const MYSTERY_BOX_WAIT_TIME = 4.75  # Don't change this, it lines up with the length of the associated audio
const MYSTERY_BOX_PRICE = 200

# Fire rate increase box
const FIRE_RATE_INCREASE_BOX_PRICE = 200

# Bullet amount increase box
const BULLET_AMOUNT_INCREASE_BOX_PRICE = 200

# Bullet
const BULLET = preload("res://weapons/bullet.tscn")
const BULLET_SPEED = 150
const BULLET_DAMAGE = 5

# Guns (general)
const GUN_DISTANCE_FROM_PLAYER = 15.0
const GUNS = [
	preload("res://weapons/pistol.tscn"),
	preload("res://weapons/shotgun.tscn"),
	preload("res://weapons/repeater.tscn"),
]

# Pistol
const PISTOL_BULLET_WAIT_TIME = [0.5, 0.4, 0.3]

# Shotgun
const SHOTGUN_SPREAD_DEGREES = 55.0
const SHOTGUN_BULLET_WAIT_TIME = [1.5, 1.2, 0.9]
const SHOTGUN_BULLETS = [4, 5, 6]

# Repeater
const TIME_BETWEEN_REPEATER_SHOTS = 0.1
const TIME_BETWEEN_REPEATER_CYCLES = [1.5, 1.2, 0.9]
const REPEATER_SHOTS = [4, 5, 6]

# End screen data
var finalWave = -1
var finalCurrencyAmount= -1
var totalNumberWaves = -1
