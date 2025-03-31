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

func _on_octo_button_pressed() -> void:
	pass # Replace with function body.

func _on_close_market_button_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	create_chart("00CFFF", "Fyction")
	create_chart("e0163e", "Haznuclear")
	create_chart("d63ffc", "Owlwing")
	create_chart("ffc858", "Bill")
	create_chart("e45c24", "Interstellar")
	create_chart("14c020", "Anura")
	create_chart("ffffff", "Octane")
	
	for linha in $StockPanel.get_children():
		if linha is Line2D:
			print(linha.get_meta("linename"))
	
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

func create_chart(cor, nome):
	var line = Line2D.new()
	line.width = 8
	line.default_color = Color(cor)
	line.z_index = 1
	line.set_meta("linename", nome)
	
	var curve = Curve2D.new()
	for i in range(0, $StockPanel.size.x, 117.5):
		curve.add_point(Vector2(i + 12.5, randi_range(0, 800)))
	var curve_points = curve.get_baked_points()
	
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.points = curve_points
	$StockPanel.add_child(line)
