extends CharacterBody2D

var current_item = 1
var current_health : int
var current_oxygen : int
var current_uv : int
var max_health : int
var max_oxygen : int
var max_uv : int
var flashlight : bool = false

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
var block_selection_default = preload("res://assets/textures/selected_block.png")
var block_selection_out = preload("res://assets/textures/selected_block_out_of_range.png")

@onready var block_selection = $"../WorldTileMap/BlockSelection"
@onready var player = $"../Player"
@onready var CaveSystem = $"../WorldTileMap/CaveSystem"
@onready var BreakingStages = $"../WorldTileMap/BreakingStages"
@onready var InventoryAtWorld = $HUD/ItemList
@onready var world = $".."

var cursor_texture_sword = preload("res://assets/textures/equipment/swords/debug_sword.png")
var cursor_texture_pickaxe = preload("res://assets/textures/equipment/pickaxes/debug_pickaxe.png")
var cursor_texture_light = preload("res://assets/textures/equipment/others/bulkhead_light.png")
var cursor_texture_flashlight = preload("res://assets/textures/equipment/others/flashlight_item.png")
var the_nothing_texture = preload("res://assets/textures/equipment/others/the_nothing.png")
var cursor_default = preload("res://assets/textures/players/main_cursor.png")

var bloddy_overlay1 = preload("res://assets/textures/bloody_overlay/overlay_1.png")
var bloddy_overlay2 = preload("res://assets/textures/bloody_overlay/overlay_2.png")
var bloddy_overlay3 = preload("res://assets/textures/bloody_overlay/overlay_3.png")

var skin_selected : int
var skin_path : String = str("user://save/", GetSaveFile.save_being_used, "/skin.cfg")
var player_path : String = str("user://save/", GetSaveFile.save_being_used, "/player.cfg")
var window_mode = 0

func _ready():
	var player_config = ConfigFile.new()
	player_config.load(player_path)
	max_health = player_config.get_value("player", "max_health", 100)
	max_oxygen = player_config.get_value("player", "max_oxygen", 300)
	max_uv = player_config.get_value("player", "max_uv_battery", 200)
	walking_speed = player_config.get_value("player", "walking_speed", 55)
	running_speed = player_config.get_value("player", "running_speed", 90)
	
	current_health = max_health
	current_oxygen = max_oxygen
	current_uv = max_uv
	
	Input.set_custom_mouse_cursor(cursor_default)
	load_skin()
	
	match world.asteroid_biome:
		"Frozen": $Camera2D/HUD/FreezingOverlay.visible = true
		"Vulcanic": $Camera2D/HUD/MirageOverlay.visible = true
	
	$Camera2D/HUD/Hotbar/TabBar.set_tab_icon(0, cursor_texture_sword)
	$Camera2D/HUD/Hotbar/TabBar.set_tab_icon(1, cursor_texture_pickaxe)
	$Camera2D/HUD/Hotbar/TabBar.set_tab_icon(2, cursor_texture_light)
	$Camera2D/HUD/Hotbar/TabBar.set_tab_icon(3, cursor_texture_flashlight)
	
	$Camera2D/HUD/VersionDisplay.text = "[center]%s[/center]" % "beta." + str(ProjectSettings.get_setting("application/config/version"))
	$HUD/ItemList/TeamInventoryLabel.text = "[center]%s[/center]" % "Duck's Pockets"

func player_movement(input, delta):
	if is_duck_dead == false:
		if $"../PauseMenu/GUI_Pause".visible == false:
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
			velocity.y += falling_speed * delta

