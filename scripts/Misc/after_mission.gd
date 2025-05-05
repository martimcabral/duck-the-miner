extends Node2D

var difficulty_path : String = str("user://save/", 1, "/difficulty.cfg")
var player_path : String = str("user://save/", 1, "/player.cfg")
var money_path : String = str("user://save/", 1, "/money.cfg")
var stock_path : String = str("user://save/", 1, "/stock.cfg")
var day_path : String = str("user://save/", 1, "/day.cfg")

var difficulty_config : ConfigFile = ConfigFile.new()
var player_config : ConfigFile = ConfigFile.new()
var money_config : ConfigFile = ConfigFile.new()
var stock_config : ConfigFile = ConfigFile.new()
var day_config : ConfigFile = ConfigFile.new()

var fyction_tax : float = 0.0001
var fyction_interest : int = 0

var habitat_rental : int = 8500
var did_player_died : bool = false
var health_insurance : int = 0

var travel_destiny : String = "Delta Belt"
var travel_rental : int = 2400

var oxygen_used : int = 0
var oxygen_price : int = 5
var oxygen_rental : int = 0

var sword_rental : int = 3000
var has_sword : bool = false

var pickaxe_rental : int = 2575
var has_pickaxe : bool = false

var uv_flashlight_rental : int = 4500
var has_uv_flashlight : bool = false

var radar_the_tool_rental : int = 6375
var has_radar_the_tool : bool = false

var radar_the_enemies_rental : int = 8500
var has_radar_the_enemies : bool = false

var lights_used : int = 12
var light_price : int = 125
var light_rental : int = 0

var has_lights : bool = false

var total : int = 0
var fees_label : String = ""
var fees_values : String = ""

func _ready() -> void:
	difficulty_config.load(difficulty_path)
	player_config.load(player_path)
	money_config.load(money_path)
	stock_config.load(stock_path)
	day_config.load(day_path)
	
	var current_money = money_config.get_value("money", "current")
	fyction_interest = (current_money * fyction_tax) * -1
	
	var difficulty = difficulty_config.get_value("difficulty", "current")
	print("[after_mission.gd] Difficulty: ", difficulty)
	more_days()
	forward_stock()
	get_items()
	
	fees_label += "> Fyction Interest\n"
	fees_values += str("[", fyction_tax, "%, -", fyction_interest,"€]\n")
	total += fyction_interest

	fees_label += "> Habitat Rental\n"
	fees_values += str("[-", habitat_rental,"€]\n")
	total += habitat_rental
	
	if did_player_died == true:
		health_insurance = randi_range(36000, 48000)
		total += health_insurance
		fees_label += "> Health Insurance\n"
		fees_values += str("[-", health_insurance,"€]\n")
	
	fees_label += "> Travel Costs\n"
	match travel_destiny:
		"Delta Belt": travel_rental = randi_range(1500, 2750)
		"Gamma Field": travel_rental = randi_range(4300, 5200)
		"Omega Field": travel_rental = randi_range(4300, 5200)
		"Koppa Belt": travel_rental = randi_range(9400, 1155)
	fees_values += str("[", travel_destiny, ", -", travel_rental, "€]\n")
	total += travel_rental
	
	fees_label += "> Oxygen Supply\n"
	oxygen_rental = oxygen_used * oxygen_price
	fees_values += str("[",oxygen_used, ", -", oxygen_rental ,"€]\n")
	total += oxygen_rental
	
	
	if has_sword == true:
		fees_label += "> Sword Rental\n"
		fees_values += str("[-", sword_rental,"€]\n")
		total += sword_rental
	if has_pickaxe == true:
		fees_label += "> Pickaxe Rental\n"
		fees_values += str("[-", pickaxe_rental,"€]\n")
		total += sword_rental
	if has_lights == true:
		light_rental = lights_used * light_price
		fees_label += str("> ", lights_used, " * Lights Rental\n")
		fees_values += str("[", light_price, "€, -", light_rental,"€]\n")
		total += light_rental
	if has_uv_flashlight == true:
		fees_label += "> UV Flashlight Rental\n"
		fees_values += str("[-", uv_flashlight_rental,"€]\n")
		total += uv_flashlight_rental
	if has_radar_the_tool == true:
		fees_label += "> Radar the Tool Rental\n"
		fees_values += str("[-", radar_the_tool_rental,"€]\n")
		total += radar_the_tool_rental
	if has_radar_the_enemies == true:
		fees_label += "> Radar the Enemies Rental\n"
		fees_values += str("[-", radar_the_enemies_rental,"€]\n")
		total += radar_the_enemies_rental
	
	$FyctionTax/FeesText.text = fees_label
	$FyctionTax/FeesValuesText.text = fees_values
	$FyctionTax/FeesTotal.text = str("Fees Total: ", total, "€")
	
	$FyctionTax/PrintingAnimation.play("appear")
	$FyctionTax/WhooshSoundEffect.play()

func more_days():
	var current_day = day_config.get_value("day", "current")
	current_day += randi_range(1, 3)
	day_config.set_value("day", "current", current_day)
	day_config.save(day_path)

func forward_stock():
	var companies_names : Array = ["Fyction", "Haznuclear", "Owlwing", "Bill", "Interstellar", "Anura", "Octane"]
	var vlines : Array = [10, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100]
	var new_market : Dictionary = {}
	
	for companie in companies_names:
		for i in range(1, 13):
			var stock_value = stock_config.get_value("stock", companie + str(i + 1))
			stock_value = Vector2(vlines[i - 1], stock_value.y)  
			new_market[companie + str(i)] = stock_value
		new_market[companie + str(13)] = Vector2(1188, randi_range(0, 800))
		
	for key in new_market.keys():
		stock_config.set_value("stock", key, new_market[key])
	stock_config.save(stock_path)

func get_items():
	var hotbar_slots_number = player_config.get_value("hotbar_slots", "number")
	for i in range(0, hotbar_slots_number):
		match player_config.get_value("hotbar_slots", str(i)):
			"Sword": has_sword = true
			"Pickaxe": has_pickaxe = true
			"Light": has_lights = true
			"UV Flashlight": has_uv_flashlight = true
			"Radar the Tool": has_radar_the_tool = true
			"Radar the Enemies": has_radar_the_enemies = true
	print("[after_mission.gd] Sword: ", has_sword, "; Pickaxe: ", has_pickaxe, "; Light: ", has_lights, "; UV Flashlight: ", has_uv_flashlight, "; Radar the Tool: ", has_radar_the_tool, "; Radar the Enemies: ", has_radar_the_enemies)
