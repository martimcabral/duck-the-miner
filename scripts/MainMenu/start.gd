extends Node2D

var window_mode = 0
var agachado = 0

func _ready() -> void:
	$CanvasLayer/Center/StartMenu.visible = true
	$CanvasLayer/Center/OptionsMenu.visible = false
	
	var random_player = randi_range(1, 2)
	match random_player:
		1:
			$CanvasLayer/Background.texture = ResourceLoader.load("res://assets/textures/main_menu_up.png")
		2:
			$CanvasLayer/Background.texture = ResourceLoader.load("res://assets/textures/main_menu_down.png")
	
	var random_side = randi_range(1, 2)
	if random_side == 1:
		$CanvasLayer/Background.flip_h = true
			
	var random_flip_y = randi_range(1, 100)
	if random_flip_y == 1:
		$CanvasLayer/Background.flip_v = true
	
	var easter_egg_title = randi_range(1, 20)
	if easter_egg_title == 20:
		$CanvasLayer/Center/Title.text = "Miner the Duck"

func _process(_delta: float) -> void:
	$CanvasLayer/Background.size = get_viewport_rect().size
	
	# Agachar no Menu
	if Input.is_action_just_pressed("Agachar"):
		if agachado == 0:
			agachado = 1
			$CanvasLayer/Background.texture = ResourceLoader.load("res://assets/textures/main_menu_down.png")
		elif agachado == 1:
			agachado = 0
			$CanvasLayer/Background.texture = ResourceLoader.load("res://assets/textures/main_menu_up.png")
	
	# Fullscreen
	if Input.is_action_just_pressed("Fullscreen"):
		if window_mode == 0:
			window_mode = 1
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif window_mode == 1:
			window_mode = 0
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
