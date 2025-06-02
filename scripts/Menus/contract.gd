extends Panel

var license_config := ConfigFile.new()
var license_path : String = str("user://save/", GetSaveFile.save_being_used, "/license.cfg")

var hotbar_config := ConfigFile.new()
var hotbar_path : String = str("user://save/", GetSaveFile.save_being_used, "/hotbar.cfg")

var statistics_config := ConfigFile.new()
var statistics_path : String = str("user://save/", GetSaveFile.save_being_used, "/statistics.cfg")
var statistics_text : String = ""

var hotbar_slots : Array = []
var hotbar_slots_number : int = 0

@onready var HealthUpgradeSlots = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Health/HBoxContainer/UpgradeSlots
@onready var OxygenUpgradeSlots = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Oxygen/HBoxContainer/UpgradeSlots
@onready var BatteryUpgradeSlots = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Battery/HBoxContainer/UpgradeSlots
@onready var SpeedUpgradeSlots = $ScrollContainer/MarginContainer/LicenseTree/LeftSide/Duck/Speed/HBoxContainer/UpgradeSlots
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

@onready var yes_sign = preload("res://assets/textures/menus/yes.png")

func _ready() -> void:
	hotbar_config.load(hotbar_path)
	hotbar_slots_number = hotbar_config.get_value("hotbar_slots", "number")
	for i in range(0, hotbar_slots_number):
		hotbar_slots.append(hotbar_config.get_value("hotbar_slots", str(i)))
	$FirstHotbarDropdown.selected = select_hotbar_slot(hotbar_slots[0])
	$SecondHotbarDropdown.selected = select_hotbar_slot(hotbar_slots[1])
	$ThirdHotbarDropdown.selected = select_hotbar_slot(hotbar_slots[2])
	$FourthHotbarDropdown.selected = select_hotbar_slot(hotbar_slots[3])
	
	################################################################################################
	
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
	
	license_config.load(license_path)
	var experience = license_config.get_value("license", "experience")
	var level = license_config.get_value("license", "current_level")
	$FyctionLevelProgress.text = str("Level: ", str(level)," | ", str(experience)," / 100 XP")
	var available_levels = license_config.get_value("license", "available_levels")
	$FyctionPointsSprite/PointsAvailableLabel.text = str(available_levels)
	
	var maximum_health_levels = license_config.get_value("duck", "max_health_levels")
	var maximum_oxygen_levels = license_config.get_value("duck", "max_oxygen_levels")
	var maximum_battery_levels = license_config.get_value("duck", "max_battery_levels")
	var maximum_speed_levels = license_config.get_value("duck", "max_speed_levels")
	var maximum_sword_levels = license_config.get_value("tools", "max_sword_levels")
	var maximum_pickaxe_levels = license_config.get_value("tools", "max_pickaxe_levels")
	
	var current_health_levels = license_config.get_value("duck", "health_level")
	var current_oxygen_levels = license_config.get_value("duck", "oxygen_level")
	var current_battery_levels = license_config.get_value("duck", "battery_level")
	var current_speed_levels = license_config.get_value("duck", "speed_level")
	var current_sword_levels = license_config.get_value("tools", "sword_level")
	var current_pickaxe_levels = license_config.get_value("tools", "pickaxe_level")
	
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
	
	for levels in maximum_speed_levels:
		var new_slot := TextureRect.new()
		new_slot.texture = load("res://assets/textures/menus/off.png")
		SpeedUpgradeSlots.add_child(new_slot)
		
	for levels in maximum_sword_levels:
		var new_slot := TextureRect.new()
		new_slot.texture = load("res://assets/textures/menus/off.png")
		SwordUpgradeSlots.add_child(new_slot)
		
	for levels in maximum_pickaxe_levels:
		var new_slot := TextureRect.new()
		new_slot.texture = load("res://assets/textures/menus/off.png")
		PickaxeUpgradeSlots.add_child(new_slot)
		
	for i in range(0, current_health_levels):
		HealthUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
	
	for i in range(0, current_oxygen_levels):
		OxygenUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
	
	for i in range(0, current_battery_levels):
		BatteryUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
		
	for i in range(0, current_speed_levels):
		SpeedUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
	
	for i in range(0, current_sword_levels):
		SwordUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
	
	for i in range(0, current_pickaxe_levels):
		PickaxeUpgradeSlots.get_child(i).texture = load("res://assets/textures/menus/on.png")
		
	################################################################################################
	
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
	
	if stony_unlocked == true: StonyStatus.texture_normal = yes_sign
	if vulcanic_unlocked == true: VulcanicStatus.texture_normal = yes_sign
	if frozen_unlocked == true: FrozenStatus.texture_normal = yes_sign
	if swamp_unlocked == true: SwampStatus.texture_normal = yes_sign
	if desert_unlocked == true: DesertStatus.texture_normal = yes_sign
	if radioactive_unlocked == true: RadioactiveStatus.texture_normal = yes_sign
	
	if delta_unlocked == true: DeltaStatus.texture_normal = yes_sign
	if gamma_unlocked == true: GammaStatus.texture_normal = yes_sign
	if omega_unlocked == true: OmegaStatus.texture_normal = yes_sign
	if koppa_unlocked == true: KoppaStatus.texture_normal = yes_sign

func _on_first_hotbar_dropdown_item_selected(index: int) -> void:
	change_hotbar_slot(index, 0)

func _on_second_hotbar_dropdown_item_selected(index: int) -> void:
	change_hotbar_slot(index, 1)

func _on_third_hotbar_dropdown_item_selected(index: int) -> void:
	change_hotbar_slot(index, 2)

func _on_fourth_hotbar_dropdown_item_selected(index: int) -> void:
	change_hotbar_slot(index, 3)

func change_hotbar_slot(item_index, slot_number):
	match item_index:
		0: hotbar_config.set_value("hotbar_slots", str(slot_number), "Sword")
		1: hotbar_config.set_value("hotbar_slots", str(slot_number), "Pickaxe")
		2: hotbar_config.set_value("hotbar_slots", str(slot_number), "Light")
		3: hotbar_config.set_value("hotbar_slots", str(slot_number), "UV Flashlight")
		4: hotbar_config.set_value("hotbar_slots", str(slot_number), "Radar the Tool")
		5: hotbar_config.set_value("hotbar_slots", str(slot_number), "Radar the Enemies")
	hotbar_config.save(hotbar_path)
	print("[contract.gd] Changed Slot [", str(slot_number), "] to: ", hotbar_config.get_value("hotbar_slots", str(slot_number)))

func select_hotbar_slot(hotbar_slot):
	match hotbar_slot:
		"Sword": return 0
		"Pickaxe": return 1
		"Light": return 2
		"UV Flashlight": return 3
		"Radar the Tool": return 4
		"Radar the Enemies": return 5

func _on_exit_button_pressed() -> void:
	$AnimationPlayer.play("bread")

func _on_more_resting_time_timeout() -> void:
	statistics_config.load(statistics_path)
	var new_time_resting = 1 + statistics_config.get_value("statistics", "time_resting")
	statistics_config.set_value("statistics", "time_resting", new_time_resting)
	statistics_config.save(statistics_path)
