class_name DragDropCursor
extends Area2D

const DRAG_THRESHOLD = 5

var dragging: DragDropObject
var hovering: DragDropObject

func _enter_tree():
    set_multiplayer_authority(name.to_int())
    pass

func _input(event):
    if not is_multiplayer_authority():
        return
    
    hovering = choose_dragdrop_object()

    if hovering != null:
        #print("hovering ", hovering.name)
        if Input.is_action_just_pressed("LMB") and dragging == null:
            print("picked ", hovering.name)
            hovering.start_dragging()
            hovering.push_to_front()
            dragging = hovering
        elif Input.is_action_just_pressed("RMB"):
            hovering.flip()
    
    if dragging != null:
        if Input.is_action_just_pressed("ROTATE_LEFT"):
            dragging.move_to(global_position)
            dragging.rotate_object(-90)
        elif Input.is_action_just_pressed("ROTATE_RIGHT"):
            dragging.move_to(global_position)
            dragging.rotate_object(90)
        elif Input.is_action_just_pressed("RMB"):
            dragging.flip()
        
        # drop the card
        if Input.is_action_just_released("LMB"):
            #if hovering != null:
                #hovering.dropped_by(dragging)
            dragging.end_dragging()
            print(dragging.name, " dropped")
            dragging = null
    
    if event is InputEventMouseMotion:
        global_position = get_global_mouse_position()
        
        if dragging != null:
            dragging.drag(event.relative)

func choose_dragdrop_object() -> DragDropObject:
    var cards: Array[Area2D] = get_overlapping_areas().filter(
        func(c): return c is DragDropObject and not c.is_dragging)
        
    if len(cards) == 0:
        return null
    elif len(cards) == 1:
        return cards[0]
    else:
        return cards.reduce(func(a, b): return a if a.get_index() > b.get_index() else b)