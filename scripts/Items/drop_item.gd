extends TileMap

@onready var player = $"../Player"
@onready var block_range = $"../Player/BlockRange"
@onready var CaveSystem = $"../WorldTileMap/CaveSystem"
@onready var world = $".."

var packed_scene = load("res://scenes/misc/items.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var tile_pos = CaveSystem.local_to_map(CaveSystem.get_global_mouse_position())
	var mouse_pos = get_global_mouse_position()
	var local_mouse_pos = block_range.to_local(mouse_pos)
	var collision_shape = block_range.get_node("CollisionShape2D").shape
	var radius = (collision_shape as CircleShape2D).radius
		
	if local_mouse_pos.length() <= radius:
		if (Input.is_action_just_pressed("Place_Torch")) and player.current_item == "Light":
			if (CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
				var torch_scene : PackedScene = preload("res://scenes/misc/light.tscn")
				var torch = torch_scene.instantiate()
			
				torch.position = CaveSystem.map_to_local(tile_pos)
				add_child(torch)
				$"../Player/PlayerSounds/PlaceBlock".play()
				#print("Torch Placed: ", tile_pos)

func drop_items():
	var instance = packed_scene.instantiate()
	
	var tile_pos = get_global_mouse_position() / 16
	var block = CaveSystem.get_cell_atlas_coords(tile_pos)
	
	var item_name = ""
	if world.asteroid_biome == "Stony":
		match block:
			Vector2i(0, 0):
				item_name = "Stone"
			Vector2i(3, 0):
				item_name = "Diamond"
			Vector2i(3, 2):
				item_name = "Ice"
			Vector2i(1, 1):
				item_name = "Emerald"
			Vector2i(2, 1):
				item_name = "Ruby"
			Vector2i(3, 1):
				item_name = "Sapphire"
			Vector2i(1, 0):
				item_name = "Coal"
			Vector2i(2, 0):
				item_name = "RawIron"
			Vector2i(0, 2):
				item_name = "RawGold"
			Vector2i(1, 2):
				item_name = "RawCopper"
				
	elif world.asteroid_biome == "Vulcanic":
		match block:
			Vector2i(0, 0):
				item_name = "Stone"
			Vector2i(1, 0):
				item_name = "Coal"
			Vector2i(2, 0):
				item_name = "RawIron"
			Vector2i(3, 0):
				item_name = "Diamond"
			Vector2i(1, 1):
				item_name = "Topaz"
			Vector2i(2, 1):
				item_name = "Tsavorite"
			Vector2i(3, 1):
				item_name = "Garnet"
			Vector2i(0, 2):
				item_name = "RawGold"
			Vector2i(1, 2):
				item_name = "RawMagnetite"
			Vector2i(3, 2):
				item_name = "LavaCluster"
			Vector2i(0, 3):
				item_name = "RawBauxite"
				
	elif world.asteroid_biome == "Frozen":
		match block:
			Vector2i(0, 0):
				item_name = "Stone"
			Vector2i(3, 0):
				item_name = "FrozenDiamond"
			Vector2i(3, 2):
				item_name = "DenseIce"
			Vector2i(1, 1):
				item_name = "Ametrine"
			Vector2i(2, 1):
				item_name = "Apatite"
			Vector2i(3, 1):
				item_name = "Amazonite"
			Vector2i(1, 0):
				item_name = "Galena"
			Vector2i(2, 0):
				item_name = "Silver"
			Vector2i(0, 2):
				item_name = "Wolframite"
			Vector2i(1, 2):
				item_name = "Pyrolusite"
			Vector2i(0, 3):
				item_name = "Nickel"
		
	elif world.asteroid_biome == "Swamp":
		match block:
			Vector2i(0, 0):
				item_name = "Stone"
			Vector2i(1, 0):
				item_name = "Graphite"
			Vector2i(2, 0):
				item_name = "RawCobalt"
			Vector2i(3, 0):
				item_name = "RawUranium"
			Vector2i(0, 2):
				item_name = "RawPlatinum"
			Vector2i(1, 2):
				item_name = "RawZirconium"
			Vector2i(3, 2):
				item_name = "Sulfur"
			Vector2i(1, 1):
				item_name = "Charoite"
			Vector2i(2, 1):
				item_name = "Sugilite"
			Vector2i(3, 1):
				item_name = "Peridot"
	
	elif world.asteroid_biome == "Desert":
		match block:
			Vector2i(0, 0):
				item_name = "Sandstone"
			Vector2i(3, 1):
				item_name = "Azurite"
			Vector2i(1, 1):
				item_name = "Bloodstone"
			Vector2i(2, 1):
				item_name = "Chalcedony"
			Vector2i(1, 0):
				item_name = "OilShale"
			Vector2i(0, 2):
				item_name = "Gypsum"
			Vector2i(1, 2):
				item_name = "Kaolinite"
			Vector2i(2, 0):
				item_name = "RawScheelite"
			Vector2i(3, 0):
				item_name = "Vanadinite"

	if item_name != "":
		var target_node = instance.get_node(item_name)
		target_node.get_parent().remove_child(target_node)  # Remove the item from its original parent
		target_node.owner = null  # Unset the owner to avoid inconsistency
		add_child(target_node)  # Add the item to the current scene
		target_node.position = CaveSystem.map_to_local(tile_pos + Vector2(randf_range(-0.05, 0.05), randf_range(-0.05, 0.05)))
		target_node.rotation = randi_range(0, 360)

# © Sr. Patinho // 2007-2025 🦆
