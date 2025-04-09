extends Control

var cheats : bool = false
var cheated_item_icon = preload("res://assets/textures/items/cheated_item.png")

func _ready():
	visible = false
	var cheats_path = str("user://save/", GetSaveFile.save_being_used, "/cheats.cfg")
	var cheats_config = ConfigFile.new()
	cheats_config.load(cheats_path)
	cheats = cheats_config.get_value("cheating", "enabled", false)
	print(cheats)

func _input(_event):
	if Input.is_action_just_pressed("Cheat_Menu") and cheats == true:
		match get_tree().current_scene.name:
			"AsteroidSelector":
				position = Vector2(960, 600)
				$Container/WorldLabel/GiveItems.disabled = true
				$Container/WorldLabel/ChangePosition.disabled = true
				$Container/WorldLabel/ChangeOxygen.disabled = true
				$Container/WorldLabel/ChangeHealth.disabled = true
				$Container/WorldLabel/ChangeUVBattery.disabled = true
				$Container/WorldLabel/DuckTheDeath.disabled = true
			"World":
				position = Vector2(0, 0)
				$Container/LobbyLabel/ChangeDay.disabled = true
				$Container/LobbyLabel/ChangeMoney.disabled = true
				$Container/LobbyLabel/AdvanceStockMartket.disabled = true
				$Container/LobbyLabel/RerollMissions.disabled = true
		
		if visible == true:
			visible = false
		elif visible == false:
			visible = true

func _on_change_day_pressed() -> void:
	if get_tree().current_scene.name == "AsteroidSelector":
		var new_day = $Container/LobbyLabel/ChangeDay/DayTextEdit.text
		var day_path = str("user://save/", GetSaveFile.save_being_used, "/day.cfg")
		var day_config = ConfigFile.new()
		day_config.set_value("day", "current", int(new_day))
		day_config.save(day_path)
		$"../LobbyPanel/MoneyPanel/DaysLabel".text = "Day: " + new_day
		print("[cheat_menu.gd] Day changed to: ", new_day)

func _on_change_money_pressed() -> void:
	if get_tree().current_scene.name == "AsteroidSelector":
		var new_money = $Container/LobbyLabel/ChangeMoney/MoneyTextEdit.text
		var money_path = str("user://save/", GetSaveFile.save_being_used, "/money.cfg")
		var money_config = ConfigFile.new()
		money_config.set_value("money", "current", int(new_money))
		money_config.save(money_path)
		$"../LobbyPanel/MoneyPanel/MoneyLabel".text = "Money: " + new_money + " €"
		print("[cheat_menu.gd] Money changed to: ", new_money)

func _on_advance_stock_martket_pressed() -> void:
	if get_tree().current_scene.name == "AsteroidSelector":
		# This code is from pause_menu.gd
		var companies_names : Array = ["Fyction", "Haznuclear", "Owlwing", "Bill", "Interstellar", "Anura", "Octane"]
		var hlines : Array = [10, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100]
		var market_path = str("user://save/", GetSaveFile.save_being_used, "/stock.cfg")
		var market_config = ConfigFile.new()
		market_config.load(market_path)
		var new_market : Dictionary = {}

		for companie in companies_names:
			for i in range(1, 13):
				var stock_value = market_config.get_value("stock", companie + str(i + 1))
				stock_value = Vector2(hlines[i - 1], stock_value.y)  
				new_market[companie + str(i)] = stock_value
			new_market[companie + str(13)] = Vector2(1188, randi_range(0, 800))
		
		for key in new_market.keys():
			market_config.set_value("stock", key, new_market[key])
		market_config.save(market_path)
		
		$"../../StockTheMarket".delete_older_graph()
		$"../../StockTheMarket".create_all_charts()

func _on_reroll_missions_pressed() -> void:
	if get_tree().current_scene.name == "AsteroidSelector":
		$"../../../..".current_page = 1
		$"../../../..".save_asteroid_data()
		$"../../../..".get_asteroid_info()
		$"../../../..".get_pages()
		print("[cheat_menu.gd] Rerolled Missions")

####################################################################################################
####################################################################################################
####################################################################################################

func _on_give_items_pressed() -> void:
	if get_tree().current_scene.name == "World":
		var new_item = $Container/WorldLabel/GiveItems/ItemTextEdit.text
		var new_amount = $Container/WorldLabel/GiveItems/AmountTextEdit.text
		$"../ItemList".add_item(str(new_item, " ", new_amount), cheated_item_icon)
		print("[cheat_menu.gd] Gave ", new_amount, " of ", new_item, "to Inventory")

func _on_change_position_pressed() -> void:
	if get_tree().current_scene.name == "World":
		var new_position = Vector2(float($Container/WorldLabel/ChangePosition/X_PositionTextEdit.text) * 16, float($Container/WorldLabel/ChangePosition/Y_PositionTextEdit.text) * 16)
		$"../..".position = new_position
		print("[cheat_menu.gd] Position changed to: ", new_position)

func _on_change_oxygen_pressed() -> void:
	if get_tree().current_scene.name == "World":
		var new_oxygen = $Container/WorldLabel/ChangeOxygen/OxygenTextEdit.text
		$"../.."/Camera2D/HUD/Stats/OxygenStat.value = int(new_oxygen) 
		$"../.."/Camera2D/HUD/Stats/OxygenStat/OxygenText.text = new_oxygen
		print("[cheat_menu.gd] Oxygen changed to: ", new_oxygen)

func _on_change_health_pressed() -> void:
	if get_tree().current_scene.name == "World":
		var new_health = $Container/WorldLabel/ChangeHealth/HealthTextEdit.text
		$"../.."/Camera2D/HUD/Stats/HealthStat.value = int(new_health)
		$"../.."/Camera2D/HUD/Stats/HealthStat/HealthText.text = new_health
		print("[cheat_menu.gd] Health changed to: ", new_health)

func _on_change_uv_battery_pressed() -> void:
	if get_tree().current_scene.name == "World":
		var new_uv_battery = $Container/WorldLabel/ChangeUVBattery/uvBatteryTextEdit.text
		$"../.."/Camera2D/HUD/Stats/uvStat.value = int(new_uv_battery)
		$"../.."/Camera2D/HUD/Stats/uvStat/uvText.text = new_uv_battery
		print("[cheat_menu.gd] UV Battery changed to: ", new_uv_battery)

func _on_duck_the_death_pressed() -> void:
	if get_tree().current_scene.name == "World":
		var get_bool = $Container/WorldLabel/DuckTheDeath/DeathTextEdit.text
		if get_bool == "true":
			$"../..".is_duck_dead = true
			$"../.."/Camera2D/HUD/Stats/HealthStat.value = 0
		elif get_bool == "false":
			$"../..".is_duck_dead = false
			$"../.."/Camera2D/HUD/Stats/HealthStat.value = 25
		print("[cheat_menu.gd] Duck the Death triggered")
