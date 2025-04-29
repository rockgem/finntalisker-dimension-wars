extends Node


signal troop_clicked(ref)


var areas_monsters = {
	"fantasy": ['peasant', 'warrior', 'hunter', 'swordsman', 'amazon']
}

var all_entities_data = {}


func _ready() -> void:
	all_entities_data = get_data("res://reso/data/troops_data.json")


func get_data(path):
	var f = FileAccess.open(path, FileAccess.READ)
	var j = JSON.new()
	j.parse(f.get_as_text())
	
	return j.data
