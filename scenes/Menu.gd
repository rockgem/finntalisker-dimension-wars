extends Control


func _ready() -> void:
	get_tree().paused = false
	ManagerGame.current_world_idx = 0


func _on_play_pressed() -> void:
	ManagerGame.fade()
	await ManagerGame.fader_step_finished
	
	get_tree().change_scene_to_file('res://scenes/Main.tscn')
