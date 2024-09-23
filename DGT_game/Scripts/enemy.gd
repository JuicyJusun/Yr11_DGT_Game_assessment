extends CharacterBody2D

# Constant variables
const ENEMY_BULLET_PRELOAD = preload("res://Scenes/enemy_bullet.tscn")
const MINION_PRELOAD = preload("res://Scenes/minion.tscn")
const FLYING_SPEED = 1.5

# Variables
var enemy_health = 250
var positions 
var minion_spawns
var minion_cycle = 0
var flight_cycle = 0
var flight_rng = RandomNumberGenerator.new()
var minion_spawn_rng = RandomNumberGenerator.new()
var random
var random_minion
var can_fire = false
var can_spawn = false
var is_alive

# Onready variables
@onready var enemy_bullet_spawn = $enemy_bullet_spawn
@onready var enemy_health_bar = $"../enemy_ui/enemy_healthbar"
@onready var animated_sprite = $animated_sprite
@onready var boss_defeated_screen = $"../death_screens/boss_defeated_screen"
@onready var retry_label = $"../death_screens/retry_label"
# Timer variables
@onready var minion_spawn_delay = $minion_spawn_delay
@onready var death_delay = $death_delay
@onready var bullet_delay = $bullet_delay
@onready var cycle_cooldown = $cycle_cooldown

#Exported variables
# Player variable
@export var fireball_player: Node2D
@export var minion_player: Node2D
# Flying cycles for the boss
@export var pos_1: Node2D
@export var pos_2: Node2D
@export var pos_3: Node2D
# Minion spawns
@export var minion_spawn_1: Node2D
@export var minion_spawn_2: Node2D
@export var minion_spawn_3: Node2D
@export var minion_spawn_4: Node2D

# Function for physics process. The code inside the function runs at a fixed rate.
# This allows for the boss to shoot fireballs, spawn minions and fly when it needs to.
func _physics_process(delta):
	# Boss movement code, Change flying speed to make boss move between nodes faster.
	# The boss changes it global position to the current flight position and smoothly flies over.
	global_position = global_position.lerp(positions[flight_cycle].global_position, delta * FLYING_SPEED)
	
	# Checks whether the enemy's health bar is changed or not every frame. 
	# If it is changed, it updates the value of the health bar.
	update_health()
	
	# Checks whether the enemy's health is less than or equal to 0. 
	# If the enemy loses all it's health and is still alive, 
	# it dies and sets the "is_alive" variable to false.
	if enemy_health <= 0 and is_alive:
		die()
		is_alive = false
	if enemy_health > 0:
		is_alive = true
		
	# Checks every frame whether it can spawn a minion or not.
	# If it can spawn a minion and is still alive, the enemy spawns a minion and starts a delay.
	if can_spawn and is_alive:
		spawn_minion()
		minion_spawn_delay.start() # Delay for minion spawns.
		can_spawn = false
	
	# Checks every frame whether it can shoot a fireball or not. 
	# If it can shoot a fireball and is still alive, the enemy shoots a fireball at the player.
	# and starts a delay.
	if can_fire and is_alive:
		shoot_fireball()
		bullet_delay.start() # Delay for shooting fireball.
		can_fire = false
	if Input.is_action_just_pressed("spawn_minion"):
		spawn_minion()
# Ready function. Runs immediately when the scene is loaded. 
func _ready():
	flight_rng.randomize() # Randomizes where it will fly to.
	positions = [pos_1, pos_2, pos_3]
	# Delays start at the start of the game to avoid the boss shooting immediately.
	minion_spawn_delay.start()
	bullet_delay.start()

# Code for flying to different positions. Makes sure the boss doesn't fly to the same position twice.
func _on_cycle_cooldown_timeout():
	random = flight_cycle
	while random == flight_cycle:
		random = flight_rng.randi_range(0, 2)
	flight_cycle = random
	cycle_cooldown.start()

# Minion spawn function.
func spawn_minion():
	# Randomizes where the minion spawns.
	minion_spawn_rng.randomize()
	minion_spawns = [minion_spawn_1, minion_spawn_2, minion_spawn_3, minion_spawn_4]
	random_minion = minion_cycle
	while random_minion == minion_cycle:
		random_minion = minion_spawn_rng.randi_range(0,3)
	minion_cycle = random_minion
	# Instantiates minion.
	var minion = MINION_PRELOAD.instantiate()
	get_parent().add_child(minion)
	minion.global_position = minion_spawns[minion_cycle].global_position
	minion.player = minion_player

# Function to shoot fireball.
func shoot_fireball(): 
		var enemy_bullet = ENEMY_BULLET_PRELOAD.instantiate()
		get_parent().add_child(enemy_bullet)
		enemy_bullet.global_position = enemy_bullet_spawn.global_position
		enemy_bullet.velo = (fireball_player.global_position - global_position).normalized()
		
# Updates health everytime enemy_health_bar is changed.
func update_health():
	enemy_health_bar.value = enemy_health
	
# Function for damage method 
func take_damage(amount):
	enemy_health -= amount

# Function for death.
func die():
	animated_sprite.play("death")
	death_delay.start()
	boss_defeated_screen.visible = true
	retry_label.visible = true

# Function to stop the game when boss is defeated.
func _on_death_delay_timeout():
	queue_free()
	Engine.time_scale = 0

# Delays for spawning minion and shooting fireball.
func _on_bullet_delay_timeout():
	can_fire = true
func _on_minion_spawn_delay_timeout():
	can_spawn = true
