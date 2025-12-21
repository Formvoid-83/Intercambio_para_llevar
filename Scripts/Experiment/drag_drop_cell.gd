class_name DragDropCell extends Button


# Called when the node enters the scene tree for the first time.
func _get_drag_data(at_position: Vector2) -> Variant:
	if not icon:
		return null
	var preview: TextureRect = TextureRect.new()
	preview.texture = icon
	set_drag_preview(preview)
	return self
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not data is DragDropCell or data == self:
		return false
	grab_focus()
	return true
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp: Texture2D = icon
	icon= data.icon
	data.icon = temp


	
