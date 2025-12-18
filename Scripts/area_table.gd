extends Area2D

signal shelf_clicked
signal wrap_clicked

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		var owner_id = shape_find_owner(shape_idx)
		var shape_node = shape_owner_get_owner(owner_id)

		if shape_node.name == "CollisionShelf":
			emit_signal("shelf_clicked")
		elif shape_node.name == "CollisionWrap":
			emit_signal("wrap_clicked")
