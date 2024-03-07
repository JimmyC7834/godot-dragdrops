class_name DragDropBody3D
extends CharacterBody3D

const Z = 10

static var picking: DragDropBody3D
static var hovering: DragDropBody3D

@export var draggable: bool = true
@export var droppable: bool = true
@export var selectable: bool = true
@export var pickup_offset: Vector3 = Vector3(0, 1, 0)

@export var camera: Camera3D

@export var span: float = 0.1

var picked_up: bool = false
var pick_up_position: Vector3
var degree: int = 0

# drag
signal on_mouse_pressed
signal on_mouse_released
signal on_picked_up
signal on_dropped(d: DragDropBody3D)

# drop
signal on_dropped_by(d: DragDropBody3D)

# hover
signal on_hovered

func _ready():
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    on_dropped.emit(self)


func _input_event(camera, event, position, normal, shape_idx):
    if event is InputEventMouseMotion:
        if hovering == null and !picked_up and selectable:
            hovering = self
            print(name, " hovered")
            mouse_entered.emit()
            on_hovered.emit()
        elif hovering == self and picked_up:
            hovering = null

func _process(_delta):
    if picked_up:
        global_position = get_mouse_3d_position() + pickup_offset
    
    if Input.is_action_just_released("LMB") and picking == self:
        on_mouse_released.emit()
        drop()
    
    if Input.is_action_just_pressed("LMB") and hovering == self:
        on_mouse_pressed.emit()
        start_dragging()
    
    if picking == self:
        if Input.is_action_just_pressed("ROTATE_LEFT"):
            var t = create_tween().set_ease(Tween.EASE_OUT)
            t.tween_property(self, "rotation", Vector3(0, deg_to_rad(90), 0), span).as_relative()
        elif Input.is_action_just_pressed("ROTATE_RIGHT"):
            var t = create_tween().set_ease(Tween.EASE_OUT)
            t.tween_property(self, "rotation", Vector3(0, deg_to_rad(-90), 0), span).as_relative()

func get_mouse_3d_position():
    var position2D = get_viewport().get_mouse_position()
    var dropPlane  = Plane(Vector3(0, 10, 0), Z)
    var position3D = dropPlane.intersects_ray(
        camera.project_ray_origin(position2D),
        camera.project_ray_normal(position2D))
    print(position3D)
    return position3D

func dropped_by(d: DragDropBody3D):
    print(name, " dropped by ", d.name)
    on_dropped_by.emit(d)

func start_dragging():
    if not draggable: return
    if picking != null: return
    
    picked_up = true
    picking = self
    pick_up_position = global_position
    print(name, " is picked")
    on_picked_up.emit()
    
func _notification(blah):
    match blah:
        NOTIFICATION_WM_MOUSE_EXIT:
            if picked_up:
                global_position = pick_up_position
                drop()

func drop():
    print(name, " dropped")
    picked_up = false
    picking = null
    
    # return to anchor if it's set
    global_position -= pickup_offset
    
    # detect if this dragdrop is dropped on other dragdrop
    if hovering != self and hovering != null:
        #Audio.play_sfx(SFX_DROP_ON)
        hovering.dropped_by(self)
    else:
        #Audio.play_sfx(SFX_DROP) 
        pass
        
    move_and_collide(Vector3.ZERO)
    on_dropped.emit(self)

func _on_mouse_entered():
    pass

func _on_mouse_exited():
    if hovering == self:
        hovering = null

static func clear():
    hovering = null
    picking = null
