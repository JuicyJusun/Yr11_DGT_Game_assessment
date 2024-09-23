extends Control

# Changes the scene to the game scene when the button is pressed
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

# Quits the game when the button is pressed
func _on_quit_pressed():
	get_tree().quit()

# Changes the scene to the how_to_play scene when the button is pressed
func _on_how_to_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")
	
