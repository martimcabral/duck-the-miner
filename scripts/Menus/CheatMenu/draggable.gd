extends Control

var drag_offset = Vector2()
var dragging = false

signal drag_started
signal drag_stopped

func _ready():
	position = Vector2(960, 600)

func _input(event):
	if Input.is_action_just_pressed("Cheat_Menu"):
		match get_tree().current_scene.name:
			"AsteroidSelector": 
				$Container/WorldLabel/GiveItems.disabled = true
				$Container/WorldLabel/ChangePosition.disabled = true
				$Container/WorldLabel/ChangeOxygen.disabled = true
				$Container/WorldLabel/ChangeHealth.disabled = true
				$Container/WorldLabel/ChangeUVBattery.disabled = true
				$Container/WorldLabel/DuckTheDeath.disabled = true
			"World":
				$Container/LobbyLabel/GiveItem.disabled = true
				$Container/LobbyLabel/ChangeDay.disabled = true
				$Container/LobbyLabel/ChangeMoney.disabled = true
				$Container/LobbyLabel/AdvanceStockMartket.disabled = true
				$Container/LobbyLabel/RerollMissions.disabled = true
		
		if visible == true:
			visible = false
		elif visible == false:
			visible = true
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if get_rect().has_point(event.position):
					dragging = true
					drag_offset = position - event.position
					emit_signal("drag_started")  # Emit the drag started signal
			else:
				dragging = false
				emit_signal("drag_stopped")  # Emit the drag stopped signal
	elif event is InputEventMouseMotion and dragging:
		position = event.position + drag_offset
