extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.visible = true
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		on_transition_finished.emit()
		color_rect.visible = false 

func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")
