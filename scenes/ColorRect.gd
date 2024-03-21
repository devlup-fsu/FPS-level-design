extends ColorRect


# this code is evil

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not %MainMenu.visible:
		visible = Input.mouse_mode == Input.MOUSE_MODE_VISIBLE
