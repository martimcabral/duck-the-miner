extends Control

var window_mode = 0
var agachado = 0

func _ready() -> void:
	create_pricing_json()
	for button in get_tree().get_nodes_in_group("Buttons"):
		button.mouse_entered.connect(func(): _on_button_mouse_entered())
	
	var file_path = "user://game_settings.cfg"
	var config = ConfigFile.new()
	
	if FileAccess.file_exists(file_path):
		print("[game_settings.cfg] was detected successfully")
	else:
		print("[game_settings.cfg] not found. Creating a new one...")
		# Save the file
		var save_error = config.save(file_path)
		if save_error != OK:
			print("[ERROR] Could not save the configuration file: ", save_error)
		else:
			print("Configuration file created successfully.")
	
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
	
	var easter_egg_title = randi_range(1, 25)
	if easter_egg_title == 25:
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

func _on_button_mouse_entered() -> void:
	var mouse_sound = $MouseSoundEffects
	if mouse_sound:
		mouse_sound.stream = load("res://sounds/sound_effects/mining1.ogg")
		mouse_sound.pitch_scale = 1
		mouse_sound.play()

func create_pricing_json():
	var pricing_path = "user://pricing.cfg"
	if FileAccess.file_exists(pricing_path):
		print("Pricing File found successfully!")
	else:
		print("Pricing File not found! Creating a new one...")
		var pricing_file = ConfigFile.new()
		pricing_file.load(pricing_path)
		pricing_file.set_value("pricing", "Stone", 20)
		pricing_file.set_value("pricing", "Coal", 20)
		pricing_file.set_value("pricing", "Dense Ice", 20)
		pricing_file.set_value("pricing", "Graphite", 20)
		pricing_file.set_value("pricing", "Gypsum", 20)
		pricing_file.set_value("pricing", "Ice", 20)
		pricing_file.set_value("pricing", "Kaolinite", 20)
		pricing_file.set_value("pricing", "Lava Cluster", 20)
		pricing_file.set_value("pricing", "Oil Shale", 20)
		pricing_file.set_value("pricing", "Gold", 20)
		pricing_file.set_value("pricing", "Iron", 20)
		pricing_file.set_value("pricing", "Raw Bauxite", 20)
		pricing_file.set_value("pricing", "Raw Cobalt", 20)
		pricing_file.set_value("pricing", "Raw Copper", 20)
		pricing_file.set_value("pricing", "Raw Galena", 20)
		pricing_file.set_value("pricing", "Raw Magnetite", 20)
		pricing_file.set_value("pricing", "Raw Nickel", 20)
		pricing_file.set_value("pricing", "Raw Platinum", 20)
		pricing_file.set_value("pricing", "Raw Pyrolusite", 20)
		pricing_file.set_value("pricing", "Raw Scheelite", 20)
		pricing_file.set_value("pricing", "Raw Silver", 20)
		pricing_file.set_value("pricing", "Raw Uranium", 20)
		pricing_file.set_value("pricing", "Raw Wolframite", 20)
		pricing_file.set_value("pricing", "Raw Zirconium", 20)
		pricing_file.set_value("pricing", "Sandstone", 20)
		pricing_file.set_value("pricing", "Sulfur", 20)
		pricing_file.set_value("pricing", "Vanadinite", 20)
		pricing_file.set_value("pricing", "Amazonite", 20)
		pricing_file.set_value("pricing", "Ametrine", 20)
		pricing_file.set_value("pricing", "Apatite", 20)
		pricing_file.set_value("pricing", "Azurite", 20)
		pricing_file.set_value("pricing", "Bloodstone", 20)
		pricing_file.set_value("pricing", "Chalcedony", 20)
		pricing_file.set_value("pricing", "Charoite", 20)
		pricing_file.set_value("pricing", "Diamond", 20)
		pricing_file.set_value("pricing", "Emerald", 20)
		pricing_file.set_value("pricing", "Frozen Diamond", 20)
		pricing_file.set_value("pricing", "Garnet", 20)
		pricing_file.set_value("pricing", "Peridot", 20)
		pricing_file.set_value("pricing", "Ruby", 20)
		pricing_file.set_value("pricing", "Sapphire", 20)
		pricing_file.set_value("pricing", "Sugilite", 20)
		pricing_file.set_value("pricing", "Topaz", 20)
		pricing_file.set_value("pricing", "Tsavorite", 20)
		pricing_file.save(pricing_path)
