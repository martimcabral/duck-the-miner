extends Panel

var saves_number : int = 1
var selected_save : int = 0

var savedir = DirAccess.open("res://save")
var saves_path = str("res://save/saves.cfg")
var saves_config = ConfigFile.new()
var getmoney_config = ConfigFile.new()

func _ready() -> void:
	
	if not FileAccess.file_exists(saves_path):
		print("[save/save.cfg] not found. Creating a new one....")
		saves_config.set_value("saves", "selected", 0)
		saves_config.set_value("saves", "ammount", 0)
		saves_config.save(saves_path)
	else:
		print("[save/save.cfg] was detected successfully")
		saves_number = savedir.get_directories().size()
		saves_config.set_value("saves", "ammount", saves_number)
		selected_save = saves_config.get_value("saves", "selected", 0)
		saves_config.save(saves_path)
		print("[save_files_menu.gd] Number of SaveFolders: ", saves_number)
	get_save_files()

func get_save_files():
	var directories = savedir.get_directories()
	for i in range(0, 100):
		if directories.has(str(i)) == true:
			print(i, directories.has(str(i)))
			var SaveButton = Button.new()
			
			getmoney_config.load(str("res://save/", i, "/money.cfg"))
			var current_money = str(getmoney_config.get_value("money", "current", 0))
			print("ABACATE: ", current_money)
			var number_str = str(current_money)
			var formatted_number = ""
			var counter = 0
			for x in range(number_str.length() - 1, -1, -1):
				formatted_number = number_str[x] + formatted_number
				counter += 1
				if counter % 3 == 0 and x != 0:
					formatted_number = " " + formatted_number
			SaveButton.text = "Save " + str(i) + " - " + str(formatted_number) + " €"
			
			SaveButton.add_theme_color_override("font_color", Color.WHITE)
			SaveButton.add_theme_font_size_override("font_size", 48)
			SaveButton.set_meta("save", i)
			SaveButton.pressed.connect(set_selected_save.bind(SaveButton))
			$ScrollContainer/SaveList.add_child(SaveButton)

func _on_verify_files_timeout() -> void:
	saves_number = savedir.get_directories().size()
	saves_config.set_value("saves", "ammount", saves_number)
	saves_config.save(saves_path)

func _on_back_button_pressed() -> void:
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/back.ogg")
	$"../../../MouseSoundEffects".play()
	$"../StartMenu".visible = true
	$".".visible = false

func _on_create_game_pressed() -> void:
	# Create SaveGame Button
	saves_number += 1
	var SaveButton = Button.new()
	SaveButton.text = "Save " + str(saves_number) + " - Just Created"
	SaveButton.add_theme_color_override("font_color", Color.WHITE)
	SaveButton.add_theme_font_size_override("font_size", 48)
	SaveButton.set_meta("save", saves_number)
	SaveButton.pressed.connect(set_selected_save.bind(SaveButton))
	$ScrollContainer/SaveList.add_child(SaveButton)
	
	# Create the actual file
	var save_file_path = "res://save/" + str(saves_number)
	if not DirAccess.dir_exists_absolute(save_file_path):
		DirAccess.make_dir_absolute(save_file_path)
	
	################################################################################
	
	var money_path = str("res://save/", saves_number, "/money.cfg")
	var money_config = ConfigFile.new()
	
	if FileAccess.file_exists(money_path):
		print("[money.cfg] was detected successfully")
	else:
		print("[money.cfg] not found. Creating a new one..., with a new money.")
		var new_money = int(randf_range(1_000, 10_000))
		money_config.set_value("money", "start", new_money)
		money_config.set_value("money", "current", new_money)
		money_config.save(money_path)
	
	################################################################################
	
	var missions_path = str("res://save/", saves_number, "/missions.json")
	if not FileAccess.file_exists(missions_path):
		var empty_file = 0
		var result = JSON.stringify(empty_file)
		
		var file = FileAccess.open(missions_path, FileAccess.WRITE)
		if file:
			file.store_string(result)
			file.close()
			print("[start.gd/missions.json] Asteroid data emptied")
		else:
			print("[start.gd/missions.json] Failed to open file for emptying stage.")
	
	################################################################################
	
	var skin_path = str("res://save/", saves_number, "/skin.cfg")
	var skin_config = ConfigFile.new()
	
	if FileAccess.file_exists(skin_path):
		print("[skin.cfg] was detected successfully")
	else:
		print("[skin.cfg] not found. Creating a new one..., with a new skin.")
		skin_config.set_value("skin", "selected", 1)
		skin_config.save(skin_path)
	
	################################################################################

func _on_delete_game_pressed() -> void:
	var button = find_button_by_save(selected_save)
	if button:
		button.queue_free()
		if savedir:
			var new_name = "DELETED-" + random_bullshit_go()
			if savedir.rename(str(selected_save), new_name):
				print("Rename successful to: ", new_name)
			else:
				print("Rename failed")
		else:
			print("Failed to access directory")
		print("Deleted Save: ", selected_save)

func find_button_by_save(save_id: int) -> Button:
	for button in $ScrollContainer/SaveList.get_children():
		if button.get_meta("save") == save_id:
			return button
	return null

func set_selected_save(button: Button):
	$PlayButton.disabled = false
	selected_save = button.get_meta("save")
	saves_config.set_value("saves", "selected", selected_save)
	saves_config.save(saves_path)
	print("Selected Save: ", selected_save)

func _on_delete_game_mouse_entered() -> void:
	$DeleteGame.icon = preload("res://assets/textures/main_menu/trash_can_hover.png")
func _on_delete_game_mouse_exited() -> void:
	$DeleteGame.icon = preload("res://assets/textures/main_menu/trash_can.png")

func random_bullshit_go():
	var symbols : Array = ["#", "@", "$", "€", "%", "&", "£", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "A", "E", "I", "O", "U"]
	var rbg : String = ""
	for i in range(24):
		rbg += symbols[randi() % symbols.size()]
	return rbg
