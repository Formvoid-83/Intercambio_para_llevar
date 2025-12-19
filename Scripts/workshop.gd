extends Node2D

@export var letter_scene: PackedScene
@export var toy_scene: PackedScene
@export var world_toy_scene: PackedScene
@onready var inventory: Control = $CanvasToys/InventoryPanel
@onready var wrapping_panel: Control = $CanvasWrapping/WrappingPanel
@onready var toys_container: Node2D = $ToysContainer
@onready var letters_container: Node2D = $LettersContainer
@onready var letter_popup: Control = $CanvasLayer/letter_open
@onready var area_table: Area2D = $Area_Table
@onready var deploy_area: Area2D = $"Area_Deploy&Background"
@onready var timer: Timer = $Timer
@onready var timer_label: Label = $CanvasLayer2/Panel/Label
@onready var results_panel: Panel = $CanvasLayer3/Panel
@onready var hud := get_parent().get_node("HUD_Layer")



const ATLAS := preload("res://Assets/Images/Gifts.png")
var time_left: int
var total_time :=  180

var current_commission := 0


@export var wrap_scene: PackedScene = preload("res://Scenes/wrap.tscn")
const WRAP_ATLAS := preload("res://Assets/Images/Wrapping_Gifts.png")

var letter_db := LetterDatabase.new()
var data : LetterOpenData
var letter : Node

var drag_ghost: Control
var dragged_toy_data: ToyData

const LETTER_SPAWN_POS := Vector2(90, -212)
const LETTER_TARGET_POS := Vector2(90, 600)


func _ready():
	hud.setup(500) #La meta diaria del shift del día
	area_table.table_dropped.connect(_on_table_dropped)
	inventory.toy_requested.connect(_spawn_toy)
	letter_db.load_letters()
	spawn_random_letter()
	area_table.shelf_clicked.connect(_on_shelf_clicked)
	inventory.hide()
	wrapping_panel.wrap_requested.connect(_on_wrap_requested)
	wrapping_panel.hide()
	time_left = total_time
	update_label()
	results_panel.visible = false

	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func spawn_random_letter():
	if letter_db.letters.is_empty():
		return
	if letters_container.get_child_count() > 0:
		return
	var data = letter_db.letters.pick_random()
	letter = letter_scene.instantiate() 

	letter.set_letter_data(data)
	letter.read_requested.connect(_on_letter_read)

	letters_container.add_child(letter)
	letter.drop_to(LETTER_TARGET_POS)



func _on_letter_read(data: LetterOpenData):
	current_commission = data.comission
	letter_popup.show_letter(data)


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

func _on_wrap_requested(wrap_data: WrapData):
	var wrap := wrap_scene.instantiate() as Wrap
	add_child(wrap)
	wrap.setup(wrap_data, WRAP_ATLAS)
	wrap.released.connect(_on_wrap_released)

func _on_wrap_released(wrap: Wrap):
	for child in toys_container.get_children():
		if child is WorldToy:
			if child.try_wrap(wrap, wrap.wrap_data, WRAP_ATLAS):
				wrapping_panel.release_wrap()
				return
	# No toy accepted it
	wrap.queue_free()
	wrapping_panel.release_wrap()

func _get_world_toy_under_point(pos: Vector2) -> WorldToy:
	var space := get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true

	var results := space.intersect_point(query)
	for r in results:
		if r.collider is WorldToy:
			return r.collider
	return null

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
		if r.collider == area_table:
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
	print("SPAWNING WORLD TOY:", toy_data.name)

	var toy := world_toy_scene.instantiate() as WorldToy
	toys_container.add_child(toy)

	toy.global_position = pos
	toy.setup(toy_data, ATLAS)
	toy.deployed.connect(_on_world_toy_deployed) 
	
func _on_world_toy_deployed(toy: WorldToy):
	print("DEPLOYED:", toy)
	var total_cost := toy.toy_cost + toy.wrap_cost
	var delta := current_commission - total_cost

	hud.apply_delta(delta)
	if letter and is_instance_valid(letter):
		letter.queue_free()
		letter = null

	await get_tree().create_timer(0.2).timeout
	spawn_random_letter()

func _is_mouse_over_deploy_area() -> bool:
	var space := get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true

	var results := space.intersect_point(query)
	for r in results:
		if r.collider == deploy_area:
			return true
	return false

func _unhandled_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		for child in toys_container.get_children():
			if child is WorldToy \
			and child.dragging \
			and child.is_wrapped \
			and _is_mouse_over_deploy_area():
				child.deploy()
				return


func _on_toy_released():
	inventory.release_toy()
	
func _on_shelf_clicked():
	inventory.toggle()
	
	
func _on_area_table_wrap_clicked() -> void:
	wrapping_panel.toggle()

func _on_timer_timeout():
	time_left -= 1
	update_label()

	if time_left <= 0:
		timer.stop()
		on_time_finished()

func update_label():
	timer_label.text = format_time(time_left)


func format_time(seconds: int) -> String:
	var minutes = seconds / 60
	var secs = seconds % 60
	return "%02d:%02d" % [minutes, secs]

func on_time_finished():
	results_panel.visible = true
	get_tree().paused = true  # optional: freeze game
