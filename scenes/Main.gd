extends Node2D


var eras = [
	'cyberpunk',
	'fantasy',
	'zombie',
]

var world_id = 'fantasy'
var troops = []

var money = 100



func _ready() -> void:
	load_valid_troops()


func load_valid_troops():
	var data = {}
	
	for troop in ManagerGame.areas_monsters[world_id]:
		data[troop] = ManagerGame.all_entities_data[troop]
	
	$UI.load_troops_display(data)
