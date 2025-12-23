extends Control

@onready var puntaje_label = $CenterContainer/VBoxContainer/PuntajeLabel
@onready var objective_meter = get_node_or_null("ResultScore/CanvasLayer/ObjetiveMeter")


func _ready():
	hide()

func aparecer(final_score: int, max_score: int):
	show()

	puntaje_label.text = "Puntaje Final: %d $" % final_score

	var percent := float(final_score) / float(max_score)
	objective_meter.show_result(percent)


func _on_btn_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_btn_salir_pressed() -> void:
	get_tree().quit()
