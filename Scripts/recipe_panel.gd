extends Panel
@onready var recipe_id
@onready var food := $container/food
@onready var food_text := $container/food_name
signal selected(rec)

func initialize(dish):
	custom_minimum_size.y = get_parent_area_size().y/4
	food.texture = load("res://Assets/foods/dishes/%s.svg" % dish)
	food_text.text = dish
	recipe_id = dish

func _on_touch_area_gui_input(event):
	if event.is_action_pressed("screen_touch"):
		emit_signal("selected", recipe_id)
