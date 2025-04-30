extends Node2D


func _ready() -> void:
	scale = Vector2.ZERO
	
	var t = create_tween().set_parallel()
	t.tween_property(self, 'modulate:a', 0.0, 1.0).set_delay(4.0)
	t.tween_property(self, 'scale', Vector2.ONE, .4).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	await t.finished
	
	queue_free()
