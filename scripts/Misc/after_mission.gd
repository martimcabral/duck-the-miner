extends Node2D

var difficulty_path : String = str("user://save/", GetSaveFile.save_being_used, "/difficulty.cfg")
var player_path : String = str("user://save/", GetSaveFile.save_being_used, "/player.cfg")
var money_path : String = str("user://save/", GetSaveFile.save_being_used, "/money.cfg")
var stock_path : String = str("user://save/", GetSaveFile.save_being_used, "/stock.cfg")
var day_path : String = str("user://save/", GetSaveFile.save_being_used, "/day.cfg")

var difficulty_config : ConfigFile = ConfigFile.new()
var player_config : ConfigFile = ConfigFile.new()
var money_config : ConfigFile = ConfigFile.new()
var stock_config : ConfigFile = ConfigFile.new()
var day_config : ConfigFile = ConfigFile.new()

var fyction_tax : float = 0.001
var fyction_interest : int = 0
var habitat_rental : int = 12000
var enable_health_insurance : bool = false
var health_insurance : int = 24000
var travel_destiny : String = "Delta"
var travel_rental : int = 2400
var oxygen_used : int = 360
var oxygen_price : int = 5
var oxygen_rental : int = 0
var sword_rental : int = 3000
var pickaxe_rental : int = 2575
var light_used : int = 87
var light_price : int = 125
var light_rental : int = 0
var uv_flashlight_rental : int = 4600
var radar_the_tool_rental : int = 6580

func _ready() -> void:
	difficulty_config.load(difficulty_path)
	player_config.load(player_path)
	money_config.load(money_path)
	stock_config.load(stock_path)
	day_config.load(day_path)
	
	var difficulty = difficulty_config.get_value("difficulty", "current")
	print("[after_mission.gd] Difficulty: ", difficulty)
	more_days()
	forward_stock()
	
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
