extends Node2D
class_name Game


var eras = [
	'fantasy',
	'cyberpunk',
	'zombie',
]

@onready var world_id = eras[ManagerGame.current_world_idx]
var troops = []

var dimension_progress = 0.0
var portal_hp = 100.0

var player_spawn_position = Vector2(36, 204)
var enemy_spawn_count_min = 3
var enemy_spawn_count_max = 4
var wave = 0
var wave_max = 10

# this is used to scale enemies' hp and overall attack damage
# ( see spawn_enemy_wave() function )
var difficulty_scale = 1.0 

var current_enemies_ref = []


func _ready() -> void:
	ManagerGame.troop_clicked.connect(on_troop_clicked)
	ManagerGame.portal_destroyed.connect(on_portal_destroyed)
	
	ManagerGame.global_game_ref = self
	
	load_valid_troops()
	spawn_enemy_wave()


func _physics_process(delta: float) -> void:
	if portal_hp <= 0.0:
		ManagerGame.portal_destroyed.emit()
		return
	
	if dimension_progress >= 100.0:
		ManagerGame.dimension_finished.emit()
	
	$Portal/HP.value = portal_hp
	$UI/DimensionProgress.value = dimension_progress
	$UI/DimensionProgress/Percentage.text = '%0.01f%%' % dimension_progress
	$UI/DimensionProgress/Wave.text = 'Wave %s' % int(wave)
	
	# constantly check if all enemies are cleared
	if dimension_progress < 100:
		var has_active = false
		for enemy in current_enemies_ref:
			if is_instance_valid(enemy):
				has_active = true
				break
		
		if has_active == false:
			current_enemies_ref.clear()
			spawn_enemy_wave()


func spawn_enemy_wave():
	print('New Wave Initiated!')
	ManagerGame.new_wave_initiated.emit()
	
	wave += 1
	enemy_spawn_count_max += 1
	difficulty_scale += 0.1
	
	for i in randi_range(enemy_spawn_count_min, enemy_spawn_count_max):
		spawn_enemy()
	
	for e in get_tree().get_nodes_in_group("Troop"):
		if e.is_player == false:
			current_enemies_ref.append(e)


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
	i.data = ManagerGame.all_entities_data[random_enemy].duplicate()
	i.set_as_enemy()
	
	spawn_obj(i, Vector2(randf_range(600.0, 700.0), player_spawn_position.y))


func on_troop_clicked(ref):
	var i = load('res://actors/entities/Troop.tscn').instantiate()
	i.is_player = true
	i.data = ref.data.duplicate()
	i.global_position = player_spawn_position
	
	add_child(i)


func on_portal_destroyed():
	var i = load('res://actors/ui/GameOverView.tscn').instantiate()
	
	ManagerGame.pop_to_ui.emit(i)


func _on_next_dimension_pressed() -> void:
	ManagerGame.current_world_idx += 1
	get_tree().change_scene_to_file('res://scenes/Main.tscn')
