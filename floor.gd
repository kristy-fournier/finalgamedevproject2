extends Node2D

@export var is_on: bool
@export var locked: bool
const box_type = preload("res://box.gd")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func disableFloor():
	for i in self.get_children():
		if i is not box_type:
			i.enabled = true
func enableFloor():
	for i in self.get_children():
		if i is not box_type:
			i.enabled = true


func _on_hidden() -> void:
	disableFloor()


func _on_draw() -> void:
	enableFloor()
