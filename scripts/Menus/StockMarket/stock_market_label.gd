extends RichTextLabel

var empresas = ["FYC", "HAZ", "OWL", "BIL", "INT", "ANU", "OCT"]

func _ready() -> void:
	create_stock_market()

func create_stock_market():
	var random_percentage = round(randf_range(0, 2) * 100) / 100.0
	match randi_range(1,2):
		1: 
			self.add_theme_color_override("default_color", Color(0, 0.92, 0))
			self.text = "[center]%s[/center]" % empresas[randi() % empresas.size()] + " +" + str(random_percentage) + "%"
		2: 
			self.add_theme_color_override("default_color", Color(0.92, 0, 0))
			self.text = "[center]%s[/center]" % empresas[randi() % empresas.size()] + " -" + str(random_percentage) + "%"

func _on_stock_market_timer_timeout() -> void:
	create_stock_market()
