extends Area2D

@onready var world = get_tree().get_first_node_in_group("world")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@export var coinValue = 1
var coin1 = preload("res://art/coin1.png")
var coin2 = preload("res://art/coin2.png")
var coin3 = preload("res://art/coin3.png")
var target = null
var speed = -1

func _ready():
	# Setting appropriate sprite
	if coinValue == Global.ENEMY_1_COIN_VALUE:
		sprite.texture = coin1
	elif coinValue == Global.ENEMY_2_COIN_VALUE:
		sprite.texture = coin2
	elif coinValue == Global.ENEMY_3_COIN_VALUE:
		sprite.texture = coin3
	else:
		print("ERROR - Unexpected coin value")

func _physics_process(delta):
	# Movement happens when gem is assigned a target (nearby player)
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2 * delta

func collect():
	# Called when the gem gets really close to player
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	world.playCoinCollect()
	queue_free()
	return coinValue
