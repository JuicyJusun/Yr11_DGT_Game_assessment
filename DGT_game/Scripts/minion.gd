extends CharacterBody2D

const flying_speed = 50
const minion_instantiate = preload("res://Scenes/minion.tscn")

@onready var animated_sprite = $AnimatedSprite2D
@onready var minion_health_bar = $MinionHealth
@export var player: Node2D

var direction : Vector2
var is_alive = true
var minion_health = 30

func _physics_process(_delta):
	
	direction = (player.global_position - global_position).normalized()
	if direction.x < 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
	
	var velocity = (direction * flying_speed * _delta)
	move_and_collide(velocity)
	
	if minion_health <= 0 and is_alive:
		is_alive = false
		die() 
	
	# Updates health every frame
	update_health()

func take_damage(amount):
	minion_health -= amount
	
func die():
	animated_sprite.play("death")
	$DeathDelay.start()
	
func _on_death_delay_timeout():
	queue_free()

func update_health():
	minion_health_bar.value = minion_health
	
	

