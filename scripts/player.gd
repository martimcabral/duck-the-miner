extends CharacterBody2D

var current_item = ""
var current_health : float
var current_oxygen : float
var current_battery : float
var max_health : float
var max_oxygen : float
var max_battery : float
var health_ratio : float
var oxygen_ratio : float
var battery_ratio : float
var is_flashlight_being_used : bool = false
var is_radar_the_tool_being_used : bool = false
var is_radar_the_enemies_being_used : bool = false
var hotbar_slots_number : int = 4

var oxygen_used : int = 0
var lights_used : int = 0

var speed : int
var walking_speed : int
var running_speed : int 
const accel : int = 400
const friction : int = 375
const falling_speed : int = 250

var is_duck_dead : bool = false
var do_death_once : bool = false
var touched_enemy
var BaW_time_remaining : float = 0
var ghost_mode : bool = false
var used_tiles = {}

var block_selection_default = preload("res://assets/textures/tilemaps/selected_block/selected_block.png")
var block_selection_out = preload("res://assets/textures/tilemaps/selected_block/selected_block_out_of_range.png")
var highlighted_block_selection_default = preload("res://assets/textures/tilemaps/selected_block/highlighted_selected_block.png")
var highlighted_block_selection_out = preload("res://assets/textures/tilemaps/selected_block/highlighted_selected_block_out_of_range.png")

@onready var block_selection = $"../WorldTileMap/BlockSelection"
@onready var player = $"../Player"
@onready var CaveSystem = $"../WorldTileMap/CaveSystem"
@onready var BreakingStages = $"../WorldTileMap/BreakingStages"
@onready var InventoryAtWorld = $HUD/ItemList
@onready var MissionListAtWorld = $HUD/MissionList
@onready var world = $".."
@onready var hotbar = $Camera2D/HUD/Hotbar/TabBar
@onready var block_range = $BlockRange
@onready var ItemKeyLabel = $Camera2D/HUD/ShowControls/ItemKeyLabel
@onready var KeyLabel = $Camera2D/HUD/ShowControls/Panel/KeyLabel

var cursor_texture_sword = preload("res://assets/textures/equipment/swords/debug_sword.png")
var cursor_texture_pickaxe = preload("res://assets/textures/equipment/pickaxes/debug_pickaxe.png")
var cursor_texture_light = preload("res://assets/textures/equipment/others/bulkhead_light.png")
var cursor_texture_flashlight = preload("res://assets/textures/equipment/others/flashlight_item.png")
var cursor_texture_radar_the_tool = preload("res://assets/textures/equipment/others/radar_the_tool.png")
var cursor_texture_radar_the_enemies = preload("res://assets/textures/equipment/others/radar_the_enemies.png")

var cursor_default = preload("res://assets/textures/player/main_cursor.png")
var the_nothing_texture = preload("res://assets/textures/equipment/others/the_nothing.png")

var bloddy_overlay1 = preload("res://assets/textures/player/overlays/overlay_1.png")
var bloddy_overlay2 = preload("res://assets/textures/player/overlays/overlay_2.png")
var bloddy_overlay3 = preload("res://assets/textures/player/overlays/overlay_3.png")

var skin_selected : int
var skin_path : String = str("user://save/", GetSaveFile.save_being_used, "/skin.cfg")

var player_path : String = str("user://save/", GetSaveFile.save_being_used, "/player.cfg")
var player_config = ConfigFile.new()

var statistics_path : String = str("user://save/", GetSaveFile.save_being_used, "/statistics.cfg")
var statistics_config = ConfigFile.new()

var difficulty_path : String = str("user://save/", GetSaveFile.save_being_used, "/player.cfg")
var difficulty_config = ConfigFile.new()
var current_difficulty : String = ""

var settings_path : String = str("user://game_settings.cfg")
var settings_config = ConfigFile.new()

var quack_scene : PackedScene = preload("res://scenes/misc/quack.tscn")

