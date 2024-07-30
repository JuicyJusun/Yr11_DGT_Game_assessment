extends Area2D

@export var damage : float

func _on_body_entered(body):
	body.take_damage(damage)
