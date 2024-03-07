#class_name PanelCard
extends DragDropBuiltin

@export var card_ratio: Vector2 = Vector2.ONE

func _ready():
    super._ready()
    #var card_texture_rect: TextureRect = TextureRect.new()
    #card_texture_rect.size = get_object_size()
    #card_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    #card_texture_rect.texture = object_texture

func get_drag_preview() -> Control:
    return DragPreview.new(
        object_texture, get_object_size(), rotation, 
        drag_offset if drag_style == &"OFFSET" else -0.5 * get_object_size())

func get_object_size() -> Vector2:
    return super.get_object_size() * card_ratio
