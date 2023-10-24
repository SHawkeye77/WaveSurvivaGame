extends Node2D

var level = "res://screens/world.tscn"

func _on_play_button_pressed():
	# Reset any data
	Global.finalWave = -1
	var _level = get_tree().change_scene_to_file(level)

