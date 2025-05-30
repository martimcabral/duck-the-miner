extends Control

var window_mode = 0
var agachado = 0

var started_from_exe : int = 1
var username : String = ""

var date = Time.get_datetime_dict_from_system()
var month_number = date["month"]

var version_config := ConfigFile.new()
var version_path : String = str("user://version.cfg")

var tutorial_config := ConfigFile.new()
var tutorial_path : String = str("user://tutorial.cfg")

func _ready() -> void:
	print("[start.gd] Current Date Package: ", date)
	print("[start.gd] Current Month: ", date["month"])
	
	version_config.set_value("version", "current", str("release." + ProjectSettings.get_setting("application/config/version")))
	version_config.save(version_path)
	
	if not FileAccess.file_exists(tutorial_path):
		tutorial_config.set_value("tutorial", "done", false)
		tutorial_config.save(tutorial_path)
	
	match OS.get_name():
		"Windows": username = OS.get_environment("USERNAME")
		"Linux": username = OS.get_environment("USER")
	
	create_pricing_config()
	create_splashes_file()
	
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
			print("[start.cfg] error - Could not save the configuration file: ", save_error)
		else:
			print("[start.cfg] Configuration file created successfully.")
	
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
	if easter_egg_title == 1:
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
		"Sandstone": 60,
		"Gypsum": 175,
		"Kaolinite": 175,
		"Ice": 150,
		"Coal": 250,
		"Lava Cluster": 350,
		"Dense Ice": 450,
		"Sulfur": 625,
		"Biomass": 500,
		"Copper": 800,
		"Iron": 800,
		"Magnetite": 800,
		"Bauxite": 800,
		"Raw Galena": 800,
		"Raw Silver": 800,
		"Raw Pyrolusite": 800,
		"Raw Wolframite": 800,
		"Raw Nickel": 800,
		"Raw Platinum": 800,
		"Raw Uranium": 800,
		"Raw Cobalt": 800,
		"Raw Zirconium": 800,
		"Raw Scheelite": 800,
		"Pitchblende": 800,
		"Phosphorite": 800,
		"Hematite": 800,
		"Oil Shale": 850,
		"Graphite": 850,
		"Gold": 3600,
		"Emerald": 25000,
		"Diamond": 25000,
		"Ruby": 25000,
		"Sapphire": 25000,
		"Garnet": 25000,
		"Topaz": 25000,
		"Tsavorite": 25000,
		"Ametrine": 25000,
		"Apatite": 25000,
		"Azurite": 25000,
		"Charoite": 25000,
		"Sugilite": 25000,
		"Peridot": 25000,
		"Vanadinite": 25000,
		"Amazonite": 25000,
		"Bloodstone": 25000,
		"Chalcedony": 25000,
		"Chrysocolla": 25000,
		"Pietersite": 25000,
		"Labradorite": 25000,
		"Frozen Diamond": 37500,
		"Jeremejevite": 40000
	}
	
	for ore in prices:
		if not pricing_file.has_section_key("pricing", ore):
			pricing_file.set_value("pricing", ore, prices[ore])
			pricing_file.save(pricing_path)

func create_splashes_file():
	var splashes_text : Array = [ # NORMAIS
		"Dan the Duckling then Dan the Duck",
		"Dan the Duckling",
		"Dan the Duck",
		"Dan the Duck the Miner",
		"by Sr. Patinho",
		"by Duck the Dev",
		"Fyction loves you!",
		"Bill Industries is always hiring!",
		"100% Godot",
		"Here be Dragons!",
		"Fyction does not approve Ducks on planets!",
		"Why would you want to go to planets? There is absolutly nothing do to there.",
		"Closed source!",
		"Open source!",
		"Exclusive Fyction Offer: 3 minutes lunch break!",
		"Not on Steam!",
		"Duck the Splash Text",
		"Share it with your friends!",
		"https://sr-patinho.itch.io/duck-the-miner",
		"Also try Minecraft!",
		"Also try Deep Rock Galactic!",
		"Also try Satisfactory!",
		"Also try Phasmophobia!",
		"Also try Teardown!",
		"Also try Outer Wilds!",
		"Mining Away!",
		"print(chr(sum(range(ord(min(str(not)))))))",
		"Always with Rich Presence!",
		"Shenanigans!",
		"Lorem Ipsum",
		"Godot 4.4.1 + 1.2.3 = 5.6.4!",
		"/give @a ducks 64",
		"You've been ducked!",
		"F is for Fyction, not Flutter!",
		"This splash text is currently under construction!",
		"Welcome aboard captain. All systems online!",
		"Have you even learned anything useful from the Tutorial?",
		"ROCK AND STONE!"
	]
	
	# ESPECIAS
	splashes_text.append("Played by: " + username)
	match date["month"]:
		1: splashes_text.append("New year, same bugs. Time to blame the duck.")
		2: splashes_text.append("Love is in the air. So is confusion and merge conflicts.")
		3: splashes_text.append("March on, brave coder! Even if your code doesn’t compile.")
		4: splashes_text.append("Beware of April Fools... and that one semicolon that ruins everything.")
		5: splashes_text.append("Have you talked recently to your debugging duck?")
		6: splashes_text.append("Happy Pride Month! Be proud of your code, even the spaghetti parts.")
		7: splashes_text.append("Hot tip for July: Don’t grill your GPU.")
		8: splashes_text.append("August is hot. Stay cool, stay hydrated, debug with a duck.")
		9: splashes_text.append("Don't destroy yourself! Health Insurance is expensive!")
		10: splashes_text.append("October is spooky. So is your untested code.")
		11: splashes_text.append("Give thanks for version control. And ducks.")
		12: splashes_text.append("Perfect time to gift yourself a working build!")
	
	$GUI/Center/SplashTitleLabel.text = splashes_text[randi_range(0, splashes_text.size()-1)]

func _on_splash_construction_timer_timeout() -> void:
	if $GUI/Center/SplashTitleLabel.text == "This splash text is currently under construction!":
		$GUI/Center/SplashTitleLabel.text = "This splash text is now complete!"
