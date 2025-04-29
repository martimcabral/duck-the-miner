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
		print("[start.cfg] was detected successfully")
	else:
		print("[start.cfg] not found. Creating a new one...")
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
		print("[start.gd] Pricing File found successfully!")
	else:
		print("[start.gd] Pricing File not found! Creating a new one...")
		var pricing_file = ConfigFile.new()
		pricing_file.load(pricing_path)
		pricing_file.set_value("pricing", "Stone", 20)
		pricing_file.set_value("pricing", "Coal", 120)
		pricing_file.set_value("pricing", "Dense Ice", 350)
		pricing_file.set_value("pricing", "Graphite", 450)
		pricing_file.set_value("pricing", "Gypsum", 40)
		pricing_file.set_value("pricing", "Ice", 30)
		pricing_file.set_value("pricing", "Kaolinite", 40)
		pricing_file.set_value("pricing", "Lava Cluster", 250)
		pricing_file.set_value("pricing", "Oil Shale", 640)
		pricing_file.set_value("pricing", "Gold", 2600)
		pricing_file.set_value("pricing", "Iron", 400)
		pricing_file.set_value("pricing", "Raw Bauxite", 400)
		pricing_file.set_value("pricing", "Raw Cobalt", 400)
		pricing_file.set_value("pricing", "Raw Copper", 400)
		pricing_file.set_value("pricing", "Raw Galena", 400)
		pricing_file.set_value("pricing", "Raw Magnetite", 400)
		pricing_file.set_value("pricing", "Raw Nickel", 400)
		pricing_file.set_value("pricing", "Raw Platinum", 400)
		pricing_file.set_value("pricing", "Raw Pyrolusite", 400)
		pricing_file.set_value("pricing", "Raw Scheelite", 400)
		pricing_file.set_value("pricing", "Raw Silver", 400)
		pricing_file.set_value("pricing", "Raw Uranium", 400)
		pricing_file.set_value("pricing", "Raw Wolframite", 400)
		pricing_file.set_value("pricing", "Raw Zirconium", 400)
		pricing_file.set_value("pricing", "Sandstone", 22)
		pricing_file.set_value("pricing", "Sulfur", 425)
		pricing_file.set_value("pricing", "Vanadinite", 15000)
		pricing_file.set_value("pricing", "Amazonite", 15000)
		pricing_file.set_value("pricing", "Ametrine", 15000)
		pricing_file.set_value("pricing", "Apatite", 15000)
		pricing_file.set_value("pricing", "Azurite", 15000)
		pricing_file.set_value("pricing", "Bloodstone", 15000)
		pricing_file.set_value("pricing", "Chalcedony", 15000)
		pricing_file.set_value("pricing", "Charoite", 15000)
		pricing_file.set_value("pricing", "Diamond", 25000)
		pricing_file.set_value("pricing", "Emerald", 15000)
		pricing_file.set_value("pricing", "Frozen Diamond", 27500)
		pricing_file.set_value("pricing", "Garnet", 15000)
		pricing_file.set_value("pricing", "Peridot", 15000)
		pricing_file.set_value("pricing", "Ruby", 15000)
		pricing_file.set_value("pricing", "Sapphire", 15000)
		pricing_file.set_value("pricing", "Sugilite", 15000)
		pricing_file.set_value("pricing", "Topaz", 15000)
		pricing_file.set_value("pricing", "Tsavorite", 15000)
		pricing_file.set_value("pricing", "Biomass", 115)
		pricing_file.save(pricing_path)
