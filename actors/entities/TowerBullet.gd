extends Node2D

var bullet_speed = 300.0
var direction



func _physics_process(delta: float) -> void:
	global_position += direction * bullet_speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	var body: Troop = area.get_parent()
	body.receive_damage()
	
	queue_free()
