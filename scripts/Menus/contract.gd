extends Panel

var license_path : String = str("user://save/", GetSaveFile.save_being_used, "/license.cfg")

var hotbar_path : String = str("user://save/", GetSaveFile.save_being_used, "/hotbar.cfg")
var hotbar_dropdowns : Array = []

var statistics_path : String = str("user://save/", GetSaveFile.save_being_used, "/statistics.cfg")
var statistics_text : String = ""

var fyction_points : int = 0

@onready var HealthUpgradeSlots = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Health/HBoxContainer/UpgradeSlots
@onready var OxygenUpgradeSlots = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Oxygen/HBoxContainer/UpgradeSlots
@onready var BatteryUpgradeSlots = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Battery/HBoxContainer/UpgradeSlots
@onready var SwordUpgradeSlots = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Tools/Sword/HBoxContainer/UpgradeSlots
@onready var PickaxeUpgradeSlots = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Tools/Pickaxe/HBoxContainer/UpgradeSlots

@onready var StonyStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Biomes/Stony/Status
@onready var VulcanicStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Biomes/Vulcanic/Status
@onready var FrozenStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Biomes/Frozen/Status
@onready var SwampStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Biomes/Swamp/Status
@onready var DesertStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Biomes/Desert/Status
@onready var RadioactiveStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Biomes/Radiactive/Status

@onready var DeltaStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Zones/Delta/Status
@onready var GammaStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Zones/Gamma/Status
@onready var OmegaStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Zones/Omega/Status
@onready var KoppaStatus = $ScrollContainer/MarginContainer/LicenseTree/RightSide/Zones/Koppa/Status

@onready var LightStatus = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Tools/Light/HBoxContainer/Status
@onready var FlashlightStatus = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Tools/Flashlight/HBoxContainer/Status
@onready var RadarTheToolStatus = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Tools/RadarTheTool/HBoxContainer/Status
@onready var RadarTheEnemiesStatus = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Tools/RadarTheEnemies/HBoxContainer/Status

var NothingTexture : Texture = load("res://assets/textures/items/equipment/others/big_cross.png")
var SwordTexture : Texture = load("res://assets/textures/items/equipment/sword.png")
var PickaxeTexture : Texture = load("res://assets/textures/items/equipment/pickaxe.png")
var LightTexture : Texture = load("res://assets/textures/items/equipment/bulkhead_light_centered.png")
var FlashlightTexture : Texture = load("res://assets/textures/items/equipment/flashlight_item.png")
var RadarTheToolTexture : Texture = load("res://assets/textures/items/equipment/radar_the_tool.png")
var RadarTheEnemiesTexture : Texture = load("res://assets/textures/items/equipment/radar_the_enemies.png")

@onready var yes_sign : Texture = preload("res://assets/textures/menus/yes.png")
@onready var blocked_sign : Texture = preload("res://assets/textures/menus/blocked.png")

