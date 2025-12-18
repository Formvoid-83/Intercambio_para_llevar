extends Area2D

signal read_requested(data: LetterOpenData)

enum LetterState { CLOSED, OPEN }
var state = LetterState.CLOSED

var letter_data: LetterOpenData

var dragging := false
var drag_offset := Vector2.ZERO

@onready var sprite := $Sprite2D
@onready var audio_open: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_release_air: AudioStreamPlayer2D = $AudioReleaseAir
@onready var audio_creasing_paper: AudioStreamPlayer2D = $AudioCreasingPaper

const LETTER_SPAWN_POS := Vector2(90, -212)
const LETTER_TARGET_POS := Vector2(90, 600)


const LETTER_SHEET := preload("res://Assets/Images/Letters.png")
const CLOSED_REGION := Rect2(1128.0, 504.0, 248.0, 112.0)
const OPEN_REGION   := Rect2(456.0, 456.0, 240.0, 168.0)

func _ready():
	set_letter_region(CLOSED_REGION)

func set_letter_data(data: LetterOpenData):
	letter_data = data

func _input_event(viewport, event, shape_idx):
	if state != LetterState.OPEN:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
			
	if event is InputEventMouseButton \
	and event.double_click \
	and event.button_index == MOUSE_BUTTON_LEFT:
		audio_creasing_paper.play()
		dragging = false
		emit_signal("read_requested", letter_data)


func open_letter():
	if state == LetterState.CLOSED:
		state = LetterState.OPEN
		audio_open.play()
		set_letter_region(OPEN_REGION)

func set_letter_region(region: Rect2):
	var atlas := AtlasTexture.new()
	atlas.atlas = LETTER_SHEET
	atlas.region = region
	sprite.texture = atlas
	sprite.centered = false
	sprite.position = Vector2.ZERO
	
func drop_to(target_pos: Vector2):
	audio_release_air.play()
	position = LETTER_SPAWN_POS
	visible = true

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"position",
		target_pos,
		0.35   # duration (fast drop)
	)

	
func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
