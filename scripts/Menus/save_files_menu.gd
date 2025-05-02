extends Panel

var saves_number : int = 1
var selected_save : int = 0

var saves_path = "user://save/"
var savedir

var saves_config = ConfigFile.new()
var getmoney_config = ConfigFile.new()
var raw_inv_config = ConfigFile.new()
var crafted_inv_config = ConfigFile.new()
var money_config = ConfigFile.new()
var skin_config = ConfigFile.new()
var day_config = ConfigFile.new()
var difficulty_config = ConfigFile.new()
var cheating_config = ConfigFile.new()
var stock_config = ConfigFile.new()
var player_config = ConfigFile.new()

var normal_stylebox = StyleBoxFlat.new()
var focus_stylebox = StyleBoxFlat.new()
var hover_stylebox = StyleBoxFlat.new()

var choosen_difficulty : String = "normal"
var choosen_cheating : bool = false
var choosen_intro : bool = true

func _ready() -> void:
	$SaveScreationPanel.visible = false
	# Check if the save directory exists, if not, create it
	if not DirAccess.dir_exists_absolute(saves_path):
		print("[save] Directory not found. Creating directory: ", saves_path)
		DirAccess.make_dir_absolute(saves_path)
		savedir = DirAccess.open("user://save")
	else: 
		savedir = DirAccess.open("user://save")
	
	var config_path = saves_path + "saves.cfg"
	# Check if the saves configuration file exists
	if not FileAccess.file_exists(config_path):
		print("[save/saves.cfg] not found. Creating a new one....")
		saves_config.set_value("saves", "ammount", 0)
		saves_config.set_value("saves", "selected", 0)
		saves_config.save(config_path)
	else:
		print("[save/saves.cfg] detected successfully")
		saves_number = savedir.get_files().size()
		saves_config.set_value("saves", "ammount", saves_number)
		saves_config.save(config_path)
		print("[save_files_menu.gd] Number of Save Folders: ", saves_number)
	get_save_files()

func get_save_files():
	var directories = DirAccess.get_directories_at(saves_path)
	for i in range(0, 100):
		if directories.has(str(i)):
			var SaveButton = Button.new()
			var getday_file = ConfigFile.new()
			
			# Load the day config file from the user data save directory
			getday_file.load(saves_path + str(i) + "/day.cfg")
			var current_day = str(getday_file.get_value("day", "current", "what"))
			
			# Load the money config file from the user data save directory
			getmoney_config.load(saves_path + str(i) + "/money.cfg")
			var current_money = str(getmoney_config.get_value("money", "current", 0))
			
			# Format money with spaces
			var number_str = str(current_money)
			var formatted_number = ""
			var counter = 0
			for x in range(number_str.length() - 1, -1, -1):
				formatted_number = number_str[x] + formatted_number
				counter += 1
				if counter % 3 == 0 and x != 0:
					formatted_number = " " + formatted_number
			SaveButton.text = "Save " + str(i) + " ─ " + str(formatted_number) + " € ─ Day: " + current_day 
			
			# Create and apply styleboxes
			create_styleboxes()
			SaveButton.add_theme_stylebox_override("normal", normal_stylebox)
			SaveButton.add_theme_stylebox_override("focus", focus_stylebox)
			SaveButton.add_theme_stylebox_override("hover", hover_stylebox)
			SaveButton.add_theme_color_override("font_color", Color.WHITE)
			SaveButton.add_theme_font_size_override("font_size", 48)
			SaveButton.set_meta("save", i)
			SaveButton.pressed.connect(func(): set_selected_save(SaveButton))
			SaveButton.mouse_entered.connect(func(): _on_button_mouse_entered())
			$ScrollContainer/SaveList.add_child(SaveButton)
			SaveButton.add_to_group("Buttons")

func _on_verify_files_timeout() -> void:
	saves_number = savedir.get_directories().size()
	saves_config.set_value("saves", "ammount", saves_number)
	saves_config.save(saves_path)

func _on_back_button_pressed() -> void:
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/back.ogg")
	$"../../../MouseSoundEffects".play()
	$"../StartMenu".visible = true
	$".".visible = false

