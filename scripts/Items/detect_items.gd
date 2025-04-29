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
				var stoneIcon = load("res://assets/textures/items/ores/rock_and_stone.png")
				add_item_to_inventory("Stone", stoneIcon)
			"Coal":
				var coalIcon = load("res://assets/textures/items/ores/coal.png")
				add_item_to_inventory("Coal", coalIcon)
			"RawCopper":
				var copperIcon = load("res://assets/textures/items/ores/raw_copper.png")
				add_item_to_inventory("Copper", copperIcon)
			"RawIron":
				var ironIcon = load("res://assets/textures/items/ores/raw_iron.png")
				add_item_to_inventory("Iron", ironIcon)
			"RawGold":
				var goldIcon = load("res://assets/textures/items/ores/raw_gold.png")
				add_item_to_inventory("Gold", goldIcon)
			"Emerald":
				var emeraldIcon = load("res://assets/textures/items/gems/emerald.png")
				add_item_to_inventory("Emerald", emeraldIcon)
			"Ruby":
				var rubyIcon = load("res://assets/textures/items/gems/ruby.png")
				add_item_to_inventory("Ruby", rubyIcon)
			"Sapphire":
				var sapphireIcon = load("res://assets/textures/items/gems/sapphire.png")
				add_item_to_inventory("Sapphire", sapphireIcon)
			"Diamond":
				var diamondIcon = load("res://assets/textures/items/gems/diamond.png")
				add_item_to_inventory("Diamond", diamondIcon)
			"Ice":
				var iceIcon = load("res://assets/textures/items/ores/ice.png")
				add_item_to_inventory("Ice", iceIcon)
			"Magnetite":
				var magnetiteIcon = load("res://assets/textures/items/ores/raw_magnetite.png")
				add_item_to_inventory("Magnetite", magnetiteIcon)
			"Bauxite":
				var bauxiteIcon = load("res://assets/textures/items/ores/raw_bauxite.png")
				add_item_to_inventory("Bauxite", bauxiteIcon)
			"Topaz":
				var topazIcon = load("res://assets/textures/items/gems/topaz.png")
				add_item_to_inventory("Topaz", topazIcon)
			"Garnet":
				var garnetIcon = load("res://assets/textures/items/gems/garnet.png")
				add_item_to_inventory("Garnet", garnetIcon)
			"Tsavorite":
				var tsavoriteIcon = load("res://assets/textures/items/gems/tsavorite.png")
				add_item_to_inventory("Tsavorire", tsavoriteIcon)
			"LavaCluster":
				var lavaClusterIcon = load("res://assets/textures/items/ores/lava_cluster.png")
				add_item_to_inventory("Lava Cluster", lavaClusterIcon)
			"DenseIce":
				var denseIceIcon = load("res://assets/textures/items/ores/dense_ice.png")
				add_item_to_inventory("Dense Ice", denseIceIcon)
			"Amazonite":
				var amazoniteIcon = load("res://assets/textures/items/gems/amazonite.png")
				add_item_to_inventory("Amazonite", amazoniteIcon)
			"Ametrine":
				var ametrineIcon = load("res://assets/textures/items/gems/ametrine.png")
				add_item_to_inventory("Ametrine", ametrineIcon)
			"Apatite":
				var apatiteIcon = load("res://assets/textures/items/gems/apatite.png")
				add_item_to_inventory("Apatite", apatiteIcon)
			"FrozenDiamond":
				var frozenDiamondIcon = load("res://assets/textures/items/gems/frozen_diamond.png")
				add_item_to_inventory("Frozen Diamond", frozenDiamondIcon)
			"Galena":
				var galenaIcon = load("res://assets/textures/items/ores/raw_galena.png")
				add_item_to_inventory("Raw Galena", galenaIcon)
			"Silver":
				var silverIcon = load("res://assets/textures/items/ores/raw_silver.png")
				add_item_to_inventory("Raw Silver", silverIcon)
			"Wolframite":
				var wolframiteIcon = load("res://assets/textures/items/ores/raw_wolframite.png")
				add_item_to_inventory("Raw Wolframite", wolframiteIcon)
			"Pyrolusite":
				var pyrolusiteIcon = load("res://assets/textures/items/ores/raw_pyrolusite.png")
				add_item_to_inventory("Raw Pyrolusite", pyrolusiteIcon)
			"Nickel":
				var nickelIcon = load("res://assets/textures/items/ores/raw_nickel.png")
				add_item_to_inventory("Raw Nickel", nickelIcon)
			"Graphite":
				var graphiteIcon = load("res://assets/textures/items/ores/graphite.png")
				add_item_to_inventory("Graphite", graphiteIcon)
			"RawCobalt":
				var cobaltIcon = load("res://assets/textures/items/ores/raw_cobalt.png")
				add_item_to_inventory("Raw Cobalt", cobaltIcon)
			"RawUranium":
				var uraniumIcon = load("res://assets/textures/items/ores/raw_uranium.png")
				add_item_to_inventory("Raw Uranium", uraniumIcon)
			"Charoite":
				var charoiteIcon = load("res://assets/textures/items/gems/charoite.png")
				add_item_to_inventory("Charoite", charoiteIcon)
			"Sugilite":
				var sugiliteIcon = load("res://assets/textures/items/gems/sugilite.png")
				add_item_to_inventory("Sugilite", sugiliteIcon)
			"Peridot":
				var peridotIcon = load("res://assets/textures/items/gems/peridot.png")
				add_item_to_inventory("Peridot", peridotIcon)
			"Sulfur":
				var sulfurIcon = load("res://assets/textures/items/ores/sulfur.png")
				add_item_to_inventory("Sulfur", sulfurIcon)
			"RawZirconium":
				var zirconiumIcon = load("res://assets/textures/items/ores/raw_zirconium.png")
				add_item_to_inventory("Raw Zirconium", zirconiumIcon)
			"RawPlatinum":
				var platinumIcon = load("res://assets/textures/items/ores/raw_platinum.png")
				add_item_to_inventory("Raw Platinum", platinumIcon)
			"Sandstone":
				var sandstoneIcon = load("res://assets/textures/items/ores/sandstone.png")
				add_item_to_inventory("Sandstone", sandstoneIcon)
			"Azurite":
				var azuriteIcon = load("res://assets/textures/items/gems/azurite.png")
				add_item_to_inventory("Azurite", azuriteIcon)
			"Bloodstone":
				var bloodstoneIcon = load("res://assets/textures/items/gems/bloodstone.png")
				add_item_to_inventory("Bloodstone", bloodstoneIcon)
			"Chalcedony":
				var chalcedonyIcon = load("res://assets/textures/items/gems/chalcedony.png")
				add_item_to_inventory("Chalcedony", chalcedonyIcon)
			"OilShale":
				var oilshaleIcon = load("res://assets/textures/items/ores/oil_shale.png")
				add_item_to_inventory("Oil Shale", oilshaleIcon)
			"Gypsum":
				var gypsumIcon = load("res://assets/textures/items/ores/gypsum.png")
				add_item_to_inventory("Gypsum", gypsumIcon)
			"Kaolinite":
				var kaolitineIcon = load("res://assets/textures/items/ores/kaolinite.png")
				add_item_to_inventory("Kaolinite", kaolitineIcon)
			"RawScheelite":
				var scheeliteIcon = load("res://assets/textures/items/ores/raw_scheelite.png")
				add_item_to_inventory("Raw Scheelite", scheeliteIcon)
			"Vanadinite":
				var vanadiniteIcon = load("res://assets/textures/items/ores/vanadinite.png")
				add_item_to_inventory("Vanadinite", vanadiniteIcon)
			"Biomass":
				var biomassIcon = load("res://assets/textures/items/misc/biomass.png")
				add_item_to_inventory("Biomass", biomassIcon)
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
