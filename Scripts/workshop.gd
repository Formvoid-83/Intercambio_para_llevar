extends Node2D

@export var letter_scene: PackedScene
@onready var letters_container: Node2D = $LettersContainer
@onready var letter_popup: Control = $CanvasLayer/letter_open

var letter_db := LetterDatabase.new()
var data : LetterOpenData
var letter : Node


func _ready():
	letter_db.load_letters()
	spawn_random_letter()

func spawn_random_letter():
	if letter_db.letters.is_empty():
		return
	data = letter_db.letters.pick_random()
	letter = letter_scene.instantiate()

	letter.position = Vector2(100, 200)
	letter.set_letter_data(data)
	letter.read_requested.connect(_on_letter_read)

	letters_container.add_child(letter)

func _on_letter_read(letter):
	letter_popup.show_letter(letter)
