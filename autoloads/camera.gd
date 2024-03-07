extends Node

const CAMERA_3D = preload("res://autoloads/camera_3d.tscn")

var _camera: Camera3D

func _ready():
    _camera = CAMERA_3D.instantiate()
    add_child(_camera)

func get_mouse_3d_position(dropPlane: Plane) -> Vector3:
    var position2D = get_viewport().get_mouse_position()
    var position3D = dropPlane.intersects_ray(
        _camera.project_ray_origin(position2D),
        _camera.project_ray_normal(position2D))
    return position3D
