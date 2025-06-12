extends TileMap

@onready var CaveSystem = $"../WorldTileMap/CaveSystem"
@onready var world = $".."

var items_scene = preload("res://scenes/misc/items.tscn")

func drop_items():
	var tile_pos = get_global_mouse_position() / 16
	var block_atlas = CaveSystem.get_cell_atlas_coords(tile_pos)
	
	var item_name = ""
	if world.asteroid_biome == "Stony":
		match block_atlas:
			Vector2i(0, 0): item_name = "Stone"
			Vector2i(3, 0): item_name = "Diamond"
			Vector2i(3, 2): item_name = "Ice"
			Vector2i(1, 1): item_name = "Emerald"
			Vector2i(2, 1): item_name = "Ruby"
			Vector2i(3, 1): item_name = "Sapphire"
			Vector2i(1, 0): item_name = "Coal"
			Vector2i(2, 0): item_name = "Iron"
			Vector2i(0, 2): item_name = "Gold"
			Vector2i(1, 2): item_name = "Copper"
	elif world.asteroid_biome == "Vulcanic":
		match block_atlas:
			Vector2i(0, 0): item_name = "Stone"
			Vector2i(1, 0): item_name = "Coal"
			Vector2i(2, 0): item_name = "Iron"
			Vector2i(3, 0): item_name = "Diamond"
			Vector2i(1, 1): item_name = "Topaz"
			Vector2i(2, 1): item_name = "Tsavorite"
			Vector2i(3, 1): item_name = "Garnet"
			Vector2i(0, 2): item_name = "Gold"
			Vector2i(1, 2): item_name = "Magnetite"
			Vector2i(3, 2): item_name = "LavaCluster"
			Vector2i(0, 3): item_name = "Bauxite"
			
	elif world.asteroid_biome == "Frozen":
		match block_atlas:
			Vector2i(0, 0): item_name = "Stone"
			Vector2i(3, 0): item_name = "FrozenDiamond"
			Vector2i(3, 2): item_name = "DenseIce"
			Vector2i(1, 1): item_name = "Ametrine"
			Vector2i(2, 1): item_name = "Apatite"
			Vector2i(3, 1): item_name = "Amazonite"
			Vector2i(1, 0): item_name = "Galena"
			Vector2i(2, 0): item_name = "Silver"
			Vector2i(0, 2): item_name = "Wolframite"
			Vector2i(1, 2): item_name = "Pyrolusite"
			Vector2i(0, 3): item_name = "Nickel"
		
	elif world.asteroid_biome == "Swamp":
		match block_atlas:
			Vector2i(0, 0): item_name = "Stone"
			Vector2i(1, 0): item_name = "Graphite"
			Vector2i(2, 0): item_name = "Cobalt"
			Vector2i(3, 0): item_name = "Uranium"
			Vector2i(0, 2): item_name = "Platinum"
			Vector2i(1, 2): item_name = "Zirconium"
			Vector2i(3, 2): item_name = "Sulfur"
			Vector2i(1, 1): item_name = "Charoite"
			Vector2i(2, 1): item_name = "Sugilite"
			Vector2i(3, 1): item_name = "Peridot"
	
	elif world.asteroid_biome == "Desert":
		match block_atlas:
			Vector2i(0, 0): item_name = "Sandstone"
			Vector2i(3, 1): item_name = "Azurite"
			Vector2i(1, 1): item_name = "Bloodstone"
			Vector2i(2, 1): item_name = "Chalcedony"
			Vector2i(1, 0): item_name = "OilShale"
			Vector2i(0, 2): item_name = "Gypsum"
			Vector2i(1, 2): item_name = "Kaolinite"
			Vector2i(2, 0): item_name = "Scheelite"
			Vector2i(3, 0): item_name = "Vanadinite"
	
	elif world.asteroid_biome == "Radioactive":
		match block_atlas:
			Vector2i(0, 0): item_name = "Stone"
			Vector2i(1, 0): item_name = "Copper"
			Vector2i(2, 0): item_name = "Iron"
			Vector2i(3, 0): item_name = "Jeremejevite"
			Vector2i(1, 1): item_name = "Chrysocolla"
			Vector2i(2, 1): item_name = "Labradorite"
			Vector2i(3, 1): item_name = "Pietersite"
			Vector2i(0, 2): item_name = "Phosphorite"
			Vector2i(1, 2): item_name = "Pitchblende"
			Vector2i(3, 2): item_name = "Ice"
			Vector2i(0, 3): item_name = "Hematite"
	
	if item_name != "":
		for i in range(randi_range(1, 3)):
			var instance = items_scene.instantiate()
			
			if not instance.has_node(item_name):
				print("[drop_item.gd] Warning: item_name '%s' not found in items.tscn" % item_name)
				instance.free()
				continue
			
			var target_node = instance.get_node(item_name)
			instance.remove_child(target_node)
			instance.queue_free()  
			
			target_node.owner = null
			add_child(target_node)
			target_node.position = CaveSystem.map_to_local(tile_pos)
			target_node.rotation_degrees = randi_range(0, 360)

# © Sr. Patinho // 2007-2025 🦆
