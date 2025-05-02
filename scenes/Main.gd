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

# this is used to scale enemies' hp and overall attack damage
# ( see spawn_enemy_wave() function )
var difficulty_scale = 1.0 

# an array where we can reference to every enemy in the scene
# over a certain period, this will get populated will null references so
# we need to clear this array everytime we spawn a new set of enemies ( see: spawn_enemy_wave() function )
var current_enemies_ref = []


func _ready() -> void:
	ManagerGame.troop_clicked.connect(on_troop_clicked)
	ManagerGame.portal_destroyed.connect(on_portal_destroyed)
	
	ManagerGame.global_game_ref = self
	
	# we change the textures of objects according to the era/theme we are on
	$Container/Background.texture = load(ManagerGame.areas_config[world_id]['background'])
	$Container/Tower.texture = load(ManagerGame.areas_config[world_id]['tower_sprite'])
	
	load_valid_troops()
	spawn_enemy_wave()


func _physics_process(delta: float) -> void:
	if portal_hp <= 0.0:
		ManagerGame.portal_destroyed.emit()
		return
	
	if dimension_progress >= 100.0:
		ManagerGame.dimension_finished.emit()
	
	$Container/Portal/HP.value = portal_hp
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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		$Container.position.x += event.relative.x
		
		if $Container.global_position.x < -93.0:
			$Container.global_position.x = -93.0
		if $Container.global_position.x > 0:
			$Container.global_position.x = 0.0


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


# loading only the available and troops on a certain era/theme
# ( see ManagerGame -> areas_troops[] )
func load_valid_troops():
	var data = {}
	
	for troop in ManagerGame.areas_troops[world_id]:
		data[troop] = ManagerGame.all_entities_data[troop]
	
	$UI.load_troops_display(data)


func spawn_obj(instance, global_pos):
	instance.global_position = global_pos
	
	$Container.add_child(instance)


func spawn_enemy():
	var random_enemy = ManagerGame.areas_monsters[world_id].pick_random()
	var i = load('res://actors/entities/Troop.tscn').instantiate()
	i.data = ManagerGame.all_entities_data[random_enemy].duplicate() # do not forget to duplicate() the data or else it will just modify the original one!
	i.set_as_enemy()
	
	spawn_obj(i, $Container/EnemySpawnPoint.global_position)


# this runs when the signal to spawn a hero is emitted
func on_troop_clicked(ref):
	var i = load('res://actors/entities/Troop.tscn').instantiate()
	i.is_player = true
	i.data = ref.data.duplicate() # do not forget to duplicate() the data or else it will just modify the original one!
	
	
	$Container.add_child(i)
	i.global_position = $Container/SpawnPoint.global_position


func on_portal_destroyed():
	var i = load('res://actors/ui/GameOverView.tscn').instantiate()
	
	ManagerGame.pop_to_ui.emit(i)


func _on_next_dimension_pressed() -> void:
	ManagerGame.current_world_idx += 1
	get_tree().change_scene_to_file('res://scenes/Main.tscn')
