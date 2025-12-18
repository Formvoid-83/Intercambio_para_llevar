extends Node2D

@export var letter_scene: PackedScene
@export var toy_scene: PackedScene
@onready var inventory: Control = $CanvasToys/InventoryPanel
@onready var wrapping_panel: Control = $CanvasWrapping/WrappingPanel
@onready var toys_container: Node2D = $ToysContainer
@onready var letters_container: Node2D = $LettersContainer
@onready var letter_popup: Control = $CanvasLayer/letter_open
@onready var area_table: Area2D = $Area_Table

const ATLAS := preload("res://Assets/Images/Gifts.png")

var letter_db := LetterDatabase.new()
var data : LetterOpenData
var letter : Node

const LETTER_SPAWN_POS := Vector2(90, -212)
const LETTER_TARGET_POS := Vector2(90, 600)


func _ready():
	inventory.toy_requested.connect(_spawn_toy)
	letter_db.load_letters()
	spawn_random_letter()
	area_table.shelf_clicked.connect(_on_shelf_clicked)
	inventory.hide()
	wrapping_panel.hide()

func spawn_random_letter():
	if letter_db.letters.is_empty():
		return

	# Prevent multiple letters
	if letters_container.get_child_count() > 0:
		return

	var data = letter_db.letters.pick_random()
	var letter := letter_scene.instantiate()

	letter.set_letter_data(data)
	letter.read_requested.connect(_on_letter_read)

	letters_container.add_child(letter)
	
	letter.drop_to(LETTER_TARGET_POS)


func _on_letter_read(letter):
	letter_popup.show_letter(letter)


func _spawn_toy(toy_data: Variant) -> void:
	var toy := toy_scene.instantiate() as Toy
	toys_container.add_child(toy)
	toy.setup(toy_data, ATLAS)
	toy.released.connect(_on_toy_released)
	
func _on_toy_released():
	inventory.release_toy()
	
func _on_shelf_clicked():
	inventory.toggle()
	
	
func _on_area_table_wrap_clicked() -> void:
	wrapping_panel.toggle()
