extends Panel


var data = {}


func _ready() -> void:
	if data.is_empty() == false:
		$Cooldown.text = '%0.01f' % data['cooldown']


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and !event.pressed:
		ManagerGame.troop_clicked.emit(self)
