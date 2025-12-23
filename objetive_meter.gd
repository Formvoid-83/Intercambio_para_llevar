extends ProgressBar

func _ready():
	min_value = 0
	max_value = 100
	value = 0
	fill_mode = FillMode.FILL_BOTTOM_TO_TOP
	visible = false

func show_result(percent: float):
	visible = true
	var target :float= clamp(percent * 100.0, 0, 100)

	var tween := create_tween()
	tween.tween_property(self, "value", target, 1.2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
