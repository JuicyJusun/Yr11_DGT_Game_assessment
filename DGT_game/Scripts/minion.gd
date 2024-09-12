extends CharacterBody2D

const flying_speed = 50

@onready var animated_sprite = $AnimatedSprite2D
@onready var minion_health_bar = $MinionHealth
@onready var minion_raycast = $MinionRaycast
@export var player: Node2D

var direction : Vector2
var is_alive = true
var minion_health = 30

func _physics_process(delta):
	
	minion_raycast.target_position = player.global_position
	
	direction = ((player.global_position - global_position)*delta).normalized()
	if direction.x <= 0:
		scale.x = 0.6
	elif direction.x > 0:
		scale.x = -0.6
	
	var velo = (direction * flying_speed * delta)
	self.global_position += velo
	
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
	
	

