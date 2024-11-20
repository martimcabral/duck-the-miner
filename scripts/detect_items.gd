extends Area2D

@onready var Inventory = $"../HUD/ItemList"
@onready var World = $"../.." # Will be used to know what biome the player is at, to change the texture to the correct biome

func _process(_delta: float) -> void:
	if Inventory.get_item_count() > 0:
		$"../HUD/ItemList/EmptyLabel".visible = false

func _on_body_entered(body : Node2D):
	if body.is_in_group("Pickable"):
		match body.editor_description:
			"Stone":
				var stoneIcon = load("res://assets/textures/items/raw/rock_and_stone.png")
				add_item_to_inventory("Stone", stoneIcon)
			"Coal":
				var coalIcon = load("res://assets/textures/items/raw/coal.png")
				add_item_to_inventory("Coal", coalIcon)
			"RawCopper":
				var copperIcon = load("res://assets/textures/items/raw/raw_copper.png")
				add_item_to_inventory("Copper", copperIcon)
			"RawIron":
				var ironIcon = load("res://assets/textures/items/raw/raw_iron.png")
				add_item_to_inventory("Iron", ironIcon)
			"RawGold":
				var goldIcon = load("res://assets/textures/items/raw/raw_gold.png")
				add_item_to_inventory("Gold", goldIcon)
			"Emerald":
				var emeraldIcon = load("res://assets/textures/items/raw/emerald.png")
				add_item_to_inventory("Emerald", emeraldIcon)
			"Ruby":
				var rubyIcon = load("res://assets/textures/items/raw/ruby.png")
				add_item_to_inventory("Ruby", rubyIcon)
			"Sapphire":
				var sapphireIcon = load("res://assets/textures/items/raw/sapphire.png")
				add_item_to_inventory("Sapphire", sapphireIcon)
			"Diamond":
				var diamondIcon = load("res://assets/textures/items/raw/diamond.png")
				add_item_to_inventory("Diamond", diamondIcon)
			"Ice":
				var iceIcon = load("res://assets/textures/items/raw/ice.png")
				add_item_to_inventory("Ice", iceIcon)
				
		body.queue_free()
		$PickupItem.play()

func add_item_to_inventory(item_name: String, item_icon: Texture): # AI Generated
	# Check if the inventory is empty
	if Inventory.get_item_count() == 0:
		Inventory.add_item(item_name + " 1", item_icon)  # Add the first item
	else:
		# Loop through the inventory to check for existing items
		for i in range(Inventory.get_item_count()):
			if Inventory.get_item_text(i).begins_with(item_name):
				# If the item is found, increment the count
				var current_count = int(Inventory.get_item_text(i).split(" ")[1])  # Assumes format "Item X"
				current_count += 1  # Increment the count
				Inventory.set_item_text(i, item_name + " " + str(current_count))  # Update the item text
				return  # Exit the function after updating the count
		
		# If no item was found after the loop, add a new one
		Inventory.add_item(item_name + " 1", item_icon)  # Add as "Item 1"
