extends CharacterBody2D

# Variables
var velo = Vector2.ZERO
var speed = 200

# Physics_process function. Runs the code inside the function every frame.
func _physics_process(delta):
	var _collision_info = move_and_collide(velo.normalized() * delta * speed)
	update_rotation()
	
# Queue free if the projectile is out of the screen. Less lag in game.
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
	
# Makes the bullet disappear when it comes into contact with the player.
func _on_damage_zone_body_entered(_body):
	queue_free()

# Makes the bullet face the direction its heading.
func update_rotation():
	if velo.length_squared() > 0:
		rotation = velo.angle()

