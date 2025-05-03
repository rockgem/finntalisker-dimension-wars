extends Node


signal troop_clicked(ref)
signal new_wave_initiated
signal portal_destroyed
signal dimension_finished
signal pop_to_ui(instance)

signal fader_step_finished
signal fader_finished

var areas_config = {
	"fantasy": {
		"background": "res://art/fantasy/world/battleback10.png",
		"tower_sprite": "res://art/fantasy/objs/Sniper Tower.png"
	},
	"cyberpunk": {
		"background": "res://art/cyberpunk/world/battleback9.png",
		"tower_sprite": "res://art/fantasy/objs/Sniper Tower.png"
	},
}


var areas_troops = {
	"fantasy": ['peasant', 'warrior', 'hunter', 'swordsman', 'amazon'],
	"cyberpunk": ['punk', 'biker', 'cyborg', 'robo_cop', 'mech_vampire'],
}
var areas_monsters = {
	"fantasy": ['goblin', 'flying_demon', 'wolf'],
	"cyberpunk": ['rioter', 'flying_robot', 'robot']
}

var all_entities_data = {}

var current_world_idx = 0 # used in changing dimensions, keeps track of which dimension we are
var global_game_ref: Game = null

var fader_duration = 1.0

func _ready() -> void:
	pop_to_ui.connect(on_pop_to_ui)
	
	all_entities_data = get_data("res://reso/data/troops_data.json")


func fade():
	var mat = $CanvasLayer/Fader.get('material')
	var t = create_tween()
	t.step_finished.connect(on_step_finished)
	
	t.tween_property(mat, 'shader_parameter/progress', 1.0, fader_duration)
	t.tween_property(mat, 'shader_parameter/progress', 0.0, fader_duration)


func on_step_finished(idx):
	fader_step_finished.emit()


func get_data(path):
	var f = FileAccess.open(path, FileAccess.READ)
	var j = JSON.new()
	j.parse(f.get_as_text())
	
	return j.data


func on_pop_to_ui(instance):
	for child in $Popups.get_children():
		child.queue_free()
	
	$Popups.add_child(instance)
