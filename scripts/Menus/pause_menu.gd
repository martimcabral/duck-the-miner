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
	Input.set_custom_mouse_cursor(null)
	var new_game_scene = load("res://scenes/lobby.tscn")
	get_tree().change_scene_to_packed(new_game_scene)
	new_game_scene.instantiate()
	
	# Get items from the ItemList Node
	var item_list = get_items_from_itemlist($"../Player/HUD/ItemList")
	
	# Get current inventory from the JSON file
	var current_inventory = load_inventory("user://items.json")
	
	# Merge the current inventory with the new items
	var updated_inventory = merge_inventories(current_inventory, item_list)
	
	# Convert the updated inventory to JSON
	var json_data = create_json_from_list(updated_inventory)
	
	# Save JSON to a file
	var file_path = "res://inventory.json"
	if save_json_to_file(file_path, json_data):
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

# Function to merge current inventory with new items
func merge_inventories(current_inventory, new_items):
	var inventory_dict = {}

	# Add current inventory to a dictionary
	for item in current_inventory:
		inventory_dict[item["name"]] = item["quantity"]

	# Add or update items from the new inventory
	for item in new_items:
		if inventory_dict.has(item["name"]):
			inventory_dict[item["name"]] += item["quantity"]
		else:
			inventory_dict[item["name"]] = item["quantity"]

	# Convert back to the desired format
	var updated_inventory = []
	var inventory_entry = {}
	for item_name in inventory_dict.keys():
		inventory_entry[item_name] = inventory_dict[item_name]
	updated_inventory.append(inventory_entry)

	return updated_inventory

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
	return []

# Function to convert the item list to JSON
func create_json_from_list(item_list):
	# Create JSON string from the list
	var json_string = JSON.stringify(item_list, "\t") # Pretty-print with tabs
	return json_string

# Function to save JSON data to a file
func save_json_to_file(file_path, json_data):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(json_data)
		file.close()
		return true
	return false
