extends CharacterBody2D

var enemy_health = 250

func _physics_process(delta):
	update_health()
	
	
	
func take_damage(amount):
	enemy_health -= amount
	print(enemy_health)


# Updates health everytime enemy_health_bar is changed
func update_health():
	var enemy_health_bar = $"../Enemy_health"
	enemy_health_bar.value = enemy_health

	
