extends Control

signal start_timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("MainMenu received mouse input")



func _on_start_button_pressed() -> void:
	get_tree().paused = false
	print("Iniciar JUEGOSSSS")
	visible = false
	get_tree().get_root().get_node("Node2D/Workshop").start_game()
	emit_signal("start_timer")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
