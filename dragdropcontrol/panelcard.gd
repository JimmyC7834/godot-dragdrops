class_name PanelCard
extends DragDropControl

@export var card_back_texture: Texture2D
@export var degree: int = 0

var rotation_span: float = 0.1
var flip_span: float = 0.1
var card_back: TextureRect

func _ready():
    super._ready()
    card_back = TextureRect.new()
    add_child(card_back)
    card_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
    card_back.anchors_preset = Control.PRESET_FULL_RECT
    card_back.texture = card_back_texture
    card_back.visible = false

func _input(event):
    if dragging_self():
        var rotated = false
    
    if Input.is_action_just_pressed("ROTATE_LEFT"):
        degree -= 90
        rotate_card(degree)
    elif Input.is_action_just_pressed("ROTATE_RIGHT"):
        degree += 90
        rotate_card(degree)
    
    if Input.is_action_just_released("RMB") and not is_dragging():
        filp_card()

@rpc("any_peer", "call_local", "reliable")
func filp_card():
    var t = create_tween().set_ease(Tween.EASE_OUT)
    var original_scale = scale
    t.tween_property(self, "scale", Vector2(0, scale.y), flip_span / 2)
    await t.finished
    card_back.visible = not card_back.visible
    t = create_tween().set_ease(Tween.EASE_OUT)
    t.tween_property(self, "scale", original_scale, flip_span / 2)

@rpc("any_peer", "call_local", "reliable")
func rotate_card(d: int):     
    drag_offset = Vector2.ZERO
    var t = create_tween().set_ease(Tween.EASE_OUT)
    t.tween_property(self, "rotation", deg_to_rad(degree), rotation_span)
