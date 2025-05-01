extends Node


func play_sound(sound_name: String):
	get_node(sound_name).play()
