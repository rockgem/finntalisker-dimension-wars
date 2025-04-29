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

var direction = Vector2.RIGHT

func _ready() -> void:
	if data.is_empty():
		return
	
	$AnimatedSprite2D.sprite_frames = load(data['sprite_frame'])
	$RayCast2D.target_position.x = data['range']


func _physics_process(delta: float) -> void:
	if data.is_empty():
		return
	
	if target_ref and is_instance_valid(target_ref):
		
		
		return
	
	match state:
		STATE.WALKING:
			global_position.x += data['move_speed'] * direction.x * delta
			$AnimatedSprite2D.play("run")
		STATE.ATTACKING:
			$AnimatedSprite2D.play("attack")
		STATE.IDLE:
			$AnimatedSprite2D.play("idle")


func get_closest():
	pass


func set_as_enemy():
	is_player = false
	$AnimatedSprite2D.flip_h = true
	direction = Vector2.LEFT
	
	$RayCast2D.collision_mask = 8
	$Area2D.collision_layer = 16
