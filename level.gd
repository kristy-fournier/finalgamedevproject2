extends Node2D

var floorOrder
## Floor the player should start on (as a node)
@export var startingFloor:Node2D
## Floor the exit is on (as a node)
@export var exitFloor:Node2D
## Starting from (0,0) being the topright tile
@export var starting_tile: Vector2i
## Make sure the scale is small enough for the whole level to fit in the SpiritConnector
@export var scaleForMainScene: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in self.get_children():
		if i != startingFloor:
			i.visible = false
		else:
			#make sure at least the starting floor is visible
			startingFloor.visible = true
	# initialise the floor order
	floorOrder = []
	for i in self.get_children():
		floorOrder.append(i)
	floorOrder.reverse()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
