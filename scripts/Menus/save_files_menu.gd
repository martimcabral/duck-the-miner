extends Panel

var saves_number : int = 1
var selected_save : int = 0

var savedir = DirAccess.open("res://save")
var saves_path = str("res://save/saves.cfg")
var saves_config = ConfigFile.new()
var getmoney_config = ConfigFile.new()

var normal_stylebox = StyleBoxFlat.new()
var focus_stylebox = StyleBoxFlat.new()
var hover_stylebox = StyleBoxFlat.new()

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
			var SaveButton = Button.new()
			var getday_file = ConfigFile.new()
			
			getday_file.load(str("res://save/", i, "/day.cfg"))
			var current_day = str(getday_file.get_value("day", "current", "what"))
			
			getmoney_config.load(str("res://save/", i, "/money.cfg"))
			var current_money = str(getmoney_config.get_value("money", "current", 0))
			var number_str = str(current_money)
			var formatted_number = ""
			var counter = 0
			for x in range(number_str.length() - 1, -1, -1):
				formatted_number = number_str[x] + formatted_number
				counter += 1
				if counter % 3 == 0 and x != 0:
					formatted_number = " " + formatted_number
			SaveButton.text = "Save " + str(i) + " ─ " + str(formatted_number) + " € ─ Day: " + current_day 
			
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

func _on_create_game_pressed() -> void:
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
	var save_file_path = "res://save/" + str(saves_number)
	if not DirAccess.dir_exists_absolute(save_file_path):
		DirAccess.make_dir_absolute(save_file_path)
	
	################################################################################
	
	var inv_path = str("res://save/", saves_number, "/inventory_resources.cfg")
	var inv_config = ConfigFile.new()
	inv_config.set_value("[inventory", "new_file", null)
	inv_config.save(inv_path)

	################################################################################
	
	var money_path = str("res://save/", saves_number, "/money.cfg")
	var money_config = ConfigFile.new()
	
	var new_money = int(randf_range(1_000, 10_000))
	money_config.set_value("money", "start", new_money)
	money_config.set_value("money", "current", new_money)
	money_config.save(money_path)
	
	################################################################################
	
	var missions_path = str("res://save/", saves_number, "/missions.json")
	var empty_file = 0
	var result = JSON.stringify(empty_file)
	
	var file = FileAccess.open(missions_path, FileAccess.WRITE)
	file.store_string(result)
	file.close()
	print("[start.gd/missions.json] Asteroid data emptied")
	
	################################################################################
	
	var skin_path = str("res://save/", saves_number, "/skin.cfg")
	var skin_config = ConfigFile.new()
	skin_config.set_value("skin", "selected", 1)
	skin_config.save(skin_path)
	
	################################################################################
	
	var day_path = str("res://save/", saves_number, "/day.cfg")
	var day_config = ConfigFile.new()
	day_config.set_value("day", "current", 1)
	day_config.save(day_path)
	
	################################################################################
		
	var stock_path = str("res://save/", saves_number, "/stock.cfg")
	var stock_config = ConfigFile.new()
	stock_config.set_value("stock", "idk", 1)
	stock_config.save(stock_path)
	
	################################################################################

func _on_delete_game_pressed() -> void:
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/back.ogg")
	$"../../../MouseSoundEffects".pitch_scale = 0.75
	$"../../../MouseSoundEffects".play()
	
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

func create_styleboxes():
	normal_stylebox.border_color = Color("555555")
	normal_stylebox.border_width_bottom = 3
	normal_stylebox.border_width_top = 3
	normal_stylebox.border_width_left = 3
	normal_stylebox.border_width_right = 3
	normal_stylebox.corner_radius_bottom_left = 4
	normal_stylebox.corner_radius_bottom_right = 4
	normal_stylebox.corner_radius_top_left = 4
	normal_stylebox.corner_radius_top_right = 4
	normal_stylebox.content_margin_bottom = 10
	normal_stylebox.content_margin_top = 10
	normal_stylebox.content_margin_left = 20
	normal_stylebox.content_margin_right = 20
	normal_stylebox.bg_color = Color.BLACK
	
	focus_stylebox.border_color = Color("f9b53f")
	focus_stylebox.border_width_bottom = 3
	focus_stylebox.border_width_top = 3
	focus_stylebox.border_width_left = 3
	focus_stylebox.border_width_right = 3
	focus_stylebox.corner_radius_bottom_left = 4
	focus_stylebox.corner_radius_bottom_right = 4
	focus_stylebox.corner_radius_top_left = 4
	focus_stylebox.corner_radius_top_right = 4
	focus_stylebox.bg_color = Color.BLACK

	hover_stylebox.border_color = Color.WHITE
	hover_stylebox.border_width_bottom = 3
	hover_stylebox.border_width_top = 3
	hover_stylebox.border_width_left = 3
	hover_stylebox.border_width_right = 3
	hover_stylebox.corner_radius_bottom_left = 4
	hover_stylebox.corner_radius_bottom_right = 4
	hover_stylebox.corner_radius_top_left = 4
	hover_stylebox.corner_radius_top_right = 4
	hover_stylebox.bg_color = Color.BLACK
	return hover_stylebox

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
