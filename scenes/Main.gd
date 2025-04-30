extends Node2D


var eras = [
	'cyberpunk',
	'fantasy',
	'zombie',
]

var world_id = 'fantasy'
var troops = []

var money = 100
var wave = 1
var dimension_progress = 0.0
var portal_hp = 100.0

var player_spawn_position = Vector2(36, 204)


func _ready() -> void:
	ManagerGame.troop_clicked.connect(on_troop_clicked)
	
	ManagerGame.global_game_ref = self
	
	load_valid_troops()


func _physics_process(delta: float) -> void:
	$Portal/HP.value = portal_hp
	$UI/DimensionProgress.value = dimension_progress
	$UI/DimensionProgress/Percentage.text = '%0.01f%%' % dimension_progress


func load_valid_troops():
	var data = {}
	
	for troop in ManagerGame.areas_troops[world_id]:
		data[troop] = ManagerGame.all_entities_data[troop]
	
	$UI.load_troops_display(data)


func spawn_obj(instance, global_pos):
	instance.global_position = global_pos
	
	add_child(instance)


func spawn_enemy():
	var random_enemy = ManagerGame.areas_monsters[world_id].pick_random()
	var i = load('res://actors/entities/Troop.tscn').instantiate()
	i.data = ManagerGame.all_entities_data[random_enemy]
	i.set_as_enemy()
	
	spawn_obj(i, Vector2(600.0, player_spawn_position.y))


func on_troop_clicked(ref):
	var i = load('res://actors/entities/Troop.tscn').instantiate()
	i.is_player = true
	i.data = ref.data.duplicate()
	i.global_position = player_spawn_position
	
	add_child(i)
