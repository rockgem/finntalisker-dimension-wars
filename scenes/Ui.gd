extends CanvasLayer


func _ready() -> void:
	ManagerGame.new_wave_initiated.connect(on_new_wave_initiated)


func _physics_process(delta: float) -> void:
	$DimensionProgress/NextDimension.visible = true if ManagerGame.global_game_ref.dimension_progress >= 100.0 else false


func load_troops_display(troops_data: Dictionary):
	for child in $TroopDisplayBox.get_children():
		child.queue_free()
	
	for troop in troops_data:
		var i = load('res://actors/ui/TroopDisplay.tscn').instantiate()
		i.data = troops_data[troop]
		
		$TroopDisplayBox.add_child(i)


func on_new_wave_initiated():
	var i = load('res://actors/etc/NewWaveWarning.tscn').instantiate()
	i.position.x = get_viewport().get_visible_rect().size.x / 2
	i.position.y = get_viewport().get_visible_rect().size.y / 2 - 32.0
	
	add_child(i)
