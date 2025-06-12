extends Panel

var Stone : int = 0
var Sandstone : int = 0
var Gypsum : int = 0
var Kaolinite : int = 0
var Ice : int = 0
var Coal : int = 0
var Lava_Cluster : int = 0
var Dense_Ice : int = 0
var Sulfur : int = 0
var Biomass : int = 0
var Copper : int = 0
var Iron : int = 0
var Magnetite : int = 0
var Bauxite : int = 0
var Galena : int = 0
var Silver : int = 0
var Pyrolusite : int = 0
var Wolframite : int = 0
var Nickel : int = 0
var Platinum : int = 0
var Uranium : int = 0
var Cobalt : int = 0
var Zirconium : int = 0
var Scheelite : int = 0
var Pitchblende : int = 0
var Phosphorite : int = 0
var Hematite : int = 0
var Oil_Shale : int = 0
var Graphite : int = 0
var Gold : int = 0
var Emerald : int = 0
var Diamond : int = 0
var Ruby : int = 0
var Sapphire : int = 0
var Garnet : int = 0
var Topaz : int = 0
var Tsavorite : int = 0
var Ametrine : int = 0
var Apatite : int = 0
var Azurite : int = 0
var Charoite : int = 0
var Sugilite : int = 0
var Peridot : int = 0
var Vanadinite : int = 0
var Amazonite : int = 0
var Bloodstone : int = 0
var Chalcedony : int = 0
var Chrysocolla : int = 0
var Pietersite : int = 0
var Labradorite : int = 0
var Frozen_Diamond : int = 0
var Jeremejevite : int = 0
var Water : int = 0
var Sulfuric_Acid : int = 0

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
	var raw_resources_path : String = str("user://", GetSaveFile.save_being_used, "/inventory_resources.cfg")
	var raw_resources := ConfigFile.new()
	raw_resources.load(raw_resources_path)
	
	Stone = raw_resources.get_value("inventory", "Stone", 0)
	Sandstone = raw_resources.get_value("inventory", "Sandstone", 0)
	Gypsum = raw_resources.get_value("inventory", "Gypsum", 0) 
	Kaolinite = raw_resources.get_value("inventory", "Kaolinite", 0)
	Ice = raw_resources.get_value("inventory", "Ice", 0)
	Coal = raw_resources.get_value("inventory", "Coal", 0)
	Lava_Cluster = raw_resources.get_value("inventory", "Lava_Cluster", 0)
	Dense_Ice = raw_resources.get_value("inventory", "Dense_Ice", 0)
	Sulfur = raw_resources.get_value("inventory", "Sulfur", 0)
	Biomass = raw_resources.get_value("inventory", "Biomass", 0)
	Copper = raw_resources.get_value("inventory", "Copper", 0) 
	Iron = raw_resources.get_value("inventory", "Iron", 0)
	Magnetite = raw_resources.get_value("inventory", "Magnetite", 0)
	Bauxite = raw_resources.get_value("inventory", "Bauxite", 0)
	Galena = raw_resources.get_value("inventory", "Galena", 0)
	Silver = raw_resources.get_value("inventory", "Silver", 0)
	Pyrolusite = raw_resources.get_value("inventory", "Pyrolusite", 0)
	Wolframite = raw_resources.get_value("inventory", "Wolframite", 0)
	Nickel = raw_resources.get_value("inventory", "Nickel", 0)
	Platinum = raw_resources.get_value("inventory", "Platinum", 0)
	Uranium = raw_resources.get_value("inventory", "Uranium", 0)
	Cobalt = raw_resources.get_value("inventory", "Cobalt", 0)
	Zirconium = raw_resources.get_value("inventory", "Zirconium")
	Scheelite = raw_resources.get_value("inventory", "Scheelite")
	Pitchblende = raw_resources.get_value("inventory", "Pitchblende")
	Phosphorite = raw_resources.get_value("inventory", "Phosphorite")
	Hematite = raw_resources.get_value("inventory", "Hematite")
	Oil_Shale = raw_resources.get_value("inventory", "Oil_Shale")
	Graphite = raw_resources.get_value("inventory", "Graphite")
	Gold = raw_resources.get_value("inventory", "Gold")
	Emerald = raw_resources.get_value("inventory", "Emerald")
	Diamond = raw_resources.get_value("inventory", "Diamond")
	Ruby = raw_resources.get_value("inventory", "Ruby")
	Sapphire = raw_resources.get_value("inventory", "Sapphire")
	Garnet = raw_resources.get_value("inventory", "Garnet")
	Topaz = raw_resources.get_value("inventory", "Topaz")
	Tsavorite = raw_resources.get_value("inventory", "Tsavorite")
	Ametrine = raw_resources.get_value("inventory", "Ametrine")
	Apatite = raw_resources.get_value("inventory", "Apatite")
	Azurite = raw_resources.get_value("inventory", "Azurite")
	Charoite = raw_resources.get_value("inventory", "Charoite")
	Sugilite = raw_resources.get_value("inventory", "Sugilite")
	Peridot = raw_resources.get_value("inventory", "Peridot")
	Vanadinite = raw_resources.get_value("inventory", "Vanadinite")
	Amazonite = raw_resources.get_value("inventory", "Amazonite")
	Bloodstone = raw_resources.get_value("inventory", "Bloodstone")
	Chalcedony = raw_resources.get_value("inventory", "Chalcedony")
	Chrysocolla = raw_resources.get_value("inventory", "Chrysocolla")
	Pietersite = raw_resources.get_value("inventory", "Pietersite")
	Labradorite = raw_resources.get_value("inventory", "Labradorite")
	Frozen_Diamond = raw_resources.get_value("inventory", "Frozen_Diamond")
	Jeremejevite = raw_resources.get_value("inventory", "Jeremejevite")
	
	var crafted_resources_path : String = str("user://", GetSaveFile.save_being_used, "/inventory_crafted.cfg")
	var crafted_resources := ConfigFile.new()
	crafted_resources.load(crafted_resources_path)
	
	Water = crafted_resources.get_value("inventory", "Water")
	Sulfuric_Acid = crafted_resources.get_value("inventory", "Sulfuric Acid")