var window_mode = 0
var subtitles : bool
var biome_visual_effects : bool

var collision_shape
var radius
var mouse_pos
var local_mouse_pos

func _ready():
	Input.set_custom_mouse_cursor(cursor_default)
	
	difficulty_config.load(difficulty_path)
	current_difficulty = difficulty_config.get_value("difficulty", "current", "normal")
	
	$HUD/RadarPanel.visible = false
	$HUD/RadarPanelEnemies.visible = false
	
	settings_config.load(settings_path)
	$Camera2D/HUD/BloddyOverlay.visible = !settings_config.get_value("accessibility", "hide_blood")
	
	collision_shape = $BlockRange.get_node("CollisionShape2D").shape
	radius = (collision_shape as CircleShape2D).radius
	
	var file_path = "user://game_settings.cfg"
	var config = ConfigFile.new()
	config.load(file_path)
	subtitles = config.get_value("accessibility", "subtitles", true)
	biome_visual_effects = config.get_value("display", "biome_visual_effects", true)
	
	player_config.load(player_path)
	max_health = player_config.get_value("status", "max_health", 100)
	max_oxygen = player_config.get_value("status", "max_oxygen", 480)
	max_battery = player_config.get_value("status", "max_battery_battery", 200)
	walking_speed = player_config.get_value("status", "walking_speed", 55)
	running_speed = player_config.get_value("status", "running_speed", 90)
	
	current_health = max_health
	current_oxygen = max_oxygen
	current_battery = max_battery
	
	hotbar.remove_tab(0)
	hotbar_slots_number = player_config.get_value("hotbar_slots", "number")
	for i in range(0, hotbar_slots_number):
		hotbar.add_tab(player_config.get_value("hotbar_slots", str(i)))
		hotbar.set_tab_icon(i, set_custom_cursor(i))
	
	load_skin()
	
	if biome_visual_effects == true:
		match world.asteroid_biome:
			"Frozen": $Camera2D/HUD/FreezingOverlay.visible = true
			"Vulcanic": $Camera2D/HUD/MirageOverlay.visible = true
			"Radioactive": $ChromaticAberration.visible = true

func player_movement(input, delta):
	if $"../PauseMenu/GUI_Pause".visible == false and is_duck_dead == false:
		if input: 
			if Input.is_action_pressed("Agachar"):
				speed = 0
				velocity = velocity.move_toward(input * speed , delta * accel)
			elif Input.is_action_pressed("Run"):
				speed = running_speed
				velocity = velocity.move_toward(input * speed , delta * accel)
			else:
				speed = walking_speed
				velocity = velocity.move_toward(input * speed , delta * accel)
		else: 
			velocity = velocity.move_toward(Vector2(0,0), delta * friction)
		velocity.y += (falling_speed * delta) * 0.75