func _process(delta):
	do_bloddy_overlay()
	$Camera2D/HUD/Stats/CurrentHealth.text = str(current_health)
	$Camera2D/HUD/Stats/CurrentOxygen.text = str(current_oxygen)
	$Camera2D/HUD/Stats/CurrentUv.text =  str(current_uv)
	$Camera2D/HUD/Stats/MaxHealth.text = " / " + str(max_health) 
	$Camera2D/HUD/Stats/MaxOxygen.text = " / " + str(max_oxygen)
	$Camera2D/HUD/Stats/MaxUv.text = " / " + str(max_uv)
	
	BaW_time_remaining =  $HUD/BlackAndWhite/BaWFadeInTimer.wait_time - $HUD/BlackAndWhite/BaWFadeInTimer.time_left
	
	if current_health <= 0:
		is_duck_dead = true
	
	if is_duck_dead == true:
		Input.set_custom_mouse_cursor(load("res://assets/textures/players/main_cursor.png"))
		$HUD/DeathLabel.visible = true
		current_health = 0
		$AnimatedSprite2D.animation = str(skin_selected) + "_dead"
		$HUD/BlackAndWhite.visible = true
		velocity.y += (falling_speed / 2.5) * delta
		move_and_slide()
		if do_death_once == false:
			$HUD/BlackAndWhite/BaWFadeInTimer.start()
			$AnimatedSprite2D.animation = str(skin_selected) + "_dead"
			do_death_once = true
		$HUD/BlackAndWhite.material.set_shader_parameter("intensity", BaW_time_remaining)
	else:
		$HUD/DeathLabel/GoToMenuTimer.start()
		$HUD/BlackAndWhite.material.set_shader_parameter("intensity", 0)
		do_death_once = false
		$HUD/DeathLabel.visible = false
	
	if $HUD/DeathLabel/GoToMenuTimer.time_left >= 0.5 and $HUD/DeathLabel/GoToMenuTimer.time_left <= 7:
		$HUD/DeathLabel/TimingLabel.text = "Going to Menu in ..." + str(int(round($HUD/DeathLabel/GoToMenuTimer.time_left)))
	elif $HUD/DeathLabel/GoToMenuTimer.time_left >= 0 and $HUD/DeathLabel/GoToMenuTimer.time_left <= 0.49:
		$HUD/DeathLabel/TimingLabel.text = "Going to Menu!"
	
	if Input.is_action_just_pressed("Open_Feedback_Page"):
		OS.shell_open("https://sr-patinho.itch.io/duck-the-miner")
	
	if is_duck_dead == false:
		$Flashlight.look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("Use_Flashlight") and self.current_item == 4:
			match (flashlight):
				true:
					$Flashlight.energy = 0
					flashlight = false
				false:
					$Flashlight.energy = 1.75
					flashlight = true
	
	if current_uv == 0:
		flashlight = false
		$Flashlight.energy = 0
	
	if current_oxygen == 0:
		current_oxygen = 300
		current_health -= 5
	
	if $"../PauseMenu/GUI_Pause".visible == false:
		if is_duck_dead == false:
			if Input.is_action_just_pressed("Hide_Show_Inventory"):
				if InventoryAtWorld.visible == true:
					InventoryAtWorld.visible = false
				else:
					InventoryAtWorld.visible = true
			
			if Input.is_action_just_pressed("Quack"):
				var random_pitch = randi_range(1, 3)
				match random_pitch:
					1:
						$"PlayerSounds/Quack".pitch_scale = 0.9
					2:
						$"PlayerSounds/Quack".pitch_scale = 1
					3:
						$"PlayerSounds/Quack".pitch_scale = 1.1
				$"PlayerSounds/Quack".play()
		
	if Input.is_action_just_pressed("PauseMenu"):
		if $"../PauseMenu/GUI_Pause".visible == true:
			$"../PauseMenu/GUI_Pause".visible = false
			match current_item:
				1: Input.set_custom_mouse_cursor(cursor_texture_sword)
				2: Input.set_custom_mouse_cursor(cursor_texture_pickaxe)
				3: Input.set_custom_mouse_cursor(cursor_texture_light)
				4: Input.set_custom_mouse_cursor(cursor_texture_flashlight)
		elif $"../PauseMenu/GUI_Pause".visible == false:
			$"../PauseMenu/GUI_Pause".visible = true
			Input.set_custom_mouse_cursor(cursor_default)
		
	var tile_pos = CaveSystem.local_to_map(CaveSystem.get_global_mouse_position())
	var tile_data = CaveSystem.get_cell_tile_data(tile_pos)
	var tile_id = CaveSystem.get_cell_atlas_coords(tile_pos)
	$"../Player/PlayerSounds".position = tile_pos
	
	if is_duck_dead == false:
		if $"../PauseMenu/GUI_Pause".visible == false:
			if Input.is_action_pressed("Destroy_Block") and current_item == 2:
				var offset = Vector2i(-8, -8)
				var block_selection_position = (Vector2i(CaveSystem.get_global_mouse_position()) - offset)
				
				var tile_size = Vector2(16, 16)
				var mouse_pos = get_global_mouse_position()
				var local_mouse_pos = $BlockRange.to_local(mouse_pos)
				
				block_selection_position = block_selection_position.snapped(tile_size)
				$"../WorldTileMap/BlockSelection".position = block_selection_position
				
				var collision_shape = $BlockRange.get_node("CollisionShape2D").shape
				var radius = (collision_shape as CircleShape2D).radius
				
				if local_mouse_pos.length() <= radius:
					$"../WorldTileMap/BlockSelection".texture = block_selection_default
				else:
					$"../WorldTileMap/BlockSelection".texture = block_selection_out
			else:
				$"../WorldTileMap/BlockSelection".position = Vector2(-128, -128)
				$"../WorldTileMap/BlockSelection".texture = block_selection_default
				
			if Input.is_action_just_pressed("Place_Block") and current_item != 3:
				var mouse_pos = get_global_mouse_position()
				var local_mouse_pos = $BlockRange.to_local(mouse_pos)
				var collision_shape = $BlockRange.get_node("CollisionShape2D").shape
				var radius = (collision_shape as CircleShape2D).radius
				
				if local_mouse_pos.length() <= radius:
					if (CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)): #and $"../MissionInventory".inventory[0] >= 1):
						#$"../MissionInventory".inventory[0] -= 1
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
			
			var input = Input.get_vector("Walk_Left","Walk_Right","Fly_Up","Fly_Down")
			player_movement(input, delta)
			move_and_slide()
			$AnimatedSprite2D.play()
		
			if not is_on_floor():
				$AnimatedSprite2D.animation = str(skin_selected) + "_flying"
				if Input.is_action_pressed("Walk_Right"):
					$AnimatedSprite2D.flip_h = true
				elif Input.is_action_pressed("Walk_Left"):
					$AnimatedSprite2D.flip_h = false
				
			if is_on_floor() and Input.is_action_pressed("Agachar"):
				$AnimatedSprite2D.animation = str(skin_selected) + "_squat"
				if Input.is_action_pressed("Walk_Left"):
					$AnimatedSprite2D.flip_h = false
				elif Input.is_action_pressed("Walk_Right"):
					$AnimatedSprite2D.flip_h = true
			elif is_on_floor():
				$AnimatedSprite2D.animation = str(skin_selected) + "_walking"
				if Input.is_action_pressed("Walk_Right"):
					$AnimatedSprite2D.flip_h = true
				elif Input.is_action_pressed("Walk_Left"):
					$AnimatedSprite2D.flip_h = false
				else:
					$AnimatedSprite2D.stop()
				
			# Mudar o Cursor dependendo do Item selecinado da Hotbar
			if Input.is_action_just_pressed("Hotbar_1"):
				current_item = 1
				Input.set_custom_mouse_cursor(cursor_texture_sword)
				$Camera2D/HUD/Hotbar/TabBar.current_tab = 0
			if Input.is_action_just_pressed("Hotbar_2"):
				current_item = 2
				Input.set_custom_mouse_cursor(cursor_texture_pickaxe)
				$Camera2D/HUD/Hotbar/TabBar.current_tab = 1
			if Input.is_action_just_pressed("Hotbar_3"):
				current_item = 3
				Input.set_custom_mouse_cursor(cursor_texture_light)
				$Camera2D/HUD/Hotbar/TabBar.current_tab = 2
			if Input.is_action_just_pressed("Hotbar_4"):
				current_item = 4
				Input.set_custom_mouse_cursor(cursor_texture_flashlight)
				$Camera2D/HUD/Hotbar/TabBar.current_tab = 3
		else:
			$AnimatedSprite2D.stop()
	
	# Fullscreen
	if Input.is_action_just_pressed("Fullscreen"):
		if window_mode == 0:
			window_mode = 1
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif window_mode == 1:
			window_mode = 0
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	$Camera2D/HUD/PlayerPosition.text = "X: " + str(int($".".position.x / 16)) + \
	"\nY: " + str(int($".".position.y / 16))

