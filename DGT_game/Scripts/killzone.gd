extends Area2D

@onready var timer = $Timer

# Starts a timer when body enters the killzone
func _on_body_entered(_body):
	timer.start()

# Resets game when after certain amount of time after touching killzone
func _on_timer_timeout():
	get_tree().reload_current_scene()

