extends Node2D
class_name Troop

enum STATE{
	WALKING,
	ATTACKING,
	IDLE
}

var data = {}
var is_player = true

var target_ref = null
var state: STATE = STATE.WALKING


func _ready() -> void:
	if data.is_empty():
		return
	
	$AnimatedSprite2D.sprite_frames = load(data['sprite_frame'])


func _physics_process(delta: float) -> void:
	if data.is_empty():
		return
	
	match state:
		STATE.WALKING:
			global_position.x += data['move_speed'] * delta
			$AnimatedSprite2D.play("run")
		STATE.ATTACKING:
			$AnimatedSprite2D.play("attack")
		STATE.IDLE:
			$AnimatedSprite2D.play("idle")


func get_closest():
	pass
