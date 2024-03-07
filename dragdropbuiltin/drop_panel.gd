extends Control

func _can_drop_data(at_position, data):
    return true
    
func _drop_data(at_position, obj):
    obj.place_at(at_position)
    obj.show()
    obj.on_drop.emit()
    return obj
