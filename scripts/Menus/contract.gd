extends Panel

var player_path : String = str("user://save/", GetSaveFile.save_being_used, "/player.cfg")
var player_config : ConfigFile = ConfigFile.new()

var statistics_path : String = str("user://save/", GetSaveFile.save_being_used, "/statistics.cfg")
var statistics_config : ConfigFile = ConfigFile.new()
var statistics_text : String = ""

var hotbar_slots : Array = []
var hotbar_slots_number : int = 0

func _ready() -> void:
	player_config.load(player_path)
	hotbar_slots_number = player_config.get_value("hotbar_slots", "number")
	for i in range(0, hotbar_slots_number):
		hotbar_slots.append(player_config.get_value("hotbar_slots", str(i)))
	$FirstHotbarDropdown.selected = select_hotbar_slot(hotbar_slots[0])
	$SecondHotbarDropdown.selected = select_hotbar_slot(hotbar_slots[1])
	$ThirdHotbarDropdown.selected = select_hotbar_slot(hotbar_slots[2])
	$FourthHotbarDropdown.selected = select_hotbar_slot(hotbar_slots[3])
	
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
	
	statistics_text += str("Oxygen Consumed: ", oxygen_used,"u\n")
	statistics_text += str("Energy Battery Used: ", battery_used,"W\n")
	statistics_text += str("Damage Received: ", damage_received, "\n")
	statistics_text += str("Damage Dealt: ", damage_dealt, "\n")
	statistics_text += str("Enemies Killed: ", enemies_killed, "\n")
	statistics_text += str("Blocks Mined: ", blocks_mined,"\n")
	statistics_text += str("Time Working: ", time_working, "s\n")
	statistics_text += str("Time Resting: ", time_resting, "s\n")
	statistics_text += str("Days at Fyction: ", current_day)
	$StatisticsLabel.text = statistics_text
	

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
		0: player_config.set_value("hotbar_slots", str(slot_number), "Sword")
		1: player_config.set_value("hotbar_slots", str(slot_number), "Pickaxe")
		2: player_config.set_value("hotbar_slots", str(slot_number), "Light")
		3: player_config.set_value("hotbar_slots", str(slot_number), "UV Flashlight")
		4: player_config.set_value("hotbar_slots", str(slot_number), "Radar the Tool")
		5: player_config.set_value("hotbar_slots", str(slot_number), "Radar the Enemies")
	player_config.save(player_path)
	print("[contract.gd] Changed Slot [", str(slot_number), "] to: ", player_config.get_value("hotbar_slots", str(slot_number)))

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
	
