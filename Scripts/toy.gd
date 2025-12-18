extends Area2D

signal released

var dragging := true

@onready var sprite := $Sprite2D

func setup(data: ToyData, atlas: Texture2D):
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = data.region
	sprite.texture = tex
	sprite.centered = true

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position()

func _unhandled_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		dragging = false
		emit_signal("released")
