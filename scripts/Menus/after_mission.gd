extends Node2D

var difficulty_path : String = str("user://save/", GetSaveFile.save_being_used, "/difficulty.cfg")
var hotbar_path : String = str("user://save/", GetSaveFile.save_being_used, "/hotbar.cfg")
var money_path : String = str("user://save/", GetSaveFile.save_being_used, "/money.cfg")
var stock_path : String = str("user://save/", GetSaveFile.save_being_used, "/stock.cfg")
var statistics_path : String = str("user://save/", GetSaveFile.save_being_used, "/statistics.cfg")

var difficulty_config : ConfigFile = ConfigFile.new()
var hotbar_config : ConfigFile = ConfigFile.new()
var money_config : ConfigFile = ConfigFile.new()
var stock_config : ConfigFile = ConfigFile.new()
var statistics_config : ConfigFile = ConfigFile.new()

var primary_mission_completed : bool = false
var primary_mission_award : int = 14000
var secondary_mission_completed : bool = false
var secondary_mission_award : int = 9000
var bonus : int = 0

var fyction_tax : float = 0.000001
var fyction_interest : int = 0

var habitat_rental : int = 8500

var did_player_died : bool = false
var health_insurance : int = 0

var travel_destiny : String
var travel_rental : float = 2400

var oxygen_used : int = 0
var oxygen_price : int = 5
var oxygen_rental : int = 0

var sword_rental : int = 1500
var has_sword : bool = false

var pickaxe_rental : int = 1575
var has_pickaxe : bool = false

var uv_flashlight_rental : int = 2500
var has_uv_flashlight : bool = false

var radar_the_tool_rental : int = 4500
var has_radar_the_tool : bool = false

var radar_the_enemies_rental : int = 6500
var has_radar_the_enemies : bool = false

var lights_used : int = 0
var light_price : int = 125
var light_rental : int = 0

var has_lights : bool = false

var total : int = 0
var fees_label : String = ""
var fees_values : String = ""

func _ready() -> void:
	$FyctionTax/PrintingAnimation.play("appear")
	$FyctionTax/WhooshSoundEffect.play()
	
	difficulty_config.load(difficulty_path)
	hotbar_config.load(hotbar_path)
	money_config.load(money_path)
	stock_config.load(stock_path)
	statistics_config.load(statistics_path)
	
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
		match difficulty:
			"easy": health_insurance = randi_range(24000, 32000)
			"normal": health_insurance = randi_range(48000, 64000)
			"hard": health_insurance = randi_range(72000, 96000)
		total += health_insurance
		fees_label += "> Health Insurance\n"
		fees_values += str("[-", health_insurance,"€]\n")
	
	fees_label += "> Travel Costs\n"
	match travel_destiny:
		"Delta Belt": travel_rental = randi_range(1500, 2000)
		"Gamma Field": travel_rental = randi_range(4000, 4500)
		"Omega Field": travel_rental = randi_range(4000, 4500)
		"Koppa Belt": travel_rental = randi_range(9000, 10000)
	match difficulty:
		"easy": travel_rental *= 0.8
		"normal": travel_rental *= 1
		"hard": travel_rental *= 1.2
	fees_values += str("[", travel_destiny, ", -", travel_rental, "€]\n")
	@warning_ignore("narrowing_conversion")
	total += travel_rental
	
	fees_label += "> Oxygen Supply\n"
	match difficulty:
		"easy": oxygen_price = 4
		"normal": oxygen_price = 5
		"hard": oxygen_price = 6
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
	if has_lights == true:
		match difficulty:
			"easy": light_price = 115
			"normal": light_price = 125
			"hard": light_price = 135
		light_rental = lights_used * light_price
		fees_label += str("> ", lights_used, " * Lights Cost\n")
		fees_values += str("[", light_price, "€, -", light_rental,"€]\n")
		total += light_rental
	
	if primary_mission_completed == true:
		fees_label += str("> Primary Mission\n")
		match difficulty:
			"easy": primary_mission_award = 16000
			"normal": primary_mission_award = 14000
			"hard": primary_mission_award = 12000
		fees_values += str("[+", primary_mission_award,"€]\n")
		bonus += primary_mission_award
	if secondary_mission_completed == true:
		fees_label += str("> Seconday Mission\n")
		match difficulty:
			"easy": secondary_mission_award = 10000
			"normal": secondary_mission_award = 9000
			"hard": secondary_mission_award = 8000
		fees_values += str("[+", secondary_mission_award,"€]\n")
		bonus += secondary_mission_award
	$FyctionTax/FeesText.text = fees_label
	$FyctionTax/FeesValuesText.text = fees_values
	$FyctionTax/FeesTotal.text = str("Fees Total: -", total, "€ ─ Bonus: ", bonus,"€")
	
	
	adjust_money()

func more_days():
	var new_current_day = randi_range(1, 3) + statistics_config.get_value("statistics", "days")
	statistics_config.set_value("statistics", "days", new_current_day)
	statistics_config.save(statistics_path)

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
	var hotbar_slots_number = hotbar_config.get_value("hotbar_slots", "number")
	for i in range(0, hotbar_slots_number):
		match hotbar_config.get_value("hotbar_slots", str(i)):
			"Sword": has_sword = true
			"Pickaxe": has_pickaxe = true
			"Light": has_lights = true
			"UV Flashlight": has_uv_flashlight = true
			"Radar the Tool": has_radar_the_tool = true
			"Radar the Enemies": has_radar_the_enemies = true
	print("[after_mission.gd] Sword: ", has_sword, "; Pickaxe: ", has_pickaxe, "; Light: ", has_lights, "; UV Flashlight: ", has_uv_flashlight, "; Radar the Tool: ", has_radar_the_tool, "; Radar the Enemies: ", has_radar_the_enemies)

func adjust_money():
	var current_money = money_config.get_value("money", "current")
	current_money += (total * -1) + bonus
	money_config.set_value("money", "current", current_money)
	money_config.save(money_path)

func go_to_lobby():
	Input.set_custom_mouse_cursor(load("res://assets/textures/player/main_cursor.png"))
	var new_game_scene = load("res://scenes/lobby.tscn")
	get_tree().change_scene_to_packed(new_game_scene)
	new_game_scene.instantiate()

func _on_printing_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		$ColorBackground/GoToLobby.visible = true
	elif anim_name == "bye_bye":
		go_to_lobby()

func _on_go_to_lobby_pressed() -> void:
	$ColorBackground/GoToLobby.visible = false
	$FyctionTax/PrintingAnimation.play("bye_bye")
	$FyctionTax/WhooshSoundEffect.play()
