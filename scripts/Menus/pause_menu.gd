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
	Input.set_custom_mouse_cursor(load("res://assets/textures/players/main_cursor.png"))
	var new_game_scene = load("res://scenes/lobby.tscn")
	get_tree().change_scene_to_packed(new_game_scene)
	new_game_scene.instantiate()
	
	# Load current inventory from the JSON file
	var current_inventory = load_inventory("res://inventory.json")
	
	# Get new items from the ItemList Node
	var new_items = get_items_from_itemlist($"../Player/HUD/ItemList")
	
	# Merge current inventory with new items
	var updated_inventory = merge_items(current_inventory, new_items)
	
	# Convert the updated inventory to JSON format
	var formatted_data = format_items_to_json(updated_inventory)
	
	# Save JSON to a file
	var file_path = "res://inventory.json"
	if save_json_to_file(file_path, formatted_data):
		print("JSON saved successfully to", file_path)
	else:
		print("Failed to save JSON")

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

# Function to merge items into the current inventory
func merge_items(current_inventory, new_items):
	var inventory_dict = {}

	# Add current inventory to a dictionary
	if current_inventory.size() > 0:
		for item_name in current_inventory[0].keys():
			inventory_dict[item_name] = current_inventory[0][item_name]

	# Add or update items from the new inventory
	for item in new_items:
		if inventory_dict.has(item["name"]):
			inventory_dict[item["name"]] += item["quantity"]
		else:
			inventory_dict[item["name"]] = item["quantity"]

	# Return the merged inventory as a list of one dictionary
	return [inventory_dict]

# Function to format the inventory into the desired JSON structure
func format_items_to_json(inventory_dict):
	# Convert inventory dictionary to a JSON string
	return JSON.stringify(inventory_dict, "\t")  # Pretty-print with tabs

# Function to load inventory from a JSON file
func load_inventory(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		file.close()
		var json_parser = JSON.new()  # Create an instance of the JSON class
		var result = json_parser.parse(json)
		if result == OK:
			return json_parser.get_data()  # Return parsed JSON as a list of dictionaries
	return [{}]  # Return an empty inventory if the file does not exist or is invalid

# Function to save JSON data to a file
func save_json_to_file(file_path, json_data):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(json_data)
		file.close()
		return true
	return false
