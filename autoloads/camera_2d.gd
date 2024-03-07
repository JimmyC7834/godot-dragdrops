extends Node

var _camera: Camera2D

func _ready():
    _camera = Camera2D.new()
    add_child(_camera)
