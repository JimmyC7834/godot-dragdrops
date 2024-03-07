extends Sprite2D

func _input(event):
    if event is InputEventMouseMotion:
        global_position = get_global_mouse_position()
