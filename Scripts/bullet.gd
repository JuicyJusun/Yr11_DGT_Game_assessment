extends CharacterBody2D

var velo = Vector2(1,0)
var speed = 500 
var can_fire = true
@onready var sprite_2d = $Sprite2D



func _physics_process(delta):
	var collision_info = move_and_collide(velo.normalized() * delta * speed)
   # Update rotation
	if velo.length_squared() > 0:
		var rotation_radians = velo.angle()
		var rotation_degrees = rad_to_deg(rotation_radians)
		sprite_2d.rotation_degrees = rotation_degrees


