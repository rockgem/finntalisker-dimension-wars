extends Node


signal troop_clicked(ref)
signal new_wave_initiated
signal portal_destroyed
signal dimension_finished
signal pop_to_ui(instance)


var areas_troops = {
	"fantasy": ['peasant', 'warrior', 'hunter', 'swordsman', 'amazon']
}
var areas_monsters = {
	"fantasy": ['goblin', 'flying_demon', 'wolf']
}

var all_entities_data = {}

var global_game_ref: Game = null


func _ready() -> void:
	pop_to_ui.connect(on_pop_to_ui)
	
	all_entities_data = get_data("res://reso/data/troops_data.json")


func get_data(path):
	var f = FileAccess.open(path, FileAccess.READ)
	var j = JSON.new()
	j.parse(f.get_as_text())
	
	return j.data


func on_pop_to_ui(instance):
	for child in $Popups.get_children():
		child.queue_free()
	
	$Popups.add_child(instance)
