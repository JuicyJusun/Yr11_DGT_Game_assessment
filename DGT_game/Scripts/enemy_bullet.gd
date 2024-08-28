extends CharacterBody2D

var velo = Vector2.ZERO
var speed = 250

@onready var sprite_2d = $Sprite2D



func _physics_process(delta):
	var _collision_info = move_and_collide(velo.normalized() * delta * speed)
   # Update rotation
#	if velo.length_squared() > 0:
#		var rotation_radians = velo.angle() 
#		var rotation_degrees = rad_to_deg(rotation_radians)
#		sprite_2d.rotation_degrees = rotation_degrees 
	update_rotation()

# Queue free if the projectile is out of the screen. Less lag in game.
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
	
func _on_damage_zone_body_entered(body):
	queue_free()
	
func update_rotation():
	if velo.length_squared() >0:
		sprite_2d.rotation = velo.angle()
