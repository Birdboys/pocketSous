extends Node
@onready var food := {}
const FOOD_DATA_PATH := "res://Assets/food_data_v1.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	loadFoodData(FOOD_DATA_PATH)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadFoodData(path):
	if not FileAccess.file_exists(path):
		print("ITEM DATA LOADING ERROR")
		return
	var data = FileAccess.open(path, FileAccess.READ)
	food = JSON.parse_string(data.get_as_text())
	data.close()
