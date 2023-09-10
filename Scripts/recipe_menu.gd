extends Control
@onready var recipeContainer := $stuff/recipeScroll/recipeContainer
@onready var recipePanel := preload("res://Scenes/recipe_panel.tscn")
@onready var recipeGame := preload("res://Scenes/recipe_game.tscn")
func _ready():
	await get_tree().process_frame
	for dish in RecipeManager.recipes:
		var new_rec := recipePanel.instantiate()
		recipeContainer.add_child(new_rec)
		new_rec.selected.connect(startCooking)
		new_rec.initialize(dish)

func _process(delta):
	pass

func startCooking(dish):
	print(dish)
	RecipeManager.current_recipe_buffer = dish
	get_tree().change_scene_to_file("res://Scenes/recipe_game.tscn")
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
