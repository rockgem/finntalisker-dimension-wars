extends Node2D
class_name Troop

enum STATE{
	WALKING,
	ATTACKING,
	IDLE
}

var data = {}
var is_player = true

var target_ref: Troop = null
var state: STATE = STATE.WALKING

var direction = Vector2.RIGHT

var attack_tick = 0.0
var attack_tick_max = 0.0


func _ready() -> void:
	if data.is_empty():
		return
	
	$AnimatedSprite2D.sprite_frames = load(data['sprite_frame'])
	
	if is_player:
		$RayCast2D.target_position.x = data['range']
	else:
		$RayCast2D.target_position.x = -data['range']


func _physics_process(delta: float) -> void:
	if data.is_empty():
		return
	
	if $RayCast2D.is_colliding():
		target_ref = $RayCast2D.get_collider().get_parent()
	else:
		target_ref = null
	
	if target_ref and is_instance_valid(target_ref):
		state = STATE.ATTACKING
	else:
		state = STATE.WALKING
	
	match state:
		STATE.WALKING:
			global_position.x += data['move_speed'] * direction.x * delta
			$AnimatedSprite2D.play("run")
		STATE.ATTACKING:
			attack_tick += delta
			
			if attack_tick >= attack_tick_max:
				$AnimatedSprite2D.play("attack")
				await $AnimatedSprite2D.animation_finished
				target_ref.receive_damage(data['attack'])
				
				attack_tick = 0.0
			
			$AnimatedSprite2D.play("idle")
		STATE.IDLE:
			$AnimatedSprite2D.play("idle")


func receive_damage(damage = 1):
	pass


func attack():
	if target_ref == null or is_instance_valid(target_ref) == false:
		return
	
	


func get_closest():
	pass


func set_as_enemy():
	is_player = false
	$AnimatedSprite2D.flip_h = true
	direction = Vector2.LEFT
	
	$RayCast2D.collision_mask = 8
	$Area2D.collision_layer = 16
