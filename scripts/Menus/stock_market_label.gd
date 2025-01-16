extends RichTextLabel

var consoantes = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']
var vogais = ['a', 'e', 'i', 'o', 'u']

func _ready() -> void:
	create_stock_market()

func create_stock_market():
	var consoante1 = consoantes[randi() % consoantes.size()]
	var consoante2 = consoantes[randi() % consoantes.size()]
	var vogal1 = vogais[randi() % vogais.size()]
	var vogal2 = vogais[randi() % vogais.size()]
	
	var variante = randi_range(1, 4)
	
	var money_word : String
	match variante: # 4 935 Variações
		1:
			money_word = vogal1 + consoante1 + consoante2
		2:
			money_word = consoante1 + vogal1 + consoante2
		3:
			money_word = vogal1 + vogal2 + consoante1
		4:
			money_word = consoante1 + vogal1 + vogal2
	
	var random_percentage = round(randf_range(0, 2) * 100) / 100.0
	
	match randi_range(1,2):
		1: 
			self.add_theme_color_override("default_color", Color(0, 0.92, 0))
			self.text = "[center]%s[/center]" % money_word.to_upper() + " +" + str(random_percentage) + "%"
		2: 
			self.add_theme_color_override("default_color", Color(0.92, 0, 0))
			self.text = "[center]%s[/center]" % money_word.to_upper() + " -" + str(random_percentage) + "%"

func _on_stock_market_timer_timeout() -> void:
	create_stock_market()
