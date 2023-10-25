extends Node2D

@onready var mysteryBoxWaitTimer = get_node("%MysteryBoxWaitTimer")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var wavesSpawner = get_tree().get_first_node_in_group("WavesSpawner")
@onready var labelMoney = get_node("%LabelMoney")
@onready var labelWave = get_node("%LabelWave")
@onready var panelNotification = get_node("%PanelNotification")
@onready var labelNotification = get_node("%LabelNotification")
# Mystery box
@onready var panelOfferMysteryBox = get_node("%PanelOfferMysteryBox")
@onready var labelOfferMysteryBox = get_node("%LabelOfferMysteryBox")
# Fire rate increase box
@onready var panelOfferFireRateIncreaseBox = get_node("%PanelOfferFireRateIncreaseBox")
@onready var labelOfferFireRateIncreaseBox = get_node("%LabelOfferFireRateIncreaseBox")
# Bullet amout increase box
@onready var panelOfferBulletAmountIncreaseBox = get_node("%PanelBulletAmountIncreaseBox")
@onready var labelOfferBulletAmountIncreaseBox = get_node("%LabelBulletAmountIncreaseBox")
# Sounds
@onready var coinCollect = get_node("%CoinCollect")
@onready var enemyDeath = get_node("%EnemyDeath")
@onready var equipGun = get_node("%EquipGun")
@onready var gunShot = get_node("%GunShot")
@onready var hurt = get_node("%Hurt")
@onready var interact = get_node("%Interact")
@onready var mysteryBox = get_node("%MysteryBox")
@onready var newWave = get_node("%NewWave")
@onready var upgrade1 = get_node("%Upgrade1")
@onready var upgrade2 = get_node("%Upgrade2")

var endScreen = "res://screens/end_screen.tscn"

func _ready():
	mysteryBoxWaitTimer.wait_time = Global.MYSTERY_BOX_WAIT_TIME
	labelOfferMysteryBox.text = "Purchase a mystery gun for " + str(Global.MYSTERY_BOX_PRICE) + " credits?"
	labelOfferFireRateIncreaseBox.text = "Upgrade your fire rate for " + str(Global.FIRE_RATE_INCREASE_BOX_PRICE) + " credits?"
	labelOfferBulletAmountIncreaseBox.text = "Upgrade your bullet amount for " + str(Global.BULLET_AMOUNT_INCREASE_BOX_PRICE) + " credits?"
	updateUI()

func updateUI():
	labelMoney.text = "$" + str(player.money)
	labelWave.text = "Wave " + str(wavesSpawner.currentWaveIndex)

func notifyPlayer(notificationText):
	panelNotification.visible = true
	labelNotification.text = notificationText
	# Pausing the game
	get_tree().paused = true
	
# Offering the player the mystery box
func offerMysteryBox():
	panelOfferMysteryBox.visible = true
	get_tree().paused = true

# Offering the fire rate increase box to the player
func offerFireRateIncreaseBox():
	panelOfferFireRateIncreaseBox.visible = true
	get_tree().paused = true

# Offering the bullet amount increase box to the player
func offerBulletAmountIncreaseBox():
	panelOfferBulletAmountIncreaseBox.visible = true
	get_tree().paused = true

func _on_button_cancel_mystery_box_pressed():
	panelOfferMysteryBox.visible = false
	get_tree().paused = false

func _on_acknowledge_notification_button_pressed():
	panelNotification.visible = false
	get_tree().paused = false


func _on_button_cancel_fire_rate_increase_box_pressed():
	panelOfferFireRateIncreaseBox.visible = false
	get_tree().paused = false


func _on_button_cancel_bullet_amount_increase_box_pressed():
	panelOfferBulletAmountIncreaseBox.visible = false
	get_tree().paused = false

func _on_button_buy_mystery_box_pressed():
	panelOfferMysteryBox.visible = false
	player.money -= Global.MYSTERY_BOX_PRICE
	updateUI()
	# Getting rid of the current gun
	get_tree().get_first_node_in_group("gun").queue_free()
	mysteryBoxWaitTimer.start()
	playMysteryBox()
	get_tree().paused = false

func _on_mystery_box_wait_timer_timeout():
	# Selecting a random gun
	var randomGun = Global.GUNS[randi() % Global.GUNS.size()]
	# Spawning the random gun
	player.add_child(randomGun.instantiate())
	playEquipGun()

func _on_button_buy_fire_rate_increase_box_pressed():
	panelOfferFireRateIncreaseBox.visible = false
	player.money -= Global.FIRE_RATE_INCREASE_BOX_PRICE
	updateUI()
	player.fireRateIndex += 1
	get_tree().get_first_node_in_group("gun").updateWeaponStats()
	playUpgrade1()
	get_tree().paused = false


func _on_button_buy_bullet_amount_increase_box_pressed():
	panelOfferBulletAmountIncreaseBox.visible = false
	player.money -= Global.BULLET_AMOUNT_INCREASE_BOX_PRICE
	updateUI()
	player.bulletAmountIndex += 1
	get_tree().get_first_node_in_group("gun").updateWeaponStats()
	playUpgrade2()
	get_tree().paused = false

func endGame():
	# Setting up end screen data
	Global.finalWave = wavesSpawner.currentWaveIndex
	Global.finalCurrencyAmount = player.money
	Global.totalNumberWaves = len(wavesSpawner.WAVES)
	# Loading the end game screen
	var _level = get_tree().change_scene_to_file(endScreen)
	
# Sounds
func playCoinCollect():
	coinCollect.play()
func playEnemyDeath():
	enemyDeath.play()
func playEquipGun():
	equipGun.play()
func playGunShot():
	gunShot.play()
func playHurt():
	hurt.play()
func playInteract():
	interact.play()
func playMysteryBox():
	mysteryBox.play()
func playUpgrade1():
	upgrade1.play()
func playUpgrade2():
	upgrade2.play()
func playNewWave():
	newWave.play()


func _on_start_game_timer_timeout():
	wavesSpawner.spawnWave()
