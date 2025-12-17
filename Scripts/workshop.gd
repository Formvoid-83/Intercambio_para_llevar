extends Node2D

@export var letter_scene: PackedScene
@onready var letters_container: Node2D = $LettersContainer


func _ready():
	spawn_letter(Vector2(100, 200))

func spawn_letter(pos):
	var letter = letter_scene.instantiate()
	letter.position = pos
	letters_container.add_child(letter)