func _on_creator_button_pressed() -> void:
	$SaveScreationPanel.visible = false
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/play.ogg")
	$"../../../MouseSoundEffects".pitch_scale = 1.25
	$"../../../MouseSoundEffects".play()
	
	# Create SaveGame Button
	saves_number += 1
	var SaveButton = Button.new()
	SaveButton.text = "Save " + str(saves_number) + " - New"
	SaveButton.add_theme_color_override("font_color", Color.WHITE)
	SaveButton.add_theme_font_size_override("font_size", 48)
	
	create_styleboxes()
	
	SaveButton.add_theme_stylebox_override("normal", normal_stylebox)
	SaveButton.add_theme_stylebox_override("focus", focus_stylebox)
	SaveButton.add_theme_stylebox_override("hover", hover_stylebox)
	SaveButton.set_meta("save", saves_number)
	SaveButton.pressed.connect(func(): set_selected_save(SaveButton))
	SaveButton.mouse_entered.connect(func(): _on_button_mouse_entered())
	$ScrollContainer/SaveList.add_child(SaveButton)
	SaveButton.add_to_group("Buttons")
	
	# Create the actual file
	DirAccess.make_dir_absolute("user://save/" + str(saves_number))
	
	################################################################################
	
	var raw_inv_path = str(saves_path + str(saves_number) + "/inventory_resources.cfg")
	raw_inv_config.set_value("inventory", "new_file", null)
	raw_inv_config.save(raw_inv_path)
	
	var crafted_inv_path = str(saves_path + str(saves_number) + "/inventory_crafted.cfg")
	crafted_inv_config.set_value("inventory", "new_file", null)
	crafted_inv_config.save(crafted_inv_path)

	################################################################################
	
	var money_path = str(saves_path + str(saves_number) + "/money.cfg")
	
	var new_money = int(randf_range(-95_000_000, -98_999_999))
	money_config.set_value("money", "start", new_money)
	money_config.set_value("money", "current", new_money)
	money_config.save(money_path)
	
	################################################################################
	
	var missions_path = str(saves_path + str(saves_number) + "/missions.json")
	var empty_file = 0
	var result = JSON.stringify(empty_file)

	var file = FileAccess.open(missions_path, FileAccess.WRITE)
	if file != null:
		file.store_string(result)
		file.close()
		print("[start.gd/missions.json] Asteroid data emptied")
	else:
		print("Failed to open the file for writing: " + missions_path)
	
	################################################################################
	
	var skin_path = str(saves_path + str(saves_number) + "/skin.cfg")
	skin_config.set_value("skin", "selected", 1)
	skin_config.save(skin_path)
	
	################################################################################
	
	var day_path = str(saves_path + str(saves_number) + "/day.cfg")
	day_config.set_value("day", "current", 1)
	day_config.save(day_path)
	
	################################################################################
	
	var difficulty_path = str(saves_path + str(saves_number) + "/difficulty.cfg")
	difficulty_config.set_value("difficulty", "current", choosen_difficulty)
	difficulty_config.save(difficulty_path)
	
	################################################################################
	
	var cheating_path = str(saves_path + str(saves_number) + "/cheats.cfg")
	cheating_config.set_value("cheating", "enabled", choosen_cheating)
	cheating_config.save(cheating_path)
	
	################################################################################
	
	var companies_names : Array = ["Fyction", "Haznuclear", "Owlwing", "Bill", "Interstellar", "Anura", "Octane"]
	var vlines : Array = [10, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1188]

	var stock_path = str(saves_path+ str(saves_number) + "/stock.cfg")
	
	for i in range(companies_names.size()):
		for num in range(1, 14):
			var random_point = Vector2(vlines[num-1], randi_range(16, 800))
			stock_config.set_value("stock", str(companies_names[i] + str(num)), random_point)
	stock_config.save(stock_path)
	
	################################################################################
	
	if choosen_intro == true:
		var new_path = str(saves_path + str(saves_number) + "/new")
		DirAccess.make_dir_absolute(new_path)
	
	################################################################################
	
	FileAccess.open(str("user://save/", str(saves_number) ,"/version-beta", ProjectSettings.get_setting("application/config/version")), FileAccess.WRITE) # Open file in write mode
	
	################################################################################
	
	var player_path = str(saves_path + str(saves_number) + "/player.cfg")
	player_config.set_value("status", "max_health", 100)
	player_config.set_value("status", "max_oxygen", 360)
	player_config.set_value("status", "max_uv_battery", 200)
	player_config.set_value("status", "walking_speed", 55)
	player_config.set_value("status", "running_speed", 90)
	player_config.set_value("status", "radiatian_tolerance", 0)
	player_config.set_value("status", "temperature_tolerance", 0)
	
	player_config.set_value("hotbar_slots", "0", "Sword")
	player_config.set_value("hotbar_slots", "1", "Pickaxe")
	player_config.set_value("hotbar_slots", "2", "Light")
	player_config.set_value("hotbar_slots", "3", "UV_Flashlight")
	player_config.save(player_path)
	
	################################################################################

