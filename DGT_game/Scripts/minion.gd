extends CharacterBody2D

const flying_speed = 60

@onready var death_delay = $death_delay
@onready var attack_delay = $attack_delay
@onready var animated_sprite = $animated_sprite
@onready var minion_healthbar = $minion_healthbar
@onready var attack_range_collider = $damage_zone/attack_range_collider
@onready var animation_player = $animation_player
@export var player: Node2D

var direction : Vector2
var is_alive = true
var minion_health = 30
var minion_distance_from_player
var is_attacking = false

func _ready():
	attack_range_collider.disabled = true

func _physics_process(delta):
	
	minion_distance_from_player = (global_position - player.global_position).length_squared()
	
	direction = ((player.global_position - global_position)*delta).normalized()
	if direction.x <= 0:
		scale.x = 0.6
	elif direction.x > 0:
		scale.x = -0.6
		
	if minion_distance_from_player < 800 and is_alive:
		is_attacking = true
		animation_player.play("attack")
		animated_sprite.play("attack")
		attack_delay.start()
		
	elif minion_distance_from_player > 800 and is_alive and is_attacking == false:
		var velo = (direction * flying_speed * delta)
		self.global_position += velo
		animated_sprite.play("flying")

	if minion_health <= 0 and is_alive:
		is_alive = false
		die() 
	
	# Updates health every frame
	update_health()

func take_damage(amount):
	minion_health -= amount
	
func die():
	animated_sprite.play("death")
	death_delay.start()
	
func update_health():
	minion_healthbar.value = minion_health

func _on_attack_delay_timeout():
	is_attacking = false
	
func _on_death_delay_timeout():
	queue_free()
