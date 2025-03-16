extends Node2D

var floorOrder


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	A is the starting floor
	$"Floor B".visible = false;
	# initialise the floor order
	floorOrder = []
	for i in self.get_children():
		floorOrder.append(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