func _ready() -> void:
	$ScrollContainer.scroll_vertical = 0
	
	hotbar_dropdowns = [
		$FirstHotbarDropdown,
		$SecondHotbarDropdown,
		$ThirdHotbarDropdown,
		$FourthHotbarDropdown
	]
	
	start_hotbar()
	
	################################################################################################
	
	var statistics_config := ConfigFile.new()
	statistics_config.load(statistics_path)
	var oxygen_used : String = str(statistics_config.get_value("statistics", "oxygen"))
	var battery_used : String = str(statistics_config.get_value("statistics", "battery"))
	var damage_received : String = str(statistics_config.get_value("statistics", "damage_received"))
	var damage_dealt : String = str(statistics_config.get_value("statistics", "damage_dealt"))
	var enemies_killed : String = str(statistics_config.get_value("statistics", "enemies"))
	var blocks_mined : String = str(statistics_config.get_value("statistics", "blocks"))
	var time_working : String = str(statistics_config.get_value("statistics", "time_working"))
	var time_resting : String = str(statistics_config.get_value("statistics", "time_resting"))
	var current_day : String = str(statistics_config.get_value("statistics", "days", "ERROR:396"))
	var finished_missions : String = str(statistics_config.get_value("statistics", "missions_finished"))
	
	statistics_text += str("Oxygen Consumed: ", oxygen_used,"u\n")
	statistics_text += str("Energy Consumed: ", battery_used,"W\n")
	statistics_text += str("Damage Received: ", damage_received, "\n")
	statistics_text += str("Damage Dealt: ", damage_dealt, "\n")
	statistics_text += str("Enemies Killed: ", enemies_killed, "\n")
	statistics_text += str("Blocks Mined: ", blocks_mined,"\n")
	statistics_text += str("Time Working: ", time_working, "s\n")
	statistics_text += str("Time Resting: ", time_resting, "s\n")
	statistics_text += str("Days at Fyction: ", current_day ,"\n")
	statistics_text += str("Finished Missions: ", finished_missions)
	$StatisticsLabel.text = statistics_text
	
	################################################################################################
	
	var license_config := ConfigFile.new()
	license_config.load(license_path)
	
	fyction_points = license_config.get_value("license", "fyction_points")
	update_levels()
	
	var maximum_health_levels = license_config.get_value("duck", "max_health_levels")
	var maximum_oxygen_levels = license_config.get_value("duck", "max_oxygen_levels")
	var maximum_battery_levels = license_config.get_value("duck", "max_battery_levels")
	var maximum_sword_levels = license_config.get_value("tools", "max_sword_levels")
	var maximum_pickaxe_levels = license_config.get_value("tools", "max_pickaxe_levels")
	
	for levels in maximum_health_levels:
		var new_slot := TextureRect.new()
		new_slot.texture = load("res://assets/textures/menus/off.png")
		HealthUpgradeSlots.add_child(new_slot)
	
	for levels in maximum_oxygen_levels:
		var new_slot := TextureRect.new()
		new_slot.texture = load("res://assets/textures/menus/off.png")
		OxygenUpgradeSlots.add_child(new_slot)
	
	for levels in maximum_battery_levels:
		var new_slot := TextureRect.new()
		new_slot.texture = load("res://assets/textures/menus/off.png")
		BatteryUpgradeSlots.add_child(new_slot)
	
	for levels in maximum_sword_levels:
		var new_slot := TextureRect.new()
		new_slot.texture = load("res://assets/textures/menus/off.png")
		SwordUpgradeSlots.add_child(new_slot)
		
	for levels in maximum_pickaxe_levels:
		var new_slot := TextureRect.new()
		new_slot.texture = load("res://assets/textures/menus/off.png")
		PickaxeUpgradeSlots.add_child(new_slot)
	
	update_status_pips()
	update_blocked_content()

func _on_exit_button_pressed() -> void:
	$AnimationPlayer.play("bread")

func _on_more_resting_time_timeout() -> void:
	var statistics_config := ConfigFile.new()
	statistics_config.load(statistics_path)
	var new_time_resting = 1 + statistics_config.get_value("statistics", "time_resting")
	statistics_config.set_value("statistics", "time_resting", new_time_resting)
	statistics_config.save(statistics_path)

func update_status_pips():
	var license_config := ConfigFile.new()
	license_config.load(license_path)
	
	var current_health_levels = license_config.get_value("duck", "health_level")
	var current_oxygen_levels = license_config.get_value("duck", "oxygen_level")
	var current_battery_levels = license_config.get_value("duck", "battery_level")
	var current_sword_levels = license_config.get_value("tools", "sword_level")
	var current_pickaxe_levels = license_config.get_value("tools", "pickaxe_level")
	
	var maximum_health_levels = license_config.get_value("duck", "max_health_levels")
	var maximum_oxygen_levels = license_config.get_value("duck", "max_oxygen_levels")
	var maximum_battery_levels = license_config.get_value("duck", "max_battery_levels")
	var maximum_sword_levels = license_config.get_value("tools", "max_sword_levels")
	var maximum_pickaxe_levels = license_config.get_value("tools", "max_pickaxe_levels")
	
	if current_health_levels >= maximum_health_levels: $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Health/UpgradeButton.visible = false
	if current_oxygen_levels >= maximum_oxygen_levels: $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Oxygen/UpgradeButton.visible = false
	if current_battery_levels >= maximum_battery_levels: $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Battery/UpgradeButton.visible = false
	if current_sword_levels >= maximum_sword_levels: $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Tools/Sword/UpgradeButton.visible = false
	if current_pickaxe_levels >= maximum_pickaxe_levels: $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Tools/Pickaxe/UpgradeButton.visible = false
	
	for i in range(0, current_health_levels):
		HealthUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
	
	for i in range(0, current_oxygen_levels):
		OxygenUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
	
	for i in range(0, current_battery_levels):
		BatteryUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
	
	for i in range(0, current_sword_levels):
		SwordUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
	
	for i in range(0, current_pickaxe_levels):
		PickaxeUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")

