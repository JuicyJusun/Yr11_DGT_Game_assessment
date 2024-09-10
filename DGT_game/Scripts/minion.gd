extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var minion_health_bar = $MinionHealth

var minion_health = 30

func take_damage(amount):
	minion_health -= amount
	
func die():
	animated_sprite.play("death")
	$DeathDelay.start()
	
func _on_death_delay_timeout():
	queue_free()

func update_health():
	minion_health_bar.value = minion_health

func _physics_process(delta):
	if minion_health < 0:
		minion_health = 0 
		die() 
	
	update_health()
		

