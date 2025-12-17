extends Control

func  _ready() -> void:
	visible = false

func show_text(text):
	visible = true
	$Panel/Label.text = text

func hide_popup():
	visible = false
