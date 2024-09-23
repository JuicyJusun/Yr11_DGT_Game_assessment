extends CharacterBody2D

# Constant variables.
const FLYING_SPEED = 60

# Variables.
var direction : Vector2
var is_alive = true
var minion_health = 30
var minion_distance_from_player
var is_attacking = false

# Onready variables.
@onready var death_delay = $death_delay
@onready var attack_delay = $attack_delay
@onready var animated_sprite = $animated_sprite
@onready var minion_healthbar = $minion_healthbar
@onready var attack_range_collider = $damage_zone/attack_range_collider
@onready var animation_player = $animation_player
@export var player: Node2D

# Physics_process function. Runs the code inside the function every frame.
func _physics_process(delta):
	
	# Calculates how far the minion is from the player every frame.
	minion_distance_from_player = (global_position - player.global_position).length_squared()
	
	# Calculates which direction the player is to the minion.
	direction = (player.global_position - global_position).normalized()
	# If the player is standing on the right of the minion then it doesn't flip the minion's character.
	if direction.x <= 0:
		scale.x = 0.6
		minion_healthbar.fill_mode = minion_healthbar.FILL_BEGIN_TO_END
	# If the player is on the left of the minion, then the minion changes to look at the 
	# player and the health bar stays constant.
	elif direction.x > 0:
		scale.x = -0.6
		minion_healthbar.fill_mode = minion_healthbar.FILL_END_TO_BEGIN
	
	# If the minion is close enough to the player and is still alive.
	if minion_distance_from_player < 800 and is_alive:
		is_attacking = true # is_attacking is set to true.
		animation_player.play("attack") # Plays the attack animation to quickly enable and disable the collision box.
		animated_sprite.play("attack") # Plays the attack 
		attack_delay.start() # Starts the delay for attacks.
	
	# If the minion is not close enough to the player and is not attacking.
	elif minion_distance_from_player > 800 and is_alive and is_attacking == false:
		var velo = (direction * FLYING_SPEED * delta) # Adds a velocity variable.
		self.global_position += velo # Changes its global position to the velocity.
		animated_sprite.play("flying") # Plays the flying animation.
		
	# Minion dies if health is lower or equal to 0.
	if minion_health <= 0 and is_alive:
		is_alive = false # is_alive variable is set to false.
		die() # Dies.
	
	# Updates health every frame.
	update_health()

# Ready function. Runs the code inside the function as soon as the scene is loaded.
func _ready():
	attack_range_collider.disabled = true # Disables the attack_collider.
	
# take_damage function. Subtracts the amount of damage dealt with the minion's current health.
func take_damage(amount):
	minion_health -= amount

# Function for dying.
func die():
	animated_sprite.play("death") # Plays death animation.
	death_delay.start() # Death delay starts.
	
# Sets the minion's health bar to the same value as the minion's health.
func update_health():
	minion_healthbar.value = minion_health

# Sets the is_attacking variable to false when the attack animation is finished.
func _on_attack_delay_timeout():
	is_attacking = false
	
# Makes the minion disappear after the death animation is finished.
func _on_death_delay_timeout():
	queue_free()
