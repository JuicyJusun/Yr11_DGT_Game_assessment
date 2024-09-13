extends CharacterBody2D

const player_bullet_preload = preload("res://Scenes/bullet.tscn")
const speed = 300.0
const jump_velocity = -350.0

# Delay for being able to shoot bullets
var can_fire = true
var health = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player_healthbar = $"../player_ui/player_healthbar"
@onready var timer = $bullet_delay
@onready var animated_sprite_2d = $animated_sprite_2d
@onready var bullet_spawn = $bullet_spawn

func _on_timer_timeout():
	can_fire = true

func shoot():
	if can_fire:
		var player_bullet = player_bullet_preload.instantiate()
		get_parent().add_child(player_bullet)
		player_bullet.global_position = bullet_spawn.global_position
		player_bullet.velo = (get_global_mouse_position() - player_bullet.position).normalized()
		can_fire = false
	
func _physics_process(delta):
	
	update_health()
	
	$bullet_spawn.look_at(get_global_mouse_position())
	
	# Shooting code
	if Input.is_action_just_pressed("shoot") and can_fire:
		shoot()
		timer.start()
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jumping code
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0: 
		animated_sprite_2d.flip_h = true
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
	if Input.is_action_just_pressed("stop_time"):
		Engine.time_scale = 0

func _ready():
	Engine.time_scale = 1 

func take_damage(amount):
	health -= amount
	print(health)

func update_health():
	player_healthbar.value = health
