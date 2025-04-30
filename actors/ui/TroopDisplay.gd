extends Panel


var data = {}

var is_cooldown = false


func _ready() -> void:
	if data.is_empty() == false:
		$Cooldown.text = '%0.01f' % data['cooldown']
		
		$AnimatedSprite2D.sprite_frames = load(data['sprite_frame'])
		$Timer.wait_time = data['cooldown']


func _physics_process(delta: float) -> void:
	if is_cooldown:
		modulate = Color('ffffff6b')
		$Cooldown.visible = true
		$Cooldown.text = '%0.01f' % $Timer.time_left
	else:
		modulate = Color.WHITE
		$Cooldown.visible = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and !event.pressed:
		if is_cooldown:
			print('cant click troop is on cooldown')
			return
		
		$Timer.start()
		is_cooldown = true
		ManagerGame.troop_clicked.emit(self)


func _on_timer_timeout() -> void:
	is_cooldown = false
