extends CharacterBody2D

const BULLET = preload("res://Scenes/bullet.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -350.0

# Delay for being able to shoot bullets
var can_fire = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var timer = $BulletDelay
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var node_2d = $BulletSpawn

func _on_timer_timeout():
	can_fire = true

func shoot():
	if can_fire:
		var bullet = BULLET.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = $BulletSpawn.global_position
		bullet.velo = get_global_mouse_position() - bullet.position
		bullet.rotation_degrees = rotation_degrees
		can_fire = false
	
func _physics_process(delta):
	
	$BulletSpawn.look_at(get_global_mouse_position())
	
	# Shooting code
	if Input.is_action_just_pressed("shoot") and can_fire:
		shoot()
		timer.start()
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jumping code
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0: 
		animated_sprite_2d.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
		
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
