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
	
	attack_tick_max = data['attack_speed']
	
	$AnimatedSprite2D.sprite_frames = load(data['sprite_frame'])
	
	if is_player:
		$RayCast2D.target_position.x = data['range']
	else:
		data['hp'] *= ManagerGame.global_game_ref.difficulty_scale
		data['attack'] *= ManagerGame.global_game_ref.difficulty_scale
		$RayCast2D.target_position.x = -data['range']


func _physics_process(delta: float) -> void:
	if data.is_empty():
		return
	
	if $RayCast2D.is_colliding():
		if is_instance_valid($RayCast2D.get_collider()):
			target_ref = $RayCast2D.get_collider().get_parent()
		else:
			target_ref = null
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
			
			if is_player:
				if global_position.x > get_viewport().get_visible_rect().size.x:
					queue_free()
			else:
				if global_position.x < ManagerGame.global_game_ref.player_spawn_position.x:
					ManagerGame.global_game_ref.portal_hp -= 5
					queue_free()
		STATE.ATTACKING:
			# we don't execute anything in this block when we are in "attack" animation
			# weird shit happens if this check does not exists
			if $AnimatedSprite2D.animation == 'attack':
				return
			
			$AnimatedSprite2D.play("idle")
			attack_tick += delta
			
			if attack_tick >= attack_tick_max:
				attack_tick = 0.0
				$AnimatedSprite2D.play("attack")
				
				await $AnimatedSprite2D.animation_finished
				
				if is_instance_valid(target_ref):
					target_ref.receive_damage(data['attack'])
				$AnimatedSprite2D.play("idle")
		STATE.IDLE:
			$AnimatedSprite2D.play("idle")


func receive_damage(damage = 1):
	var df = load('res://actors/etc/DamageFloater.tscn').instantiate()
	df.get_node('Label').text = '%s' % int(damage)
	
	add_child(df)
	
	data['hp'] -= damage
	print(data['hp'])
	
	if data['hp'] <= 0:
		death()


#func attack():
	#if target_ref == null or is_instance_valid(target_ref) == false:
		#return
	#
	#


func death():
	set_physics_process(false)
	$AnimatedSprite2D.play('death')
	
	await $AnimatedSprite2D.animation_finished
	
	queue_free()


func get_closest():
	pass


func set_as_enemy():
	is_player = false
	$AnimatedSprite2D.flip_h = true
	direction = Vector2.LEFT
	
	$RayCast2D.collision_mask = 8
	$Area2D.collision_layer = 16