####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################

func destroy_block():
	if $"../PauseMenu/GUI_Pause".visible == false and is_duck_dead == false:
		var tile_pos = CaveSystem.local_to_map(CaveSystem.get_global_mouse_position())
		var tile_data = CaveSystem.get_cell_tile_data(tile_pos)
		var tile_id = CaveSystem.get_cell_atlas_coords(tile_pos)
		
		if player.current_item == 2:
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
					var mining_sound_effect = randi_range(1, 4)  # Adjusted range to match sound clips
					if randi_range(0, 2) == 1:
						match mining_sound_effect:
							1: $"../Player/PlayerSounds/Mining1".play()
							2: $"../Player/PlayerSounds/Mining2".play()
							3: $"../Player/PlayerSounds/Mining3".play()
							4: $"../Player/PlayerSounds/Mining4".play()
						
					# Reduce health of the tile
					if used_tiles[tile_pos]["health"] > 0:
						used_tiles[tile_pos]["health"] -= 125  # Reduce health here // Pickaxe Damage
					
					# Detect percentage of the health of the Tile here:
					var percentage = float(used_tiles[tile_pos]["health"]) / tile_health * 100
					print("Block Health: ", percentage, "%")
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

##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

func _on_minning_cooldown_timeout() -> void:
	if Input.is_action_pressed("Destroy_Block"):
		# 1. Get the global position of the mouse
		var mouse_pos = get_global_mouse_position()
		# 2. Convert the global mouse position to the local position of the Area2D
		var local_mouse_pos = $BlockRange.to_local(mouse_pos)
		# 3. Get the CollisionShape2D's shape
		var collision_shape = $BlockRange.get_node("CollisionShape2D").shape
		
		# 4. Get CollisionShape2D's size
		var radius = (collision_shape as CircleShape2D).radius
		
		# 5. If the mouse is within the Area2D/BlockRange than start to destroy EVERYTHING
		if local_mouse_pos.length() <= radius:
			destroy_block()

