extends CharacterBody2D

var velo = Vector2.ZERO
var speed = 500 

func _physics_process(delta):
	var _collision_info = move_and_collide(velo.normalized() * delta * speed)
	update_rotation()
	
# Queue free if the projectile is out of the screen. Less lag in game.
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_damage_zone_body_entered(_body):
	queue_free()

func update_rotation():
	if velo.length_squared() > 0:
		rotation = velo.angle()
