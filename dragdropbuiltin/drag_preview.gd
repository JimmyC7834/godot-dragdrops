class_name DragPreview
extends Control

@export var degree: int = 0
@export var span: float = 0.1

var prev: TextureRect

func _init(texture: Texture2D, _size: Vector2, _rotation: float = 0, offset: Vector2 = Vector2.ZERO):
    size = _size
    rotation = _rotation
    degree = rad_to_deg(_rotation)
    
    prev = TextureRect.new()
    add_child(prev)
    
    prev.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    prev.texture = texture
    prev.size = size
    prev.position += offset

func _process(delta):
    if Input.is_action_just_pressed("ROTATE_LEFT"):
        degree -= 90
        var t = create_tween().set_ease(Tween.EASE_OUT)
        t.tween_property(self, "rotation", deg_to_rad(degree), span)
    elif Input.is_action_just_pressed("ROTATE_RIGHT"):
        degree += 90
        var t = create_tween().set_ease(Tween.EASE_OUT)
        t.tween_property(self, "rotation", deg_to_rad(degree), span)

func set_position_of(obj):
    obj.global_position = prev.global_position
    obj.rotation = deg_to_rad(degree)