################################################################################

func _on_vulcanic_status_pressed() -> void:
	unlock_region(VulcanicStatus, "biomes", "vulcanic")

func _on_frozen_status_pressed() -> void:
	unlock_region(FrozenStatus, "biomes", "frozen")

func _on_swamp_status_pressed() -> void:
	unlock_region(SwampStatus, "biomes", "swamp")

func _on_desert_status_pressed() -> void:
	unlock_region(DesertStatus, "biomes", "desert")

func _on_radioactive_status_pressed() -> void:
	unlock_region(RadioactiveStatus, "biomes", "radioactive")

func _on_delta_status_pressed() -> void:
	unlock_region(DeltaStatus, "zones", "delta")

func _on_gamma_status_pressed() -> void:
	unlock_region(GammaStatus, "zones", "gamma")

func _on_omega_status_pressed() -> void:
	unlock_region(OmegaStatus, "zones", "omega")

func _on_koppa_status_pressed() -> void:
	unlock_region(KoppaStatus, "zones", "koppa")

func unlock_region(RegionStatus : TextureButton, region : String, type : String):
	if fyction_points >= 1:
		fyction_points -= 1
		$FyctionPointsSprite/PointsAvailableLabel.text = str(fyction_points)
		RegionStatus.texture_normal = yes_sign
		RegionStatus.texture_hover = null
		
		var license_config := ConfigFile.new()
		license_config.load(license_path)
		license_config.set_value("license", "fyction_points", fyction_points)
		license_config.set_value(region, type, true)
		license_config.save(license_path)
		$"../../..".reroll_missions()

################################################################################

func _on_light_status_pressed() -> void:
	unlock_tool(LightStatus, "light", LightTexture, "Light")

func _on_flashlight_status_pressed() -> void:
	unlock_tool(FlashlightStatus, "uv_flashlight", FlashlightTexture, "UV Flashlight")

func _on_radarthetool_status_pressed() -> void:
	unlock_tool(RadarTheToolStatus, "radar_the_tool", RadarTheToolTexture, "Radar the Tool")

func _on_radartheenemies_status_pressed() -> void:
	unlock_tool(RadarTheEnemiesStatus, "radar_the_enemies", RadarTheEnemiesTexture, "Radar the Enemies")

func unlock_tool(ToolStatus : TextureButton, ToolType : String, texture : Texture, Name : String):
	if fyction_points >= 1:
		fyction_points -= 1
		$FyctionPointsSprite/PointsAvailableLabel.text = str(fyction_points)
		ToolStatus.texture_normal = yes_sign
		ToolStatus.texture_hover = null
		var license_config := ConfigFile.new()
		license_config.load(license_path)
		
		license_config.set_value("license", "fyction_points", fyction_points)
		license_config.set_value("tools", ToolType, true)
		license_config.save(license_path)
		update_blocked_content()
		add_item_to_all_dropdowns(texture, Name)

################################################################################

func _on_health_upgrade_button_pressed() -> void:
	update_thing_with_pips("duck", "health_level")

func _on_oxygen_upgrade_button_pressed() -> void:
	update_thing_with_pips("duck", "oxygen_level")

func _on_battery_upgrade_button_pressed() -> void:
	update_thing_with_pips("duck", "battery_level")

func _on_sword_upgrade_button_pressed() -> void:
	update_thing_with_pips("tools", "sword_level")

func _on_pickaxe_upgrade_button_pressed() -> void:
	update_thing_with_pips("tools", "pickaxe_level")

func update_thing_with_pips(ThingType : String, WhatThing : String):
	if fyction_points >= 1:
		fyction_points -= 1
		$FyctionPointsSprite/PointsAvailableLabel.text = str(fyction_points)
		var license_config := ConfigFile.new()
		license_config.load(license_path)
		
		license_config.set_value("license", "fyction_points", fyction_points)
		
		var new_value = license_config.get_value(ThingType, WhatThing)
		license_config.set_value(ThingType, WhatThing, new_value + 1)
		
		license_config.save(license_path)
	update_status_pips()
	update_blocked_content()

