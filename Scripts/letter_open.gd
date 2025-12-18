extends Control

@onready var greetings_label = $CenterContainer/TextureRect/MarginContainer/contentVBox/greetings
@onready var content_label = $CenterContainer/TextureRect/MarginContainer/contentVBox/contentLabel
@onready var author_label = $CenterContainer/TextureRect/MarginContainer/contentVBox/FromLabel

const font_color: Color = Color(0,0,0)

func show_letter(data: LetterOpenData):
	visible = true
	greetings_label.text = data.greetings
	content_label.text = data.content
	author_label.text = data.author

func hide_popup():
	visible = false

func _ready():
	visible = false
	greetings_label.add_theme_color_override("font_color",font_color)
	content_label.add_theme_color_override("font_color",font_color)
	author_label.add_theme_color_override("font_color",font_color)
	


func _on_close_button_pressed() -> void:
	hide()