func _on_uv_battery_consumption_timeout() -> void:
	if $"../PauseMenu/GUI_Pause".visible == false:
		if flashlight == true:
			current_uv -= 1

func _on_oxygen_consumption_timeout() -> void:
	if $"../PauseMenu/GUI_Pause".visible == false:
		if is_duck_dead == false:
			current_oxygen -= 1

func _on_tab_bar_tab_clicked(tab: int) -> void:
	if $"../PauseMenu/GUI_Pause".visible == false:
		match tab:
			0:
				current_item = 1
				Input.set_custom_mouse_cursor(cursor_texture_sword)
				$Camera2D/HUD/Hotbar/TabBar.current_tab = 0
			1: 
				current_item = 2
				Input.set_custom_mouse_cursor(cursor_texture_pickaxe)
				$Camera2D/HUD/Hotbar/TabBar.current_tab = 1
			2:
				current_item = 3
				Input.set_custom_mouse_cursor(cursor_texture_light)
				$Camera2D/HUD/Hotbar/TabBar.current_tab = 2
			3: 
				current_item = 4
				Input.set_custom_mouse_cursor(cursor_texture_flashlight)
				$Camera2D/HUD/Hotbar/TabBar.current_tab = 3

func load_skin():
	if FileAccess.file_exists(skin_path):
		var skin_file = ConfigFile.new()
		skin_file.load(skin_path)
		skin_selected = int(skin_file.get_value("skin", "selected", 1))
		print("[player.gd] Current Skin: " + str(skin_selected))

func _on_go_to_menu_timer_timeout() -> void:
	var new_game_scene = load("res://scenes/lobby.tscn")
	get_tree().change_scene_to_packed(new_game_scene)
	new_game_scene.instantiate()

func _on_reset_used_tiles_timeout() -> void:
	print("[player.gd] Used Tiles Reseted")
	used_tiles = {}

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_meta("Enemy") and ghost_mode == false:
		$AnimatedSprite2D.modulate = Color(1, 0, 0)
		current_health -= 10
		body.run_away()

func _on_reset_modulate_red_hit_timeout() -> void:
	$AnimatedSprite2D.modulate = Color("ffffff")

func _on_attack_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_item == 1:
			print("Player attacked Player's Attack Range")
			if touched_enemy != null:
				touched_enemy.attacked()

func do_bloddy_overlay():
	if  current_health >= 11% max_health and current_health <= 20% max_health:
		$Camera2D/HUD/BloddyOverlay.texture = bloddy_overlay1
	elif  current_health >= 6% max_health and current_health <= 10% max_health:
		$Camera2D/HUD/BloddyOverlay.texture = bloddy_overlay2
	elif current_health >= 1% max_health and current_health <= 5% max_health:
		$Camera2D/HUD/BloddyOverlay.texture = bloddy_overlay3
	else: 
		$Camera2D/HUD/BloddyOverlay.texture = null
