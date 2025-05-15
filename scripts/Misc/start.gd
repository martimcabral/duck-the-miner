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

func create_pricing_json():
	var pricing_path = "user://pricing.cfg"
	if FileAccess.file_exists(pricing_path):
		print("[start.gd] Checking pricing file!")
		var pricing_file = ConfigFile.new()
		pricing_file.load(pricing_path)
		
		var prices = {
			"Stone": 50,
			"Coal": 250,
			"Dense Ice": 450,
			"Graphite": 850,
			"Gypsum": 175,
			"Kaolinite": 175,
			"Lava Cluster": 350,
			"Oil Shale": 850,
			"Gold": 3600,
			"Iron": 800,
			"Raw Bauxite": 800,
			"Raw Cobalt": 800,
			"Raw Copper": 800,
			"Raw Galena": 800,
			"Raw Magnetite": 800,
			"Raw Nickel": 800,
			"Raw Platinum": 800,
			"Raw Pyrolusite": 800,
			"Raw Scheelite": 800,
			"Raw Silver": 800,
			"Raw Uranium": 800,
			"Raw Wolframite": 800,
			"Raw Zirconium": 800,
			"Sandstone": 60,
			"Sulfur": 625,
			"Vanadinite": 25000,
			"Amazonite": 25000,
			"Ametrine": 25000,
			"Apatite": 25000,
			"Azurite": 25000,
			"Bloodstone": 25000,
			"Chalcedony": 25000,
			"Charoite": 25000,
			"Diamond": 25000,
			"Emerald": 25000,
			"Frozen Diamond": 37500,
			"Garnet": 25000,
			"Peridot": 25000,
			"Ruby": 25000,
			"Sapphire": 25000,
			"Sugilite": 25000,
			"Topaz": 25000,
			"Tsavorite": 25000,
			"Biomass": 500,
			"Ice": 150,
			"Chrysocolla": 25000,
			"Pietersite": 25000,
			"Labradorite": 25000,
			"Jeremejevite": 40000,
			"Pitchblende": 800,
			"Phosphorite": 800,
			"Hematite": 800,
		}
		
		for ore in prices:
			if not pricing_file.has_section_key("pricing", ore):
				pricing_file.set_value("pricing", ore, prices[ore])
				pricing_file.save(pricing_path)
