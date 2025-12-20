extends Control

@onready var puntaje_label = $CenterContainer/VBoxContainer/PuntajeLabel

func aparecer(puntos_finales: int):
	show() # Muestra la pantalla
	puntaje_label.text = "Puntaje Final: " + str(puntos_finales)
	# Aquí podrías pausar el juego si quieres
	# get_tree().paused = true 

func _on_btn_reiniciar_pressed():
	# get_tree().paused = false
	get_tree().reload_current_scene() # Reinicia el taller

func _on_btn_menu_pressed():
	# get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
