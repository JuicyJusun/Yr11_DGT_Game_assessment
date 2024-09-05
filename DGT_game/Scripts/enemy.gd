extends CharacterBody2D

const ENEMY_BULLET = preload("res://Scenes/enemy_bullet.tscn")
const flying_speed = 1.5

var enemy_health = 250

@onready var player = get_parent().find_child("Player")  # Adjust the path according to your node hierarchy
@onready var enemy_bullet_spawn = $Enemy_Bullet_Spawn
@export var pos_1: Node2D
@export var pos_2: Node2D
@export var pos_3: Node2D
var positions
var cycle = 0
var rng = RandomNumberGenerator.new()
var random

func _on_cycle_cooldown_timeout():
	random = cycle
	while random == cycle:
		random = rng.randi_range(0, 2)
	cycle = random
	$"Cycle Cooldown".start()
	
	
func _ready():
	rng.randomize()
	positions = [pos_1, pos_2, pos_3]

func _physics_process(delta):
	global_position = global_position.lerp(positions[cycle].global_position, delta * flying_speed)
	update_health()

func take_damage(amount):
	enemy_health -= amount

func shoot_fireball():
	var enemy_bullet = ENEMY_BULLET.instantiate()
	get_parent().add_child(enemy_bullet)
	enemy_bullet.global_position = $Enemy_Bullet_Spawn.global_position
	enemy_bullet.velo = (player.global_position - global_position)

# Updates health everytime enemy_health_bar is changed
func update_health():
	var enemy_health_bar = $"../Enemy_health"
	enemy_health_bar.value = enemy_health
