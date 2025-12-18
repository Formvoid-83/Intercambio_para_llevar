extends Node2D

@export var letter_scene: PackedScene
@export var toy_scene: PackedScene
@onready var inventory: Control = $CanvasToys/InventoryPanel
@onready var toys_container: Node2D = $ToysContainer
@onready var letters_container: Node2D = $LettersContainer
@onready var letter_popup: Control = $CanvasLayer/letter_open

const ATLAS := preload("res://Assets/Images/Gifts.png")

var letter_db := LetterDatabase.new()
var data : LetterOpenData
var letter : Node


func _ready():
	inventory.toy_requested.connect(_spawn_toy)
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


func _spawn_toy(toy_data: Variant) -> void:
	var toy := toy_scene.instantiate() as Toy
	toys_container.add_child(toy)
	toy.setup(toy_data, ATLAS)
	toy.released.connect(_on_toy_released)
	
func _on_toy_released():
	inventory.release_toy()
