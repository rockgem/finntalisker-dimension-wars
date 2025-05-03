extends Control


func _ready() -> void:
	get_tree().paused = true


func _on_resume_pressed() -> void:
	get_tree().paused = false
	
	queue_free()


func _on_main_menu_pressed() -> void:
	ManagerGame.fade()
	
	await ManagerGame.fader_step_finished
	
	get_tree().change_scene_to_file('res://scenes/Menu.tscn')
	
	get_tree().paused = false
	queue_free()
