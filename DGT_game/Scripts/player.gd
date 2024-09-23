extends CharacterBody2D

# Constant variables
const PLAYER_BULLET_PRELOAD = preload("res://Scenes/bullet.tscn")
const SPEED = 250.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_fire = true
var health = 50

# Onready variables. 
@onready var player_died_screen = $"../death_screens/player_died_screen"
@onready var player_healthbar = $"../player_ui/player_healthbar"
@onready var retry_label = $"../death_screens/retry_label"
@onready var timer = $bullet_delay
@onready var animated_sprite_2d = $animated_sprite_2d
@onready var bullet_spawn = $bullet_spawn

# Function for physics process. The code inside the function runs at a fixed rate.
# Input commands and gravity is put in here as it checks for these inputs or changes every frame.
func _physics_process(delta):
	
	# Dying function. If the player's health is below or is equal to 0 
	# then the game's time stops and the player's "You died" screen becomes visible.
	if health <= 0:
		Engine.time_scale = 0
		player_died_screen.visible = true
		retry_label.visible = true
	
	# Updates the player's health bar every frame so it matches the health.
	update_health()
	
	# Bullet direction. Makes the "Bullet spawn" node look at the users mouse cursor.
	bullet_spawn.look_at(get_global_mouse_position())
	
	# Shooting code. Checks whether the "shoot" input was pressed and the "can_fire" conditions 
	# are met then shoots a bullet and starts a delay.
	if Input.is_action_just_pressed("shoot") and can_fire:
		shoot()
		timer.start()
	
	# Gravity. If the player is not on the floor then the game multiplies gravity and delta 
	# and changes the y velocity for as long as the player falls. 
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jumping code. Checks whether the input "jump" was pressed and if the player is on the floor.
	# If both conditions are met, the game changes the player's y velocity to the jump velocity.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Changes the player's sprite to match the direction he is facing.
	var direction = Input.get_axis("move_left", "move_right")
	# If the direction is bigger than 1 meaning the player is moving right. 
	if direction > 0:
		animated_sprite_2d.flip_h = false # It doesn't flip the sprite as it is already facing right.
	# If the direction is smaller than 1 meaning the player is moving left.
	elif direction < 0: 
		animated_sprite_2d.flip_h = true # Flips the player's sprite to look left.
	
	# Code that moves the player in the direction he's heading in.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

# Checks whether the player pressed the escape button and changes the scene back to the menu.
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# Checks if the player pressed the retry button and reloads the scene if the player did.
	if Input.is_action_just_pressed("retry"):
		get_tree().reload_current_scene()
	
# Ready function. Runs the code inside the function immediately when the scene is loaded.
func _ready():
	Engine.time_scale = 1 # Sets the game's time to normal when the scene is loaded.
	
# Delay for being able to shoot bullets. If the timer ends the can_fire 
# variable is set to true allowing the player to the again.
func _on_timer_timeout():
	can_fire = true

# Function for shooting a bullet. If the can_fire variable is equal to true then 
# the game adds a bullet and makes the bullet move towards the mouse position. 
# then sets the can_fire variable to false.
func shoot():
	if can_fire:
		var player_bullet = PLAYER_BULLET_PRELOAD.instantiate()
		get_parent().add_child(player_bullet)
		player_bullet.global_position = bullet_spawn.global_position
		player_bullet.velo = (get_global_mouse_position() - player_bullet.position).normalized()
		can_fire = false

# Function to update health bar. Sets the progress bar's value to the player's health.
func update_health():
	player_healthbar.value = health

# Function for damage. Subtracts the amount of damage from the health.
func take_damage(amount):
	health -= amount
