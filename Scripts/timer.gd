extends Node2D

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $CanvasLayer2/Panel/Label
@onready var results_panel: Panel = $CanvasLayer3/Panel
@onready var audio_alarm: AudioStreamPlayer2D = $CanvasLayer2/AudioStreamPlayer2D

var time_left: int
var total_time :=  180
func _ready() -> void:
	visible = false
	results_panel.hide()
	update_label()
	timer.timeout.connect(_on_timer_timeout)

func activate_timer() -> void:
	time_left = total_time 
	visible=true
	timer.start()
	
func _on_timer_timeout():

	time_left -= 1
	update_label()

	if time_left <= 0:
		time_left = 0 
		timer.stop()
		audio_alarm.play()
		on_time_finished()

func update_label():
	timer_label.text = format_time(time_left)


func format_time(seconds: int) -> String:
	var minutes = seconds / 60
	var secs = seconds % 60
	return "%02d:%02d" % [minutes, secs]

func on_time_finished():
	results_panel.visible = true
	get_tree().paused = true  # optional: freeze game
