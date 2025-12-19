extends Area2D
class_name WorldToy

signal deployed
@onready var sprite: Sprite2D = $Sprite2D
@onready var wrapping_sound: AudioStreamPlayer2D = $Wrapping_Sound
@onready var assembly_sound: AudioStreamPlayer2D = $Assembly_Sound


var dragging := false
var drag_offset := Vector2.ZERO
var is_wrapped := false
var is_deploying := false

func setup(data: ToyData, atlas: Texture2D):
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = data.region
	sprite.texture = tex

	scale = Vector2(1.8, 1.8)
	z_index = 100

func _input_event(viewport, event, shape_idx):
	if is_deploying:
		return
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
func deploy():
	if is_deploying:
		return

	is_deploying = true
	dragging = false
	input_pickable = false
	self.z_index=-1
	#z_index = 1
	sprite.z_index=1
	var target_pos := Vector2(
		1920 + 300,
		global_position.y
	)	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)

	assembly_sound.play()
	tween.tween_property(
		self,
		"global_position",
		target_pos,
		5
	)
	tween.finished.connect(func():
		emit_signal("deployed")
		queue_free()
	)
