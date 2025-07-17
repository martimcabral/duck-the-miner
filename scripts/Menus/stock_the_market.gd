extends Panel

var stock_label_string : String = ""

var companies_names : Array = ["Fyction", "Haznuclear", "Owlwing", "Bill", "Interstellar", "Anura", "Octane"]
var companies_names_short : Array = ["FYC", "HAZ", "OWL", "BIL", "INT", "ANU", "OCT"]
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

var companies_values : Dictionary = {
	"Fyction": 0.0,
	"Haznuclear": 0.0,
	"Owlwing": 0.0,
	"Bill": 0.0,
	"Interstellar": 0.0,
	"Anura": 0.0,
	"Octane": 0.0,
}

var companies_comparisons : Dictionary = {
	"Fyction": 0.0,
	"Haznuclear": 0.0,
	"Owlwing": 0.0,
	"Bill": 0.0,
	"Interstellar": 0.0,
	"Anura": 0.0,
	"Octane": 0.0,
}

func _process(_delta):
	for linha in $Background/StockPanel.get_children():
		if linha is Line2D:
			if linha.is_in_group("PressedStock"):
				linha.visible = true
			else:
				linha.visible = false

# Funções para os botões de toggle
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
	$AnimationPlayer.play("stock_the_down")

# Função chamada quando o botão de fechar o painel de ações é pressionado
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
	
	create_all_charts()
	get_companies_values()

# Função para criar o gráfico de ações de uma empresa
func create_chart(cor : Color, nome : String):
	var stored_chart_points : Array = []
	
	var get_stock_path = str("user://save/", GetSaveFile.save_being_used, "/stock.cfg")
	var get_stock = ConfigFile.new()
	get_stock.load(get_stock_path)
	
	for i in range(1, 14):
		stored_chart_points.append(get_stock.get_value("stock", nome + str(i), -1))
	
	var curve = Curve2D.new()
	for i in stored_chart_points.size():
		curve.add_point(Vector2(stored_chart_points[i]))
	var curve_points = curve.get_baked_points()
	
	var line = Line2D.new()
	line.points = curve_points
	line.set_meta("linename", nome)
	line.add_to_group("PressedStock")
	line.width = 6
	line.z_index = 1
	line.default_color = cor
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	
	$Background/StockPanel.add_child(line)

# Função para verificar se o gráfico de uma empresa está ativo ou não
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

# Função chamada quando o mouse entra no botão
func _on_button_mouse_entered() -> void:
	var mouse_sound = $Companies/MouseSoundEffects
	if mouse_sound:
		mouse_sound.stream = load("res://sounds/effects/mining/mining2.ogg")
		mouse_sound.pitch_scale = 5
		mouse_sound.play()

# Função para criar todos os gráficos de ações das empresas
func create_all_charts():
	if GetSaveFile.save_being_used != 0:
		create_chart("00CFFF", "Fyction")
		create_chart("e0163e", "Haznuclear")
		create_chart("d63ffc", "Owlwing")
		create_chart("ffc858", "Bill")
		create_chart("e45c24", "Interstellar")
		create_chart("14c020", "Anura")
		create_chart("e0d5d5", "Octane")

# Função para deletar os gráficos mais antigos, caso o jogador tenha mais de 13 dias de jogo
func delete_older_graph():
	if GetSaveFile.save_being_used != 0:
		for linha in $Background/StockPanel.get_children():
			for nome in companies_names:
				if linha is Line2D:
					if linha.get_meta("linename") == nome:
						linha.queue_free()

# Função para obter os valores das ações das empresas do arquivo de configuração
func get_companies_values():
	if GetSaveFile.save_being_used != 0:
		var get_stock_path = str("user://save/", GetSaveFile.save_being_used, "/stock.cfg")
		var get_stock = ConfigFile.new()
		get_stock.load(get_stock_path)
		
		for companie in companies_names:
			companies_values[companie] = get_stock.get_value("stock", companie + "13").y
			companies_comparisons[companie] = get_stock.get_value("stock", companie + "12").y
			companies_comparisons[companie] = companies_comparisons[companie] - companies_values[companie]
			
			companies_comparisons[companie] = clamp_stock(companies_comparisons[companie], -40, 40, -800, 800)
			companies_values[companie] = clamp_stock(companies_values[companie], -20, 20, 0, 800.0) * -1
		
		stock_label_string = ""
		stock_label_string += _colored(companies_comparisons["Fyction"], "FYC") + " | "
		stock_label_string += _colored(companies_comparisons["Haznuclear"], "HAZ") + " | "
		stock_label_string += _colored(companies_comparisons["Owlwing"], "OWL") + "\n"
		stock_label_string += _colored(companies_comparisons["Bill"], "BIL") + " | "
		stock_label_string += _colored(companies_comparisons["Interstellar"], "INT") + " | "
		stock_label_string += _colored(companies_comparisons["Anura"], "ANU") + " | "
		stock_label_string += _colored(companies_comparisons["Octane"], "OCT")
			
		$CurrentStockLabel.text = stock_label_string
		print("[stock_the_market.gd] Stock Label Full-String:", stock_label_string)
		print("[stock_the_market.gd] Companie Stocks: ", companies_values)
		print("[stock_the_market.gd] Companie Comparisons: ", companies_comparisons)

# Função para clamar os valores das ações, para que fiquem dentro de um intervalo específico
func clamp_stock(value: float, to_min : float, to_max : float, from_min : float, from_max):
	var new_value = (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min
	return clamp(new_value, to_min, to_max)

# Função para formatar o valor das ações com cores e sinal de mais, se necessário
func _colored(value: float, ticker: String) -> String: 
	var color := "#00b54c" if value >= 0 else "#ff3737"
	var plus_sign := "+" if value > 0 else ""
	return "[color=%s]%s %s%.1f%%[/color]" % [color, ticker, plus_sign, value]
