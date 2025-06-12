extends Panel

var amount_Stone : int = 0
var amount_Sandstone : int = 0
var amount_Gypsum : int = 0
var amount_Kaolinite : int = 0
var amount_Ice : int = 0
var amount_Coal : int = 0
var amount_Lava_Cluster : int = 0
var amount_Dense_Ice : int = 0
var amount_Sulfur : int = 0
var amount_Biomass : int = 0
var amount_Copper : int = 0
var amount_Iron : int = 0
var amount_Magnetite : int = 0
var amount_Bauxite : int = 0
var amount_Galena : int = 0
var amount_Silver : int = 0
var amount_Pyrolusite : int = 0
var amount_Wolframite : int = 0
var amount_Nickel : int = 0
var amount_Platinum : int = 0
var amount_Uranium : int = 0
var amount_Cobalt : int = 0
var amount_Zirconium : int = 0
var amount_Scheelite : int = 0
var amount_Pitchblende : int = 0
var amount_Phosphorite : int = 0
var amount_Hematite : int = 0
var amount_Oil_Shale : int = 0
var amount_Graphite : int = 0
var amount_Gold : int = 0
var amount_Emerald : int = 0
var amount_Diamond : int = 0
var amount_Ruby : int = 0
var amount_Sapphire : int = 0
var amount_Garnet : int = 0
var amount_Topaz : int = 0
var amount_Tsavorite : int = 0
var amount_Ametrine : int = 0
var amount_Apatite : int = 0
var amount_Azurite : int = 0
var amount_Charoite : int = 0
var amount_Sugilite : int = 0
var amount_Peridot : int = 0
var amount_Vanadinite : int = 0
var amount_Amazonite : int = 0
var amount_Bloodstone : int = 0
var amount_Chalcedony : int = 0
var amount_Chrysocolla : int = 0
var amount_Pietersite : int = 0
var amount_Labradorite : int = 0
var amount_Frozen_Diamond : int = 0
var amount_Jeremejevite : int = 0
var amount_Water : int = 0
var amount_Sulfuric_Acid : int = 0

var CurrentPanel : int = 0

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	hide_all_recipes()
	show_recipes()
	update_current_resources_amount()

func _on_crafting_icon_texture_button_pressed() -> void:
	$AnimationPlayer.play("grow")

func _on_close_crafting_tab_pressed() -> void:
	$AnimationPlayer.play_backwards("grow")

func _on_crafting_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/CraftingButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 0; show_recipes()
	$Navbar/Icons/CraftingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_alloying_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/AlloyingButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 1; show_recipes()
	$Navbar/Icons/AlloyingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_mettalurgic_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/MettalurgicButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 2; show_recipes()
	$Navbar/Icons/MettalurgicButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_fluids_refining_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/FluidsRefiningButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 3; show_recipes()
	$Navbar/Icons/FluidsRefiningButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_advanced_crafting_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/AdvancedCraftingButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 4; show_recipes()
	$Navbar/Icons/AdvancedCraftingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_gem_polishing_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/GemPolishingButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 5; show_recipes()
	$Navbar/Icons/GemPolishingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func reset_crafting_terminal():
	$Navbar/Icons/CraftingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/AlloyingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/MettalurgicButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/FluidsRefiningButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/AdvancedCraftingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/GemPolishingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	hide_all_recipes()

func hide_all_recipes():
	for recipe in get_children():
		if recipe.is_in_group("Recipe"):
			print("a")

func show_recipes():
	for recipe in $Recipes/FluidRefiningRecipes.get_children():
		if recipe is Button:
			if recipe.button_type == CurrentPanel: recipe.visible = true
			else: recipe.visible = false
		if recipe is Label:
			if int(recipe.editor_description) == CurrentPanel: recipe.visible = true
			else: recipe.visible = false

