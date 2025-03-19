extends Node2D

var floorOrder
@export var startingFloor:Node2D
@export var exitFloor:Node2D
@export var starting_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set this to the node of the starting floor
	# startingFloor = $"Floor A"
	for i in self.get_children():
		if i != startingFloor:
			i.visible = false
	# initialise the floor order
	floorOrder = []
	for i in self.get_children():
		floorOrder.append(i)
	floorOrder.reverse()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
