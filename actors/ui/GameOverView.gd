extends Control



func _ready() -> void:
	get_tree().paused = true


func _on_main_menu_pressed() -> void:
	ManagerGame.fade()
	await ManagerGame.fader_step_finished
	
	get_tree().change_scene_to_file('res://scenes/Menu.tscn')
	
	queue_free()


func _on_retry_pressed() -> void:
	ManagerGame.fade()
	await ManagerGame.fader_step_finished
	
	get_tree().change_scene_to_file('res://scenes/Main.tscn')
	
	queue_free()


func _on_tree_exiting() -> void:
	get_tree().paused = false