func _on_delete_game_pressed() -> void:
	$PlayButton.disabled = true
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/back.ogg")
	$"../../../MouseSoundEffects".pitch_scale = 0.75
	$"../../../MouseSoundEffects".play()

	var button = find_button_by_save(selected_save)
	if button != null:
		button.queue_free()
		var folder_path = saves_path + str(selected_save)
		var folder_save = DirAccess.open(folder_path)
		
		folder_save.list_dir_begin() 
		var file_name = folder_save.get_next()
		while file_name != "":
			var file_path = folder_path + "/" + file_name
			DirAccess.remove_absolute(file_path)
			file_name = folder_save.get_next()
		folder_save.list_dir_end()

		DirAccess.remove_absolute(folder_path)
		print("Removed Save: ", selected_save)

func find_button_by_save(save_id: int) -> Button:
	for button in $ScrollContainer/SaveList.get_children():
		if button.get_meta("save") == save_id:
			return button
	return null

func set_selected_save(button: Button):
	$PlayButton.disabled = false
	selected_save = button.get_meta("save")
	saves_config.set_value("saves", "selected", selected_save)
	saves_config.save("user://save/saves.cfg")
	print("[save_files_menu.gd] Selected Save: ", selected_save)

func _on_delete_game_mouse_entered() -> void:
	$DeleteGame.icon = preload("res://assets/textures/main_menu/trash_can_hover.png")
func _on_delete_game_mouse_exited() -> void:
	$DeleteGame.icon = preload("res://assets/textures/main_menu/trash_can.png")

func create_styleboxes():
	var StyleBoxes : Array = [normal_stylebox, focus_stylebox, hover_stylebox]
	for s in StyleBoxes.size():
		StyleBoxes[s].border_width_bottom = 3
		StyleBoxes[s].border_width_top = 3
		StyleBoxes[s].border_width_left = 3
		StyleBoxes[s].border_width_right = 3
		StyleBoxes[s].corner_radius_bottom_left = 4
		StyleBoxes[s].corner_radius_bottom_right = 4
		StyleBoxes[s].corner_radius_top_left = 4
		StyleBoxes[s].corner_radius_top_right = 4
		StyleBoxes[s].content_margin_bottom = 10
		StyleBoxes[s].content_margin_top = 10
		StyleBoxes[s].content_margin_left = 20
		StyleBoxes[s].content_margin_right = 20
		StyleBoxes[s].bg_color = Color.BLACK
	
	normal_stylebox = StyleBoxes[0]
	focus_stylebox = StyleBoxes[1]
	focus_stylebox = StyleBoxes[2]
	normal_stylebox.border_color = Color("555555")
	focus_stylebox.border_color = Color("f9b53f")
	focus_stylebox.border_color = Color.WHITE

func _on_play_button_mouse_entered() -> void:
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/back.ogg")
	$"../../../MouseSoundEffects".pitch_scale = 1
	$"../../../MouseSoundEffects".play()

func _on_button_mouse_entered() -> void:
	var mouse_sound = $"../../../MouseSoundEffects"
	if mouse_sound:
		mouse_sound.stream = load("res://sounds/sound_effects/mining1.ogg")
		mouse_sound.pitch_scale = 1
		mouse_sound.play()

func _on_create_game_pressed() -> void:
	$SaveScreationPanel/DifficultyTabBar.current_tab = 1
	$SaveScreationPanel/CheatingTabBar.current_tab = 0
	$SaveScreationPanel/IntroTabBar.current_tab = 1
	$SaveScreationPanel.visible = true

func _on_difficulty_tab_bar_tab_selected(tab: int) -> void:
	match tab:
		0: choosen_difficulty = "easy"
		1: choosen_difficulty = "normal"
		2: choosen_difficulty = "hard"

func _on_cheating_tab_bar_tab_selected(tab: int) -> void:
	match tab:
		0: choosen_cheating = false
		1: choosen_cheating = true

func _on_intro_tab_bar_tab_selected(tab: int) -> void:
	match tab:
		0: choosen_intro = false
		1: choosen_intro = true