func update_blocked_content():
	var license_config := ConfigFile.new()
	license_config.load(license_path)
	
	fyction_points = license_config.get_value("license", "fyction_points")
	
	var stony_unlocked : bool = license_config.get_value("biomes", "stony")
	var vulcanic_unlocked : bool = license_config.get_value("biomes", "vulcanic")
	var frozen_unlocked : bool = license_config.get_value("biomes", "frozen")
	var swamp_unlocked : bool = license_config.get_value("biomes", "swamp")
	var desert_unlocked : bool = license_config.get_value("biomes", "desert")
	var radioactive_unlocked : bool = license_config.get_value("biomes", "radioactive")
	
	var delta_unlocked : bool = license_config.get_value("zones", "delta")
	var gamma_unlocked : bool = license_config.get_value("zones", "gamma")
	var omega_unlocked : bool = license_config.get_value("zones", "omega")
	var koppa_unlocked : bool = license_config.get_value("zones", "koppa")
	
	if fyction_points == 0:
		StonyStatus.texture_hover = null
		VulcanicStatus.texture_hover = null
		FrozenStatus.texture_hover = null
		SwampStatus.texture_hover = null
		DesertStatus.texture_hover = null
		RadioactiveStatus.texture_hover = null
		DeltaStatus.texture_hover = null
		GammaStatus.texture_hover = null
		OmegaStatus.texture_hover = null
		KoppaStatus.texture_hover = null
		
		StonyStatus.texture_normal = blocked_sign
		VulcanicStatus.texture_normal = blocked_sign
		FrozenStatus.texture_normal = blocked_sign
		SwampStatus.texture_normal = blocked_sign
		DesertStatus.texture_normal = blocked_sign
		RadioactiveStatus.texture_normal = blocked_sign
		DeltaStatus.texture_normal = blocked_sign
		GammaStatus.texture_normal = blocked_sign
		OmegaStatus.texture_normal = blocked_sign
		KoppaStatus.texture_normal = blocked_sign
	
	if stony_unlocked == true: StonyStatus.texture_normal = yes_sign; StonyStatus.texture_hover = null
	if vulcanic_unlocked == true: VulcanicStatus.texture_normal = yes_sign; VulcanicStatus.texture_hover = null
	if frozen_unlocked == true: FrozenStatus.texture_normal = yes_sign; FrozenStatus.texture_hover = null
	if swamp_unlocked == true: SwampStatus.texture_normal = yes_sign; SwampStatus.texture_hover = null
	if desert_unlocked == true: DesertStatus.texture_normal = yes_sign; DesertStatus.texture_hover = null
	if radioactive_unlocked == true: RadioactiveStatus.texture_normal = yes_sign; RadioactiveStatus.texture_hover = null
	
	if delta_unlocked == true: DeltaStatus.texture_normal = yes_sign; DeltaStatus.texture_hover = null
	if gamma_unlocked == true: GammaStatus.texture_normal = yes_sign; GammaStatus.texture_hover = null
	if omega_unlocked == true: OmegaStatus.texture_normal = yes_sign; OmegaStatus.texture_hover = null
	if koppa_unlocked == true: KoppaStatus.texture_normal = yes_sign; KoppaStatus.texture_hover = null
	
	################################################################################################
	
	var light_unlocked : bool = license_config.get_value("tools", "light")
	var flashlight_unlocked : bool = license_config.get_value("tools", "uv_flashlight")
	var radar_the_tool_unlocked : bool = license_config.get_value("tools", "radar_the_tool")
	var radar_the_enemies_unlocked : bool = license_config.get_value("tools", "radar_the_enemies")
	
	if fyction_points == 0:
		LightStatus.texture_hover = null
		FlashlightStatus.texture_hover = null
		RadarTheToolStatus.texture_hover = null
		RadarTheEnemiesStatus.texture_hover = null
		
		LightStatus.texture_normal = blocked_sign
		FlashlightStatus.texture_normal = blocked_sign
		RadarTheToolStatus.texture_normal = blocked_sign
		RadarTheEnemiesStatus.texture_normal = blocked_sign
	
	if light_unlocked == true: LightStatus.texture_normal = yes_sign; LightStatus.texture_hover = null
	if flashlight_unlocked == true: FlashlightStatus.texture_normal = yes_sign; FlashlightStatus.texture_hover = null
	if radar_the_tool_unlocked == true: RadarTheToolStatus.texture_normal = yes_sign; RadarTheToolStatus.texture_hover = null
	if radar_the_enemies_unlocked == true: RadarTheEnemiesStatus.texture_normal = yes_sign; RadarTheEnemiesStatus.texture_hover = null
	

