extends Sprite2D


var range = 200.0
var target: Troop = null

# these are used for attacking
# basically attack speed, this thing shoots every 1.0 second
var tick = 0.0
var tick_max = 1.0

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	
	# #######################################################
	var distance = 99999999
	var closest = null
	
	for enemy in ManagerGame.global_game_ref.current_enemies_ref:
		if is_instance_valid(enemy):
			if global_position.distance_to(enemy.global_position) < distance:
				distance = global_position.distance_to(enemy.global_position)
				closest = enemy
	
	if closest:
		# still check if the closest enemy is within range
		if global_position.distance_to(closest.global_position) < range:
			target = closest
	
	# #######################################################
	
	tick += delta
	
	# only shoot when target is not null
	if tick > tick_max and target:
		shoot()
		tick = 0.0


func shoot():
	var bullet = load('res://actors/entities/TowerBullet.tscn').instantiate()
	bullet.direction = global_position.direction_to(target.global_position)
	
	ManagerGame.global_game_ref.spawn_obj(bullet, global_position)
