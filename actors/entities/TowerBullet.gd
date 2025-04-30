extends Node2D

var bullet_speed = 300.0
var direction



func _physics_process(delta: float) -> void:
	global_position += direction * bullet_speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	# we get the actual body or the troop entity
	# when the bullet touches the enemies' area
	var body: Troop = area.get_parent()
	body.receive_damage() # received damage is by default "1" change anyway you like
	
	queue_free()
