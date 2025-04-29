extends Node2D
class_name Troop

enum STATE{
	WALKING,
	ATTACKING
}

var data = {}
var is_player = true

var target_ref = null
var state: STATE = STATE.WALKING


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if data.is_empty():
		return
	
	match state:
		STATE.WALKING:
			global_position.x += data['move_speed'] * delta
		STATE.ATTACKING:
			pass


func get_closest():
	pass
