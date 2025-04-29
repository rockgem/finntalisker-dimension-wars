extends Node2D


func _ready() -> void:
	var t = create_tween().set_parallel()
	t.tween_property(self, 'global_position:y', global_position.y - 32.0, .2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(self, 'modulate:a', modulate.a, .2).set_delay(.5)
	t.tween_property(self, 'rotation_degrees', -20.0, .1)
	t.tween_property(self, 'rotation_degrees', 20.0, .1).set_delay(.1)
	t.tween_property(self, 'rotation_degrees', 0.0, .1).set_delay(.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	await t.finished
	
	queue_free()
