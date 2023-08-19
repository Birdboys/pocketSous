extends GridContainer
@onready var tapable = preload("res://Scenes/tapable.tscn")
var current_tap = 0
var total_tap = 0
signal game_win
signal game_loss

func initialize(num_taps, num_col, num_bad_tap, good_taps, bad_taps):
	columns = num_col
	total_tap = num_taps - num_bad_tap
	var tap_list = []
	for x in range(num_taps):
		if x < num_bad_tap: tap_list.append(-1)
		else: tap_list.append(0)
	tap_list.shuffle()
	for x in range(num_taps):
		var new_tapable = tapable.instantiate()
		add_child(new_tapable)
		new_tapable.tapped.connect(onTapable)
		if tap_list[x] == -1:
			var tap_choice = bad_taps[randi() % bad_taps.size()]
			new_tapable.initialize(tap_choice[0],tap_choice[1],tap_list[x])
		else:
			var tap_choice = good_taps[randi() % good_taps.size()]
			new_tapable.initialize(tap_choice[0],tap_choice[1],tap_list[x])

func onTapable(tap_id):
	if tap_id == -1:
		emit_signal("game_loss")
		pass
		#clearTapables()
		#generateTapables(num_tap, tap, bad_tap)
	else:
		current_tap += 1
		if current_tap == total_tap:
			current_tap = 0
			emit_signal("game_win")
			pass
		
