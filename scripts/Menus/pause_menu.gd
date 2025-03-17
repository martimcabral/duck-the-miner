extends Node2D

var pause_menu_visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("PauseMenu"):
		match pause_menu_visible:
			false:
				pause_menu_visible = true
				$GUI_Pause.visible = pause_menu_visible
			true:
				pause_menu_visible = false
				$GUI_Pause.visible = pause_menu_visible

func _on_continue_pressed() -> void:
	$GUI_Pause.visible = false
	pause_menu_visible = false

func _on_go_to_desktop_button_pressed() -> void:
	get_tree().quit()

func _on_feedback_button_pressed() -> void:
	OS.shell_open("https://sr-patinho.itch.io/duck-the-miner")

func _on_abort_mission_button_pressed() -> void:
	var empty_file = 0
	var result = JSON.stringify(empty_file)
	
	var file = FileAccess.open("res://save/missions.json", FileAccess.WRITE)
	if file:
		file.store_string(result)
		file.close()
		print("[start.gd/missions.json] Asteroid data emptied")
	else:
		print("[start.gd/missions.json] Failed to open file for emptying stage.")
	
	var file_path = "res://save/inventory_resources.cfg"
	var current_inventory = load_inventory("res://save/inventory_resources.cfg")
	var new_items = get_items_from_itemlist($"../Player/HUD/ItemList")
	var updated_inventory = merge_items(current_inventory, new_items)
	if save_inventory_to_cfg(file_path, updated_inventory):
		print("Inventory saved successfully to", file_path)
	else:
		print("Failed to save inventory")
	
	Input.set_custom_mouse_cursor(load("res://assets/textures/players/main_cursor.png"))
	var new_game_scene = load("res://scenes/lobby.tscn")
	get_tree().change_scene_to_packed(new_game_scene)
	new_game_scene.instantiate()

# Function to retrieve items from the ItemList Node
func get_items_from_itemlist(item_list_node):
	var items = []
	for i in range(item_list_node.get_item_count()):
		var item_text = item_list_node.get_item_text(i)
		var item_name = item_text
		var quantity = 1
		
		# Split the item text into parts
		var parts = item_text.split(" ")
		if parts.size() > 1:
			item_name = " ".join(parts.slice(0, parts.size() - 1))  # Join all except the last part
			quantity = int(parts[-1])  # Get the last part as a number
		
		items.append({
			"name": item_name,
			"quantity": quantity
		})
	return items

func merge_items(current_inventory, new_items):
	var inventory_dict = {}

	# Convert current_inventory into a usable dictionary
	for item_name in current_inventory:
		# Assuming current_inventory is a dictionary-like structure with keys as item names
		var quantity = current_inventory.get(item_name, 0)
		inventory_dict[item_name] = quantity

	# Add or update items from the new inventory
	for item in new_items:
		if inventory_dict.has(item["name"]):
			inventory_dict[item["name"]] += item["quantity"]
		else:
			inventory_dict[item["name"]] = item["quantity"]

	return inventory_dict

# Function to load inventory from a CFG file
func load_inventory(file_path):
	var config = ConfigFile.new()
	if config.load(file_path) == OK:
		var inventory_data = {}
		for item_name in config.get_section_keys("inventory"):
			inventory_data[item_name] = config.get_value("inventory", item_name, 0)  # Default to 0 if not found
		return inventory_data
	return {}

# Function to save inventory to a CFG file
func save_inventory_to_cfg(file_path, inventory):
	var config = ConfigFile.new()
	for item_name in inventory.keys():
		config.set_value("inventory", item_name, inventory[item_name])
	return config.save(file_path) == OK
