class_name DragDropControl
extends Node2D

const DRAG_THRESHOLD = 5

static var dragging

@export var drag_offset: Vector2
@export var btn: Button

@export var is_mouse_down: bool = false
@export var mouse_down_position: Vector2

signal on_clicked
signal on_dragged
signal on_dropped
signal on_dropped_on(d: DragDropControl)

func _ready():
    btn = Button.new()
    add_child(btn)

    btn.anchors_preset = Control.PRESET_FULL_RECT
    btn.button_down.connect(_mouse_down)
    btn.button_up.connect(_mouse_up)

func _process(delta):
    # if mouse pressed inside btn
    if is_mouse_down and not is_dragging():
        # check if is dragging
        print(get_global_mouse_position().distance_to(mouse_down_position), btn.is_hovered())
        if get_global_mouse_position().distance_to(mouse_down_position) > DRAG_THRESHOLD and btn.is_hovered():
            print("drag")
            drag()
    
    if dragging_self():
        move()
    
    if Input.is_action_just_released("LMB") and btn.is_hovered() and not dragging_self() and is_dragging():
        print("dropped on", name)
        on_dropped_on.emit(dragging)
        dragging.drop()

@rpc("any_peer", "call_local", "reliable")
func move():
    global_position = get_global_mouse_position() + drag_offset
    #print(get_viewport().get_viewport_rid(), " moving ", global_position, " ", get_global_mouse_position(), " ", drag_offset)

func drag():
    _drag()

@rpc("any_peer", "call_local", "reliable")
func _drag():
    dragging = self
    move_to_back()
    z_index = 10
    
    drag_offset = global_position - get_global_mouse_position()
    
    on_dragged.emit()
    await btn.button_up
    if dragging_self() and btn.is_hovered():
        _drop()

func _drop():
    drop()

@rpc("any_peer", "call_local", "reliable")
func drop():
    dragging = null
    move_to_front()
    z_index = 0
    on_dropped.emit()

func _mouse_up():
    mouse_up()

@rpc("any_peer", "call_local", "reliable")
func mouse_up():
    is_mouse_down = false
    print(get_viewport().get_viewport_rid(), " mouse up ", is_mouse_down)
    if not dragging_self():
        print("clicked", name)
        on_clicked.emit()

func _mouse_down():
    mouse_down()
    
@rpc("any_peer", "call_local", "reliable")
func mouse_down():
    is_mouse_down = true
    mouse_down_position = get_global_mouse_position()

func dragging_self() -> bool:
    return dragging == self

func is_dragging() -> bool:
    return dragging != null

func move_to_back():
    get_parent().move_child(self, 0)
