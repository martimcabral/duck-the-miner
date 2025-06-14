@tool
extends Button

enum ItemCategory {Raw, Crafted}
enum CraftingButtonTypes {Crafting, Alloying, Mettalurgic, Fluids, Advanced, Gem}
@export_category("Button Info")
@export var button_status : bool = false
@export var button_type : CraftingButtonTypes
@export var level_required : int = 1

@export_category("Button Textures")
@export var new_resource_texture : Texture = load("res://assets/textures/menus/null.png")
@export var new_resource_name : String = ""
@export var new_resource_amount : int = 0
@export var new_resource_category : ItemCategory 
@export var alt_resource_texture: Texture = load("res://assets/textures/menus/null.png")
@export var alt_resource_name : String = ""

@export_category("Ingredient 1")
@export var ingredient_1 : bool = false
@export var name_1 : String = ""
@export var amount_1 : int = 0
@export var texture_1 : Texture = load("res://assets/textures/menus/null.png")
@export var category_1 : ItemCategory 

@export_category("Ingredient 2")
@export var ingredient_2 : bool = false
@export var name_2 : String = ""
@export var amount_2 : int = 0
@export var texture_2 : Texture = load("res://assets/textures/menus/null.png")
@export var category_2 : ItemCategory 

@export_category("Ingredient 3")
@export var ingredient_3 : bool = false
@export var name_3 : String = ""
@export var amount_3 : int = 0
@export var texture_3 : Texture = load("res://assets/textures/menus/null.png")
@export var category_3 : ItemCategory 

@export_category("Ingredient 4")
@export var ingredient_4 : bool = false
@export var name_4 : String = ""
@export var amount_4 : int = 0
@export var texture_4 : Texture = load("res://assets/textures/menus/null.png")
@export var category_4 : ItemCategory 

@export_category("Byproduct 1")
@export var byproduct_1 : bool = false
@export var byproduct_name_1 : String = ""
@export var byproduct_amount_1 : int = 0
@export var byproduct_texture_1 : Texture = load("res://assets/textures/menus/null.png")
@export var byproduct_category_1 : ItemCategory 

@export_category("Byproduct 2")
@export var byproduct_2 : bool = false
@export var byproduct_name_2 : String = ""
@export var byproduct_amount_2 : int = 0
@export var byproduct_texture_2 : Texture = load("res://assets/textures/menus/null.png")
@export var byproduct_category_2 : ItemCategory 

@onready var Ingredient_1_Texture = $RecipeTooltip/RecipeList/ItemsDeCima/Item1/Texture
@onready var Ingredient_1_Label = $RecipeTooltip/RecipeList/ItemsDeCima/Item1/Label
@onready var Ingredient_2_Texture = $RecipeTooltip/RecipeList/ItemsDeCima/Item2/Texture
@onready var Ingredient_2_Label = $RecipeTooltip/RecipeList/ItemsDeCima/Item2/Label
@onready var Ingredient_3_Texture = $RecipeTooltip/RecipeList/ItemsDeBaixo/Item1/Texture
@onready var Ingredient_3_Label = $RecipeTooltip/RecipeList/ItemsDeBaixo/Item1/Label
@onready var Ingredient_4_Texture = $RecipeTooltip/RecipeList/ItemsDeBaixo/Item2/Texture
@onready var Ingredient_4_Label = $RecipeTooltip/RecipeList/ItemsDeBaixo/Item2/Label

@onready var Byproduct_1_Texture = $RecipeTooltip/RecipeList/ItemsByproduct/Item1/Texture
@onready var Byproduct_1_Label = $RecipeTooltip/RecipeList/ItemsByproduct/Item1/Label
@onready var Byproduct_2_Texture = $RecipeTooltip/RecipeList/ItemsByproduct/Item2/Texture
@onready var Byproduct_2_Label = $RecipeTooltip/RecipeList/ItemsByproduct/Item2/Label

@onready var CraftingPanel = $"../../.."
@onready var Lobby = $"../../../../../.."
@onready var Contract = $"../../../../Contract"

var inventory_path : String = str("user://save/", GetSaveFile.save_being_used, "/inventory.cfg")
var inventory_config := ConfigFile.new()

func _ready() -> void:
	if Contract.current_level < level_required:
		self.queue_free()
	
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
	
	if byproduct_1 == true:
		Byproduct_1_Texture.texture = byproduct_texture_1; Byproduct_1_Label.text = str(byproduct_name_1, " (x", byproduct_amount_1, ")")
	else: remove_item(5)
	if byproduct_2 == true:
		Byproduct_2_Texture.texture = byproduct_texture_2; Byproduct_2_Label.text = str(byproduct_name_2, " (x", byproduct_amount_2, ")")
	else: remove_item(6)
	
	if byproduct_1 == false and byproduct_2 == false:
		$RecipeTooltip/RecipeList/ByproductLabel.queue_free()

