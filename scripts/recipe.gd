@tool
extends Button

enum CraftingButtonTypes {Crafting, Alloying, Mettalurgic, Fluids, Advanced, Gem}
@export_category("Button Status")
@export var button_status : bool = false
@export var button_type : CraftingButtonTypes

@export_category("Button Textures")
@export var new_resource_texture : Texture = load("res://assets/textures/menus/null.png")
@export var new_resource_name : String = ""
@export var new_resource_amount : int = 0
@export var alt_resource_texture: Texture = load("res://assets/textures/menus/null.png")
@export var alt_resource_name : String = ""

@export_category("Ingredient 1")
@export var ingredient_1 : bool = false
@export var name_1 : String = ""
@export var amount_1 : int = 0
@export var texture_1 : Texture = load("res://assets/textures/menus/null.png")

@export_category("Ingredient 2")
@export var ingredient_2 : bool = false
@export var name_2 : String = ""
@export var amount_2 : int = 0
@export var texture_2 : Texture = load("res://assets/textures/menus/null.png")

@export_category("Ingredient 3")
@export var ingredient_3 : bool = false
@export var name_3 : String = ""
@export var amount_3 : int = 0
@export var texture_3 : Texture = load("res://assets/textures/menus/null.png")

@export_category("Ingredient 4")
@export var ingredient_4 : bool = false
@export var name_4 : String = ""
@export var amount_4 : int = 0
@export var texture_4 : Texture = load("res://assets/textures/menus/null.png")

@onready var Ingredient_1_Texture = $RecipeTooltip/RecipeList/ItemsDeCima/Item1/Texture
@onready var Ingredient_1_Label = $RecipeTooltip/RecipeList/ItemsDeCima/Item1/Label
@onready var Ingredient_2_Texture = $RecipeTooltip/RecipeList/ItemsDeCima/Item2/Texture
@onready var Ingredient_2_Label = $RecipeTooltip/RecipeList/ItemsDeCima/Item2/Label
@onready var Ingredient_3_Texture = $RecipeTooltip/RecipeList/ItemsDeBaixo/Item1/Texture
@onready var Ingredient_3_Label = $RecipeTooltip/RecipeList/ItemsDeBaixo/Item1/Label
@onready var Ingredient_4_Texture = $RecipeTooltip/RecipeList/ItemsDeBaixo/Item2/Texture
@onready var Ingredient_4_Label = $RecipeTooltip/RecipeList/ItemsDeBaixo/Item2/Label

@onready var CraftingPanel = $"../../.."

var raw_resources_path = 

func _ready() -> void:
	self.icon = new_resource_texture
	$AlternativeResource.texture = alt_resource_texture
	$RecipeTooltip/Label.text = str(new_resource_name, " x", new_resource_amount, " ", alt_resource_name)
	$RecipeTooltip.visible = false
	
	if ingredient_1 == true:
		Ingredient_1_Texture.texture = texture_1; Ingredient_1_Label.text = str(name_1, " (x", amount_1, ")")
	else: remove_item(1)
	if ingredient_2 == true:
		Ingredient_2_Texture.texture = texture_2; Ingredient_2_Label.text = str(name_2, " (x", amount_2, ")")
	else: remove_item(2)
	if ingredient_3 == true:
		Ingredient_3_Texture.texture = texture_3; Ingredient_3_Label.text = str(name_3, " (x", amount_3, ")")
	else: remove_item(3)
	if ingredient_4 == true:
		Ingredient_4_Texture.texture = texture_4; Ingredient_4_Label.text = str(name_4, " (x", amount_4, ")")
	else: remove_item(4)

func remove_item(SlotNumber):
	match SlotNumber:
		1: $RecipeTooltip/RecipeList/ItemsDeCima/Item1.queue_free()
		2: $RecipeTooltip/RecipeList/ItemsDeCima/Item2.queue_free()
		3: $RecipeTooltip/RecipeList/ItemsDeBaixo/Item1.queue_free()
		4: $RecipeTooltip/RecipeList/ItemsDeBaixo/Item2.queue_free()

func _process(_delta):
	detect_status()
	
	if not Engine.is_editor_hint():
		var tooltip_size = $RecipeTooltip.size
		var mouse_pos = get_local_mouse_position()
		var viewport_size = get_viewport_rect().size
		var global_pos = get_global_mouse_position()
		
		var offset = Vector2(15, 35)
		
		# Adjust horizontal position if too close to right edge
		if global_pos.x + tooltip_size.x + offset.x > viewport_size.x:
			offset.x = -tooltip_size.x - 15
		
		# Adjust vertical position if too close to bottom edge
		if global_pos.y + tooltip_size.y + offset.y > viewport_size.y:
			offset.y = -tooltip_size.y - 15
			
		$RecipeTooltip.position = mouse_pos + offset
	
	if Engine.is_editor_hint():
		self.icon = new_resource_texture
		$AlternativeResource.texture = alt_resource_texture

func _on_mouse_entered() -> void:
	$RecipeTooltip.visible = true
	if has_node("%ItemsDeBaixo"):
		if ingredient_3 == false and ingredient_4 == false:
			%ItemsDeBaixo.queue_free()
			$RecipeTooltip.size = Vector2($RecipeTooltip.custom_minimum_size.x, $RecipeTooltip.custom_minimum_size.y)

func _on_mouse_exited() -> void:
	$RecipeTooltip.visible = false

func detect_status():
	var stylebox := self.get_theme_stylebox("normal")
	if stylebox is StyleBoxFlat:
		if button_status: stylebox.border_color = Color("00b54c")
		else: stylebox.border_color = Color.FIREBRICK

func _on_pressed() -> void:
	self.set_focus_mode(FOCUS_NONE)
	print(CraftingPanel.amount_Amazonite)

func recipe_ice_to_water():
	

func recipe_condensed_ice_to_water():
	

func recipe_sulfuric_acid():
	
