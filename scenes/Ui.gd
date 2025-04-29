extends CanvasLayer


func load_troops_display(troops_data: Dictionary):
	for child in $TroopDisplayBox.get_children():
		child.queue_free()
	
	for troop in troops_data:
		var i = load('res://actors/ui/TroopDisplay.tscn').instantiate()
		i.data = troops_data[troop]
		
		$TroopDisplayBox.add_child(i)
