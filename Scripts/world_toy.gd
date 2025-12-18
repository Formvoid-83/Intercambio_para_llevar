extends Area2D
class_name WorldToy

@onready var sprite: Sprite2D = $Sprite2D
@onready var wrapping_sound: AudioStreamPlayer2D = $Wrapping_Sound

var dragging := false
var drag_offset := Vector2.ZERO
var is_wrapped := false

func setup(data: ToyData, atlas: Texture2D):
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = data.region
	sprite.texture = tex

	scale = Vector2(2.5, 2.5)
	z_index = 100

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			dragging = false

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
		
func try_wrap(wrap: Wrap, wrap_data: WrapData, atlas: Texture2D) -> bool:
	if is_wrapped:
		return false

	if not overlaps_area(wrap):
		return false

	apply_wrap(wrap_data, atlas)
	wrap.queue_free()
	return true

func apply_wrap(wrap_data: WrapData, atlas: Texture2D):
	if is_wrapped:
		return

	is_wrapped = true
	wrapping_sound.play()
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = wrap_data.wrapped_gift_region
	sprite.texture = tex
