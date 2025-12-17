extends Area2D

var dragging := false
var drag_offset := Vector2.ZERO

func _ready():
	input_pickable = true

func _input_event(viewport, event: InputEvent, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			dragging = false

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func _on_area_entered(area):
	if area.has_method("open_letter"):
		area.open_letter()
