extends Control

@onready var icon: TextureRect = $Icon


func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func setup(data: ToyData, atlas: Texture2D):
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = data.region
	icon.texture = tex
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(_delta):
	global_position = get_global_mouse_position()