func remove_item(SlotNumber):
	match SlotNumber:
		1: $RecipeTooltip/RecipeList/ItemsDeCima/Item1.queue_free()
		2: $RecipeTooltip/RecipeList/ItemsDeCima/Item2.queue_free()
		3: $RecipeTooltip/RecipeList/ItemsDeBaixo/Item1.queue_free()
		4: $RecipeTooltip/RecipeList/ItemsDeBaixo/Item2.queue_free()
		5: $RecipeTooltip/RecipeList/ItemsByproduct/Item1.queue_free()
		6: $RecipeTooltip/RecipeList/ItemsByproduct/Item2.queue_free()

func _process(_delta):
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

func _on_pressed() -> void:
	self.set_focus_mode(FOCUS_NONE)
	do_recipe()

func do_recipe():
	$"../../..".update_current_resources_amount()
	inventory_config.load(inventory_path)
	
	var has_ingredients : bool = false
	
	if ingredient_1 == true: has_ingredients = true && CraftingPanel.get(name_1.replace(" ", "")) >= amount_1
	if ingredient_2 == true: has_ingredients = true && CraftingPanel.get(name_2.replace(" ", "")) >= amount_2
	if ingredient_3 == true: has_ingredients = true && CraftingPanel.get(name_3.replace(" ", "")) >= amount_3
	if ingredient_4 == true: has_ingredients = true && CraftingPanel.get(name_4.replace(" ", "")) >= amount_4
	
	# Remove ingredients
	if has_ingredients == true:
		if ingredient_1 == true:
			match category_1:
				0: inventory_config.set_value("raw", name_1.replace(" ", " "), int(CraftingPanel.get(name_1.replace(" ", "")) - amount_1))
				1: inventory_config.set_value("crafted", name_1.replace(" ", " "), int(CraftingPanel.get(name_1.replace(" ", "")) - amount_1))
		if ingredient_2 == true:
			match category_2:
				0: inventory_config.set_value("raw", name_2.replace(" ", " "), int(CraftingPanel.get(name_2.replace(" ", "")) - amount_2))
				1: inventory_config.set_value("crafted", name_2.replace(" ", " "), int(CraftingPanel.get(name_2.replace(" ", "")) - amount_2))
		if ingredient_3 == true:
			match category_3:
				0: inventory_config.set_value("raw", name_3.replace(" ", " "), int(CraftingPanel.get(name_3.replace(" ", "")) - amount_3))
				1: inventory_config.set_value("crafted", name_3.replace(" ", " "), int(CraftingPanel.get(name_3.replace(" ", "")) - amount_3))
		if ingredient_4 == true:
			match category_4:
				0: inventory_config.set_value("raw", name_4.replace(" ", " "), int(CraftingPanel.get(name_4.replace(" ", "")) - amount_4))
				1: inventory_config.set_value("crafted", name_4.replace(" ", " "), int(CraftingPanel.get(name_4.replace(" ", "")) - amount_4))
		
		# Add main product
		match new_resource_category:
			0: inventory_config.set_value("raw", new_resource_name.replace(" ", " "), CraftingPanel.get(new_resource_name.replace(" ", "")) + new_resource_amount)
			1: inventory_config.set_value("crafted", new_resource_name.replace(" ", " "), CraftingPanel.get(new_resource_name.replace(" ", "")) + new_resource_amount)
		
		# Add byproducts
		if byproduct_1 == true:
			match byproduct_category_1:
				0: inventory_config.set_value("raw", byproduct_name_1.replace(" ", " "), CraftingPanel.get(byproduct_name_1.replace(" ", "")) + byproduct_amount_1)
				1: inventory_config.set_value("crafted", byproduct_name_1.replace(" ", " "), CraftingPanel.get(byproduct_name_1.replace(" ", "")) + byproduct_amount_1)
		
		if byproduct_2 == true:
			match byproduct_category_2:
				0: inventory_config.set_value("raw", byproduct_name_2.replace(" ", " "), CraftingPanel.get(byproduct_name_2.replace(" ", "")) + byproduct_amount_2)
				1: inventory_config.set_value("crafted", byproduct_name_2.replace(" ", " "), CraftingPanel.get(byproduct_name_2.replace(" ", "")) + byproduct_amount_2)
		
		inventory_config.save(inventory_path)
		inventory_config.clear()
		CraftingPanel.update_current_resources_amount()
		
		match Lobby.selected_inventory:
			0: Lobby._on_tab_bar_item_selected(0)
			1: Lobby._on_tab_bar_item_selected(1)
