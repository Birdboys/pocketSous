extends Node
@onready var recipe_path := "res://Assets/recipes/%s.json"
@onready var recipes := ['pbj_blueberry','tomato_soup','pbj_blueberry','pbj_blueberry','pbj_blueberry','pbj_blueberry','pbj_blueberry','pbj_blueberry','pbj_blueberry','pbj_blueberry','pbj_blueberry','pbj_blueberry']
@onready var current_recipe_buffer := ""
func getRecipe(dish):
	if dish not in recipes:
		print("RECIPE NOT FOUND")
		return -1
	if FileAccess.file_exists(recipe_path % dish):
		var recipe_data = FileAccess.get_file_as_string(recipe_path % dish)
		var recipe_parsed = JSON.parse_string(recipe_data)
		if not (recipe_parsed is Dictionary): print("RECIPE FILE LOAD ERROR"); return -1
		return recipe_parsed
	else:
		print("RECIPE FILE DOESNT EXIST")
		return -1
