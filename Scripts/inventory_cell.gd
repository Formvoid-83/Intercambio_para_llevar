extends Control

signal pressed(toy_data)

var toy_data
var wrap_data

@onready var bg: TextureRect = $Background
@onready var icon: TextureRect = $ToyIcon
@onready var price: Label = $PriceLabel


func _ready() -> void:
	print("BG:", bg)
	print("ICON:", icon)
	print("PRICE:", price)

func setup_toy(data: ToyData, atlas: Texture2D, cell_region: Rect2):
	toy_data = data

	var bg_tex := AtlasTexture.new()
	bg_tex.atlas = atlas
	bg_tex.region = cell_region
	bg.texture = bg_tex

	var toy_tex := AtlasTexture.new()
	toy_tex.atlas = atlas
	toy_tex.region = data.region
	icon.texture = toy_tex

	price.text = "$" + str(data.price)

func setup_wrap(data: WrapData, atlas: Texture2D, atlas2: Texture2D, cell_region:Rect2):
	wrap_data = data

	var bg_tex := AtlasTexture.new()
	bg_tex.atlas = atlas
	bg_tex.region = cell_region
	bg.texture = bg_tex

	var wrap_tex := AtlasTexture.new()
	wrap_tex.atlas = atlas2
	wrap_tex.region = data.region
	icon.texture = wrap_tex

	price.text = "$" + str(data.price)

func _gui_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		emit_signal("pressed", toy_data)
