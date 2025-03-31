extends Control

var companies_logos : Dictionary = {
	"Fyction": "res://assets/textures/companies/fyction_enterprise.png",
	"Haznuclear": "res://assets/textures/companies/haznuclear_power.png",
	"Owlwing": "res://assets/textures/companies/owlwing_laboratories_nobg.png",
	"Bill": "res://assets/textures/companies/bill_industries.png",
	"Interstellar": "res://assets/textures/companies/interstellar_logistics.png",
	"Anura": "res://assets/textures/companies/anura_jewelry.png"
}

func _on_fyction_button_pressed() -> void:
	$Timer.start()
	$CompanyLogo.texture = load(companies_logos["Fyction"])

func _on_haznuclear_button_pressed() -> void:
	$CompanyLogo.texture = load(companies_logos["Haznuclear"])

func _on_owlwing_button_pressed() -> void:
	$CompanyLogo.texture = load(companies_logos["Owlwing"])

func _on_bill_button_pressed() -> void:
	$CompanyLogo.texture = load(companies_logos["Bill"])

func _on_interstellar_button_pressed() -> void:
	$CompanyLogo.texture = load(companies_logos["Interstellar"])

func _on_anura_button_pressed() -> void:
	$CompanyLogo.texture = load(companies_logos["Anura"])

func _on_close_market_button_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	for x in range(0, $StockPanel.size.x, 100):
		for y in range(0, $StockPanel.size.y, 100):
			var vline = Line2D.new()
			vline.default_color = Color("36014d")
			vline.points = PackedVector2Array ([
				Vector2(x + 85, y + 40.5),
				Vector2(x + 85, 10)
			])
			$StockPanel.add_child(vline)
		
	for x in range(0, $StockPanel.size.x, 100):
		for y in range(0, $StockPanel.size.y, 100):
			var hline = Line2D.new()
			hline.default_color = Color("36014d")
			hline.points = PackedVector2Array ([
				Vector2(x + 10, y + 18),
				Vector2(1190, y + 18)
			])
			$StockPanel.add_child(hline)

func _on_timer_timeout() -> void:
	fyction_chart()

func fyction_chart():
	var line = Line2D.new()
	line.width = 10
	#line.default_color = Color("00CFFF")
	line.default_color = Color(randf(), randf(), randf())
	line.z_index = 1
	
	var curve = Curve2D.new()
	for i in range(0, $StockPanel.size.x, 50):
		curve.add_point(Vector2(i, randi_range(800, 0)))
	curve.bake_interval = 2
	var curve_points = curve.get_baked_points()
	
	line.points = curve_points
	$StockPanel.add_child(line)
