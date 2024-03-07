class_name DragDropBuiltin
extends Control

const DEFAULT_SIZE: Vector2 = Vector2.ONE * 100

@export var object_scale: float = 1.0

@export var can_drop: bool
@export var can_drag: bool

@export var object_texture: Texture2D
@export_enum(&"OFFSET", &"CENTER") var drag_style: String = &"CENTER"

var drag_offset: Vector2

signal on_drop

func _ready():
    size = get_object_size()

func _can_drop_data(at_position, data):
    return can_drop
    
func _drop_data(at_position, data):
    return data

func _get_drag_data(at_position) -> DragDropBuiltin:
    if not can_drag: return
    drag_offset = -at_position
    
    hide()
    var prev = DragPreview.new(
        object_texture, get_object_size(), rotation, 
        drag_offset if drag_style == &"OFFSET" else -0.5 * get_object_size())
    
    set_drag_preview(prev)
    prev.tree_exiting.connect(prev.set_position_of.bind(self))
    return self

func get_object_size():
    return DEFAULT_SIZE * object_scale

func place_at(pos: Vector2):
    if drag_style == &"OFFSET":
        global_position = pos + drag_offset
    elif drag_style == &"CENTER": 
        global_position = pos + -0.5 * size
