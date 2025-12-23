extends Control

@onready var score_label: Label = $MarginContainer/HBoxContainer/Label
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/ProgressBar

var total_score := 0

func setup(max_shift_score: int):
	progress_bar.max_value = max_shift_score
	progress_bar.value = 0
	total_score=0
	score_label.text = "0 $"

func apply_delta(delta: int):
	total_score += delta
	progress_bar.value = total_score

	score_label.text = "%+d $" % delta
	if delta >= 0:
		score_label.modulate = Color(0.2, 0.9, 0.2) 
	else :
		score_label.modulate = Color(0.9, 0.2, 0.2)

	await get_tree().create_timer(2.0).timeout

	score_label.text = "%d $" % total_score
	score_label.modulate = Color.WHITE