func update_levels():
	var license_config := ConfigFile.new()
	license_config.load(license_path)
	
	var current_experience = license_config.get_value("license", "experience")
	var current_level = license_config.get_value("license", "current_level")
	var current_fyction_points = license_config.get_value("license", "fyction_points")
	
	var experience_required = 60 + current_level * 15
	
	while current_experience >= experience_required:
		current_experience -= experience_required
		current_level += 1
		current_fyction_points += 1
		
		experience_required = 75 + current_level * 25
	
	# Update values only once after the loop
	license_config.set_value("license", "experience", current_experience)
	license_config.set_value("license", "current_level", current_level)
	license_config.set_value("license", "fyction_points", current_fyction_points)
	
	fyction_points = current_fyction_points
	
	license_config.save(license_path)
	update_blocked_content()
	
	$FyctionLevelProgress.text = \
		str("Level: ", str(current_level)," | ", str(current_experience)," / ", experience_required ,"XP")
	$FyctionPointsSprite/PointsAvailableLabel.text = str(current_fyction_points)

func start_hotbar():
	add_stater_pack()
	get_selected_hotbar_items()

func add_stater_pack():
	var license_config := ConfigFile.new()
	license_config.load(license_path)
	
	add_item_to_all_dropdowns(NothingTexture, "Nothing")
	add_item_to_all_dropdowns(SwordTexture, "Sword")
	add_item_to_all_dropdowns(PickaxeTexture, "Pickaxe")
	
	if license_config.get_value("tools", "light") == true: add_item_to_all_dropdowns(LightTexture, "Light")
	if license_config.get_value("tools", "uv_flashlight") == true: add_item_to_all_dropdowns(FlashlightTexture, "UV Flaslight")
	if license_config.get_value("tools", "radar_the_tool") == true: add_item_to_all_dropdowns(RadarTheToolTexture, "Radar the Tool")
	if license_config.get_value("tools", "radar_the_enemies") == true: add_item_to_all_dropdowns(RadarTheEnemiesTexture, "Radar the Enemies")

func add_item_to_all_dropdowns(texture : Texture, Name : String):
	for dropdown in hotbar_dropdowns:
		dropdown.add_icon_item(texture, Name)

func get_selected_hotbar_items():
	var hotbar_config := ConfigFile.new()
	hotbar_config.load(hotbar_path)
	
	for i in range(hotbar_dropdowns.size()):
		var item_name = hotbar_config.get_value("hotbar", str(i))
		var dropdown = hotbar_dropdowns[i]
		var index = get_item_index_by_text(dropdown, item_name)
		if index != -1:
			dropdown.select(index)

func get_item_index_by_text(dropdown: OptionButton, text: String) -> int:
	for i in range(dropdown.item_count):
		if dropdown.get_item_text(i) == text:
			return i
	return -1  # Not found

func _on_first_hotbar_dropdown_item_selected(index: int) -> void:
	set_hotbar_item(0, $FirstHotbarDropdown.get_item_text(index))

func _on_second_hotbar_dropdown_item_selected(index: int) -> void:
	set_hotbar_item(1, $SecondHotbarDropdown.get_item_text(index))

func _on_third_hotbar_dropdown_item_selected(index: int) -> void:
	set_hotbar_item(2, $ThirdHotbarDropdown.get_item_text(index))

func _on_fourth_hotbar_dropdown_item_selected(index: int) -> void:
	set_hotbar_item(3, $FourthHotbarDropdown.get_item_text(index))

func set_hotbar_item(index : int, Name : String):
	var hotbar_config := ConfigFile.new()
	hotbar_config.load(hotbar_path)
	hotbar_config.set_value("hotbar", str(index), Name)
	hotbar_config.save(hotbar_path)
