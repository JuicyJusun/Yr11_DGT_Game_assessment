extends CharacterBody2D

const ENEMY_BULLET = preload("res://Scenes/enemy_bullet.tscn")
const flying_speed = 1.5

var enemy_health = 250

@onready var enemy_bullet_spawn = $Enemy_Bullet_Spawn
@export var pos_1: Node2D
@export var pos_2: Node2D
@export var pos_3: Node2D
@export var player: Node2D
var positions
var cycle = 0
var flight_rng = RandomNumberGenerator.new()
var attack_rng = RandomNumberGenerator.new()
var random
var can_fire = true

func _on_cycle_cooldown_timeout():
	random = cycle
	while random == cycle:
		random = flight_rng.randi_range(0, 2)
	cycle = random
	$"Cycle Cooldown".start()


func _on_bullet_delay_timeout():
	can_fire = true
	
func _ready():
	flight_rng.randomize()
	attack_rng.randomize()
	positions = [pos_1, pos_2, pos_3]

# Physics process function
func _physics_process(delta):
	# Boss movement code, Change flying speed to make boss move between nodes faster.
	global_position = global_position.lerp(positions[cycle].global_position, delta * flying_speed)
#	if cycle == 0:
#		shoot_fireball()
	# Updates health every frame
	update_health()
		

# Function for damage method 
func take_damage(amount):
	enemy_health -= amount

# Function to shoot fireball
func shoot_fireball(): 
	if can_fire:
		var enemy_bullet = ENEMY_BULLET.instantiate()
		get_parent().add_child(enemy_bullet)
		enemy_bullet.global_position = $Enemy_Bullet_Spawn.global_position
		enemy_bullet.velo = (player.global_position - global_position).normalized()
		can_fire = false
		

# Updates health everytime enemy_health_bar is changed
func update_health():
	var enemy_health_bar = $"../Enemy_health"
	enemy_health_bar.value = enemy_health
