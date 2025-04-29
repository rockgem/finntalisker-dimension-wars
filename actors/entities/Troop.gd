extends Node2D
class_name Troop

enum STATE{
	WALKING,
	ATTACKING
}


var is_player = true

var target_ref = null
var state: STATE = STATE.WALKING


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func get_closest():
	pass
