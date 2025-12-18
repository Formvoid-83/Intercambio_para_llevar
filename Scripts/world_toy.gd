class_name WorldToy
extends Node2D

#@export var sprite: Sprite2D
@onready var sprite: Sprite2D = $Sprite2D

func setup(data: ToyData, atlas: Texture2D):
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = data.region
	sprite.texture = tex

	# BIG, GUARANTEED TO SHOW
	scale = Vector2(2.5, 2.5)
	z_index = 100
