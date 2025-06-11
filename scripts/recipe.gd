@tool
extends Button

@export_category("Button Status")
@export var button_status : bool = false

@export_category("Button Textures")
@export var new_resource_texture : Texture = load("")
@export var new_resource_name : String = ""
@export var new_resource_amount : int = 0
@export var alt_resource_texture: Texture = load("")
@export var alt_resource_name : String = ""

@export_category("Ingredient Numero Uno")
@export var texture_1 : Texture = load("")
@export var name_1 : String = ""
@export var amount_1 : int = 0

@export_category("Ingredient Numero Duos")
@export var texture_2 : Texture = load("")
@export var name_2 : String = ""
@export var amount_2 : int = 0

@export_category("Ingredient Numero Tres")
@export var texture_3 : Texture = load("")
@export var name_3 : String = ""
@export var amount_3 : int = 0

@export_category("Ingredient Numero Quatro")
@export var texture_4 : Texture = load("")
@export var name_4 : String = ""
@export var amount_4 : int = 0

@export_category("Ingredient Numero Chinco")
@export var texture_5 : Texture = load("")
@export var name_5 : String = ""
@export var amount_5 : int = 0

@export_category("Ingredient Numero Seix")
@export var texture_6 : Texture = load("")
@export var name_6 : String = ""
@export var amount_6 : int = 0


func _ready() -> void:
	self.icon = new_resource_texture
	$AlternativeResource.texture = alt_resource_texture
	$RecipeTooltip/Label.text = str(new_resource_name, " x", new_resource_amount, " ", alt_resource_name)

func _process(delta):
	if Engine.is_editor_hint():
		self.icon = new_resource_texture
		$AlternativeResource.texture = alt_resource_texture
		
		var stylebox := self.get_theme_stylebox("normal")
		if stylebox is StyleBoxFlat:
			if button_status: stylebox.border_color = Color.LIME_GREEN
			else: stylebox.border_color = Color.FIREBRICK

func _on_pressed() -> void:
	pass # Replace with function body.

func _on_mouse_entered() -> void:
	$RecipeTooltip.visible = true

func _on_mouse_exited() -> void:
	$RecipeTooltip.visible = false
