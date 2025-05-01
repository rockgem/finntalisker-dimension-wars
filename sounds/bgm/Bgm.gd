extends Node


var current_playing

func _ready() -> void:
	change_bgm("BGM")



func change_bgm(bgm: String):
	if current_playing:
		current_playing.stop()
	
	var n = get_node(bgm)
	current_playing = n
	current_playing.play()


func stop_music():
	if current_playing:
		current_playing.stop()