func _process(delta):
	get_control_to_labelization()
	do_bloddy_overlay()
	health_ratio = current_health / max_health
	oxygen_ratio = current_oxygen / max_oxygen
	battery_ratio = current_battery / max_battery
	
	$Camera2D/HUD/Stats/UI/HealthPanel/HealthBar.set_point_position(1, Vector2(16, lerp(160.0, 6.0, health_ratio)))
	$Camera2D/HUD/Stats/UI/OxygenPanel/OxygenBar.set_point_position(1, Vector2(16, lerp(160.0, 6.0, oxygen_ratio)))
	$Camera2D/HUD/Stats/UI/BatteryPanel/BatteryBar.set_point_position(1, Vector2(16, lerp(160.0, 6.0, battery_ratio)))
	
	if battery_ratio <= 0:
		$Camera2D/HUD/Stats/UI/BatteryPanel/BatteryBar.set_point_position(1, Vector2(16, 160))
	
	BaW_time_remaining =  $HUD/BlackAndWhite/BaWFadeInTimer.wait_time - $HUD/BlackAndWhite/BaWFadeInTimer.time_left
	
	if current_health <= 0:
		is_duck_dead = true
	elif current_health > 0:
		is_duck_dead = false
	
	if is_duck_dead == true and $"../PauseMenu/GUI_Pause".visible == false:
		Input.set_custom_mouse_cursor(load("res://assets/textures/player/main_cursor.png"))
		$HUD/DeathLabel.visible = true
		$AnimatedSprite2D.animation = str(skin_selected) + "_dead"
		$HUD/BlackAndWhite.visible = true
		velocity.y += (falling_speed / 2.5) * delta
		move_and_slide()
		if do_death_once == false:
			$HUD/BlackAndWhite/BaWFadeInTimer.start()
			$AnimatedSprite2D.animation = str(skin_selected) + "_dead"
			$PlayerSounds/Death.play()
			$"../WorldMusic".queue_free()
			do_death_once = true
		$HUD/BlackAndWhite.material.set_shader_parameter("intensity", BaW_time_remaining)
	else:
		$HUD/DeathLabel/GoToMenuTimer.start()
		$HUD/BlackAndWhite.material.set_shader_parameter("intensity", 0)
		do_death_once = false
		$HUD/DeathLabel.visible = false
	
	if $HUD/DeathLabel/GoToMenuTimer.time_left >= 0.5 and $HUD/DeathLabel/GoToMenuTimer.time_left <= 5.5:
		$HUD/DeathLabel/TimingLabel.text = "Ending Mission in ..." + str(int(round($HUD/DeathLabel/GoToMenuTimer.time_left)))
	elif $HUD/DeathLabel/GoToMenuTimer.time_left >= 0 and $HUD/DeathLabel/GoToMenuTimer.time_left <= 0.49:
		$HUD/DeathLabel/TimingLabel.text = "Mission Ended!"
		$"../PauseMenu".go_to_after_mission()
	
	if Input.is_action_just_pressed("Open_Feedback_Page"):
		OS.shell_open("https://sr-patinho.itch.io/duck-the-miner")
	
	if current_battery <= 0:
		is_flashlight_being_used = false
		$HUD/RadarPanel.visible = false
		$HUD/RadarPanelEnemies.visible = false
		$Flashlight.energy = 0
	elif $"../PauseMenu/GUI_Pause".visible == false and is_duck_dead == false:
		$Flashlight.look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("Use_Item") and current_item == "UV Flashlight":
			print("[player.gd] UV Flashlight used!")
			match is_flashlight_being_used:
				true: $Flashlight.energy = 0; is_flashlight_being_used = false
				false: $Flashlight.energy = 2; is_flashlight_being_used = true
		
		if Input.is_action_just_pressed("Use_Item") and current_item == "Radar the Tool":
			print("[player.gd] Radar the Tool used!")
			match is_radar_the_tool_being_used:
				false: 
					$HUD/RadarPanel.visible = true
					is_radar_the_tool_being_used = true
					$HUD/RadarPanelEnemies.visible = false
					is_radar_the_enemies_being_used = false
				true:
					$HUD/RadarPanel.visible = false
					is_radar_the_tool_being_used = false
					$HUD/RadarPanelEnemies.visible = false
					is_radar_the_enemies_being_used = false
		
		if Input.is_action_just_pressed("Use_Item") and current_item == "Radar the Enemies":
			print("[player.gd] Radar the Enemies used!")
			match is_radar_the_enemies_being_used:
				false: 
					$HUD/RadarPanel.visible = false
					is_radar_the_tool_being_used = false
					$HUD/RadarPanelEnemies.visible = true
					is_radar_the_enemies_being_used = true
				true:
					$HUD/RadarPanel.visible = false
					is_radar_the_tool_being_used = false
					$HUD/RadarPanelEnemies.visible = false
					is_radar_the_enemies_being_used = false
			
		match current_item: # Set cursor after after despausing the game
			"Sword": Input.set_custom_mouse_cursor(cursor_texture_sword)
			"Pickaxe": Input.set_custom_mouse_cursor(cursor_texture_pickaxe)
			"Light": Input.set_custom_mouse_cursor(cursor_texture_light)
			"UV Flashlight": Input.set_custom_mouse_cursor(cursor_texture_flashlight)
			"Radar the Tool": Input.set_custom_mouse_cursor(cursor_texture_radar_the_tool)
			"Radar the Enemies": Input.set_custom_mouse_cursor(cursor_texture_radar_the_enemies)
		
		if Input.is_action_just_pressed("Hide_Show_Inventory"):
			if InventoryAtWorld.visible == true: 
				InventoryAtWorld.visible = false
				MissionListAtWorld.visible = false
			else: 
				InventoryAtWorld.visible = true
				MissionListAtWorld.visible = true
		
		if Input.is_action_just_pressed("Quack"):
			var random_pitch = randi_range(1, 3)
			match random_pitch:
				1: $"PlayerSounds/Quack".pitch_scale = 0.9
				2: $"PlayerSounds/Quack".pitch_scale = 1
				3: $"PlayerSounds/Quack".pitch_scale = 1.1
			$"PlayerSounds/Quack".play()
			
			if subtitles == true:
				var new_quack = quack_scene.instantiate()
				new_quack.position -= Vector2(0, 8)
				add_child(new_quack)
		
	if Input.is_action_just_pressed("PauseMenu"):
		if $"../PauseMenu/GUI_Pause".visible == true:
			$"../PauseMenu/GUI_Pause".visible = false
		elif $"../PauseMenu/GUI_Pause".visible == false:
			$"../PauseMenu/GUI_Pause".visible = true
			Input.set_custom_mouse_cursor(cursor_default)
	
	var tile_pos = CaveSystem.local_to_map(CaveSystem.get_global_mouse_position())
	var tile_data = CaveSystem.get_cell_tile_data(tile_pos)
	var tile_id = CaveSystem.get_cell_atlas_coords(tile_pos)
	$"../Player/PlayerSounds".position = tile_pos
	
	if $"../PauseMenu/GUI_Pause".visible == false:
		var input = Input.get_vector("Walk_Left","Walk_Right","Fly_Up","Fly_Down")
		player_movement(input, delta)
		move_and_slide()
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if not is_on_floor() and is_duck_dead == false:
		$AnimatedSprite2D.animation = str(skin_selected) + "_flying"
		if Input.is_action_pressed("Walk_Right"):
			$AnimatedSprite2D.flip_h = true
		elif Input.is_action_pressed("Walk_Left"):
			$AnimatedSprite2D.flip_h = false
		
	if is_on_floor() and Input.is_action_pressed("Agachar")  and is_duck_dead == false:
		$AnimatedSprite2D.animation = str(skin_selected) + "_squat"
		if Input.is_action_pressed("Walk_Left"):
			$AnimatedSprite2D.flip_h = false
		elif Input.is_action_pressed("Walk_Right"):
			$AnimatedSprite2D.flip_h = true
	elif is_on_floor() and is_duck_dead == false:
		$AnimatedSprite2D.animation = str(skin_selected) + "_walking"
		if Input.is_action_pressed("Walk_Right"):
			$AnimatedSprite2D.flip_h = true
		elif Input.is_action_pressed("Walk_Left"):
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.stop()
	
	# Mudar o Cursor dependendo do Item selecinado da Hotbar
	if Input.is_action_just_pressed("Hotbar_1") and hotbar_slots_number >= 1:
		hotbar.current_tab = 0
		current_item = player_config.get_value("hotbar_slots", "0")
		Input.set_custom_mouse_cursor(set_custom_cursor(0))
	if Input.is_action_just_pressed("Hotbar_2") and hotbar_slots_number >= 2:
		hotbar.current_tab = 1
		current_item = player_config.get_value("hotbar_slots", "1")
		Input.set_custom_mouse_cursor(set_custom_cursor(1))
	if Input.is_action_just_pressed("Hotbar_3") and hotbar_slots_number >= 3:
		hotbar.current_tab = 2
		current_item = player_config.get_value("hotbar_slots", "2")
		Input.set_custom_mouse_cursor(set_custom_cursor(2))
	if Input.is_action_just_pressed("Hotbar_4") and hotbar_slots_number >= 4:
		hotbar.current_tab = 3
		current_item = player_config.get_value("hotbar_slots", "3")
		Input.set_custom_mouse_cursor(set_custom_cursor(3))
	
	if is_duck_dead == false and $"../PauseMenu/GUI_Pause".visible == false:
		mouse_pos = get_global_mouse_position()
		local_mouse_pos = $BlockRange.to_local(mouse_pos)
		
		var offset = Vector2(-9.5, -9.5)
		var block_selection_position = (Vector2(CaveSystem.get_global_mouse_position()) - offset)
		
		var tile_size = Vector2(16, 16)
		
		block_selection_position = block_selection_position.snapped(tile_size)
		$"../WorldTileMap/BlockSelection".position = block_selection_position
		
		settings_config.load(settings_path)
		if local_mouse_pos.length() <= radius:
			if settings_config.get_value("accessibility", "highlight_block_selection") == false:
				$"../WorldTileMap/BlockSelection".texture = block_selection_default
			else:
				$"../WorldTileMap/BlockSelection".texture = highlighted_block_selection_default
		else:
			if settings_config.get_value("accessibility", "highlight_block_selection") == false:
				$"../WorldTileMap/BlockSelection".texture = block_selection_out
			else:
				$"../WorldTileMap/BlockSelection".texture = highlighted_block_selection_out
			
		if local_mouse_pos.length() <= radius:
			if (Input.is_action_just_pressed("Place_Torch")) and player.current_item == "Light":
				if (CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
					var torch_scene : PackedScene = load("res://scenes/misc/light.tscn")
					var torch = torch_scene.instantiate()
				
					torch.position = CaveSystem.map_to_local(tile_pos)
					add_sibling(torch)
					$"../Player/PlayerSounds/PlaceBlock".play()
					print("Torch Placed: ", torch, "/", tile_pos)
				
			if Input.is_action_just_pressed("Place_Block") and current_item != "Light":
					if (CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
						print(tile_data, " ", tile_id)
						if world.asteroid_biome == "Stony":
							CaveSystem.set_cell(tile_pos, 0, Vector2i(0, 0))
						elif world.asteroid_biome == "Vulcanic":
							CaveSystem.set_cell(tile_pos, 1, Vector2i(0, 0))
						elif world.asteroid_biome == "Frozen":
							CaveSystem.set_cell(tile_pos, 2, Vector2i(0, 0))
						elif world.asteroid_biome == "Swamp":
							CaveSystem.set_cell(tile_pos, 3, Vector2i(0, 0))
						elif world.asteroid_biome == "Desert":
							CaveSystem.set_cell(tile_pos, 4, Vector2i(0, 0))
						$"../Player/PlayerSounds/PlaceBlock".play()
						print("Properties Changed on Tile: (x: ", tile_pos.x, ", y: ", tile_pos.y, ")")
						
						# Restart new Tile on Used Tiles Dictionary
						var tile_health = 1000
						used_tiles[tile_pos] = {"pos" : tile_pos}
						used_tiles[tile_pos] = {"health": tile_health} 
						used_tiles[tile_pos]["health"] = tile_health
	
	# Fullscreen
	if Input.is_action_just_pressed("Fullscreen"):
		print("[player.gd] Fullscreen Key Pressed")
		if window_mode == 0:
			window_mode = 1
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif window_mode == 1:
			window_mode = 0
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
	$"HUD/CheatMenu/Container/WorldLabel/PlayerPosition".text = "X: " + str(int($".".position.x / 16)) + \
	"\nY: " + str(int($".".position.y / 16))

####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################

func destroy_block():
	if $"../PauseMenu/GUI_Pause".visible == false and is_duck_dead == false:
		var tile_pos = CaveSystem.local_to_map(CaveSystem.get_global_mouse_position())
		var tile_data = CaveSystem.get_cell_tile_data(tile_pos)
		var tile_id = CaveSystem.get_cell_atlas_coords(tile_pos)
		
		if player.current_item == "Pickaxe":
			#print("Data: ", used_tiles, " ", tile_id)
			if tile_data != null:
				var tile_health = tile_data.get_custom_data("health")
			
				# Initialize used_tiles entry if it doesn't exist
				if not used_tiles.has(tile_pos):
					used_tiles[tile_pos] = {"pos" : tile_pos}
					used_tiles[tile_pos] = {"health": tile_health}  # Store tile health in a dictionary
					used_tiles[tile_pos]["health"] = tile_health  # Update health if it exists
				
				# Check for specific tile ID
				if not (tile_id == Vector2i(0, 1)):
					if randi_range(1, 3) == 1:
						match randi_range(1, 4):
							1: $"../Player/PlayerSounds/Mining".pitch_scale = 0.9
							2: $"../Player/PlayerSounds/Mining".pitch_scale = 0.95
							3: $"../Player/PlayerSounds/Mining".pitch_scale = 1
							3: $"../Player/PlayerSounds/Mining".pitch_scale = 1.1
						$"../Player/PlayerSounds/Mining".play()
					
					# Reduce health of the tile
					if used_tiles[tile_pos]["health"] > 0:
						used_tiles[tile_pos]["health"] -= 125  # Reduce health here // Pickaxe Damage
					
					# Detect percentage of the health of the Tile here:
					var percentage = float(used_tiles[tile_pos]["health"]) / tile_health * 100
					#print("Block Health: ", percentage, "%")
					if (percentage >= 76 and percentage <= 100):
						BreakingStages.set_cell(tile_pos, 0, Vector2i(0, 0))
					elif (percentage >= 50 and percentage <= 75):
						BreakingStages.set_cell(tile_pos, 0, Vector2i(1, 0))
					elif (percentage >= 25 and percentage <= 49):
						BreakingStages.set_cell(tile_pos, 0, Vector2i(2, 0))
					elif (percentage >= 1 and percentage <= 24):
						BreakingStages.set_cell(tile_pos, 0, Vector2i(3, 0))
					elif percentage < 1:
						BreakingStages.set_cell(tile_pos, 0, Vector2i(4, 0))
					
					# Check if the tile's health drops to 0 or below
					if used_tiles[tile_pos]["health"] <= 0:
						if not used_tiles[tile_pos]["health"] == -1:
							statistics_config.load(statistics_path)
							statistics_config.set_value("statistics", "blocks", \
							statistics_config.get_value("statistics", "blocks") + 1)
							statistics_config.save(statistics_path)
							
							var drop_the_item = get_node("%WorldTileMap")
							drop_the_item.drop_items()
							if world.asteroid_biome == "Stony":
								CaveSystem.set_cell(tile_pos, 0, Vector2i(0, 1))  # Destroy the tile
							elif world.asteroid_biome == "Vulcanic":
								CaveSystem.set_cell(tile_pos, 1, Vector2i(0, 1))
							elif world.asteroid_biome == "Frozen":
								CaveSystem.set_cell(tile_pos, 2, Vector2i(0, 1))
							elif world.asteroid_biome == "Swamp":
								CaveSystem.set_cell(tile_pos, 3, Vector2i(0, 1))
							elif world.asteroid_biome == "Desert":
								CaveSystem.set_cell(tile_pos, 4, Vector2i(0, 1))
							elif world.asteroid_biome == "Radioactive":
								CaveSystem.set_cell(tile_pos, 5, Vector2i(0, 1))

##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

func _on_minning_cooldown_timeout() -> void:
	if Input.is_action_pressed("Destroy_Block"):
		# 1. Get the global position of the mouse
		mouse_pos = get_global_mouse_position()
		# 2. Convert the global mouse position to the local position of the Area2D
		local_mouse_pos = $BlockRange.to_local(mouse_pos)
		# 3. Get the CollisionShape2D's shape
		collision_shape = $BlockRange.get_node("CollisionShape2D").shape
		
		# 4. Get CollisionShape2D's size
		radius = (collision_shape as CircleShape2D).radius
		
		# 5. If the mouse is within the Area2D/BlockRange than start to destroy EVERYTHING
		if local_mouse_pos.length() <= radius:
			destroy_block()

func _on_uv_battery_consumption_timeout() -> void:
	if $"../PauseMenu/GUI_Pause".visible == false and is_duck_dead == false:
		if is_flashlight_being_used == true:
			current_battery -= 0.75
			statistics_config.load(statistics_path)
			statistics_config.set_value("statistics", "battery", \
			statistics_config.get_value("statistics", "battery") + 0.75)
			statistics_config.save(statistics_path)
		if is_radar_the_tool_being_used == true:
			current_battery -= 1.25
			statistics_config.load(statistics_path)
			statistics_config.set_value("statistics", "battery", \
			statistics_config.get_value("statistics", "battery") + 1.25)
			statistics_config.save(statistics_path)
		if is_radar_the_enemies_being_used == true:
			current_battery -= 2
			statistics_config.load(statistics_path)
			statistics_config.set_value("statistics", "battery", \
			statistics_config.get_value("statistics", "battery") + 2)
			statistics_config.save(statistics_path)
			

func _on_oxygen_consumption_timeout() -> void:
	if $"../PauseMenu/GUI_Pause".visible == false:
		if is_duck_dead == false:
			current_oxygen -= 1
			oxygen_used += 1
			statistics_config.load(statistics_path)
			statistics_config.set_value("statistics", "oxygen", \
			statistics_config.get_value("statistics", "oxygen") + 1)
			statistics_config.save(statistics_path)

func _on_tab_bar_tab_clicked(tab: int) -> void:
	if $"../PauseMenu/GUI_Pause".visible == false:
		match tab:
			0:
				hotbar.current_tab = tab
				current_item = player_config.get_value("hotbar_slots", str(tab))
				Input.set_custom_mouse_cursor(set_custom_cursor(tab))
			1: 
				hotbar.current_tab = tab
				current_item = player_config.get_value("hotbar_slots", str(tab))
				Input.set_custom_mouse_cursor(set_custom_cursor(tab))
			2:
				hotbar.current_tab = tab
				current_item = player_config.get_value("hotbar_slots", str(tab))
				Input.set_custom_mouse_cursor(set_custom_cursor(tab))
			3: 
				hotbar.current_tab = tab
				current_item = player_config.get_value("hotbar_slots", str(tab))
				Input.set_custom_mouse_cursor(set_custom_cursor(tab))

func load_skin():
	if FileAccess.file_exists(skin_path):
		var skin_file = ConfigFile.new()
		skin_file.load(skin_path)
		skin_selected = int(skin_file.get_value("skin", "selected", 1))
		print("[player.gd] Current Skin: " + str(skin_selected))

func _on_go_to_menu_timer_timeout() -> void:
	$"../PauseMenu".go_to_after_mission()

func _on_reset_used_tiles_timeout() -> void:
	print("[player.gd] Used Tiles Reseted")
	used_tiles = {}

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_meta("Enemy") and ghost_mode == false:
		$ResetModulateRedHit.start()
		$AnimatedSprite2D.modulate = Color(1, 0, 0)
		$PlayerSounds/Hit.play()
		var damage : int = 0
		match current_difficulty:
			"easy": damage = randi_range(3, 6)
			"normal": damage = randi_range(5, 9)
			"hard": damage = randi_range(7, 11)
		current_health -= damage
		body.run_away()
		
		statistics_config.load(statistics_path)
		statistics_config.set_value("statistics", "damage_received", \
		statistics_config.get_value("statistics", "damage_received") + damage)
		statistics_config.save(statistics_path)

func _on_reset_modulate_red_hit_timeout() -> void:
	$AnimatedSprite2D.modulate = Color("ffffff")

func _on_attack_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_item == "Sword":
			$PlayerSounds/Sword.pitch_scale = 0.95
			$PlayerSounds/Sword.pitch_scale = 1
			$PlayerSounds/Sword.pitch_scale = 1.05
			$PlayerSounds/Sword.play()
			print("Player attacked Player's Attack Range")
			if touched_enemy != null:
				touched_enemy.attacked()

func do_bloddy_overlay():
	if health_ratio >= 0.11 and health_ratio <= 0.2:
		$Camera2D/HUD/BloddyOverlay.texture = bloddy_overlay1
	elif health_ratio >= 0.05 and health_ratio <= 0.1:
		$Camera2D/HUD/BloddyOverlay.texture = bloddy_overlay2
	elif health_ratio >= 0.0001 and health_ratio <= 0.04:
		$Camera2D/HUD/BloddyOverlay.texture = bloddy_overlay3
	else: 
		$Camera2D/HUD/BloddyOverlay.texture = null

func _on_take_damage_from_oxygen_timeout() -> void:
	if current_oxygen <= 0:
		if is_duck_dead == false:
			var damage = 1
			current_oxygen = 0
			current_health -= damage
			statistics_config.load(statistics_path)
			statistics_config.set_value("statistics", "damage_received", \
			statistics_config.get_value("statistics", "damage_received") + damage)
			statistics_config.save(statistics_path)
			$ResetModulateRedHit.start()
			$AnimatedSprite2D.modulate = Color(1, 0, 0)

func set_custom_cursor(hotbar_slot):
	var hotbar_slot_name = player_config.get_value("hotbar_slots", str(hotbar_slot))
	match hotbar_slot_name:
		"Sword": return cursor_texture_sword
		"Pickaxe": return cursor_texture_pickaxe
		"Light": return cursor_texture_light
		"UV Flashlight": return cursor_texture_flashlight
		"Radar the Tool": return cursor_texture_radar_the_tool
		"Radar the Enemies": return cursor_texture_radar_the_enemies

func get_control_to_labelization():
	settings_config.load(settings_path)
	if settings_config.get_value("accessibility", "show_controls") == true:
		match current_item:
			"Sword": ItemKeyLabel.text = "Use Sword   "; KeyLabel.text = settings_config.get_value("controls", "Destroy_Block")
			"Pickaxe": ItemKeyLabel.text = "Use Pickaxe   \nPlace Block   "; KeyLabel.text = str(settings_config.get_value("controls", "Destroy_Block"), "\n", settings_config.get_value("controls", "Place_Block"))
			"Light": ItemKeyLabel.text = "Use Light   "; KeyLabel.text = settings_config.get_value("controls", "Place_Torch")
			"UV Flashlight": ItemKeyLabel.text = "Use UV Flashlight   "; KeyLabel.text = settings_config.get_value("controls", "Use_Item")
			"Radar the Tool": ItemKeyLabel.text = "Use Radar the Tool   "; KeyLabel.text = settings_config.get_value("controls", "Use_Item")
			"Radar the Enemies": ItemKeyLabel.text = "Use Radar the Enemies   "; KeyLabel.text = settings_config.get_value("controls", "Use_Item")
	else:
		$Camera2D/HUD/ShowControls.visible = false
			
