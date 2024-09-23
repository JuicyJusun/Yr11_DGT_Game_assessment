extends Control

# Changes the scene back to the menu scene when the back button is pressed
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# Changes the scene to the game scene when the play button is pressed
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
