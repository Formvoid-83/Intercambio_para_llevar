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

var drag_ghost: Control
var dragged_toy_data: ToyData

const LETTER_SPAWN_POS := Vector2(90, -212)
const LETTER_TARGET_POS := Vector2(90, 600)


func _ready():
	area_table.table_dropped.connect(_on_table_dropped)
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
	dragged_toy_data = toy_data
	drag_ghost = preload("res://Scenes/drag_ghost.tscn").instantiate()
	get_tree().root.add_child(drag_ghost)
	drag_ghost.setup(toy_data, ATLAS)
	#var toy := toy_scene.instantiate() as Toy
	#toys_container.add_child(toy)
	#toy.setup(toy_data, ATLAS)
	#toy.released.connect(_on_toy_released)

func _input(event):
	if drag_ghost == null:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:

		print("MOUSE RELEASE DETECTED")

		var drop_pos := get_global_mouse_position()

		if _is_mouse_over_table():
			_spawn_real_toy(dragged_toy_data, drop_pos)
		else:
			inventory.release_toy()

		drag_ghost.queue_free()
		drag_ghost = null



func _finish_drag():
	drag_ghost.queue_free()
	drag_ghost = null
	var drop_pos := get_global_mouse_position()
	if _is_mouse_over_table():
		_spawn_real_toy(dragged_toy_data, drop_pos)
	else:
		inventory.release_toy()

func _is_mouse_over_table() -> bool:
	var space := get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true

	var results := space.intersect_point(query)
	for r in results:
		if r.collider.name == "CollisionTable2D":
			return true
	return false
	
func _on_table_dropped(drop_position: Vector2):
	print("TABLE DROPPED at:", drop_position)
	if drag_ghost == null:
		return

	drag_ghost.queue_free()
	drag_ghost = null

	var toy := toy_scene.instantiate() as Toy
	toys_container.add_child(toy)
	toy.global_position = drop_position
	toy.setup(dragged_toy_data, ATLAS)
	toy.released.connect(_on_toy_released)

func _spawn_real_toy(toy_data: ToyData, pos: Vector2):
	print("SPAWNING TOY:", toy_data.name)

	var toy := toy_scene.instantiate() as Toy
	toys_container.add_child(toy)

	toy.global_position = pos
	toy.setup(toy_data, ATLAS)
	toy.released.connect(_on_toy_released)


func _on_toy_released():
	inventory.release_toy()
	
func _on_shelf_clicked():
	inventory.toggle()
	
	
func _on_area_table_wrap_clicked() -> void:
	wrapping_panel.toggle()
