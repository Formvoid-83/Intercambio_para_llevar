extends Control

class LetterOpenData:
	var greetings: String = ""
	var content: String =  ""
	var from: String = ""

# Called when the node
	func _init(ded:String, cont:String, sen:String):
		greetings = ded
		content = cont
		from = sen
		
@onready var greetings_label = $CenterContainer/TextureRect/MarginContainer/contentVBox/greetings
@onready var content_label = $CenterContainer/TextureRect/MarginContainer/contentVBox/contentLabel
@onready var from_label = $CenterContainer/TextureRect/MarginContainer/contentVBox/FromLabel

func show_Letter(data: LetterOpenData) :
	greetings_label.text = data.greetings
	content_label.text = data.content
	from_label.text = data.from
	
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
