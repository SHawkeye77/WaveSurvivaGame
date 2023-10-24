extends CharacterBody2D

@onready var world = get_tree().get_first_node_in_group("world")
@onready var sprite = $Sprite2D
@onready var healthBar = get_node("%HealthBar")

var inMysteryBoxRange = false
var inFireRateIncreaseBoxRange = false
var inBulletAmountIncreaseBoxRange = false
var hp = Global.PLAYER_STARTING_HP
var money = 0
var fireRateIndex = 0
var bulletAmountIndex = 0

func _ready():
	healthBar.value = Global.PLAYER_STARTING_HP
	healthBar.max_value = Global.PLAYER_STARTING_HP

func _physics_process(delta):
	movement()

# Move our character
func movement():
	# Calculates movement based on user input
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	
	# Flipping sprite based on left/right movement
	if mov.x > 0:
		sprite.flip_h = false
	elif mov.x < 0:
		sprite.flip_h = true
	
	# Moving the player
	velocity = mov.normalized() * Global.MOVEMENT_SPEED
	move_and_slide()

	# Clamping the position to the screen
	if position.x < 0:
		position.x = 0
	if position.x > get_viewport_rect().size.x:
		position.x = get_viewport_rect().size.x
	if position.y > get_viewport_rect().size.y:
		position.y = get_viewport_rect().size.y
	if position.y < 0:
		position.y = 0

func _input(event):
	# Interact
	if Input.is_action_just_released("interact"):
		# Ensure we are not waiting to get a purchased gun
		if get_tree().get_first_node_in_group("gun") != null:
			world.playInteract()
			if inMysteryBoxRange:  
				interactWithMysteryBox()
			if inFireRateIncreaseBoxRange:
				interactWithFireRateIncreaseBox()
			if inBulletAmountIncreaseBoxRange:
				interactWithBulletAmountIncreaseBox()

func _on_interaction_range_body_entered(body):
	if body.has_method("iAmMysteryBox"):
		inMysteryBoxRange = true
	if body.has_method("iAmFireRateIncreaseBox"):
		inFireRateIncreaseBoxRange = true
	if body.has_method("iAmBulletAmountIncreaseBox"):
		inBulletAmountIncreaseBoxRange = true

func _on_interaction_range_body_exited(body):
	if body.has_method("iAmMysteryBox"):
		inMysteryBoxRange = false
	if body.has_method("iAmFireRateIncreaseBox"):
		inFireRateIncreaseBoxRange = false
	if body.has_method("iAmBulletAmountIncreaseBox"):
		inBulletAmountIncreaseBoxRange = false

func _on_hurt_box_hurt(damage):
	hp -= damage
	healthBar.value = hp
	world.playHurt()
	if hp <= 0:
		death()

func death():
	world.endGame()

func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var moneyCollected = area.collect()
		money += moneyCollected
		world.updateUI()

func interactWithMysteryBox():
	if money < Global.MYSTERY_BOX_PRICE:
		var notificationMessage = "Need " + str(Global.MYSTERY_BOX_PRICE) + " coins to activate the mystery box!"
		world.notifyPlayer(notificationMessage)
	else:
		world.offerMysteryBox()
		
func interactWithFireRateIncreaseBox():
	if money < Global.FIRE_RATE_INCREASE_BOX_PRICE:
		var notificationMessage = "Need " + str(Global.FIRE_RATE_INCREASE_BOX_PRICE) + " coins to upgrade your fire rate!"
		world.notifyPlayer(notificationMessage)
	elif fireRateIndex >= len(Global.SHOTGUN_BULLET_WAIT_TIME) - 1:  # Arbitrarily checking the shotgun
		var notificationMessage = "Fire rate already at max level!"
		world.notifyPlayer(notificationMessage)
	else:
		world.offerFireRateIncreaseBox()

func interactWithBulletAmountIncreaseBox():
	if money < Global.BULLET_AMOUNT_INCREASE_BOX_PRICE:
		var notificationMessage = "Need " + str(Global.BULLET_AMOUNT_INCREASE_BOX_PRICE) + " coins to upgrade your bullet amount!"
		world.notifyPlayer(notificationMessage)
	elif bulletAmountIndex >= len(Global.SHOTGUN_BULLETS) - 1:  # Arbitrarily checking the shotgun
		var notificationMessage = "Bullet amount already at max level!"
		world.notifyPlayer(notificationMessage)
	else:
		world.offerBulletAmountIncreaseBox()
