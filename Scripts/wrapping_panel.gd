extends Control

signal wrap_requested(wrap_data)

@onready var grid_container: GridContainer = $GridContainer
@onready var audio_drawer: AudioStreamPlayer2D = $AudioDrawer

const ATLAS := preload("res://Assets/Images/Gifts.png")
const ATLAS2 := preload("res://Assets/Images/Wrapping_Gifts.png")
const CELL_REGION := Rect2(800.0, 48.0, 128.0, 176.0)

var is_open := false
var wrap_active := false

@onready var closed_y := size.y
@onready var open_y := 0

func _ready() -> void:
	var wraps = [
		WrapData.new(
			"Barato",
			Rect2(659, 719, 109, 113),
			Rect2(182, 623, 180, 210), 
			5
		),
		WrapData.new(
			"Regular",
			Rect2(659, 431, 109, 113),
			Rect2(182, 350, 180, 210),
			15
		),
		WrapData.new(
			"Premium",
			Rect2(659, 159, 109, 113),
			Rect2(182, 79, 180, 210),
			30
		),
	]

	for wrap in wraps:
		var cell = preload("res://Scenes/inventory_cell.tscn").instantiate()
		grid_container.add_child(cell)
		cell.setup_wrap(wrap, ATLAS, ATLAS2, CELL_REGION)
		cell.pressed.connect(request_wrap)
		

func toggle():
	audio_drawer.play()
	is_open = !is_open
	visible = is_open

func request_wrap(wrap_data):
	if wrap_active:
		return
	wrap_active = true
	emit_signal("wrap_requested", wrap_data)

func release_wrap():
	wrap_active = false