func update_current_resources_amount():
	var raw_resources_path : String = str("user://save/", GetSaveFile.save_being_used, "/inventory_resources.cfg")
	var raw_resources := ConfigFile.new()
	raw_resources.load(raw_resources_path)
	
	amount_Stone = raw_resources.get_value("inventory", "Stone", 0)
	amount_Sandstone = raw_resources.get_value("inventory", "Sandstone", 0)
	amount_Gypsum = raw_resources.get_value("inventory", "Gypsum", 0) 
	amount_Kaolinite = raw_resources.get_value("inventory", "Kaolinite", 0)
	amount_Ice = raw_resources.get_value("inventory", "Ice")
	amount_Coal = raw_resources.get_value("inventory", "Coal", 0)
	amount_Lava_Cluster = raw_resources.get_value("inventory", "Lava_Cluster", 0)
	amount_Dense_Ice = raw_resources.get_value("inventory", "Dense_Ice", 0)
	amount_Sulfur = raw_resources.get_value("inventory", "Sulfur", 0)
	amount_Biomass = raw_resources.get_value("inventory", "Biomass", 0)
	amount_Copper = raw_resources.get_value("inventory", "Copper", 0) 
	amount_Iron = raw_resources.get_value("inventory", "Iron", 0)
	amount_Magnetite = raw_resources.get_value("inventory", "Magnetite", 0)
	amount_Bauxite = raw_resources.get_value("inventory", "Bauxite", 0)
	amount_Galena = raw_resources.get_value("inventory", "Galena", 0)
	amount_Silver = raw_resources.get_value("inventory", "Silver", 0)
	amount_Pyrolusite = raw_resources.get_value("inventory", "Pyrolusite", 0)
	amount_Wolframite = raw_resources.get_value("inventory", "Wolframite", 0)
	amount_Nickel = raw_resources.get_value("inventory", "Nickel", 0)
	amount_Platinum = raw_resources.get_value("inventory", "Platinum", 0)
	amount_Uranium = raw_resources.get_value("inventory", "Uranium", 0)
	amount_Cobalt = raw_resources.get_value("inventory", "Cobalt", 0)
	amount_Zirconium = raw_resources.get_value("inventory", "Zirconium", 0)
	amount_Scheelite = raw_resources.get_value("inventory", "Scheelite", 0)
	amount_Pitchblende = raw_resources.get_value("inventory", "Pitchblende", 0)
	amount_Phosphorite = raw_resources.get_value("inventory", "Phosphorite", 0)
	amount_Hematite = raw_resources.get_value("inventory", "Hematite", 0)
	amount_Oil_Shale = raw_resources.get_value("inventory", "Oil_Shale", 0)
	amount_Graphite = raw_resources.get_value("inventory", "Graphite", 0)
	amount_Gold = raw_resources.get_value("inventory", "Gold", 0)
	amount_Emerald = raw_resources.get_value("inventory", "Emerald", 0)
	amount_Diamond = raw_resources.get_value("inventory", "Diamond", 0)
	amount_Ruby = raw_resources.get_value("inventory", "Ruby", 0)
	amount_Sapphire = raw_resources.get_value("inventory", "Sapphire", 0)
	amount_Garnet = raw_resources.get_value("inventory", "Garnet", 0)
	amount_Topaz = raw_resources.get_value("inventory", "Topaz", 0)
	amount_Tsavorite = raw_resources.get_value("inventory", "Tsavorite", 0)
	amount_Ametrine = raw_resources.get_value("inventory", "Ametrine", 0)
	amount_Apatite = raw_resources.get_value("inventory", "Apatite", 0)
	amount_Azurite = raw_resources.get_value("inventory", "Azurite", 0)
	amount_Charoite = raw_resources.get_value("inventory", "Charoite", 0)
	amount_Sugilite = raw_resources.get_value("inventory", "Sugilite", 0)
	amount_Peridot = raw_resources.get_value("inventory", "Peridot", 0)
	amount_Vanadinite = raw_resources.get_value("inventory", "Vanadinite", 0)
	amount_Amazonite = raw_resources.get_value("inventory", "Amazonite", 0)
	amount_Bloodstone = raw_resources.get_value("inventory", "Bloodstone", 0)
	amount_Chalcedony = raw_resources.get_value("inventory", "Chalcedony", 0)
	amount_Chrysocolla = raw_resources.get_value("inventory", "Chrysocolla", 0)
	amount_Pietersite = raw_resources.get_value("inventory", "Pietersite", 0)
	amount_Labradorite = raw_resources.get_value("inventory", "Labradorite", 0)
	amount_Frozen_Diamond = raw_resources.get_value("inventory", "Frozen_Diamond", 0)
	amount_Jeremejevite = raw_resources.get_value("inventory", "Jeremejevite", 0)
	
	var crafted_resources_path : String = str("user://save/", GetSaveFile.save_being_used, "/inventory_crafted.cfg")
	var crafted_resources := ConfigFile.new()
	crafted_resources.load(crafted_resources_path)
	
	amount_Water = crafted_resources.get_value("inventory", "Water", 0)
	amount_Sulfuric_Acid = crafted_resources.get_value("inventory", "Sulfuric Acid", 0)
