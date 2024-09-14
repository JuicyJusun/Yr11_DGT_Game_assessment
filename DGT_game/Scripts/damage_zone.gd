extends Area2D

#Exported damage variable
@export var damage : float = 10

# Make bodies with the function "take_damage" take damage when projectile enters its own body.
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
