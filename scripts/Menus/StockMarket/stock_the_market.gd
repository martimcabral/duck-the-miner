extends Panel

var companies_names : Array = ["Fyction", "Haznuclear", "Owlwing", "Bill", "Interstellar", "Anura", "Octane"]

var companies_logos : Dictionary = {
	"Fyction": "res://assets/textures/companies/fyction_enterprise.png",
	"Haznuclear": "res://assets/textures/companies/haznuclear_power.png",
	"Owlwing": "res://assets/textures/companies/owlwing_laboratories_nobg.png",
	"Bill": "res://assets/textures/companies/bill_industries.png",
	"Interstellar": "res://assets/textures/companies/interstellar_logistics.png",
	"Anura": "res://assets/textures/companies/anura_jewelry.png",
	"Octane": "res://assets/textures/companies/octane_works.png",
	"Nothing": "res://assets/textures/equipment/others/the_nothing.png"
}

func _process(_delta):
	for linha in $Background/StockPanel.get_children():
		if linha is Line2D:
			if linha.is_in_group("PressedStock"):
				linha.visible = true
			else:
				linha.visible = false

func _on_fyction_button_toggled(toggled_on: bool) -> void:
	check_graph(toggled_on, "Fyction")

func _on_haznuclear_button_toggled(toggled_on: bool) -> void:
	check_graph(toggled_on, "Haznuclear")

func _on_owlwing_button_toggled(toggled_on: bool) -> void:
	check_graph(toggled_on, "Owlwing")

func _on_bill_button_toggled(toggled_on: bool) -> void:
	check_graph(toggled_on, "Bill")

func _on_interstellar_button_toggled(toggled_on: bool) -> void:
	check_graph(toggled_on, "Interstellar")

func _on_anura_button_toggled(toggled_on: bool) -> void:
	check_graph(toggled_on, "Anura")

func _on_octane_button_toggled(toggled_on: bool) -> void:
	check_graph(toggled_on, "Octane")

func _on_close_market_button_pressed() -> void:
	$"../Lobby".visible = true
	$".".visible = false

func _ready() -> void:
	for button in get_tree().get_nodes_in_group("Buttons"):
		button.mouse_entered.connect(func(): _on_button_mouse_entered())
	
	if randi_range(0, 1) == 1 : DiscordRPC.details = "📈 Watching Stock the Market"
	else : DiscordRPC.details = "📉 Watching Stock the Market"
	DiscordRPC.refresh()
	
	for x in range(0, $Background/StockPanel.size.x, 100):
		for y in range(0, $Background/StockPanel.size.y, 100):
			var vline = Line2D.new()
			vline.default_color = Color("36014d")
			vline.set_meta("linename", "vline")
			vline.add_to_group("PressedStock")
			vline.points = PackedVector2Array ([
				Vector2(x + 85, y + 40.5),
				Vector2(x + 85, 10)
			])
			var hline = Line2D.new()
			hline.default_color = Color("36014d")
			hline.set_meta("linename", "hline")
			hline.add_to_group("PressedStock")
			hline.points = PackedVector2Array ([
				Vector2(x + 10, y + 18),
				Vector2(1190, y + 18)
			])
			$Background/StockPanel.add_child(vline)
			$Background/StockPanel.add_child(hline)
	
	if GetSaveFile.save_being_used != 0:
		create_chart("00CFFF", "Fyction")
		create_chart("e0163e", "Haznuclear")
		create_chart("d63ffc", "Owlwing")
		create_chart("ffc858", "Bill")
		create_chart("e45c24", "Interstellar")
		create_chart("14c020", "Anura")
		create_chart("e0d5d5", "Octane")

func create_chart(cor : Color, nome : String):
	var stored_chart_points : Array = []
	
	var get_stock_path = str("res://save/", GetSaveFile.save_being_used, "/stock.cfg")
	var get_stock = ConfigFile.new()
	get_stock.load(get_stock_path)
	
	for i in range(1, 14):
		stored_chart_points.append(get_stock.get_value("stock", nome + str(i), -1))
	
	var curve = Curve2D.new()
	for i in stored_chart_points.size():
		print("asd", stored_chart_points[i])
		curve.add_point(Vector2(stored_chart_points[i]))
	var curve_points = curve.get_baked_points()
	
	var line = Line2D.new()
	line.points = curve_points
	line.set_meta("linename", nome)
	line.add_to_group("PressedStock")
	line.width = 8
	line.z_index = 1
	line.default_color = cor
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	
	$Background/StockPanel.add_child(line)
func check_graph(toggled_on : bool, nome : String):
	$CompanyLogo.texture = load(companies_logos[nome])
	if toggled_on == true:
		for linha in $Background/StockPanel.get_children():
			if linha is Line2D:
				if linha.get_meta("linename") == nome:
					linha.add_to_group("PressedStock")
	elif toggled_on == false:
		for linha in $Background/StockPanel.get_children():
			if linha is Line2D:
				if linha.get_meta("linename") == nome:
					linha.remove_from_group("PressedStock")

func _on_button_mouse_entered() -> void:
	var mouse_sound = $Companies/MouseSoundEffects
	if mouse_sound:
		mouse_sound.stream = load("res://sounds/sound_effects/mining2.ogg")
		mouse_sound.pitch_scale = 5
		mouse_sound.play()
