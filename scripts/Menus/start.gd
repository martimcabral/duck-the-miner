extends Node2D

var window_mode = 0
var agachado = 0

func _ready() -> void:
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.details = "🏘️ At the Main Menu"
		DiscordRPC.small_image = ""
		DiscordRPC.refresh()
	else:
		print("[start.gd] Discord isn't running or wasn't detected properly, skipping rich presence.")
		
	if ResourceLoader.exists("res://rcedit/game_dependency.png"):
		pass
	else:
		get_tree().quit()
	
	$GUI/Center/StartMenu.visible = true
	$GUI/Center/OptionsMenu.visible = false
	$GUI/Center/CreditsMenu.visible = false
	
	var random_player = randi_range(1, 2)
	match random_player:
		1:
			$GUI/Center/Background.texture = ResourceLoader.load("res://assets/textures/main_menu/main_menu_up.png")
		2:
			$GUI/Center/Background.texture = ResourceLoader.load("res://assets/textures/main_menu/main_menu_down.png")
	
	var random_side = randi_range(1, 2)
	if random_side == 1:
		$GUI/Center/Background.flip_h = true
			
	var random_flip_y = randi_range(1, 100)
	if random_flip_y == 1:
		$GUI/Center/Background.flip_v = true
	
	var easter_egg_title = randi_range(1, 20)
	if easter_egg_title == 20:
		$GUI/Center/Title.text = "Miner the Duck"

func _process(_delta: float) -> void:
	DiscordRPC.run_callbacks()
	
	$GUI/Center/Background.size = get_viewport_rect().size
	
	# Agachar no Menu
	if Input.is_action_just_pressed("Agachar"):
		if agachado == 0:
			agachado = 1
			$GUI/Center/Background.texture = ResourceLoader.load("res://assets/textures/main_menu/main_menu_down.png")
		elif agachado == 1:
			agachado = 0
			$GUI/Center/Background.texture = ResourceLoader.load("res://assets/textures/main_menu/main_menu_up.png")
	
	# Fullscreen
	if Input.is_action_just_pressed("Fullscreen"):
		if window_mode == 0:
			window_mode = 1
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif window_mode == 1:
			window_mode = 0
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
