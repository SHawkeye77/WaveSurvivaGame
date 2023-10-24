extends Node2D

@onready var world = get_tree().get_first_node_in_group("world")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var ENEMY_1 = preload("res://enemies/enemy_1.tscn")
@onready var ENEMY_2 = preload("res://enemies/enemy_2.tscn")
@onready var ENEMY_3 = preload("res://enemies/enemy_3.tscn")
@onready var WAVES = [
	# Wave 1
	[ENEMY_1, ENEMY_1, ENEMY_1],
	# Wave 2
	[ENEMY_2, ENEMY_2, ENEMY_2],
	# Wave 3
	[ENEMY_3, ENEMY_3, ENEMY_3],
]
var endScreen = "res://screens/end_screen.tscn"
var currentWave = -1
var enemiesToKill = -1

func _ready():
	currentWave = -1

# Spawns the next wave
func spawnWave():
	# Game won
	if currentWave == len(WAVES) - 1:
		world.updateUI()
		world.endGame()
	# Spawn next wave
	else:
		world.playNewWave()
		currentWave += 1
		world.updateUI()
		var currentWaveEnemies = WAVES[currentWave]
		enemiesToKill = len(currentWaveEnemies)
		for i in range(0, enemiesToKill):
			# Spawning the enemy and putting it at a random spot
			var newEnemy = currentWaveEnemies[i].instantiate()
			newEnemy.global_position = getRandomPosition()
			add_child(newEnemy)

func enemyDied():
	enemiesToKill -= 1
	# Wave over, spawn next wave.
	if enemiesToKill == 0:
		spawnWave()

# Returns a random position outside of the player's viewport
func getRandomPosition():
	# Getting a rect a bit bigger than the player's viewport
	var screenDimensions = get_viewport().get_visible_rect().size
	var spawnDimensions = screenDimensions * randf_range(1.1, 1.4)
	
	# Getting the corners of the generated rect
	var topLeft = Vector2(0 - (spawnDimensions.x - screenDimensions.x)/2, 0 - (spawnDimensions.y - screenDimensions.y)/2)
	var topRight = Vector2(screenDimensions.x + (spawnDimensions.x - screenDimensions.x)/2, 0 - (spawnDimensions.y - screenDimensions.y)/2)
	var bottomLeft = Vector2(0 - (spawnDimensions.x - screenDimensions.x)/2, screenDimensions.y + (spawnDimensions.y - screenDimensions.y)/2)
	var bottomRight = Vector2(screenDimensions.x + (spawnDimensions.x - screenDimensions.x)/2, screenDimensions.y + (spawnDimensions.y - screenDimensions.y)/2)
	
	# Picking a random side of the generated rect
	var spawnPos1 = Vector2.ZERO
	var spawnPos2 = Vector2.ZERO
	var posSide = ["up", "down", "right", "left"].pick_random()
	match posSide:
		"up":
			spawnPos1 = topLeft
			spawnPos2 = topRight
		"down":
			spawnPos1 = bottomLeft
			spawnPos2 = bottomRight
		"right":
			spawnPos1 = topRight
			spawnPos2 = bottomRight
		"left":
			spawnPos1 = topLeft
			spawnPos2 = bottomLeft
	
	# Picking a random spot on the random side of the generated rect
	var xSpawn = randf_range(spawnPos1.x, spawnPos2.x)
	var ySpawn = randf_range(spawnPos1.y, spawnPos2.y)
	
	return Vector2(xSpawn, ySpawn)
