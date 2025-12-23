extends Control

signal toy_requested(toy_data)

@onready var grid_container: GridContainer = $GridContainer
@onready var audio_drawer: AudioStreamPlayer2D = $AudioDrawer

const ATLAS := preload("res://Assets/Images/Gifts.png")
const CELL_REGION := Rect2(800.0, 48.0, 128.0, 176.0)

var is_open := false
var toy_active := false

@onready var closed_y := size.y
@onready var open_y := 0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP 
	var toys = [
		ToyData.new("Ball", Rect2(1176.0,232.0,104.0,96.0), 5, true),
		ToyData.new("Ula ula", Rect2(1008.0,248.0,112.0,112.0), 5, false),
		ToyData.new("T-Rex", Rect2(1168.0,24.0,112.0,80.0), 10, true),
		ToyData.new("Doll", Rect2(1040.0,112.0,64.0,104.0), 10, false),
		ToyData.new("Truck", Rect2(1176.0,144.0,104.0,64.0), 45, true),
		ToyData.new("Kitchen", Rect2(1016.0,24.0,104.0,72.0), 45, false),
		ToyData.new("PS5", Rect2(1368.0,224.0,72.0,96.0), 500, true),
		ToyData.new("Doll House", Rect2(1176.0,384.0,112.0,112.0), 450, false)
	]
	for toy in toys:
		var cell = preload("res://Scenes/inventory_cell.tscn").instantiate()
		grid_container.add_child(cell)
		cell.setup_toy(toy, ATLAS, CELL_REGION)
		cell.pressed.connect(request_toy)
		

func toggle():
	audio_drawer.play()
	is_open = !is_open
	visible = is_open

func request_toy(toy_data):
	emit_signal("toy_requested", toy_data)

func release_toy():
	toy_active = false
