extends CharacterBody2D

@onready var world = get_tree().get_first_node_in_group("world")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var coinBase = get_tree().get_first_node_in_group("loot")
@onready var wavesSpawner = get_tree().get_first_node_in_group("WavesSpawner")
@onready var remakePathTimer = get_node("%RemakePathTimer")
@onready var navAgent = $NavigationAgent2D
@onready var hitBox = $HitBox
var coin = preload("res://items/coin.tscn")
var hp = Global.ENEMY_3_STARTING_HP

func _ready():
	hitBox.damage = Global.ENEMY_3_DAMAGE
	remakePathTimer.wait_time = Global.ENEMY_COMPUTE_PATH_FREQUENCY
	makePath()

func _physics_process(delta):
	var dir = to_local(navAgent.get_next_path_position()).normalized()
	velocity = dir * Global.ENEMY_3_SPEED
	move_and_slide()

func makePath():
	# Setting where we want to get to 
	navAgent.target_position = player.global_position

func _on_hurt_box_hurt(damage):
	# Run when enemy's hurt box is triggered
	hp -= damage
	if hp <= 0:
		death()

func _on_remake_path_timer_timeout():
	makePath()

func death():
	world.playEnemyDeath()
	wavesSpawner.enemyDied()
	# Spawning the coin
	var newCoin = coin.instantiate()
	newCoin.global_position = global_position
	newCoin.coinValue = Global.ENEMY_3_COIN_VALUE
	coinBase.call_deferred("add_child", newCoin)
	queue_free()
