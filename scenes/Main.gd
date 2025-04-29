extends Node2D


var eras = [
	'cyberpunk',
	'fantasy',
	'zombie',
]

var world_id = 'fantasy'
var troops = []

var money = 100

var player_spawn_position = Vector2(36, 204)


func _ready() -> void:
	ManagerGame.troop_clicked.connect(on_troop_clicked)
	
	load_valid_troops()


func load_valid_troops():
	var data = {}
	
	for troop in ManagerGame.areas_troops[world_id]:
		data[troop] = ManagerGame.all_entities_data[troop]
	
	$UI.load_troops_display(data)


func spawn_obj(instance, global_pos):
	instance.global_position = global_pos
	
	add_child(instance)


func on_troop_clicked(ref):
	var i = load('res://actors/entities/Troop.tscn').instantiate()
	i.is_player = true
	i.data = ref.data.duplicate()
	i.global_position = player_spawn_position
	
	add_child(i)


func _on_enemy_spawn_timer_timeout() -> void:
	var random_enemy = ManagerGame.areas_monsters[world_id].pick_random()
	var i = load('res://actors/entities/Troop.tscn').instantiate()
	i.data = ManagerGame.all_entities_data[random_enemy]
	i.set_as_enemy()
	
	spawn_obj(i, Vector2(600.0, player_spawn_position.y))
