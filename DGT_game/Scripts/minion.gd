extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var animation = $AnimatedSprite2D

var minion_health = 30

func take_damage(amount):
	minion_health -= amount
	print(minion_health)
