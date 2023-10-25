extends Node2D

var endScreen = "res://screens/end_screen.tscn"
var currentWaveIndex = -1
var currentWaveEnemiesData = []
var currentWaveEnemiesSpawned = []
var currentEnemyIndex = -1
@onready var world = get_tree().get_first_node_in_group("world")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var spawnNextEnemyTimer = get_node("%SpawnNextEnemyTimer")
@onready var E1 = preload("res://enemies/enemy_1.tscn")
@onready var E2 = preload("res://enemies/enemy_2.tscn")
@onready var E3 = preload("res://enemies/enemy_3.tscn")
# Waves for the game (Format: [ENEMY_TYPE, WAIT_TIME_TO_NEXT_ENEMY])
@onready var WAVES = [
	# Wave 1 
	[
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
	],
	# Wave 2
	[
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
	],
	# Wave 3
	[
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
	],
	# Wave 4
	[
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		
	],
	# Wave 5
	[
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
	],
	# Wave 6
	[
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
	],
	# Wave 7
	[
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
	],
	# Wave 8
	[
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 5.0],
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 15.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
	],
	# Wave 9
	[
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 15.0],
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 15.0],
	],
	# Wave 10
	[
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 15.0],
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 15.0],
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 15.0],
		[E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 0], [E3, 5.0],
		[E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 0], [E2, 5.0],
		[E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 0], [E1, 15.0],
	],
]

func _ready():
	currentWaveIndex = 0
	spawnNextEnemyTimer.wait_time = 0.0

# Spawns the next wave
func spawnWave():
	# Game won
	if currentWaveIndex == len(WAVES):
		world.updateUI()
		world.endGame()
	# Spawn next wave
	else:
		currentWaveIndex += 1
		currentWaveEnemiesData = WAVES[currentWaveIndex - 1] # Since "Wave 1" is actually the wave at index 0
		currentEnemyIndex = 0
		world.playNewWave()
		world.updateUI()
		spawnEnemy()

# Spawns the next enemy in the current wave
func spawnEnemy():
	# If there are more enemies left in this wave, spawn the next enemy
	if currentEnemyIndex != len(currentWaveEnemiesData):
		var enemyInfo = currentWaveEnemiesData[currentEnemyIndex]
		# Spawning the new enemy
		var newEnemy = enemyInfo[0].instantiate()
		newEnemy.global_position = getRandomPosition()
		add_child(newEnemy)
		currentWaveEnemiesSpawned.append(newEnemy)
		# Set up the timer to spawn the next enemy
		currentEnemyIndex += 1
		if (enemyInfo[1] == 0): # Setting to small value, otherwise run into some bugs with setting the timer
			spawnNextEnemyTimer.start(0.001)
		else:
			spawnNextEnemyTimer.start(enemyInfo[1])
		

func enemyDied(enemy):
	# Checking so we do not double remove enemies (e.g. if two shotgun bullets hit an enemy during the same frame)
	var enemyIndex = currentWaveEnemiesSpawned.find(enemy)
	if enemyIndex != -1:
		currentWaveEnemiesSpawned.remove_at(enemyIndex)
	# If we have no more alive ones and no more to spawn
	if (len(currentWaveEnemiesSpawned) == 0 && currentEnemyIndex == len(currentWaveEnemiesData)):
		spawnWave()

func _on_spawn_next_enemy_timer_timeout():
	spawnEnemy()

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
