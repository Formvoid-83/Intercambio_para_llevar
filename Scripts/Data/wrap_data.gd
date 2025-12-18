class_name WrapData
extends Resource

@export var name: String
@export var wrap_region: Rect2
@export var wrapped_gift_region: Rect2
@export var price: int

func _init(
	_name: String,
	_wrap_region: Rect2,
	_wrapped_region: Rect2,
	_price: int
):
	name = _name
	wrap_region = _wrap_region
	wrapped_gift_region = _wrapped_region
	price = _price
