extends Control

var window_mode = 0
var agachado = 0

var started_from_exe : int = 1
var username : String = ""

func _ready() -> void:
	match OS.get_name():
		"Windows": username = OS.get_environment("USERNAME")
		"Linux": username = OS.get_environment("USER")
	create_pricing_config()
	create_splashes_file()
	
	var file = FileAccess.open("user://splashes.txt", FileAccess.READ)
	var lines = []
	while not file.eof_reached():
		lines.append(file.get_line().strip_edges())
	file.close()
	if lines.size() > 0:
		$GUI/Center/SplashTitleLabel.text = lines[randi() % lines.size()]
	
	match started_from_exe:
		0: %FadeInStart.play("RESET")
		1: %FadeInStart.play("start")
	
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
			$GUI/Center/Background.texture = ResourceLoader.load("res://assets/textures/menus/main_menu_up.png")
		2:
			$GUI/Center/Background.texture = ResourceLoader.load("res://assets/textures/menus/main_menu_down.png")
	
	var random_side = randi_range(1, 2)
	if random_side == 1:
		$GUI/Center/Background.flip_h = true
			
	var random_flip_y = randi_range(1, 25)
	if random_flip_y == 1:
		$GUI/Center/Background.flip_v = true
	
	var easter_egg_title = randi_range(1, 100)
	if easter_egg_title == 25:
		$GUI/Center/Title.text = "Miner the Duck"

func _process(_delta: float) -> void:
	DiscordRPC.run_callbacks()
	
	$GUI/Center/Background.size = get_viewport_rect().size
	
	# Agachar no Menu
	if Input.is_action_just_pressed("Agachar"):
		if agachado == 0:
			agachado = 1
			$GUI/Center/Background.texture = ResourceLoader.load("res://assets/textures/menus/main_menu_down.png")
		elif agachado == 1:
			agachado = 0
			$GUI/Center/Background.texture = ResourceLoader.load("res://assets/textures/menus/main_menu_up.png")
	
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
		mouse_sound.stream = load("res://sounds/effects/mining/mining1.ogg")
		mouse_sound.pitch_scale = 1
		mouse_sound.play()

func create_pricing_config():
	var pricing_path = "user://pricing.cfg"
	var pricing_file = ConfigFile.new()
	
	pricing_file.load(pricing_path)
	var prices = {
		"Stone": 50,
		"Coal": 250,
		"Copper": 800,
		"Iron": 800,
		"Gold": 3600,
		"Emerald": 25000,
		"Diamond": 25000,
		"Ruby": 25000,
		"Sapphire": 25000,
		"Magnetite": 800,
		"Bauxite": 800,
		"Garnet": 25000,
		"Topaz": 25000,
		"Tsavorite": 25000,
		"Dense Ice": 450,
		"Lava Cluster": 350,
		"Ametrine": 25000,
		"Apatite": 25000,
		"Azurite": 25000,
		"Frozen Diamond": 37500,
		"Raw Galena": 800,
		"Raw Silver": 800,
		"Raw Pyrolusite": 800,
		"Raw Wolframite": 800,
		"Raw Nickel": 800,
		"Raw Platinum": 800,
		"Raw Uranium": 800,
		"Raw Cobalt": 800,
		"Raw Zirconium": 800,
		"Sulfur": 625,
		"Graphite": 850,
		"Charoite": 25000,
		"Sugilite": 25000,
		"Peridot": 25000,
		"Sandstone": 60,
		"Gypsum": 175,
		"Kaolinite": 175,
		"Raw Scheelite": 800,
		"Vanadinite": 25000,
		"Oil Shale": 850,
		"Amazonite": 25000,
		"Bloodstone": 25000,
		"Chalcedony": 25000,
		"Biomass": 500,
		"Ice": 150,
		"Chrysocolla": 25000,
		"Pietersite": 25000,
		"Labradorite": 25000,
		"Jeremejevite": 40000,
		"Pitchblende": 800,
		"Phosphorite": 800,
		"Hematite": 800
	}
	
	for ore in prices:
		if not pricing_file.has_section_key("pricing", ore):
			pricing_file.set_value("pricing", ore, prices[ore])
			pricing_file.save(pricing_path)

func create_splashes_file():
	var splashes_file = FileAccess.open("user://splashes.txt", FileAccess.WRITE)
	var splashes_text : String = ""
	splashes_text += "Dan the Duck\n"
	splashes_text += "Dan the Duck the Miner\n"
	splashes_text += "by Sr. Patinho\n"
	splashes_text += "by Duck the Dev\n"
	splashes_text += "Fyction loves you!\n"
	splashes_text += "Bill Industries is always hiring!\n"
	splashes_text += "100% Godot\n"
	splashes_text += "Here be Dragons!\n"
	splashes_text += "Keyboard compatible!\n"
	splashes_text += "Fyction does not approve Ducks on planets!\n"
	splashes_text += "Closed source!\n"
	splashes_text += "Open source!\n"
	splashes_text += "Exclusive Fyction Offer: 5 minutes lunch break!\n"
	splashes_text += "Not on Steam!\n"
	splashes_text += "Duck the Game\n"
	splashes_text += "Tell your friends!\n"
	splashes_text += "https://sr-patinho.itch.io/duck-the-miner\n"
	splashes_text += "Also try Terraria\n"
	splashes_text += "Also try Minecraft\n"
	splashes_text += "Also try Roblox\n"
	splashes_text += "Also try Deep Rock Galactic\n"
	splashes_text += "Also try Satisfactory\n"
	splashes_text += "Also try Phasmophobia\n"
	splashes_text += "Also try Teardown\n"
	splashes_text += "Also try Outer Wilds\n"
	splashes_text += "Mining Away!\n"
	splashes_text += "print(chr(sum(range(ord(min(str(not)))))))\n"
	splashes_text += "Always with Rich Presence!\n"
	splashes_text += "Shenanigans!\n"
	splashes_text += "Lorem Ipsum\n"
	splashes_text += "Godot 4.4.1 + 1.2.3 = 5.6.4!\n"
	splashes_text += "/give @a ducks 64\n"
	splashes_text += "Rule #1: it's never my fault\n"
	splashes_text += "You've been ducked! 🦆\n"
	splashes_text += "duck.exe\n"
	splashes_text += str("Played by: ", username, "\n")
	splashes_text += "F is for Fyction, not Flutter!"
	
	splashes_file.store_string(splashes_text)
	splashes_file.close()
