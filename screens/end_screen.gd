extends Node2D

@onready var world = get_tree().get_first_node_in_group("world")
@onready var wavesSpawner = get_tree().get_first_node_in_group("WavesSpawner")
@onready var finalWaveDisplayLabel = get_node("%FinalWaveDisplayLabel")
@onready var finalCurrencyAmountLabel = get_node("%FinalCurrencyAmountLabel")
var startScreen = "res://screens/start_screen.tscn"

# Sounds
@onready var gameOver = get_node("%GameOver")

func _ready():
	finalCurrencyAmountLabel.text = "Final currency amount: " + str(Global.finalCurrencyAmount)
	# Game won
	if Global.finalWave == (Global.totalNumberWaves):
		finalWaveDisplayLabel.text = "You won! Final wave reached: " + str(Global.finalWave)
	# Game lost
	else:
		finalWaveDisplayLabel.text = "Final wave reached: " + str(Global.finalWave)
		gameOver.play()
	
func _on_main_menu_button_pressed():
	var _level = get_tree().change_scene_to_file(startScreen)
