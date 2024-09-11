extends CharacterBody2D

const enemy_bullet_preload = preload("res://Scenes/enemy_bullet.tscn")
const minion_preload = preload("res://Scenes/minion.tscn")
const flying_speed = 1.5

var enemy_health = 250

@onready var enemy_bullet_spawn = $Enemy_Bullet_Spawn
@onready var enemy_health_bar = $"../Enemy_health"

# Player variable
@export var player: Node2D

# Flying cycles for the boss
@export var pos_1: Node2D
@export var pos_2: Node2D
@export var pos_3: Node2D

# Minion spawns
@export var minion_spawn_1: Node2D
@export var minion_spawn_2: Node2D
@export var minion_spawn_3: Node2D
@export var minion_spawn_4: Node2D

var positions 
var minion_spawns
var minion_cycle = 0
var flight_cycle = 0
var flight_rng = RandomNumberGenerator.new()
var attack_rng = RandomNumberGenerator.new()
var minion_spawn_rng = RandomNumberGenerator.new()
var random
var random_minion
var can_fire = true
var can_spawn = true

func _on_cycle_cooldown_timeout():
	random = flight_cycle
	while random == flight_cycle:
		random = flight_rng.randi_range(0, 2)
	flight_cycle = random
	$"Cycle Cooldown".start()


func _on_bullet_delay_timeout():
	can_fire = true
	
func _ready():
	flight_rng.randomize()
	attack_rng.randomize()
	attack_rng.randi_range(0,1)
	positions = [pos_1, pos_2, pos_3]

# Physics process function
func _physics_process(delta):
	# Boss movement code, Change flying speed to make boss move between nodes faster.
	global_position = global_position.lerp(positions[flight_cycle].global_position, delta * flying_speed)
	
	if Input.is_action_just_pressed("ui_accept"):
		shoot_fireball()
		$"Bullet Delay".start()
	# Updates health every frame
	update_health()
	if Input.is_action_just_pressed("spawn_minion_test"):
		spawn_minion()
	
func spawn_minion():
	minion_spawn_rng.randomize()
	minion_spawns = [minion_spawn_1, minion_spawn_2, minion_spawn_3, minion_spawn_4]
	random_minion = minion_cycle
	while random_minion == minion_cycle:
		random_minion = minion_spawn_rng.randi_range(0,3)
	minion_cycle = random_minion
	if can_spawn:
		var minion = minion_preload.instantiate()
		get_parent().add_child(minion)
		minion.global_position = minion_spawns[minion_cycle].global_position
		minion.player = player
		
# Function to shoot fireball
func shoot_fireball(): 
	if can_fire:
		var enemy_bullet = enemy_bullet_preload.instantiate()
		get_parent().add_child(enemy_bullet)
		enemy_bullet.global_position = $Enemy_Bullet_Spawn.global_position
		enemy_bullet.velo = (player.global_position - global_position).normalized()
		can_fire = false
		
# Updates health everytime enemy_health_bar is changed
func update_health():
	enemy_health_bar.value = enemy_health
	
# Function for damage method 
func take_damage(amount):
	enemy_health -= amount
