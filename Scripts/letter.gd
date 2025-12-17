extends Area2D

signal read_requested(text)

enum LetterState { CLOSED, OPEN }
var state = LetterState.CLOSED
var letter_text := "Algo"

@onready var sprite := $Sprite2D

const LETTER_SHEET := preload("res://Assets/Images/Letters.png")

const CLOSED_REGION := Rect2(1128.0, 504.0, 248.0, 112.0)
const OPEN_REGION   := Rect2(456.0, 456.0, 240.0, 168.0)

func _ready():
	set_letter_region(CLOSED_REGION)

func _input_event(viewport, event, shape_idx):
	if state != LetterState.OPEN:
		return

	if event is InputEventMouseButton \
	and event.double_click \
	and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("read_requested", letter_text)

func open_letter():
	if state == LetterState.CLOSED:
		state = LetterState.OPEN
		set_letter_region(OPEN_REGION)

func set_letter_region(region: Rect2):
	var atlas := AtlasTexture.new()
	atlas.atlas = LETTER_SHEET
	atlas.region = region

	sprite.texture = atlas
	sprite.centered = false
	sprite.position = Vector2.ZERO
