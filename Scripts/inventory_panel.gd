extends Control

signal toy_requested(toy_data)

@onready var grid_container: GridContainer = $GridContainer

const ATLAS := preload("res://Assets/Images/Gifts.png")
const CELL_REGION := Rect2(800.0, 48.0, 128.0, 176.0)

var is_open := false
var toy_active := false

@onready var closed_y := size.y
@onready var open_y := 0

func _ready() -> void:
	position.y = closed_y
	var toys = [
		ToyData.new("Ball", Rect2(1176.0,232.0,104.0,96.0), 5),
		ToyData.new("Ula ula", Rect2(1008.0,248.0,112.0,112.0), 5),
		ToyData.new("T-Rex", Rect2(1168.0,24.0,112.0,80.0), 10),
		ToyData.new("Doll", Rect2(1040.0,112.0,64.0,104.0), 10),
		ToyData.new("Truck", Rect2(1176.0,144.0,104.0,64.0), 45),
		ToyData.new("Kitchen", Rect2(1016.0,24.0,104.0,72.0), 45),
		ToyData.new("PS5", Rect2(1368.0,224.0,72.0,96.0), 500),
		ToyData.new("Doll House", Rect2(1176.0,384.0,112.0,112.0), 450)
	]
	for toy in toys:
		var cell = preload("res://Scenes/inventory_cell.tscn").instantiate()
		grid_container.add_child(cell)
		cell.setup(toy, ATLAS, CELL_REGION)
		cell.pressed.connect(request_toy)
		

func toggle():
	is_open = !is_open
	position.y = open_y if is_open else closed_y

func request_toy(toy_data):
	if toy_active:
		return
	toy_active = true
	emit_signal("toy_requested", toy_data)

func release_toy():
	toy_active = false
